import 'dart:ui';
import 'package:flutter/material.dart';
import '../sabitler/renkler.dart';

class CamKart extends StatelessWidget {
  final Widget child;
  final double? bulaniklik;
  final double? kenarYaricap;
  final Color? renk;
  final double? kenarGenislik;
  final EdgeInsetsGeometry? padding;

  const CamKart({
    super.key,
    required this.child,
    this.bulaniklik,
    this.kenarYaricap,
    this.renk,
    this.kenarGenislik,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(kenarYaricap ?? 24),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: bulaniklik ?? UygulamaRenkleri.camBulaniklik,
          sigmaY: bulaniklik ?? UygulamaRenkleri.camBulaniklik,
        ),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: renk ?? UygulamaRenkleri.camEfekt(Colors.white),
            borderRadius: BorderRadius.circular(kenarYaricap ?? 24),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
              width: kenarGenislik ?? UygulamaRenkleri.camKenarGenislik,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.12),
                Colors.white.withOpacity(0.04),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
