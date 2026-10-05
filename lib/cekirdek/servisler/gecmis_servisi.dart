import 'dart:convert';
import 'package:hive/hive.dart';
import '../../ozellikler/roast/veri/roast_model.dart';

class GecmisServisi {
  static const String _boxName = 'roast_gecmis';
  static const int _maxKayit = 50;

  final Box _box;

  GecmisServisi() : _box = Hive.box(_boxName);

  Future<List<RoastModel>> tumGecmis() async {
    final list = _box.values.toList();
    if (list.isEmpty) return [];
    
    // Hive stores the data as it was put. If we put JSON strings:
    final mapped = list.map((e) {
      if (e is String) {
        return RoastModel.fromJson(jsonDecode(e));
      }
      return RoastModel.fromJson(Map<String, dynamic>.from(e));
    }).toList();

    return mapped..sort((a, b) => b.tarih.compareTo(a.tarih));
  }

  Future<void> kaydet(RoastModel roast) async {
    // Hive'a direkt Map olarak kaydedebiliriz (daha hızlı)
    await _box.add(roast.toJson());

    // Limit kontrolü
    if (_box.length > _maxKayit) {
      final silinecekSayisi = _box.length - _maxKayit;
      for (int i = 0; i < silinecekSayisi; i++) {
        await _box.deleteAt(0);
      }
    }
  }

  Future<void> temizle() async {
    await _box.clear();
  }

  Future<int> get kayitSayisi async => _box.length;
}
