import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:async';
import '../../../cekirdek/servisler/olay_izleme_servisi.dart';
import '../../../cekirdek/servisler/gecmis_servisi.dart';
import '../../../cekirdek/servisler/baglanti_servisi.dart';
import '../../../cekirdek/sabitler/tipler.dart';
import 'roast_durum.dart';
import 'roast_servisi.dart';
import '../veri/roast_model.dart';
import '../../../cekirdek/servisler/istatistik_servisi.dart';
import '../../../cekirdek/is_mantigi/ayarlar_cubiti.dart';


class RoastCubiti extends Cubit<RoastDurum> {
  final RoastServisi _roastServisi;
  final RoastServisi _sahteServisi;
  final OlayIzlemeServisi _olayIzlemeServisi;
  final GecmisServisi _gecmisServisi;
  final BaglantiServisi _baglantiServisi;
  final IstatistikServisi _istatistikServisi;
  final AyarlarCubiti _ayarlarCubiti;
  final ImagePicker _picker = ImagePicker();

  RoastCubiti(this._roastServisi, this._sahteServisi, this._olayIzlemeServisi, this._gecmisServisi, this._baglantiServisi, this._istatistikServisi, this._ayarlarCubiti)
      : super(RoastBaslangic());

  bool get simulasyonModu => _ayarlarCubiti.state.simulasyonModu;

  Future<void> fotografSec({required ImageSource kaynak}) async {
    await _olayIzlemeServisi.olayGonder('photo_select_tapped', ekVeri: {'source': kaynak.name});
    try {
      final XFile? secilenDosya = await _picker.pickImage(
        source: kaynak,
        imageQuality: 30,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (secilenDosya != null) {
        await _olayIzlemeServisi.olayGonder('photo_selected');
        emit(RoastFotografSecildi(File(secilenDosya.path)));
      }
    } catch (e) {
      await _olayIzlemeServisi.olayGonder('photo_select_failed', ekVeri: {'error': e.toString()});
      emit(const RoastHata(RoastHataTipi.fotografSecimi));
    }
  }

  Future<void> roastUret({
    required File fotograf,
    required String karakter,
    required String mod,
    String? ozelPrompt,
    String? kisiYakinligi,
    String? sinirBozucuOzellik,
    String? sir,
  }) async {
    await _olayIzlemeServisi.olayGonder(
      'roast_started',
    );
    final isSim = _ayarlarCubiti.state.simulasyonModu;

    if (!isSim) {
      final internetVar = await _baglantiServisi.internetVarMi;
      if (!internetVar) {
        emit(const RoastHata(RoastHataTipi.baglanti));
        return;
      }

      if (_istatistikServisi.gunlukLimitDolduMu) {
        emit(const RoastHata(RoastHataTipi.gunlukLimit));
        return;
      }
    }

    emit(const RoastYukleniyor(RoastAsamasi.analiz));
    
    try {
      final servis = _ayarlarCubiti.state.simulasyonModu ? _sahteServisi : _roastServisi;
      String sonMetin = "";
      
      final stream = servis.roastUret(
            fotograf: fotograf,
            karakter: karakter,
            mod: mod,
            ozelPrompt: ozelPrompt,
            kisiYakinligi: kisiYakinligi,
            sinirBozucuOzellik: sinirBozucuOzellik,
            sir: sir,
          );

      await for (final partialText in stream.timeout(const Duration(seconds: 90))) {
        sonMetin = partialText;
        emit(RoastYukleniyor(RoastAsamasi.metinUretimi, kismiMetin: partialText));
      }

      final roast = RoastModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        metin: sonMetin,
        karakter: karakter,
        mod: mod,
        tarih: DateTime.now(),
      );

      await _olayIzlemeServisi.olayGonder('roast_success');
      await _gecmisServisi.kaydet(roast);
      try {
        await _istatistikServisi.roastKaydet();
      } catch (_) {
        // Istatistik hatasi, basarili roast akisini kesmemeli.
      }
      emit(RoastBasarili(roast, fotograf));
    } catch (e) {
      await _olayIzlemeServisi.olayGonder('roast_failed', ekVeri: {'error': e.toString()});

      final hata = e.toString();
      RoastHataTipi hataTipi = RoastHataTipi.bilinmeyen;
      final fallbackUygun = !_ayarlarCubiti.state.simulasyonModu &&
          (hata.contains('TimeoutException') || hata.contains('API hatasi'));
      
      if (hata.contains('TimeoutException')) {
        hataTipi = RoastHataTipi.zamanAsimi;
      } else if (hata.contains('API hatasi')) {
        hataTipi = RoastHataTipi.apiHatasi;
      }
      
      emit(RoastHata(hataTipi, mesaj: hata.replaceAll("Exception: ", "")));
    }
  }


  void sifirla() {
    emit(RoastBaslangic());
  }
}
