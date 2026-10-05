import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';
import 'servis_kayit.dart';
import '../is_mantigi/ayarlar_cubiti.dart';

class TitresimServisi {
  bool get _titresimAcik {
    try {
      return servisBulucu<AyarlarCubiti>().state.titresimAcik;
    } catch (_) {
      return true;
    }
  }

  /// Hafif bir tıklama hissi verir. (Buton tıklamaları vb.)
  Future<void> hafifTikla() async {
    if (!_titresimAcik) return;
    await HapticFeedback.lightImpact();
  }

  /// Orta seviye geri bildirim. (Seçim değişimleri vb.)
  Future<void> ortaTikla() async {
    if (!_titresimAcik) return;
    await HapticFeedback.mediumImpact();
  }

  /// Ağır geri bildirim. (Zafer, kritik hatalar vb.)
  Future<void> agirTikla() async {
    if (!_titresimAcik) return;
    await HapticFeedback.heavyImpact();
  }

  /// Belirli bir süre titreşim verir.
  Future<void> sureliTitret({int milisaniye = 500}) async {
    if (!_titresimAcik) return;
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(duration: milisaniye);
    }
  }

  /// "Hata" deseninde titreşim verir.
  Future<void> hataTitret() async {
    if (!_titresimAcik) return;
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(pattern: [0, 100, 50, 100]);
    }
  }

  /// "Zafer" deseninde titreşim verir.
  Future<void> zaferTitret() async {
    if (!_titresimAcik) return;
    if (await Vibration.hasVibrator()) {
      await Vibration.vibrate(pattern: [0, 200, 100, 200, 100, 500]);
    }
  }
}
