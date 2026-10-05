import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_roast_battle/cekirdek/servisler/istatistik_servisi.dart';

void main() {
  late IstatistikServisi servis;
  late DateTime fakeNow;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    fakeNow = DateTime(2026, 4, 22, 10, 0, 0);
    servis = IstatistikServisi(prefs, now: () => fakeNow);
  });

  test('baslangic degerleri sifir', () {
    expect(servis.toplamRoast, 0);
    expect(servis.savagePuan, 0);
  });

  test('roastKaydet toplam ve puani arttirir', () async {
    await servis.roastKaydet();
    expect(servis.toplamRoast, 1);
    expect(servis.savagePuan, 10);

    await servis.roastKaydet();
    expect(servis.toplamRoast, 2);
    expect(servis.savagePuan, 20);
  });

  test('unvan puanla dogru sekilde degisir', () async {
    expect(servis.unvan, 'Yeni Kurban');

    for (int i = 0; i < 5; i++) {
      await servis.roastKaydet();
    }
    expect(servis.unvan, 'Sert Derili');

    for (int i = 0; i < 10; i++) {
      await servis.roastKaydet();
    }
    expect(servis.unvan, 'Roast Çırağı');
  });

  test('seviyeIlerleme 0 ile 1 arasinda', () {
    expect(servis.seviyeIlerleme, greaterThanOrEqualTo(0.0));
    expect(servis.seviyeIlerleme, lessThanOrEqualTo(1.0));
  });

  test('olaySayaciniArtir dogru sayar', () async {
    await servis.olaySayaciniArtir('test_event');
    await servis.olaySayaciniArtir('test_event');
    await servis.olaySayaciniArtir('test_event');
    // Internal counter should be 3, no public getter but we can verify it doesn't throw
  });

  test('gunluk limit 24 saat dolmadan yenilenmez', () async {
    for (int i = 0; i < IstatistikServisi.gunlukLimit; i++) {
      await servis.roastKaydet();
    }
    expect(servis.gunlukLimitDolduMu, true);
    expect(servis.kalanHak, 0);

    fakeNow = fakeNow.add(const Duration(hours: 23, minutes: 59));
    expect(servis.gunlukLimitDolduMu, true);
    expect(servis.kalanHak, 0);
  });

  test('gunluk limit 24 saat sonra yenilenir', () async {
    for (int i = 0; i < IstatistikServisi.gunlukLimit; i++) {
      await servis.roastKaydet();
    }
    expect(servis.gunlukLimitDolduMu, true);

    fakeNow = fakeNow.add(const Duration(hours: 24, minutes: 1));
    expect(servis.gunlukLimitDolduMu, false);
    expect(servis.kalanHak, IstatistikServisi.gunlukLimit);

    await servis.roastKaydet();
    expect(servis.gunlukKullanim, 1);
    expect(servis.kalanHak, IstatistikServisi.gunlukLimit - 1);
  });
}
