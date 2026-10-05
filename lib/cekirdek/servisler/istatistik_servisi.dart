import 'package:shared_preferences/shared_preferences.dart';

class IstatistikServisi {
  static const String _keyToplamRoast = 'toplam_roast';
  static const String _keySavagePuan = 'savage_puan';
  static const String _keyGunlukRoast = 'gunluk_roast_sayisi';
  static const String _keyLimitPencereBaslangici = 'limit_pencere_baslangici';
  static const int gunlukLimit = 5;
  static const Duration _limitPenceresi = Duration(hours: 24);
  static const String _eventPrefix = 'event_';
  
  final SharedPreferences _prefs;
  final DateTime Function() _now;

  IstatistikServisi(this._prefs, {DateTime Function()? now}) : _now = now ?? DateTime.now;

  int get toplamRoast => _prefs.getInt(_keyToplamRoast) ?? 0;
  int get savagePuan => _prefs.getInt(_keySavagePuan) ?? 0;
  int get gunlukKullanim {
    final pencereBaslangici = _pencereBaslangici();
    if (pencereBaslangici == null) return 0;
    if (_limitPenceresiDolduMu(pencereBaslangici)) return 0;
    return _prefs.getInt(_keyGunlukRoast) ?? 0;
  }

  int get kalanHak => (gunlukLimit - gunlukKullanim).clamp(0, gunlukLimit);

  bool get gunlukLimitDolduMu {
    final pencereBaslangici = _pencereBaslangici();
    if (pencereBaslangici == null) return false;
    if (_limitPenceresiDolduMu(pencereBaslangici)) return false;
    return (_prefs.getInt(_keyGunlukRoast) ?? 0) >= gunlukLimit;
  }

  Duration get yenilenmeyeKalanSure {
    final pencereBaslangici = _pencereBaslangici();
    if (pencereBaslangici == null || !gunlukLimitDolduMu) {
      return Duration.zero;
    }
    final gecen = _now().difference(pencereBaslangici);
    final kalan = _limitPenceresi - gecen;
    return kalan.isNegative ? Duration.zero : kalan;
  }

  String get yenilenmeyeKalanYazi {
    final kalan = yenilenmeyeKalanSure;
    if (kalan == Duration.zero) return 'Yenilendi';
    final saat = kalan.inHours;
    final dakika = kalan.inMinutes.remainder(60);
    if (saat > 0) {
      return '${saat}s ${dakika}dk';
    }
    return '${kalan.inMinutes}dk';
  }

  Future<void> roastKaydet() async {
    final simdi = _now();
    final pencereBaslangici = _pencereBaslangici();

    int yeniGunluk = 1;
    DateTime yeniPencereBaslangici = simdi;
    if (pencereBaslangici != null && !_limitPenceresiDolduMu(pencereBaslangici)) {
      yeniGunluk = (_prefs.getInt(_keyGunlukRoast) ?? 0) + 1;
      yeniPencereBaslangici = pencereBaslangici;
    }

    final yeniToplam = toplamRoast + 1;
    final yeniPuan = savagePuan + 10;
    
    await _prefs.setInt(_keyToplamRoast, yeniToplam);
    await _prefs.setInt(_keySavagePuan, yeniPuan);
    await _prefs.setInt(_keyGunlukRoast, yeniGunluk);
    await _prefs.setString(_keyLimitPencereBaslangici, yeniPencereBaslangici.toIso8601String());
  }

  String get unvan {
    if (savagePuan < 50) return "Yeni Kurban";
    if (savagePuan < 150) return "Sert Derili";
    if (savagePuan < 300) return "Roast Çırağı";
    if (savagePuan < 600) return "Laf Cambazı";
    if (savagePuan < 1000) return "Savage Master";
    return "Efsanevi Yıkılmaz";
  }

  double get seviyeIlerleme {
    // 0-1000 arası puanı 0.0 - 1.0 arasına normalize et (basitçe)
    return (savagePuan % 200) / 200.0;
  }

  Future<void> olaySayaciniArtir(String olayAdi) async {
    final key = '$_eventPrefix$olayAdi';
    final mevcut = _prefs.getInt(key) ?? 0;
    await _prefs.setInt(key, mevcut + 1);
  }

  DateTime? _pencereBaslangici() {
    final tarihStr = _prefs.getString(_keyLimitPencereBaslangici);
    if (tarihStr == null || tarihStr.isEmpty) return null;
    return DateTime.tryParse(tarihStr);
  }

  bool _limitPenceresiDolduMu(DateTime pencereBaslangici) {
    return _now().difference(pencereBaslangici) >= _limitPenceresi;
  }
}
