import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ai_roast_battle/ozellikler/roast/veri/roast_model.dart';
import 'package:ai_roast_battle/ozellikler/roast/veri/savas_model.dart';
import 'package:ai_roast_battle/ozellikler/vitrin/is_mantigi/vitrin_cubiti.dart';
import 'package:ai_roast_battle/ozellikler/vitrin/is_mantigi/vitrin_durum.dart';
import 'package:ai_roast_battle/ozellikler/vitrin/is_mantigi/vitrin_servisi.dart';
import 'package:ai_roast_battle/ozellikler/vitrin/veri/vitrin_gonderisi_model.dart';

class _FakeVitrinServisi implements VitrinServisArayuzu {
  _FakeVitrinServisi({
    this.throwOnFetch = false,
    this.items = const <VitrinGonderisiModel>[],
  });

  final bool throwOnFetch;
  final List<VitrinGonderisiModel> items;
  int fetchCount = 0;

  @override
  Future<(List<VitrinGonderisiModel>, QueryDocumentSnapshot?)> akisiGetir({
    QueryDocumentSnapshot? sonBelge,
    int limit = 10,
  }) async {
    fetchCount += 1;
    if (throwOnFetch) {
      throw Exception('fetch failed');
    }
    return (items, null);
  }

  @override
  Future<void> paylasSavas({
    required SavasModel savas,
    required File fotograf1,
    required File fotograf2,
    required String paylasanAdi,
    Function(String p1)? onAsamaDegisti,
  }) async {}

  @override
  Future<void> paylasTekli({
    required RoastModel roast,
    required File fotograf,
    required String paylasanAdi,
    Function(String p1)? onAsamaDegisti,
  }) async {}

  @override
  Future<void> tepkiVer(String shareId, String tepkiTipi) async {}
}

void main() {
  group('VitrinCubiti', () {
    test('emits VitrinBasarili with empty list when feed is empty', () async {
      final servis = _FakeVitrinServisi(items: const []);
      final cubit = VitrinCubiti(servis);

      await cubit.akisiYukle();

      expect(cubit.state, isA<VitrinBasarili>());
      final state = cubit.state as VitrinBasarili;
      expect(state.akis, isEmpty);
      expect(servis.fetchCount, 1);
    });

    test('emits VitrinHata when service throws on fetch', () async {
      final servis = _FakeVitrinServisi(throwOnFetch: true);
      final cubit = VitrinCubiti(servis);

      await cubit.akisiYukle();

      expect(cubit.state, isA<VitrinHata>());
      final state = cubit.state as VitrinHata;
      expect(state.mesaj, contains('Akış yüklenirken hata oluştu'));
      expect(servis.fetchCount, 1);
    });
  });
}
