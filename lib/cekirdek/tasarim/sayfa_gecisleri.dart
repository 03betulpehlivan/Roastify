import 'package:flutter/material.dart';
import 'tokenlar.dart';

class KaydirmaliGecis<T> extends PageRouteBuilder<T> {
  final Widget sayfa;

  KaydirmaliGecis({required this.sayfa})
      : super(
          pageBuilder: (_, __, ___) => sayfa,
          transitionDuration: AppMotion.normal,
          reverseTransitionDuration: AppMotion.normal,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(parent: animation, curve: AppMotion.standart);
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero).animate(curved),
              child: FadeTransition(opacity: curved, child: child),
            );
          },
        );
}

class SolunmaGecis<T> extends PageRouteBuilder<T> {
  final Widget sayfa;

  SolunmaGecis({required this.sayfa})
      : super(
          pageBuilder: (_, __, ___) => sayfa,
          transitionDuration: AppMotion.yavas,
          reverseTransitionDuration: AppMotion.normal,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(parent: animation, curve: AppMotion.standart),
              child: child,
            );
          },
        );
}

class OlcekliGecis<T> extends PageRouteBuilder<T> {
  final Widget sayfa;

  OlcekliGecis({required this.sayfa})
      : super(
          pageBuilder: (_, __, ___) => sayfa,
          transitionDuration: AppMotion.normal,
          reverseTransitionDuration: AppMotion.normal,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curved = CurvedAnimation(parent: animation, curve: AppMotion.bouncy);
            return ScaleTransition(
              scale: Tween<double>(begin: 0.85, end: 1).animate(curved),
              child: FadeTransition(opacity: curved, child: child),
            );
          },
        );
}
