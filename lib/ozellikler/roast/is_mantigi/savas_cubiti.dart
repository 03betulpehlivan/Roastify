import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../cekirdek/servisler/olay_izleme_servisi.dart';
import '../../../cekirdek/servisler/istatistik_servisi.dart';
import '../../../cekirdek/servisler/baglanti_servisi.dart';
import '../../../cekirdek/sabitler/tipler.dart';
import 'savas_durum.dart';
import 'roast_servisi.dart';
import '../../../cekirdek/is_mantigi/ayarlar_cubiti.dart';

class SavasCubiti extends Cubit<SavasDurum> {
  final RoastServisi _roastServisi;
  final RoastServisi _sahteServisi;
  final OlayIzlemeServisi _olayIzlemeServisi;
  final BaglantiServisi _baglantiServisi;
  final IstatistikServisi _istatistikServisi;
  final AyarlarCubiti _ayarlarCubiti;
  final ImagePicker _picker = ImagePicker();
  
  File? _fotograf1;
  File? _fotograf2;
 
  SavasCubiti(this._roastServisi, this._sahteServisi, this._olayIzlemeServisi, this._baglantiServisi, this._istatistikServisi, this._ayarlarCubiti)
      : super(SavasBaslangic());
 
  bool get simulasyonModu => _ayarlarCubiti.state.simulasyonModu;

  Future<void> fotografSec({required int sira, required ImageSource kaynak}) async {
    await _olayIzlemeServisi.olayGonder('battle_photo_select_tapped', ekVeri: {'slot': sira});
    try {
      final XFile? secilen = await _picker.pickImage(
        source: kaynak,
        imageQuality: 30,
        maxWidth: 512,
        maxHeight: 512,
      );

      if (secilen != null) {
        if (sira == 1) {
          _fotograf1 = File(secilen.path);
        } else {
          _fotograf2 = File(secilen.path);
        }
        await _olayIzlemeServisi.olayGonder('battle_photo_selected', ekVeri: {'slot': sira});
        emit(SavasFotograflarGuncellendi(_fotograf1, _fotograf2));
      }
    } catch (e) {
      await _olayIzlemeServisi.olayGonder('battle_photo_select_failed', ekVeri: {'error': e.toString()});
      emit(const SavasHata(RoastHataTipi.fotografSecimi));
    }
  }

  Future<void> savasBaslat({required String karakter, String? ozelPrompt}) async {
    if (_fotograf1 == null || _fotograf2 == null) {
      emit(const SavasHata(RoastHataTipi.fotografSecimi));
      return;
    }

    await _olayIzlemeServisi.olayGonder(
      'battle_started',
      ekVeri: {'simulated': _ayarlarCubiti.state.simulasyonModu, 'character': karakter},
    );

    if (!_ayarlarCubiti.state.simulasyonModu) {
      final internetVar = await _baglantiServisi.internetVarMi;
      if (!internetVar) {
        emit(const SavasHata(RoastHataTipi.baglanti));
        return;
      }

      if (_istatistikServisi.gunlukLimitDolduMu) {
        emit(const SavasHata(RoastHataTipi.gunlukLimit));
        return;
      }
    }

    emit(const SavasYukleniyor(RoastAsamasi.savasAnalizi));

    try {
      final servis = _ayarlarCubiti.state.simulasyonModu ? _sahteServisi : _roastServisi;
      
      final savas = await servis.savasUret(
        fotograf1: _fotograf1!,
        fotograf2: _fotograf2!,
        karakter: karakter,
        ozelPrompt: ozelPrompt,
      ).timeout(const Duration(seconds: 90));

      await _olayIzlemeServisi.olayGonder('battle_success');
      try {
        await _istatistikServisi.roastKaydet();
      } catch (_) {
        // Istatistik hatasi, basarili savas akisini kesmemeli.
      }
      emit(SavasBasarili(savas, _fotograf1!, _fotograf2!));
    } catch (e) {
      await _olayIzlemeServisi.olayGonder('battle_failed', ekVeri: {'error': e.toString()});

      final hata = e.toString();
      final fallbackUygun = !_ayarlarCubiti.state.simulasyonModu &&
          (hata.contains('TimeoutException') ||
              hata.contains('İnternet bağlantısı kurulamadı') ||
              hata.contains('SocketException'));

      if (fallbackUygun) {
        try {
          emit(const SavasYukleniyor(RoastAsamasi.savasAnalizi)); // Fallback case
          final fallbackSavas = await _sahteServisi.savasUret(
            fotograf1: _fotograf1!,
            fotograf2: _fotograf2!,
            karakter: karakter,
            ozelPrompt: ozelPrompt,
          );
          await _olayIzlemeServisi.olayGonder('battle_fallback_success');
          try {
            await _istatistikServisi.roastKaydet();
          } catch (_) {
            // Istatistik hatasi, basarili savas akisini kesmemeli.
          }
          emit(SavasBasarili(fallbackSavas, _fotograf1!, _fotograf2!));
          return;
        } catch (fallbackHata) {
          await _olayIzlemeServisi.olayGonder(
            'battle_fallback_failed',
            ekVeri: {'error': fallbackHata.toString()},
          );
        }
      }

      RoastHataTipi hataTipi = RoastHataTipi.bilinmeyen;
      if (hata.contains('TimeoutException')) {
        hataTipi = RoastHataTipi.zamanAsimi;
      } else if (hata.contains('İnternet bağlantısı kurulamadı') || hata.contains('SocketException')) {
        hataTipi = RoastHataTipi.baglanti;
      } else if (hata.contains('API hatası')) {
        hataTipi = RoastHataTipi.apiHatasi;
      }
      
      emit(SavasHata(hataTipi, mesaj: hata.replaceAll("Exception: ", "")));
    }
  }

  void sifirla() {
    _fotograf1 = null;
    _fotograf2 = null;
    emit(SavasBaslangic());
  }
}
