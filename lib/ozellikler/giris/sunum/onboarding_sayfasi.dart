import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../../cekirdek/tasarim/tokenlar.dart';
import '../../../cekirdek/tasarim/app_buton.dart';
import '../../../cekirdek/servisler/servis_kayit.dart';
import '../../../l10n/app_localizations.dart';
import '../../kapsayici/sunum/ana_kapsayici_sayfa.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingSayfasi extends StatefulWidget {
  const OnboardingSayfasi({super.key});

  @override
  State<OnboardingSayfasi> createState() => _OnboardingSayfasiState();
}

class _OnboardingSayfasiState extends State<OnboardingSayfasi> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_OnboardingVeri> _sayfalar = [
    _OnboardingVeri(
      baslik: 'HOS GELDINIZ',
      aciklama: 'Arkadaslarinizin fotograflarini yukleyin ve yapay zekanin onlari yerin dibine sokmesini izleyin!',
      ikon: Icons.local_fire_department_rounded,
      renk: UygulamaRenkleri.anaRenk,
    ),
    _OnboardingVeri(
      baslik: 'JUDGE SECIN',
      aciklama: 'Birbirinden farkli karakterlerle savasin hakemini belirleyin. Her karakterin tarzi farklidir!',
      ikon: Icons.psychology_rounded,
      renk: UygulamaRenkleri.vurguRenk,
    ),
    _OnboardingVeri(
      baslik: 'ZAFERE ULASIN',
      aciklama: 'Savasin galibi kim olacak? Sonuclari paylasin ve eglenceyi katlayin!',
      ikon: Icons.emoji_events_rounded,
      renk: UygulamaRenkleri.neonPembe,
    ),
  ];

  void _ileri() {
    HapticFeedback.lightImpact();
    if (_currentPage < _sayfalar.length - 1) {
      _pageController.nextPage(duration: AppMotion.yavas, curve: AppMotion.standart);
    } else {
      _tamamla();
    }
  }

  void _atla() {
    HapticFeedback.lightImpact();
    _tamamla();
  }

  Future<void> _tamamla() async {
    await servisBulucu<SharedPreferences>().setBool('onboarding_tamamlandi', true);
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => const AnaKapsayiciSayfa(),
        transitionsBuilder: (_, animation, __, child) =>
            FadeTransition(opacity: animation, child: child),
        transitionDuration: AppMotion.yavas,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isLast = _currentPage == _sayfalar.length - 1;

    final sayfalar = [
      _OnboardingVeri(
        baslik: l10n.onboardingHosGeldinizBaslik,
        aciklama: l10n.onboardingHosGeldinizAciklama,
        ikon: Icons.local_fire_department_rounded,
        renk: UygulamaRenkleri.anaRenk,
      ),
      _OnboardingVeri(
        baslik: l10n.onboardingJudgeSecinBaslik,
        aciklama: l10n.onboardingJudgeSecinAciklama,
        ikon: Icons.psychology_rounded,
        renk: UygulamaRenkleri.vurguRenk,
      ),
      _OnboardingVeri(
        baslik: l10n.onboardingZafereUlasinBaslik,
        aciklama: l10n.onboardingZafereUlasinAciklama,
        ikon: Icons.emoji_events_rounded,
        renk: UygulamaRenkleri.neonPembe,
      ),
    ];

    return Scaffold(
      backgroundColor: UygulamaRenkleri.arkaPlan,
      body: Stack(
        children: [
          // Animated background orb
          AnimatedPositioned(
            duration: AppMotion.cokYavas,
            curve: AppMotion.standart,
            top: _currentPage * 80.0 - 100,
            right: _currentPage * -50.0 - 50,
            child: Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    sayfalar[_currentPage].renk.withAlpha(40),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          PageView.builder(
            controller: _pageController,
            itemCount: sayfalar.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final veri = sayfalar[index];
              return _OnboardingSayfa(veri: veri);
            },
          ),

          // Bottom controls
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Page indicators
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        sayfalar.length,
                        (index) => AnimatedContainer(
                          duration: AppMotion.normal,
                          curve: AppMotion.standart,
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 4,
                          width: _currentPage == index ? 32 : 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? sayfalar[_currentPage].renk
                                : Colors.white54,
                            borderRadius: AppRadius.tamRadius,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: AppSpacing.xl),

                    Semantics(
                      button: true,
                      label: isLast ? 'Onboarding tamamla' : 'Sonraki onboarding adimi',
                      child: AppButon(
                        metin: isLast ? l10n.onboardingBaslayalim : l10n.onboardingSonraki,
                        ikon: isLast ? Icons.rocket_launch_rounded : Icons.arrow_forward_rounded,
                        onTap: _ileri,
                      ),
                    ),

                    if (!isLast) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Semantics(
                        button: true,
                        label: 'Onboarding adimlarini atla',
                        child: AppButon(
                          metin: l10n.onboardingAtla,
                          stil: AppButonStil.hayalet,
                          yukseklik: 44,
                          onTap: _atla,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingSayfa extends StatelessWidget {
  final _OnboardingVeri veri;
  const _OnboardingSayfa({required this.veri});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Semantics(
            label: '${veri.baslik} ikonu',
            image: true,
            child: Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: veri.renk.withAlpha(20),
                border: Border.all(color: veri.renk.withAlpha(60), width: 2),
                boxShadow: [
                  BoxShadow(color: veri.renk.withAlpha(30), blurRadius: 40, spreadRadius: -4),
                ],
              ),
              child: Icon(veri.ikon, size: 80, color: veri.renk),
            ),
          )
              .animate()
              .scale(duration: 600.ms, curve: AppMotion.bouncy)
              .fadeIn(),

          const SizedBox(height: AppSpacing.xxl),

          Text(
            veri.baslik,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              letterSpacing: 3,
              color: Colors.white,
            ),
          ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.15, curve: AppMotion.standart),

          const SizedBox(height: AppSpacing.md),

          Text(
            veri.aciklama,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.white60, height: 1.6),
          ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.15, curve: AppMotion.standart),

          const SizedBox(height: 120),
        ],
      ),
    );
  }
}

class _OnboardingVeri {
  final String baslik;
  final String aciklama;
  final IconData ikon;
  final Color renk;

  const _OnboardingVeri({
    required this.baslik,
    required this.aciklama,
    required this.ikon,
    required this.renk,
  });
}
