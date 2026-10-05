import 'package:flutter/material.dart';

abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 48;

  static const EdgeInsets sayfaPadding = EdgeInsets.symmetric(horizontal: lg, vertical: md);
  static const EdgeInsets kartPadding = EdgeInsets.all(md);
}

abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;
  static const double tam = 99;

  static BorderRadius smRadius = BorderRadius.circular(sm);
  static BorderRadius mdRadius = BorderRadius.circular(md);
  static BorderRadius lgRadius = BorderRadius.circular(lg);
  static BorderRadius xlRadius = BorderRadius.circular(xl);
  static BorderRadius tamRadius = BorderRadius.circular(tam);
}

abstract final class AppMotion {
  static const Duration hizli = Duration(milliseconds: 150);
  static const Duration normal = Duration(milliseconds: 300);
  static const Duration yavas = Duration(milliseconds: 500);
  static const Duration cokYavas = Duration(milliseconds: 800);

  static const Curve standart = Curves.easeOutCubic;
  static const Curve giris = Curves.easeOut;
  static const Curve cikis = Curves.easeIn;
  static const Curve bouncy = Curves.easeOutBack;
}
