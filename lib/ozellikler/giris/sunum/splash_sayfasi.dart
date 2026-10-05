import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../../cekirdek/sabitler/metinler.dart';
import '../../../cekirdek/servisler/servis_kayit.dart';
import '../../kapsayici/sunum/ana_kapsayici_sayfa.dart';
import 'onboarding_sayfasi.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashSayfasi extends StatefulWidget {
  const SplashSayfasi({super.key});

  @override
  State<SplashSayfasi> createState() => _SplashSayfasiState();
}

class _SplashSayfasiState extends State<SplashSayfasi> {
  @override
  void initState() {
    super.initState();
    // 3 saniye sonra Onboarding'e geç
    Timer(const Duration(milliseconds: 3500), () {
      if (mounted) {
        final onboardingTamamlandi = servisBulucu<SharedPreferences>().getBool('onboarding_tamamlandi') ?? false;

        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => 
              onboardingTamamlandi ? const AnaKapsayiciSayfa() : const OnboardingSayfasi(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 800),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UygulamaRenkleri.arkaPlan,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Alanı
            Container(
              width: 160,
              height: 160,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: UygulamaRenkleri.anaRenk.withOpacity(0.1),
                boxShadow: [
                  BoxShadow(
                    color: UygulamaRenkleri.anaRenk.withOpacity(0.2),
                    blurRadius: 40,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Image.asset(
                'assets/ikon/app_icon.png',
                fit: BoxFit.contain,
              ),
            )
            .animate()
            .scale(duration: 1.seconds, curve: Curves.easeOutBack)
            .shimmer(delay: 1200.ms, duration: 1500.ms, color: UygulamaRenkleri.vurguRenk),

            const SizedBox(height: 40),

            // Uygulama Adı
            Text(
              UygulamaMetinleri.uygulamaAdi,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                color: Colors.white,
                letterSpacing: 4,
                fontWeight: FontWeight.w900,
              ),
            )
            .animate()
            .fadeIn(delay: 500.ms, duration: 800.ms)
            .slideY(begin: 0.3, end: 0, curve: Curves.easeOutQuad),

            const SizedBox(height: 12),

            // Slogan
            Text(
              UygulamaMetinleri.slogan.toUpperCase(),
              style: const TextStyle(
                color: UygulamaRenkleri.vurguRenk,
                letterSpacing: 3,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            )
            .animate()
            .fadeIn(delay: 1000.ms, duration: 800.ms),
            
            const SizedBox(height: 100),
            
            // Yükleme Çizgisi
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 100),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  backgroundColor: Colors.white.withOpacity(0.05),
                  color: UygulamaRenkleri.anaRenk,
                  minHeight: 2,
                ),
              ),
            ).animate().fadeIn(delay: 1500.ms),
          ],
        ),
      ),
    );
  }
}
