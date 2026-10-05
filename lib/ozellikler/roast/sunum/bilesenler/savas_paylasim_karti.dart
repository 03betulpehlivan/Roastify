import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../cekirdek/sabitler/renkler.dart';
import '../../veri/savas_model.dart';
import '../../../../cekirdek/bilesenler/cam_kart.dart';

class SavasPaylasimKarti extends StatelessWidget {
  final SavasModel savas;
  final File fotograf1;
  final File fotograf2;
  final double genislik;

  const SavasPaylasimKarti({
    super.key,
    required this.savas,
    required this.fotograf1,
    required this.fotograf2,
    this.genislik = 1080,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: genislik,
      height: genislik * 1.5,
      decoration: BoxDecoration(
        color: UygulamaRenkleri.arkaPlan,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            UygulamaRenkleri.neonMavi.withOpacity(0.2),
            UygulamaRenkleri.arkaPlan,
            UygulamaRenkleri.neonPembe.withOpacity(0.2),
          ],
        ),
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(60.0),
            child: Column(
              children: [
                // Başlık
                const Text(
                  "BATTLE ARENA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 64,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 4,
                  ),
                ),
                Text(
                   "HAKEM: ${savas.karakter.toUpperCase()}",
                   style: const TextStyle(color: UygulamaRenkleri.anaRenk, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 8),
                ),

                const SizedBox(height: 60),

                // Karşılaşma Alanı
                Expanded(
                  child: Row(
                    children: [
                      _Savasci(foto: fotograf1, roast: savas.birinciRoast, kazandi: savas.kazananIndeksi == 1, no: 1, renk: UygulamaRenkleri.neonMavi),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("VS", style: TextStyle(color: Colors.white, fontSize: 80, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic)),
                      ),
                      _Savasci(foto: fotograf2, roast: savas.ikinciRoast, kazandi: savas.kazananIndeksi == 2, no: 2, renk: UygulamaRenkleri.neonPembe),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Hakem Kararı Özeti
                CamKart(
                  renk: Colors.white.withOpacity(0.08),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 30),
                  child: Column(
                    children: [
                      const Text("OFFICIAL VERDICT", style: TextStyle(color: UygulamaRenkleri.anaRenk, fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 4)),
                      const SizedBox(height: 12),
                      Text(
                        savas.kazanmaNedeni,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w600, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 40),

                // Branding
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "KAPAK OLSUN",
                      style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900, letterSpacing: 2),
                    ),
                    SizedBox(width: 20),
                    Text(
                      "kapakolsun.app",
                      style: TextStyle(color: Colors.white54, fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Savasci extends StatelessWidget {
  final File foto;
  final String roast;
  final bool kazandi;
  final int no;
  final Color renk;

  const _Savasci({required this.foto, required this.roast, required this.kazandi, required this.no, required this.renk});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: kazandi ? renk : Colors.white10,
                  width: kazandi ? 12 : 2,
                ),
                boxShadow: kazandi ? [
                  BoxShadow(color: renk.withOpacity(0.5), blurRadius: 60, spreadRadius: 10),
                ] : [],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.file(foto, fit: BoxFit.cover),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "YARIŞMACI #$no",
            style: TextStyle(color: kazandi ? renk : Colors.white70, fontWeight: FontWeight.w900, fontSize: 20),
          ),
        ],
      ),
    );
  }
}
