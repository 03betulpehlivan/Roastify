import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'tokenlar.dart';

class BosEkran extends StatelessWidget {
  final IconData ikon;
  final String baslik;
  final String? aciklama;
  final Widget? aksiyon;

  const BosEkran({
    super.key,
    required this.ikon,
    required this.baslik,
    this.aciklama,
    this.aksiyon,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.sayfaPadding,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(ikon, size: 64, color: Colors.white54)
                .animate()
                .fadeIn(duration: AppMotion.yavas)
                .scale(begin: const Offset(0.6, 0.6), curve: AppMotion.bouncy),
            const SizedBox(height: AppSpacing.lg),
            Text(
              baslik,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.w600),
            ),
            if (aciklama != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                aciklama!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
            ],
            if (aksiyon != null) ...[
              const SizedBox(height: AppSpacing.lg),
              aksiyon!,
            ],
          ],
        ),
      ),
    );
  }
}
