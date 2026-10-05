import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../sabitler/renkler.dart';
import 'tokenlar.dart';

enum AppButonStil { birincil, ikincil, hayalet }

class AppButon extends StatelessWidget {
  final String metin;
  final VoidCallback? onTap;
  final AppButonStil stil;
  final IconData? ikon;
  final bool yukleniyor;
  final double yukseklik;

  const AppButon({
    super.key,
    required this.metin,
    this.onTap,
    this.stil = AppButonStil.birincil,
    this.ikon,
    this.yukleniyor = false,
    this.yukseklik = 60,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: yukseklik,
      width: double.infinity,
      child: _butonIcerigi(),
    );
  }

  Widget _butonIcerigi() {
    switch (stil) {
      case AppButonStil.birincil:
        return _birincil();
      case AppButonStil.ikincil:
        return _ikincil();
      case AppButonStil.hayalet:
        return _hayalet();
    }
  }

  Widget _birincil() {
    return ElevatedButton(
      onPressed: yukleniyor ? null : _onTapWithHaptic,
      style: ElevatedButton.styleFrom(
        backgroundColor: UygulamaRenkleri.anaRenk,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
        elevation: 0,
      ),
      child: _icerik(),
    );
  }

  Widget _ikincil() {
    return OutlinedButton(
      onPressed: yukleniyor ? null : _onTapWithHaptic,
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.white54),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
      ),
      child: _icerik(),
    );
  }

  Widget _hayalet() {
    return TextButton(
      onPressed: yukleniyor ? null : _onTapWithHaptic,
      style: TextButton.styleFrom(
        foregroundColor: Colors.white70,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
      ),
      child: _icerik(),
    );
  }

  Widget _icerik() {
    if (yukleniyor) {
      return const SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      );
    }
    if (ikon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(ikon, size: 20),
          const SizedBox(width: AppSpacing.xs),
          Text(metin, style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1)),
        ],
      );
    }
    return Text(metin, style: const TextStyle(fontWeight: FontWeight.w700, letterSpacing: 1));
  }

  void _onTapWithHaptic() {
    HapticFeedback.lightImpact();
    onTap?.call();
  }
}
