import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../sabitler/renkler.dart';
import 'tokenlar.dart';

enum DurumBannerTip { basari, hata, bilgi }

class DurumBanner extends StatelessWidget {
  final String mesaj;
  final DurumBannerTip tip;

  const DurumBanner({
    super.key,
    required this.mesaj,
    this.tip = DurumBannerTip.bilgi,
  });

  static void goster(BuildContext context, {required String mesaj, DurumBannerTip tip = DurumBannerTip.bilgi}) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) => _BannerOverlay(
        mesaj: mesaj,
        tip: tip,
        onBitti: () => entry.remove(),
      ),
    );
    overlay.insert(entry);
  }

  Color get _arkaRenk {
    switch (tip) {
      case DurumBannerTip.basari:
        return const Color(0xFF1DB954);
      case DurumBannerTip.hata:
        return UygulamaRenkleri.hata;
      case DurumBannerTip.bilgi:
        return UygulamaRenkleri.anaRenk;
    }
  }

  IconData get _ikon {
    switch (tip) {
      case DurumBannerTip.basari:
        return Icons.check_circle_outline;
      case DurumBannerTip.hata:
        return Icons.error_outline;
      case DurumBannerTip.bilgi:
        return Icons.info_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xs),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: _arkaRenk.withAlpha(40),
        borderRadius: AppRadius.mdRadius,
        border: Border.all(color: _arkaRenk.withAlpha(80)),
      ),
      child: Row(
        children: [
          Icon(_ikon, color: _arkaRenk, size: 20),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              mesaj,
              style: TextStyle(color: _arkaRenk, fontWeight: FontWeight.w600, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerOverlay extends StatefulWidget {
  final String mesaj;
  final DurumBannerTip tip;
  final VoidCallback onBitti;

  const _BannerOverlay({required this.mesaj, required this.tip, required this.onBitti});

  @override
  State<_BannerOverlay> createState() => _BannerOverlayState();
}

class _BannerOverlayState extends State<_BannerOverlay> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) widget.onBitti();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + AppSpacing.md,
      left: 0,
      right: 0,
      child: Material(
        color: Colors.transparent,
        child: DurumBanner(mesaj: widget.mesaj, tip: widget.tip)
            .animate()
            .fadeIn(duration: AppMotion.hizli)
            .slideY(begin: -0.5, duration: AppMotion.normal, curve: AppMotion.bouncy),
      ),
    );
  }
}
