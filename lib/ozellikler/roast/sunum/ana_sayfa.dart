import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../../cekirdek/sabitler/metinler.dart';
import '../../../cekirdek/servisler/servis_kayit.dart';
import '../is_mantigi/roast_cubiti.dart';
import '../is_mantigi/roast_durum.dart';
import '../../../cekirdek/sabitler/tipler.dart';
import 'sonuc_sayfasi.dart';

import 'savas_hazirlik_sayfasi.dart';
import '../../kapsayici/sunum/ayarlar_sayfasi.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../../../cekirdek/servisler/istatistik_servisi.dart';
import '../../../cekirdek/tasarim/tokenlar.dart';
import '../../../cekirdek/tasarim/durum_banner.dart';
import '../../../cekirdek/tasarim/cam_kart_v2.dart';
import '../../../cekirdek/tasarim/sayfa_gecisleri.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../gecmis/sunum/gecmis_sayfasi.dart';
import '../../vitrin/sunum/vitrin_sayfasi.dart';
import '../../../cekirdek/tasarim/resim_kaynak_secici.dart';
import '../../../cekirdek/is_mantigi/ayarlar_cubiti.dart';
import '../../../cekirdek/tasarim/simulasyon_banner.dart';
import '../../../l10n/app_localizations.dart';


class AnaSayfa extends StatefulWidget {
  const AnaSayfa({super.key});

  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  String _seciliKarakter = UygulamaMetinleri.karakterHacerTeyze;
  String? _ozelPrompt;

  Future<void> _ozelKarakterDialogGoster({bool fotografSecimiBaslatsin = true}) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: _ozelPrompt);
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: UygulamaRenkleri.yuzey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.anaOzelKarakterBaslik, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.anaOzelKarakterAciklama,
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: controller,
                autofocus: true,
                maxLines: 3,
                maxLength: 100,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: l10n.anaOzelKarakterHint,
                  hintStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                ),
                validator: (v) => (v == null || v.isEmpty) ? l10n.anaOzelKarakterBosHata : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.iptal, style: const TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() => _ozelPrompt = controller.text);
                Navigator.pop(context);
                if (fotografSecimiBaslatsin) {
                  _fotografSecimiBaslat();
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: UygulamaRenkleri.anaRenk,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(l10n.tamam, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _fotografSecimiBaslat() async {
    final kaynak = await ResimKaynakSecici.goster(context);
    if (kaynak != null && mounted) {
      context.read<RoastCubiti>().fotografSec(kaynak: kaynak);
    }
  }

  Future<String?> _hizliKarakterSecimiGoster() async {
    return showModalBottomSheet<String>(
      context: context,
      backgroundColor: UygulamaRenkleri.yuzey,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: ListView.builder(
          itemCount: UygulamaMetinleri.tumKarakterler.length,
          itemBuilder: (context, index) {
            final karakter = UygulamaMetinleri.tumKarakterler[index];
            final secili = _seciliKarakter == karakter;
            return ListTile(
              leading: Icon(
                UygulamaMetinleri.karakterIkonu(karakter),
                color: UygulamaMetinleri.karakterRengi(karakter),
              ),
              title: Text(karakter),
              trailing: secili
                  ? const Icon(Icons.check_circle, color: UygulamaRenkleri.anaRenk)
                  : null,
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _seciliKarakter = karakter);
                Navigator.pop(context, karakter);
              },
            );
          },
        ),
      ),
    );
  }

  Future<void> _ayniFotograflaFarkliKarakterleUret({
    required File fotograf,
    required String mod,
  }) async {
    final secilenKarakter = await _hizliKarakterSecimiGoster();
    if (!mounted || secilenKarakter == null) {
      return;
    }

    if (secilenKarakter == UygulamaMetinleri.karakterOzel) {
      await _ozelKarakterDialogGoster(fotografSecimiBaslatsin: false);
    }

    if (!mounted) return;
    DurumBanner.goster(
      context,
      mesaj: AppLocalizations.of(context)!.anaYeniKapakHazirlaniyor,
      tip: DurumBannerTip.bilgi,
    );
    await context.read<RoastCubiti>().roastUret(
      fotograf: fotograf,
      karakter: _seciliKarakter,
      mod: mod,
      ozelPrompt: _ozelPrompt,
    );
  }

  Future<void> _baglamDialogGoster(File fotograf) async {
    final l10n = AppLocalizations.of(context)!;
    final kisiController = TextEditingController();
    final ozellikController = TextEditingController();
    final sirController = TextEditingController();
    bool isOvgu = false;

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: UygulamaRenkleri.yuzey,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          title: Text(isOvgu ? l10n.anaBaglamPozitifVibe : l10n.anaBaglamRoastGuclendir, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () => setDialogState(() => isOvgu = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: !isOvgu ? UygulamaRenkleri.anaRenk.withOpacity(0.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: !isOvgu ? UygulamaRenkleri.anaRenk : Colors.white54),
                        ),
                        child: Text(l10n.anaBaglamKapakla, style: TextStyle(color: !isOvgu ? UygulamaRenkleri.anaRenk : Colors.white54, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () => setDialogState(() => isOvgu = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isOvgu ? UygulamaRenkleri.vurguRenk.withOpacity(0.2) : Colors.transparent,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: isOvgu ? UygulamaRenkleri.vurguRenk : Colors.white54),
                        ),
                        child: Text(l10n.anaBaglamYucelt, style: TextStyle(color: isOvgu ? UygulamaRenkleri.vurguRenk : Colors.white54, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  isOvgu ? l10n.anaBaglamPozitifAciklama : l10n.anaBaglamRoastAciklama,
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: kisiController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: l10n.anaBaglamKisiHint,
                    hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: ozellikController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: isOvgu ? l10n.anaBaglamPozitifOzellikHint : l10n.anaBaglamNegatifOzellikHint,
                    hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: sirController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: isOvgu ? l10n.anaBaglamPozitifSirHint : l10n.anaBaglamNegatifSirHint,
                    hintStyle: const TextStyle(color: Colors.white54, fontSize: 13),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<RoastCubiti>().roastUret(
                  fotograf: fotograf,
                  karakter: _seciliKarakter,
                  mod: isOvgu ? UygulamaMetinleri.modOvgulu : UygulamaMetinleri.modAcimasiz,
                  ozelPrompt: _ozelPrompt,
                );
              },
              child: Text(l10n.anaBaglamBosver, style: const TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<RoastCubiti>().roastUret(
                  fotograf: fotograf,
                  karakter: _seciliKarakter,
                  mod: isOvgu ? UygulamaMetinleri.modOvgulu : UygulamaMetinleri.modAcimasiz,
                  ozelPrompt: _ozelPrompt,
                  kisiYakinligi: kisiController.text,
                  sinirBozucuOzellik: ozellikController.text,
                  sir: sirController.text,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isOvgu ? UygulamaRenkleri.vurguRenk : UygulamaRenkleri.anaRenk,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: Text(isOvgu ? l10n.anaBaglamYucelt : l10n.anaBaglamKapakla, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return BlocListener<RoastCubiti, RoastDurum>(
      listener: (context, durum) async {
        if (durum is RoastHata) {
          DurumBanner.goster(
            context,
            mesaj: UygulamaMetinleri.hataMesaji(durum.tip, ekMesaj: durum.mesaj),
            tip: DurumBannerTip.hata,
          );
        } else if (durum is RoastFotografSecildi) {
          await _baglamDialogGoster(durum.fotograf);
        } else if (durum is RoastBasarili) {
          final sonuc = await Navigator.of(context).push<String>(
            OlcekliGecis(
              sayfa: SonucSayfasi(
                roast: durum.roast,
                fotograf: durum.fotograf,
              ),
            ),
          );
          if (!mounted) return;
          if (sonuc == SonucSayfasi.farkliKarakterAksiyonu) {
            await _hizliKarakterSecimiGoster();
          } else if (sonuc == SonucSayfasi.ayniFotografFarkliKarakterAksiyonu) {
            await _ayniFotograflaFarkliKarakterleUret(
              fotograf: durum.fotograf,
              mod: durum.roast.mod,
            );
          }
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark ? Brightness.light : Brightness.dark,
        ),
        child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            // Derin Neon Arka Plan
            Positioned.fill(
              child: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            Column(
              children: [
                const SimulasyonBanner(),
                Expanded(
                  child: Stack(
                    children: [
                      if (Theme.of(context).brightness == Brightness.dark)
                        Positioned(
                          top: -100,
                          right: -100,
                          child: Container(
                            width: 300,
                            height: 300,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: UygulamaRenkleri.anaRenk.withOpacity(0.15),
                            ),
                          ).animate(onPlay: (c) => c.repeat(reverse: true))
                           .scale(duration: 4.seconds, begin: const Offset(1, 1), end: const Offset(1.5, 1.5))
                           .blur(begin: const Offset(50, 50), end: const Offset(100, 100)),
                        ),
                      SafeArea(
                        bottom: false,
                        child: CustomScrollView(
                physics: const BouncingScrollPhysics(),
                slivers: [
                  // Üst Bar ve Ayarlar
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.uygulamaAdi,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                  color: Theme.of(context).textTheme.bodyLarge?.color,
                                ),
                              ).animate().fadeIn().slideX(begin: -0.2),
                                Text(
                                  UygulamaMetinleri.slogan,
                                  style: TextStyle(
                                    color: Theme.of(context).brightness == Brightness.dark 
                                        ? UygulamaRenkleri.vurguRenk 
                                        : UygulamaRenkleri.vurguRenk.withBlue(200).withGreen(150),
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ).animate().fadeIn(delay: 200.ms),
                            ],
                          ),
                          Row(
                            children: [
                              _AyarlarButonu(),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
                      child: _SavageMeter(),
                    ),
                  ),

                  SliverToBoxAdapter(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: AppSpacing.lg, top: AppSpacing.xl, bottom: AppSpacing.md),
                          child: Row(
                            children: [
                              Container(
                                width: 3,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: UygulamaRenkleri.anaRenk,
                                  borderRadius: AppRadius.tamRadius,
                                ),
                              ),
                              const SizedBox(width: AppSpacing.xs),
                                Text(
                                  l10n.anaStiliniSec,
                                  style: TextStyle(
                                    color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 190,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                            physics: const BouncingScrollPhysics(),
                            itemCount: UygulamaMetinleri.tumKarakterler.length,
                            itemBuilder: (context, index) {
                              final karakter = UygulamaMetinleri.tumKarakterler[index];
                              return _KarakterCarouselKart(
                                isim: karakter,
                                ikon: UygulamaMetinleri.karakterIkonu(karakter),
                                renk: UygulamaMetinleri.karakterRengi(karakter),
                                seciliMi: _seciliKarakter == karakter,
                                onTap: () => setState(() => _seciliKarakter = karakter),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.xl),
                    sliver: SliverToBoxAdapter(
                      child: BlocBuilder<RoastCubiti, RoastDurum>(
                        builder: (context, durum) {
                          if (durum is RoastYukleniyor) {
                            return _YuklemeAnimasyonu(
                              asama: durum.asama,
                              kismiMetin: durum.kismiMetin,
                            );
                          }
                          return Column(
                            children: [
                              _SimulasyonKarti(),
                              const SizedBox(height: AppSpacing.sm),
                              _ModKarti(
                                baslik: l10n.anaTekliKapakBaslik,
                                altBaslik: l10n.anaTekliKapakAltBaslik,
                                ikon: Icons.psychology_outlined,
                                renk: UygulamaRenkleri.anaRenk,
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  if (_seciliKarakter == UygulamaMetinleri.karakterOzel) {
                                    unawaited(_ozelKarakterDialogGoster());
                                  } else {
                                    _fotografSecimiBaslat();
                                  }
                                },
                              ),
                              const SizedBox(height: AppSpacing.md),
                              _ModKarti(
                                baslik: l10n.anaBattleModuBaslik,
                                altBaslik: l10n.anaBattleModuAltBaslik,
                                ikon: Icons.bolt_rounded,
                                renk: UygulamaRenkleri.vurguRenk,
                                isOutline: true,
                                onTap: () {
                                  HapticFeedback.mediumImpact();
                                  Navigator.of(context).push(
                                    KaydirmaliGecis(sayfa: const SavasHazirlikSayfasi()),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
        ),
      ),
    );
  }
}

class _KarakterCarouselKart extends StatelessWidget {
  final String isim;
  final IconData ikon;
  final Color renk;
  final bool seciliMi;
  final VoidCallback onTap;

  const _KarakterCarouselKart({
    required this.isim,
    required this.ikon,
    required this.renk,
    required this.seciliMi,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: AppSpacing.xs),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        child: AnimatedContainer(
          duration: AppMotion.normal,
          curve: AppMotion.standart,
          width: 140,
          padding: AppSpacing.kartPadding,
          decoration: BoxDecoration(
            color: seciliMi 
                ? renk.withAlpha(50) 
                : Theme.of(context).brightness == Brightness.dark 
                    ? Colors.white.withAlpha(8) 
                    : Colors.white,
            borderRadius: AppRadius.lgRadius,
            border: Border.all(
              color: seciliMi 
                  ? renk 
                  : Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white10 
                      : Colors.black12,
              width: seciliMi ? 2 : 1,
            ),
            boxShadow: seciliMi
                ? [BoxShadow(color: renk.withAlpha(75), blurRadius: 20, spreadRadius: -4)]
                : Theme.of(context).brightness == Brightness.light
                    ? [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 10, offset: const Offset(0, 2))]
                    : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedScale(
                scale: seciliMi ? 1.15 : 1.0,
                duration: AppMotion.normal,
                curve: AppMotion.bouncy,
                child: Icon(
                  ikon, 
                  size: 40, 
                  color: seciliMi 
                      ? renk 
                      : Theme.of(context).iconTheme.color?.withOpacity(0.5) ?? Colors.grey,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                isim.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: seciliMi 
                      ? (Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black87) 
                      : Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  letterSpacing: 0.5,
                ),
              ),
              if (seciliMi)
                Container(
                  margin: const EdgeInsets.only(top: AppSpacing.xs),
                  width: 20,
                  height: 3,
                  decoration: BoxDecoration(
                    color: renk,
                    borderRadius: AppRadius.tamRadius,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModKarti extends StatelessWidget {
  final String baslik;
  final String altBaslik;
  final IconData ikon;
  final Color renk;
  final VoidCallback onTap;
  final bool isOutline;

  const _ModKarti({
    required this.baslik,
    required this.altBaslik,
    required this.ikon,
    required this.renk,
    required this.onTap,
    this.isOutline = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CamKartV2(
        kenarYaricap: AppRadius.lg,
        aktif: !isOutline,
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: renk.withAlpha(50),
                shape: BoxShape.circle,
              ),
              child: Icon(ikon, color: renk, size: 28),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    baslik,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxs),
                  Text(
                    altBaslik,
                    style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.5), fontSize: 13),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(AppSpacing.xs),
              decoration: BoxDecoration(
                color: renk.withAlpha(25),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.arrow_forward_ios_rounded, color: renk, size: 14),
            ),
          ],
        ),
      ),
    ).animate().fadeIn(delay: 400.ms, duration: AppMotion.yavas).slideY(begin: 0.05, curve: AppMotion.standart);
  }
}
class _AyarlarButonu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        HapticFeedback.lightImpact();
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AyarlarSayfasi()),
        );
      },
      icon: Icon(
        Icons.settings_outlined, 
        color: Theme.of(context).brightness == Brightness.dark 
            ? Colors.white54 
            : Colors.black54,
      ),
      splashRadius: 24,
    );
  }
}

class _YuklemeAnimasyonu extends StatelessWidget {
  final RoastAsamasi asama;
  final String? kismiMetin;
  const _YuklemeAnimasyonu({required this.asama, this.kismiMetin});

  double _ilerlemeDegeri() {
    switch (asama) {
      case RoastAsamasi.analiz:
        return 0.33;
      case RoastAsamasi.tonAyari:
        return 0.66;
      case RoastAsamasi.metinUretimi:
        return 0.9;
      default:
        return 0.8;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ilerleme = _ilerlemeDegeri();
    final yuzde = (ilerleme * 100).round();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
      child: CamKartV2(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          children: [
            Lottie.network(
              'https://assets10.lottiefiles.com/packages/lf20_stkm9vsh.json',
              height: 130,
              errorBuilder: (context, error, stackTrace) =>
                  const CircularProgressIndicator(color: UygulamaRenkleri.anaRenk),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              UygulamaMetinleri.asamaMesaji(asama).toUpperCase(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: UygulamaRenkleri.vurguRenk,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
              ),
            ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds),
            if (kismiMetin != null && kismiMetin!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.xl),
              Container(
                padding: const EdgeInsets.all(AppSpacing.md),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white.withOpacity(0.05) 
                      : Colors.black.withOpacity(0.03),
                  borderRadius: AppRadius.mdRadius,
                  border: Border.all(color: UygulamaRenkleri.anaRenk.withOpacity(0.2)),
                ),
                child: Text(
                  kismiMetin!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                    fontSize: 15,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ).animate().fadeIn().slideY(begin: 0.1),
              ),
            ],
            const SizedBox(height: AppSpacing.lg),
            ClipRRect(
              borderRadius: AppRadius.tamRadius,
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: ilerleme),
                duration: AppMotion.yavas,
                curve: AppMotion.standart,
                builder: (context, value, _) => LinearProgressIndicator(
                  value: value,
                  minHeight: 6,
                  backgroundColor: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white.withAlpha(18) 
                      : Colors.black.withAlpha(12),
                  color: UygulamaRenkleri.anaRenk,
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              '%$yuzde',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5),
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavageMeter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final stats = servisBulucu<IstatistikServisi>();
    final progress = stats.seviyeIlerleme;

    return CamKartV2(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    stats.unvan.toUpperCase(),
                    style: const TextStyle(
                      color: UygulamaRenkleri.anaRenk,
                      fontWeight: FontWeight.w900,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    stats.gunlukLimitDolduMu
                        ? "${l10n.anaKalanHak}: ${stats.kalanHak} • ${l10n.anaYenilenme}: ${stats.yenilenmeyeKalanYazi}"
                        : "${l10n.anaKalanHak}: ${stats.kalanHak}",
                    style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5), fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs + 2),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white.withAlpha(13) 
                      : Colors.black.withAlpha(8),
                  borderRadius: AppRadius.tamRadius,
                  border: Border.all(color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withAlpha(18) : Colors.black12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department_rounded, color: UygulamaRenkleri.neonTuruncu, size: 14),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      '${stats.toplamRoast} ${l10n.anaRoastEtiketi}',
                      style: TextStyle(color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.7), fontSize: 10, fontWeight: FontWeight.w900),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Stack(
            children: [
              Container(
                height: 8,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white.withAlpha(13) 
                      : Colors.black.withAlpha(12),
                  borderRadius: AppRadius.tamRadius,
                ),
              ),
              LayoutBuilder(
                builder: (context, constraints) => AnimatedContainer(
                  duration: AppMotion.cokYavas,
                  curve: AppMotion.standart,
                  height: 8,
                  width: constraints.maxWidth * progress,
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.tamRadius,
                    gradient: const LinearGradient(
                      colors: [UygulamaRenkleri.anaRenk, UygulamaRenkleri.vurguRenk],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: UygulamaRenkleri.anaRenk.withAlpha(125),
                        blurRadius: 12,
                        spreadRadius: -2,
                      ),
                    ],
                  ),
                ).animate().shimmer(delay: 1.seconds, duration: 2.seconds),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SimulasyonKarti extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    bool simulasyon = context.watch<AyarlarCubiti>().state.simulasyonModu;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          context.read<AyarlarCubiti>().simulasyonModuDegistir(!simulasyon);
        },
        child: CamKartV2(
          padding: const EdgeInsets.all(AppSpacing.md),
          aktif: simulasyon,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: simulasyon 
                      ? UygulamaRenkleri.anaRenk.withOpacity(0.2) 
                      : Theme.of(context).brightness == Brightness.dark 
                          ? Colors.white.withOpacity(0.05) 
                          : Colors.black.withOpacity(0.03),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.terminal_rounded, 
                  color: simulasyon ? UygulamaRenkleri.anaRenk : Theme.of(context).iconTheme.color?.withOpacity(0.5),
                  size: 20,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.anaSimulasyonModu,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                        fontWeight: FontWeight.bold, 
                        fontSize: 13, 
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      l10n.anaSimulasyonAciklama,
                      style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodySmall?.color?.withOpacity(0.5)),
                    ),
                  ],
                ),
              ),
              Switch(
                value: simulasyon,
                onChanged: (val) {
                  HapticFeedback.lightImpact();
                  context.read<AyarlarCubiti>().simulasyonModuDegistir(val);
                },
                activeColor: UygulamaRenkleri.anaRenk,
                activeTrackColor: UygulamaRenkleri.anaRenk.withOpacity(0.3),
                inactiveThumbColor: Theme.of(context).brightness == Brightness.dark ? Colors.white54 : Colors.grey,
                inactiveTrackColor: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.1) : Colors.black12,
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn().slideY(begin: 0.1);
  }
}
