import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:ai_roast_battle/cekirdek/servisler/gecmis_servisi.dart';
import 'package:ai_roast_battle/ozellikler/roast/veri/roast_model.dart';

void main() {
  late GecmisServisi gecmisServisi;
  late Directory hiveTestDir;

  setUpAll(() async {
    hiveTestDir = await Directory.systemTemp.createTemp('hive_gecmis_test_');
    Hive.init(hiveTestDir.path);
    await Hive.openBox('roast_gecmis');
  });

  setUp(() async {
    await Hive.box('roast_gecmis').clear();
    gecmisServisi = GecmisServisi();
  });

  tearDownAll(() async {
    await Hive.box('roast_gecmis').close();
    await Hive.deleteBoxFromDisk('roast_gecmis');
    await hiveTestDir.delete(recursive: true);
  });

  test('bos gecmis bos liste doner', () async {
    expect(await gecmisServisi.tumGecmis(), isEmpty);
    expect(await gecmisServisi.kayitSayisi, 0);
  });

  test('kaydet ve oku tutarli calisir', () async {
    final roast = RoastModel(
      id: '1',
      metin: 'Test roast',
      karakter: 'Alayci',
      mod: 'roast',
      tarih: DateTime(2026, 4, 6),
    );

    await gecmisServisi.kaydet(roast);

    final gecmis = await gecmisServisi.tumGecmis();
    expect(gecmis.length, 1);
    expect(gecmis.first.id, '1');
    expect(gecmis.first.metin, 'Test roast');
  });

  test('en yeni kayit basta olur', () async {
    final eski = RoastModel(
      id: '1',
      metin: 'Eski',
      karakter: 'Alaycı',
      mod: 'roast',
      tarih: DateTime(2026, 4, 1),
    );
    final yeni = RoastModel(
      id: '2',
      metin: 'Yeni',
      karakter: 'Filozof',
      mod: 'ovgu',
      tarih: DateTime(2026, 4, 6),
    );

    await gecmisServisi.kaydet(eski);
    await gecmisServisi.kaydet(yeni);

    final gecmis = await gecmisServisi.tumGecmis();
    expect(gecmis.length, 2);
    expect(gecmis.first.id, '2');
  });

  test('temizle tum kayitlari siler', () async {
    final roast = RoastModel(
      id: '1',
      metin: 'Silinecek',
      karakter: 'Gangster',
      mod: 'roast',
      tarih: DateTime(2026, 4, 6),
    );

    await gecmisServisi.kaydet(roast);
    expect(await gecmisServisi.kayitSayisi, 1);

    await gecmisServisi.temizle();
    expect(await gecmisServisi.kayitSayisi, 0);
  });
}
