import 'dart:ui';
import 'package:flutter/material.dart';
import '../sabitler/renkler.dart';
import 'tokenlar.dart';

class CamKartV2 extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double? kenarYaricap;
  final LinearGradient? kenarGradyan;
  final bool aktif;

  const CamKartV2({
    super.key,
    required this.child,
    this.padding,
    this.kenarYaricap,
    this.kenarGradyan,
    this.aktif = false,
  });

  @override
  Widget build(BuildContext context) {
    final radius = kenarYaricap ?? AppRadius.lg;

    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
        child: AnimatedContainer(
          duration: AppMotion.normal,
          curve: AppMotion.standart,
          padding: padding ?? AppSpacing.kartPadding,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(
              color: aktif 
                  ? UygulamaRenkleri.anaRenk.withAlpha(120) 
                  : Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white.withAlpha(18) 
                      : Colors.black.withAlpha(12),
              width: aktif ? 1.5 : 1,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: aktif
                  ? [
                      UygulamaRenkleri.anaRenk.withAlpha(35),
                      UygulamaRenkleri.vurguRenk.withAlpha(12),
                    ]
                  : [
                      Theme.of(context).brightness == Brightness.dark 
                          ? Colors.white.withAlpha(18) 
                          : Colors.white.withAlpha(200),
                      Theme.of(context).brightness == Brightness.dark 
                          ? Colors.white.withAlpha(8) 
                          : Colors.white.withAlpha(100),
                    ],
            ),
            boxShadow: aktif
                ? [
                    BoxShadow(
                      color: UygulamaRenkleri.anaRenk.withAlpha(30),
                      blurRadius: 24,
                      spreadRadius: -4,
                    ),
                  ]
                : null,
          ),
          child: child,
        ),
      ),
    );
  }
}
