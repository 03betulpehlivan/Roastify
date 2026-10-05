import 'package:flutter/material.dart';

class UygulamaRenkleri {
  // Arka Plan ve Yüzey (Deep Obsidian)
  static const Color arkaPlan = Color(0xFF030303);
  static const Color yuzey = Color(0xFF121212);
  static const Color yuzeyAcik = Color(0xFF1E1E1E);
  
  // Neon Ana Renkler (Electric Palette)
  static const Color anaRenk = Color(0xFF9D50BB); // Electric Purple
  static const Color vurguRenk = Color(0xFF00F2FE); // Cyan Drift
  static const Color neonPembe = Color(0xFFFF007F); // Hot Pink
  static const Color neonTuruncu = Color(0xFFFF9D00); // Solar Orange
  static const Color neonMavi = Color(0xFF00BFFF); // Deep Sky Blue
  
  // Yardımcı Renkler
  static const Color beyaz = Color(0xFFFFFFFF);
  static const Color gri = Color(0xFF9E9E9E);
  static const Color koyuGri = Color(0xFF2C2C2C);
  static const Color hata = Color(0xFFFF3B30);

  // Glassmorphism Sabitleri
  static Color camEfekt(Color renk) => renk.withOpacity(0.1);
  static const double camBulaniklik = 12.0;
  static const double camKenarGenislik = 1.0;

  // Modern Gradyanlar
  static const LinearGradient anaGradyan = LinearGradient(
    colors: [anaRenk, vurguRenk],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient atesGradyan = LinearGradient(
    colors: [neonPembe, neonTuruncu],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
