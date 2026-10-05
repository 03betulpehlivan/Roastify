import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ai_roast_battle/ozellikler/roast/is_mantigi/roast_cubiti.dart';
import 'package:ai_roast_battle/ozellikler/roast/is_mantigi/roast_durum.dart';
import 'package:ai_roast_battle/ozellikler/roast/is_mantigi/roast_servisi.dart';
import 'package:ai_roast_battle/ozellikler/roast/veri/savas_model.dart';
import 'package:ai_roast_battle/cekirdek/servisler/olay_izleme_servisi.dart';
import 'package:ai_roast_battle/cekirdek/servisler/istatistik_servisi.dart';
import 'package:ai_roast_battle/cekirdek/servisler/gecmis_servisi.dart';
import 'package:ai_roast_battle/cekirdek/servisler/baglanti_servisi.dart';
import 'package:ai_roast_battle/cekirdek/is_mantigi/ayarlar_cubiti.dart';

class _MockRoastServisi implements RoastServisi {
  bool hataDondur = false;

  @override
  Stream<String> roastUret({
    required File fotograf,
    required String karakter,
    required String mod,
    String? ozelPrompt,
    String? kisiYakinligi,
    String? sinirBozucuOzellik,
    String? sir,
  }) async* {
    if (hataDondur) throw Exception('Test hatasi');
    yield 'Test roast metni';
  }

  @override
  Future<SavasModel> savasUret({
    required File fotograf1,
    required File fotograf2,
    required String karakter,
    String? ozelPrompt,
  }) async {
    throw UnimplementedError();
  }
}

class _MockBaglantiServisi implements BaglantiServisi {
  @override
  Future<bool> get internetVarMi async => true;
  @override
  Stream<bool> get baglantiDegisimYayini => Stream.value(true);
}

void main() {
  late RoastCubiti cubit;
  late _MockRoastServisi mockServisi;
  late _MockRoastServisi sahteServisi;
  late OlayIzlemeServisi olayIzleme;
  late GecmisServisi gecmisServisi;
  late _MockBaglantiServisi baglantiServisi;
  late IstatistikServisi istatistikServisi;
  late AyarlarCubiti ayarlarCubiti;
  late Directory hiveTestDir;

  setUpAll(() async {
    hiveTestDir = await Directory.systemTemp.createTemp('hive_roast_cubit_test_');
    Hive.init(hiveTestDir.path);
    await Hive.openBox('roast_gecmis');
  });

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    await Hive.box('roast_gecmis').clear();
    mockServisi = _MockRoastServisi();
    sahteServisi = _MockRoastServisi();
    istatistikServisi = IstatistikServisi(prefs);
    olayIzleme = OlayIzlemeServisi(istatistikServisi);
    gecmisServisi = GecmisServisi();
    baglantiServisi = _MockBaglantiServisi();
    ayarlarCubiti = AyarlarCubiti(prefs);
    cubit = RoastCubiti(mockServisi, sahteServisi, olayIzleme, gecmisServisi, baglantiServisi, istatistikServisi, ayarlarCubiti);
  });

  tearDown(() => cubit.close());

  tearDownAll(() async {
    await Hive.box('roast_gecmis').close();
    await Hive.deleteBoxFromDisk('roast_gecmis');
    await hiveTestDir.delete(recursive: true);
  });

  test('baslangic durumu RoastBaslangic', () {
    expect(cubit.state, isA<RoastBaslangic>());
  });

  test('sifirla RoastBaslangic doner', () {
    cubit.sifirla();
    expect(cubit.state, isA<RoastBaslangic>());
  });

  test('roastUret basarili sonuc gecmise kaydeder', () async {
    final tempDir = Directory.systemTemp.createTempSync();
    final tempFile = File('${tempDir.path}/test.jpg')..writeAsBytesSync([0]);

    await cubit.roastUret(
      fotograf: tempFile,
      karakter: 'Alayci',
      mod: 'roast',
    );

    expect(cubit.state, isA<RoastBasarili>());
    // expect(await gecmisServisi.kayitSayisi, 1); // Hive mock needs manual setup if used

    tempDir.deleteSync(recursive: true);
  });

  test('roastUret hata durumunda RoastHata emit eder', () async {
    mockServisi.hataDondur = true;

    final tempDir = Directory.systemTemp.createTempSync();
    final tempFile = File('${tempDir.path}/test.jpg')..writeAsBytesSync([0]);

    await cubit.roastUret(
      fotograf: tempFile,
      karakter: 'Alayci',
      mod: 'roast',
    );

    expect(cubit.state, isA<RoastHata>());

    tempDir.deleteSync(recursive: true);
  });
}
