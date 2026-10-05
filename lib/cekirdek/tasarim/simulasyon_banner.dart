import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../sabitler/renkler.dart';
import '../is_mantigi/ayarlar_cubiti.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SimulasyonBanner extends StatelessWidget {
  const SimulasyonBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AyarlarCubiti, AyarlarState>(
      builder: (context, state) {
        if (!state.simulasyonModu) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                UygulamaRenkleri.anaRenk.withOpacity(0.8),
                UygulamaRenkleri.vurguRenk.withOpacity(0.8),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: UygulamaRenkleri.anaRenk.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.terminal_rounded, color: Colors.white, size: 14),
              SizedBox(width: 8),
              Text(
                'SİMÜLASYON MODU AKTİF (SAHTE CEVAPLAR)',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.5,
                ),
              ),
            ],
          ),
        )
        .animate(onPlay: (c) => c.repeat(reverse: true))
        .shimmer(duration: 2.seconds, color: Colors.white54);
      },
    );
  }
}
