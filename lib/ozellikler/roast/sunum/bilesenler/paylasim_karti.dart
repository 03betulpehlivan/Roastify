import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../cekirdek/sabitler/renkler.dart';
import '../../veri/roast_model.dart';
import '../../../../cekirdek/bilesenler/cam_kart.dart';

class PaylasimKarti extends StatelessWidget {
  final RoastModel roast;
  final File fotograf;
  final double genislik;

  const PaylasimKarti({
    super.key,
    required this.roast,
    required this.fotograf,
    this.genislik = 1080, // Standart yüksek çözünürlük
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: genislik,
      height: genislik * 1.5, // 2:3 oranında dikey kart (Story formatına uygun)
      decoration: BoxDecoration(
        color: UygulamaRenkleri.arkaPlan,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            UygulamaRenkleri.arkaPlan,
            UygulamaRenkleri.anaRenk.withOpacity(0.2),
            UygulamaRenkleri.arkaPlan,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Arka plan neon halkalar
          Positioned(
            top: -100,
            right: -100,
            child: _NeonHalka(renk: UygulamaRenkleri.anaRenk, boyut: 400),
          ),
          Positioned(
            bottom: -50,
            left: -50,
            child: _NeonHalka(renk: UygulamaRenkleri.vurguRenk, boyut: 300),
          ),

          Padding(
            padding: const EdgeInsets.all(60.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Başlık / Logo
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: UygulamaRenkleri.anaRenk,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 40),
                    ),
                    const SizedBox(width: 20),
                    const Text(
                      "KAPAK OLSUN",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 60),

                // Ana Fotoğraf (Büyük ve Modern)
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 50,
                          spreadRadius: 10,
                        ),
                        BoxShadow(
                          color: UygulamaRenkleri.anaRenk.withOpacity(0.3),
                          blurRadius: 30,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: Image.file(
                        fotograf,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Roast Kutusu
                CamKart(
                  kenarYaricap: 30,
                  renk: Colors.white.withOpacity(0.08),
                  child: Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      children: [
                        Text(
                          roast.karakter.toUpperCase(),
                          style: TextStyle(
                            color: UygulamaRenkleri.anaRenk,
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 4,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Icon(Icons.format_quote_rounded, color: Colors.white54, size: 60),
                        const SizedBox(height: 10),
                        Text(
                          roast.metin,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w600,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                // Alt Bilgi (QR veya Link alanı taklidi)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "HEMEN DENE",
                          style: TextStyle(color: Colors.white70, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 2),
                        ),
                        Text(
                          "kapakolsun.app",
                          style: TextStyle(color: Colors.white70, fontSize: 24, fontWeight: FontWeight.w900),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white54),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Text(
                        "#RoastBattle",
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                      ),
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

class _NeonHalka extends StatelessWidget {
  final Color renk;
  final double boyut;

  const _NeonHalka({required this.renk, required this.boyut});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boyut,
      height: boyut,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            renk.withOpacity(0.2),
            renk.withOpacity(0.05),
            Colors.transparent,
          ],
        ),
      ),
    );
  }
}
