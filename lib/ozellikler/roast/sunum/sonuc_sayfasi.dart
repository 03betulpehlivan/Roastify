import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:share_plus/share_plus.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';
import '../is_mantigi/roast_cubiti.dart';
import '../veri/roast_model.dart';
import '../../vitrin/is_mantigi/vitrin_cubiti.dart';
import '../../vitrin/is_mantigi/vitrin_durum.dart';
import '../../../cekirdek/tasarim/durum_banner.dart';
import 'bilesenler/paylasim_karti.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../../cekirdek/bilesenler/cam_kart.dart';
import '../../../cekirdek/tasarim/tokenlar.dart';
import '../../../cekirdek/tasarim/app_buton.dart';
import '../../../cekirdek/tasarim/simulasyon_banner.dart';
import '../../../l10n/app_localizations.dart';

class SonucSayfasi extends StatefulWidget {
  static const String farkliKarakterAksiyonu = 'farkli_karakter_sec';
  static const String ayniFotografFarkliKarakterAksiyonu = 'ayni_fotograf_farkli_karakter';

  final RoastModel roast;
  final File fotograf;

  const SonucSayfasi({
    super.key,
    required this.roast,
    required this.fotograf,
  });

  @override
  State<SonucSayfasi> createState() => _SonucSayfasiState();
}

class _SonucSayfasiState extends State<SonucSayfasi> {
  final ScreenshotController screenshotController = ScreenshotController();
  bool _paylasiliyor = false;
  bool _vitrineGonderiliyor = false;
  String _vitrinMesaj = '';

  @override
  void initState() {
    super.initState();
    HapticFeedback.heavyImpact();
  }

  Future<void> _vitrineGonder() async {
    final l10n = AppLocalizations.of(context)!;
    final adDenetleyici = TextEditingController();
    bool anonim = true;

    final paylas = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          backgroundColor: UygulamaRenkleri.yuzey,
          title: Text(l10n.sonucVitrineGonderBaslik),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.sonucVitrineGonderAciklamaTekli),
              const SizedBox(height: 16),
              CheckboxListTile(
                title: Text(l10n.sonucAnonimPaylas),
                value: anonim,
                onChanged: (v) => setState(() => anonim = v ?? true),
                activeColor: UygulamaRenkleri.anaRenk,
              ),
              if (!anonim)
                TextField(
                  controller: adDenetleyici,
                  decoration: InputDecoration(
                    labelText: l10n.sonucIsim,
                    hintText: l10n.sonucIsimOrnek,
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l10n.iptal)),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: UygulamaRenkleri.anaRenk),
              child: Text(l10n.sonucPaylas),
            ),
          ],
        ),
      ),
    );

    if (paylas == true) {
      if (!mounted) return;
      final paylasanAd = anonim ? l10n.sonucAnonimRoaster : (adDenetleyici.text.isEmpty ? l10n.sonucIsimsiz : adDenetleyici.text);
      context.read<VitrinCubiti>().paylasTekli(
            roast: widget.roast,
            fotograf: widget.fotograf,
            paylasanAdi: paylasanAd,
          );
    }
  }

  Future<void> _paylas() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _paylasiliyor = true);
    unawaited(HapticFeedback.mediumImpact());

    try {
      // Ekran üzerindeki görüntüyü değil, özel tasarlanmış kartı yakalıyoruz
      final image = await screenshotController.captureFromWidget(
        MediaQuery(
          data: const MediaQueryData(),
          child: Material(
            child: PaylasimKarti(
              roast: widget.roast,
              fotograf: widget.fotograf,
            ),
          ),
        ),
        delay: const Duration(milliseconds: 200),
        context: context,
      );

      final directory = await getTemporaryDirectory();
      final imagePath = await File('${directory.path}/roast_paylasim_${DateTime.now().millisecondsSinceEpoch}.png').create();
      await imagePath.writeAsBytes(image);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(imagePath.path)],
          text: "🔥 ${widget.roast.karakter} beni fena haşladı! Sen de dene. #KapakOlsun #RoastBattle",
        ),
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(l10n.sonucPaylasHata(e.toString()))),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _paylasiliyor = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: UygulamaRenkleri.arkaPlan,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.white),
          onPressed: () {
            HapticFeedback.lightImpact();
            context.read<RoastCubiti>().sifirla();
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          // Arka plan gradyanı
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment.bottomRight,
                  radius: 1.5,
                  colors: [
                    UygulamaRenkleri.anaRenk.withOpacity(0.2),
                    UygulamaRenkleri.arkaPlan,
                  ],
                ),
              ),
            ),
          ),
          
          BlocListener<VitrinCubiti, VitrinDurum>(
            listener: (context, state) {
              if (state is VitrinPaylasiliyor) {
                setState(() {
                  _vitrineGonderiliyor = true;
                  _vitrinMesaj = state.mesaj;
                });
              } else if (state is VitrinPaylasimBasarili) {
                setState(() {
                  _vitrineGonderiliyor = false;
                  _vitrinMesaj = '';
                });
                DurumBanner.goster(context, mesaj: l10n.sonucVitrineEklendi, tip: DurumBannerTip.basari);
              } else if (state is VitrinHata) {
                setState(() {
                  _vitrineGonderiliyor = false;
                  _vitrinMesaj = '';
                });
                DurumBanner.goster(context, mesaj: state.mesaj, tip: DurumBannerTip.hata);
              }
            },
            child: const SizedBox.shrink(),
          ),
          
          SafeArea(
            child: Column(
              children: [
                const SimulasyonBanner(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
                    child: Column(
                      children: [
                        Screenshot(
                          controller: screenshotController,
                          child: Container(
                            color: UygulamaRenkleri.arkaPlan,
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                // Resim Bölümü (Modern Çerçeve)
                                Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: 300,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: UygulamaRenkleri.anaRenk.withOpacity(0.3),
                                            blurRadius: 40,
                                            spreadRadius: -5,
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(30),
                                        child: Image.file(
                                          widget.fotograf,
                                          fit: BoxFit.cover,
                                          cacheHeight: 800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ).animate().scale(duration: 600.ms, curve: Curves.easeOutBack),

                                const SizedBox(height: 24),

                                // Roast Master İsmi
                                Column(
                                  children: [
                                    Text(
                                      "ROAST MASTER",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w900,
                                        color: UygulamaRenkleri.anaRenk.withOpacity(0.8),
                                        letterSpacing: 4,
                                      ),
                                    ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2),
                                    const SizedBox(height: 8),
                                    Text(
                                      widget.roast.karakter.toUpperCase(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.white,
                                        letterSpacing: 1,
                                        shadows: [
                                          Shadow(
                                            color: UygulamaRenkleri.anaRenk,
                                            blurRadius: 20,
                                          ),
                                        ],
                                      ),
                                    ).animate().fadeIn(delay: 600.ms).scale(duration: 400.ms),
                                  ],
                                ),

                                const SizedBox(height: 24),

                                // Roast Metni Bölümü (Glassmorphism)
                                CamKart(
                                  renk: Colors.white.withOpacity(0.05),
                                  padding: const EdgeInsets.all(24),
                                  child: Column(
                                    children: [
                                      const Icon(
                                        Icons.format_quote_rounded,
                                        color: UygulamaRenkleri.anaRenk,
                                        size: 32,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        widget.roast.metin,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w500,
                                          height: 1.5,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      const Text(
                                        "KAPAK AI",
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white54,
                                          letterSpacing: 4,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: AppSpacing.xxl),

                        Row(
                          children: [
                            Expanded(
                              child: AppButon(
                                metin: l10n.sonucTekrar,
                                ikon: Icons.refresh,
                                stil: AppButonStil.ikincil,
                                onTap: () {
                                  context.read<RoastCubiti>().sifirla();
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                            const SizedBox(width: AppSpacing.md),
                            Expanded(
                              child: AppButon(
                                metin: _paylasiliyor ? l10n.hazirlaniyor : l10n.sonucPaylasButon,
                                ikon: Icons.share_rounded,
                                yukleniyor: _paylasiliyor,
                                onTap: _paylas,
                              ),
                            ),
                          ],
                        ).animate().fadeIn(duration: AppMotion.yavas, delay: AppMotion.cokYavas),

                        const SizedBox(height: AppSpacing.md),

                        AppButon(
                          metin: _vitrineGonderiliyor ? _vitrinMesaj.toUpperCase() : l10n.sonucVitrineGonderGlobal,
                          ikon: Icons.public_rounded,
                          yukleniyor: _vitrineGonderiliyor,
                          stil: AppButonStil.ikincil,
                          onTap: _vitrineGonder,
                        ).animate().fadeIn(delay: 1.seconds),

                        const SizedBox(height: AppSpacing.md),

                        AppButon(
                          metin: l10n.sonucFarkliKarakterSec,
                          ikon: Icons.psychology_alt_outlined,
                          stil: AppButonStil.hayalet,
                          onTap: () {
                            context.read<RoastCubiti>().sifirla();
                            Navigator.of(context).pop(SonucSayfasi.farkliKarakterAksiyonu);
                          },
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        AppButon(
                          metin: l10n.sonucAyniFotoFarkliKarakter,
                          ikon: Icons.auto_awesome,
                          stil: AppButonStil.hayalet,
                          onTap: () {
                            context.read<RoastCubiti>().sifirla();
                            Navigator.of(context).pop(SonucSayfasi.ayniFotografFarkliKarakterAksiyonu);
                          },
                        ),
                        const SizedBox(height: AppSpacing.xxl),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
