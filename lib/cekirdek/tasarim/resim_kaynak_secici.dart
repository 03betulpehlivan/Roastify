import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'tokenlar.dart';
import '../sabitler/renkler.dart';
import 'cam_kart_v2.dart';

class ResimKaynakSecici {
  static Future<ImageSource?> goster(BuildContext context) async {
    return showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        decoration: const BoxDecoration(
          color: UygulamaRenkleri.yuzey,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'FOTOĞRAF NEREDEN?',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: _KaynakButonu(
                    ikon: Icons.camera_alt_rounded,
                    etiket: 'KAMERA',
                    renk: UygulamaRenkleri.anaRenk,
                    onTap: () => Navigator.pop(context, ImageSource.camera),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _KaynakButonu(
                    ikon: Icons.photo_library_rounded,
                    etiket: 'GALERİ',
                    renk: UygulamaRenkleri.vurguRenk,
                    onTap: () => Navigator.pop(context, ImageSource.gallery),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class _KaynakButonu extends StatelessWidget {
  final IconData ikon;
  final String etiket;
  final Color renk;
  final VoidCallback onTap;

  const _KaynakButonu({
    required this.ikon,
    required this.etiket,
    required this.renk,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CamKartV2(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Column(
          children: [
            Icon(ikon, color: renk, size: 32),
            const SizedBox(height: 12),
            Text(
              etiket,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1,
                color: renk.withOpacity(0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
