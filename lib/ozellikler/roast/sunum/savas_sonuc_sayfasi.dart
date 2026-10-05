import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:confetti/confetti.dart';
import 'package:path_provider/path_provider.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../../cekirdek/tasarim/tokenlar.dart';
import '../../../cekirdek/tasarim/app_buton.dart';
import '../../../cekirdek/tasarim/cam_kart_v2.dart';
import '../../../cekirdek/tasarim/durum_banner.dart';
import '../veri/savas_model.dart';
import '../is_mantigi/savas_cubiti.dart';
import '../../vitrin/is_mantigi/vitrin_cubiti.dart';
import '../../vitrin/is_mantigi/vitrin_durum.dart';
import 'bilesenler/savas_paylasim_karti.dart';
import '../../../cekirdek/is_mantigi/ayarlar_cubiti.dart';
import '../../../cekirdek/tasarim/simulasyon_banner.dart';
import '../../../l10n/app_localizations.dart';

class SavasSonucSayfasi extends StatefulWidget {
  final SavasModel savas;
  final File fotograf1;
  final File fotograf2;

  const SavasSonucSayfasi({
    super.key,
    required this.savas,
    required this.fotograf1,
    required this.fotograf2,
  });

  @override
  State<SavasSonucSayfasi> createState() => _SavasSonucSayfasiState();
}

class _SavasSonucSayfasiState extends State<SavasSonucSayfasi> {
  final ScreenshotController screenshotController = ScreenshotController();
  late ConfettiController _confettiController;
  bool _paylasiliyor = false;
  bool _vitrineGonderiliyor = false;
  String _vitrinMesaj = '';

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
    _confettiController.play();
    HapticFeedback.heavyImpact();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _paylas() async {
    final l10n = AppLocalizations.of(context)!;
    setState(() => _paylasiliyor = true);
    try {
      final image = await screenshotController.captureFromWidget(
        MediaQuery(
          data: const MediaQueryData(),
          child: Material(
            child: SavasPaylasimKarti(
              savas: widget.savas,
              fotograf1: widget.fotograf1,
              fotograf2: widget.fotograf2,
            ),
          ),
        ),
        delay: const Duration(milliseconds: 200),
        context: context,
      );

      final directory = await getTemporaryDirectory();
      final path = '${directory.path}/battle_sonuc_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(path);
      await file.writeAsBytes(image);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(path)],
          text: "🔥 Arkadaşımla fena kapıştık! Kim kazandı dersin? #RoastBattle #KapakOlsun",
        ),
      );
    } catch (e) {
      if (mounted) {
        DurumBanner.goster(context, mesaj: l10n.sonucPaylasHataKisa(e.toString()), tip: DurumBannerTip.hata);
      }
    } finally {
      setState(() => _paylasiliyor = false);
    }
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
              Text(l10n.sonucVitrineGonderAciklamaSavas),
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
      context.read<VitrinCubiti>().paylas(
            savas: widget.savas,
            fotograf1: widget.fotograf1,
            fotograf2: widget.fotograf2,
            paylasanAdi: paylasanAd,
          );
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
            context.read<SavasCubiti>().sifirla();
            Navigator.of(context).popUntil((route) => route.isFirst);
          },
        ),
      ),
      body: BlocListener<VitrinCubiti, VitrinDurum>(
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
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      UygulamaRenkleri.neonMavi.withOpacity(0.05),
                      UygulamaRenkleri.arkaPlan,
                      UygulamaRenkleri.neonPembe.withOpacity(0.05),
                    ],
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  const SimulasyonBanner(),
                  Expanded(
                    child: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
                      child: Column(
                        children: [
                          const Text('BATTLE ARENA', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, letterSpacing: 5)),
                          const SizedBox(height: AppSpacing.xs),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xxs + 2),
                            decoration: BoxDecoration(
                              color: UygulamaRenkleri.anaRenk.withAlpha(25),
                              borderRadius: AppRadius.tamRadius,
                              border: Border.all(color: UygulamaRenkleri.anaRenk.withAlpha(50)),
                            ),
                            child: Text(
                              'JUDGE: ${widget.savas.karakter.toUpperCase()}',
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: UygulamaRenkleri.anaRenk, letterSpacing: 2),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xl),
                          Row(
                            children: [
                              Expanded(child: _SavasciGorsel(foto: widget.fotograf1, kazandi: widget.savas.kazananIndeksi == 1, renk: UygulamaRenkleri.neonMavi)),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 12),
                                child: Text("VS", style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.white, fontStyle: FontStyle.italic)),
                              ),
                              Expanded(child: _SavasciGorsel(foto: widget.fotograf2, kazandi: widget.savas.kazananIndeksi == 2, renk: UygulamaRenkleri.neonPembe)),
                            ],
                          ).animate().fadeIn().scale(duration: 600.ms, curve: Curves.easeOutBack),
                          const SizedBox(height: AppSpacing.xl),
                          _HakemRaporu(savas: widget.savas),
                          const SizedBox(height: AppSpacing.xl),
                          _SkorKartu(savas: widget.savas),
                          const SizedBox(height: AppSpacing.xl),
                          _RoastDetay(roast: widget.savas.birinciRoast, sira: 1),
                          const SizedBox(height: AppSpacing.sm),
                          _RoastDetay(roast: widget.savas.ikinciRoast, sira: 2),
                          const SizedBox(height: AppSpacing.xxl),
                          AppButon(
                            metin: _paylasiliyor ? l10n.hazirlaniyor : l10n.savasSonucPaylasButon,
                            ikon: Icons.share_rounded,
                            yukleniyor: _paylasiliyor,
                            onTap: _paylas,
                          ).animate().fadeIn(delay: 1.seconds),
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
                            metin: l10n.savasSonucYeniSavas,
                            stil: AppButonStil.hayalet,
                            ikon: Icons.refresh_rounded,
                            onTap: () {
                              context.read<SavasCubiti>().sifirla();
                              Navigator.of(context).pop();
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
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                shouldLoop: false,
                colors: const [UygulamaRenkleri.anaRenk, UygulamaRenkleri.neonMavi, UygulamaRenkleri.neonPembe],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SavasciGorsel extends StatelessWidget {
  final File foto;
  final bool kazandi;
  final Color renk;

  const _SavasciGorsel({required this.foto, required this.kazandi, required this.renk});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: AppMotion.normal,
      height: 200,
      decoration: BoxDecoration(
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: kazandi ? renk : Colors.white10, width: kazandi ? 3 : 1),
        boxShadow: kazandi
            ? [BoxShadow(color: renk.withAlpha(75), blurRadius: 24, spreadRadius: -2)]
            : null,
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg - 2),
            child: Image.file(foto, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
          ),
          if (kazandi)
            Positioned(
              top: AppSpacing.sm,
              left: AppSpacing.sm,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs),
                decoration: BoxDecoration(color: renk, borderRadius: AppRadius.smRadius),
                child: const Text('WINNER', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1)),
              ).animate().shimmer(),
            ),
          if (!kazandi)
            Container(
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(100),
                borderRadius: BorderRadius.circular(AppRadius.lg - 2),
              ),
              child: const Center(child: Icon(Icons.close, color: Colors.white54, size: 48)),
            ),
        ],
      ),
    );
  }
}

class _HakemRaporu extends StatelessWidget {
  final SavasModel savas;
  const _HakemRaporu({required this.savas});

  @override
  Widget build(BuildContext context) {
    return CamKartV2(
      aktif: true,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.gavel_rounded, color: UygulamaRenkleri.anaRenk, size: 20),
              SizedBox(width: AppSpacing.sm),
              Text('OFFICIAL VERDICT', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 13, color: Colors.white70)),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            savas.kazanmaNedeni,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, height: 1.5, fontWeight: FontWeight.w500, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 600.ms, duration: AppMotion.yavas);
  }
}

class _SkorKartu extends StatelessWidget {
  final SavasModel savas;
  const _SkorKartu({required this.savas});

  @override
  Widget build(BuildContext context) {
    return CamKartV2(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          const Text('SCORECARD', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 3, fontSize: 13, color: Colors.white70)),
          const SizedBox(height: AppSpacing.lg),
          ...savas.puanlar.entries.map((e) => _SkorSatiri(etiket: e.key, puanlar: e.value)),
        ],
      ),
    );
  }
}

class _SkorSatiri extends StatelessWidget {
  final String etiket;
  final List<int> puanlar;

  const _SkorSatiri({required this.etiket, required this.puanlar});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${puanlar[0]}', style: TextStyle(fontWeight: FontWeight.bold, color: puanlar[0] >= puanlar[1] ? UygulamaRenkleri.neonMavi : Colors.white54)),
              Text(etiket, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white70, letterSpacing: 1)),
              Text('${puanlar[1]}', style: TextStyle(fontWeight: FontWeight.bold, color: puanlar[1] >= puanlar[0] ? UygulamaRenkleri.neonPembe : Colors.white54)),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: AppRadius.tamRadius,
            child: Row(
              children: [
                Expanded(
                  child: RotatedBox(
                    quarterTurns: 2,
                    child: LinearProgressIndicator(
                      value: puanlar[0] / 100,
                      backgroundColor: Colors.white.withAlpha(13),
                      color: UygulamaRenkleri.neonMavi.withAlpha(puanlar[0] >= puanlar[1] ? 255 : 75),
                      minHeight: 5,
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                Expanded(
                  child: LinearProgressIndicator(
                    value: puanlar[1] / 100,
                    backgroundColor: Colors.white.withAlpha(13),
                    color: UygulamaRenkleri.neonPembe.withAlpha(puanlar[1] >= puanlar[0] ? 255 : 75),
                    minHeight: 5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms).slideX();
  }
}

class _RoastDetay extends StatelessWidget {
  final String roast;
  final int sira;

  const _RoastDetay({required this.roast, required this.sira});

  @override
  Widget build(BuildContext context) {
    final renk = sira == 1 ? UygulamaRenkleri.neonMavi : UygulamaRenkleri.neonPembe;
    return CamKartV2(
      padding: AppSpacing.kartPadding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: renk.withAlpha(50),
            child: Text('$sira', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: renk)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              roast,
              style: const TextStyle(fontSize: 13, color: Colors.white70, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
