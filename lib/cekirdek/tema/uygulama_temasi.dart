import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../sabitler/renkler.dart';

/// Uygulamanın genel tema yapılandırmasını yöneten sınıf.
class UygulamaTemasi {
  /// Karanlık tema yapılandırmasını döndürür.
  static ThemeData get karanlikTema {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: UygulamaRenkleri.arkaPlan,
      colorScheme: ColorScheme.fromSeed(
        seedColor: UygulamaRenkleri.anaRenk,
        brightness: Brightness.dark,
        surface: UygulamaRenkleri.yuzey,
        primary: UygulamaRenkleri.anaRenk,
        secondary: UygulamaRenkleri.vurguRenk,
      ),
      textTheme: GoogleFonts.orbitronTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32, letterSpacing: -1),
        displayMedium: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        bodyLarge: GoogleFonts.outfit(fontSize: 16),
        bodyMedium: GoogleFonts.outfit(fontSize: 14),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: UygulamaRenkleri.arkaPlan,
        elevation: 0,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: UygulamaRenkleri.anaRenk,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      cardTheme: CardTheme(
        color: UygulamaRenkleri.yuzey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }

  /// Aydınlık tema yapılandırmasını döndürür.
  static ThemeData get aydinlikTema {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      colorScheme: ColorScheme.fromSeed(
        seedColor: UygulamaRenkleri.anaRenk,
        brightness: Brightness.light,
        surface: Colors.white,
        primary: UygulamaRenkleri.anaRenk,
        secondary: UygulamaRenkleri.vurguRenk,
      ),
      textTheme: GoogleFonts.orbitronTextTheme(ThemeData.light().textTheme).copyWith(
        displayLarge: const TextStyle(fontWeight: FontWeight.bold, fontSize: 32, letterSpacing: -1, color: Colors.black87),
        displayMedium: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87),
        bodyLarge: GoogleFonts.outfit(fontSize: 16, color: Colors.black87),
        bodyMedium: GoogleFonts.outfit(fontSize: 14, color: Colors.black87),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFF5F5F5),
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        titleTextStyle: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 18, letterSpacing: 2),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: UygulamaRenkleri.anaRenk,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, 56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      cardTheme: CardTheme(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
