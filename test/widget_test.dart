import 'package:flutter_test/flutter_test.dart';
import 'package:ai_roast_battle/ozellikler/roast/veri/roast_model.dart';

void main() {
  test('RoastModel toJson/fromJson tutarli calisir', () {
    final now = DateTime.now();
    const id = '1';
    const metin = 'test roast';
    const karakter = 'test karakter';
    const mod = 'roast';

    final model = RoastModel(
      id: id,
      metin: metin,
      karakter: karakter,
      mod: mod,
      tarih: now,
    );

    final parsed = RoastModel.fromJson(model.toJson());

    expect(parsed.id, id);
    expect(parsed.metin, metin);
    expect(parsed.karakter, karakter);
    expect(parsed.mod, mod);
    expect(parsed.tarih.toIso8601String(), now.toIso8601String());
    expect(parsed, model);
  });
}
