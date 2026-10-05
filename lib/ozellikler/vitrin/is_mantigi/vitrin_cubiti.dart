import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../veri/vitrin_gonderisi_model.dart';
import '../../roast/veri/savas_model.dart';
import '../../roast/veri/roast_model.dart';
import 'vitrin_servisi.dart';
import 'vitrin_durum.dart';

class VitrinCubiti extends Cubit<VitrinDurum> {
  final VitrinServisArayuzu _servis;

  VitrinCubiti(this._servis) : super(VitrinBaslangic());

  Future<void> akisiYukle() async {
    try {
      emit(VitrinYukleniyor());
      final (akis, sonBelge) = await _servis.akisiGetir();
      emit(VitrinBasarili(
        akis,
        sonBelge: sonBelge,
        dahaFazlaVar: akis.length >= 10,
      ));
    } catch (e) {
      emit(VitrinHata('Akış yüklenirken hata oluştu: ${e.toString()}'));
    }
  }

  Future<void> dahaFazlaYukle() async {
    final suankiDurum = state;
    if (suankiDurum is VitrinBasarili &&
        suankiDurum.dahaFazlaVar &&
        !suankiDurum.dahaFazlaYukleniyor) {
      try {
        emit(suankiDurum.copyWith(dahaFazlaYukleniyor: true));

        final (yeniAkis, yeniSonBelge) = await _servis.akisiGetir(
          sonBelge: suankiDurum.sonBelge as QueryDocumentSnapshot?,
        );

        emit(VitrinBasarili(
          [...suankiDurum.akis, ...yeniAkis],
          sonBelge: yeniSonBelge,
          dahaFazlaVar: yeniAkis.length >= 10,
          dahaFazlaYukleniyor: false,
        ));
      } catch (e) {
        emit(suankiDurum.copyWith(dahaFazlaYukleniyor: false));
      }
    }
  }

  Future<void> paylas({
    required SavasModel savas,
    required File fotograf1,
    required File fotograf2,
    required String paylasanAdi,
  }) async {
    try {
      emit(const VitrinPaylasiliyor(mesaj: 'İşlem başlatılıyor...'));
      await _servis.paylasSavas(
        savas: savas,
        fotograf1: fotograf1,
        fotograf2: fotograf2,
        paylasanAdi: paylasanAdi,
        onAsamaDegisti: (mesaj) => emit(VitrinPaylasiliyor(mesaj: mesaj)),
      );
      emit(VitrinPaylasimBasarili());
      await akisiYukle();
    } catch (e) {
      emit(VitrinHata(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> paylasTekli({
    required RoastModel roast,
    required File fotograf,
    required String paylasanAdi,
  }) async {
    try {
      emit(const VitrinPaylasiliyor(mesaj: 'İşlem başlatılıyor...'));
      await _servis.paylasTekli(
        roast: roast,
        fotograf: fotograf,
        paylasanAdi: paylasanAdi,
        onAsamaDegisti: (mesaj) => emit(VitrinPaylasiliyor(mesaj: mesaj)),
      );
      emit(VitrinPaylasimBasarili());
      await akisiYukle();
    } catch (e) {
      emit(VitrinHata(e.toString().replaceAll('Exception: ', '')));
    }
  }

  Future<void> tepkiVer(String shareId, String tepkiTipi) async {
    final suankiDurum = state;
    if (suankiDurum is VitrinBasarili) {
      try {
        final guncelAkis = (state as VitrinBasarili).akis.map((gonderi) {
          if (gonderi.id == shareId) {
            final yeniTepkiler = Map<String, int>.from(gonderi.tepkiler);
            yeniTepkiler[tepkiTipi] = (yeniTepkiler[tepkiTipi] ?? 0) + 1;
            return gonderi.copyWith(tepkiler: yeniTepkiler);
          }
          return gonderi;
        }).toList();

        emit(suankiDurum.copyWith(akis: guncelAkis));
        await _servis.tepkiVer(shareId, tepkiTipi);
      } catch (e) {
        await akisiYukle();
      }
    }
  }
}
