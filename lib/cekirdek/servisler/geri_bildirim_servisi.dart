import 'package:flutter/material.dart';
import '../sabitler/renkler.dart';
import 'servis_kayit.dart';
import 'titresim_servisi.dart';

class GeriBildirimServisi {
  final GlobalKey<ScaffoldMessengerState> messengerKey = GlobalKey<ScaffoldMessengerState>();

  void basariliGoster(String mesaj) {
    servisBulucu<TitresimServisi>().hafifTikla();
    _snarkbarGoster(
      mesaj: mesaj,
      renk: Colors.greenAccent.shade700,
      ikon: Icons.check_circle_outline,
    );
  }

  void hataGoster(String mesaj) {
    servisBulucu<TitresimServisi>().hataTitret();
    _snarkbarGoster(
      mesaj: mesaj,
      renk: UygulamaRenkleri.hata,
      ikon: Icons.error_outline,
    );
  }

  void uyariGoster(String mesaj) {
    servisBulucu<TitresimServisi>().ortaTikla();
    _snarkbarGoster(
      mesaj: mesaj,
      renk: UygulamaRenkleri.neonTuruncu,
      ikon: Icons.warning_amber_rounded,
    );
  }

  void _snarkbarGoster({
    required String mesaj,
    required Color renk,
    required IconData ikon,
  }) {
    messengerKey.currentState?.clearSnackBars();
    messengerKey.currentState?.showSnackBar(
      SnackBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: renk.withOpacity(0.9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: renk.withOpacity(0.3),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(ikon, color: Colors.white),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  mesaj,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
