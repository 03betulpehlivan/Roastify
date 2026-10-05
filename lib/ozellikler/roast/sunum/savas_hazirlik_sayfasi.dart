import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../../cekirdek/sabitler/metinler.dart';
import '../../../cekirdek/bilesenler/cam_kart.dart';
import '../../../cekirdek/tasarim/tokenlar.dart';
import '../../../cekirdek/tasarim/app_buton.dart';
import '../../../cekirdek/tasarim/durum_banner.dart';
import '../../../cekirdek/tasarim/cam_kart_v2.dart';
import '../is_mantigi/savas_cubiti.dart';
import '../is_mantigi/savas_durum.dart';
import 'savas_sonuc_sayfasi.dart';
import '../../../cekirdek/tasarim/resim_kaynak_secici.dart';
import '../../../cekirdek/is_mantigi/ayarlar_cubiti.dart';
import '../../../cekirdek/tasarim/simulasyon_banner.dart';
import '../../../l10n/app_localizations.dart';

class SavasHazirlikSayfasi extends StatelessWidget {
  const SavasHazirlikSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return const _SavasHazirlikIcerik();
  }
}

class _SavasHazirlikIcerik extends StatefulWidget {
  const _SavasHazirlikIcerik();

  @override
  State<_SavasHazirlikIcerik> createState() => _SavasHazirlikIcerikState();
}

class _SavasHazirlikIcerikState extends State<_SavasHazirlikIcerik> {
  String? _ozelPrompt;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocListener<SavasCubiti, SavasDurum>(
      listener: (context, durum) {
        if (durum is SavasHata) {
          DurumBanner.goster(
            context,
            mesaj: UygulamaMetinleri.hataMesaji(durum.tip, ekMesaj: durum.mesaj),
            tip: DurumBannerTip.hata,
          );
        } else if (durum is SavasBasarili) {
          Navigator.of(context).push(
            PageRouteBuilder(
              pageBuilder: (_, animation, __) => SavasSonucSayfasi(
                savas: durum.savas,
                fotograf1: durum.fotograf1,
                fotograf2: durum.fotograf2,
              ),
              transitionsBuilder: (_, animation, __, child) =>
                  FadeTransition(opacity: animation, child: child),
              transitionDuration: AppMotion.normal,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: UygulamaRenkleri.arkaPlan,
        body: Column(
          children: [
            const SimulasyonBanner(),
            Expanded(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  title: Text(l10n.savasHazirlikBaslik),
                  centerTitle: true,
                ),
                body: SingleChildScrollView(
                  padding: AppSpacing.sayfaPadding,
                  child: Column(
                    children: [
                      Text(
                        l10n.savasHazirlikIkiKurban,
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, letterSpacing: 2),
                      ).animate().fadeIn().slideY(begin: -0.2),

                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        l10n.savasHazirlikAltYazi,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: UygulamaRenkleri.gri),
                      ).animate().fadeIn(delay: 200.ms),

                      const SizedBox(height: AppSpacing.xl),

                      Row(
                        children: [
                          Expanded(child: _FotoSecici(indeks: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                            child: const Text(
                              'VS',
                              style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, fontStyle: FontStyle.italic, color: UygulamaRenkleri.neonPembe),
                            ).animate(onPlay: (c) => c.repeat(reverse: true)).scale(begin: const Offset(1, 1), end: const Offset(1.15, 1.15), duration: 1.seconds),
                          ),
                          Expanded(child: _FotoSecici(indeks: 2)),
                        ],
                      ),

                      const SizedBox(height: AppSpacing.xxl),

                      BlocBuilder<SavasCubiti, SavasDurum>(
                        builder: (context, durum) {
                          if (durum is SavasYukleniyor) {
                            return CamKartV2(
                              padding: const EdgeInsets.all(AppSpacing.xl),
                              child: Column(
                                children: [
                                  const CircularProgressIndicator(color: UygulamaRenkleri.anaRenk),
                                  const SizedBox(height: AppSpacing.md),
                                  Text(
                                    UygulamaMetinleri.asamaMesaji(durum.asama).toUpperCase(),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(color: UygulamaRenkleri.vurguRenk, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 2),
                                  ).animate(onPlay: (c) => c.repeat()).shimmer(duration: 2.seconds),
                                ],
                              ),
                            );
                          }

                          return AppButon(
                            metin: l10n.savasHazirlikBaslat,
                            ikon: Icons.bolt_rounded,
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              _karakterSeciminiGoster(context);
                            },
                          ).animate().scale(delay: 600.ms, curve: AppMotion.bouncy);
                        },
                      ),

                      const SizedBox(height: AppSpacing.lg),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(l10n.anaSimulasyonModu, style: const TextStyle(color: UygulamaRenkleri.gri, fontSize: 13)),
                          const SizedBox(width: AppSpacing.xs),
                          BlocBuilder<AyarlarCubiti, AyarlarState>(
                            builder: (context, state) => Switch(
                              value: state.simulasyonModu,
                              onChanged: (deger) {
                                context.read<AyarlarCubiti>().simulasyonModuDegistir(deger);
                              },
                              activeColor: UygulamaRenkleri.anaRenk,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _karakterSeciminiGoster(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bCtx) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.8,
        builder: (_, controller) => CamKart(
          renk: UygulamaRenkleri.arkaPlan.withOpacity(0.95),
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
          kenarYaricap: 40,
          child: Column(
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(color: Colors.white54, borderRadius: BorderRadius.circular(2)),
              ),
              const SizedBox(height: 24),
              Text(l10n.savasHazirlikHakemSec, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  itemCount: UygulamaMetinleri.tumKarakterler.length,
                  itemBuilder: (context, index) {
                    final karakter = UygulamaMetinleri.tumKarakterler[index];
                    return _KarakterButon(
                      isim: karakter,
                      onTap: () {
                        if (karakter == UygulamaMetinleri.karakterOzel) {
                          _ozelKarakterDialogGoster(bCtx);
                        } else {
                          _savasBaslat(context, bCtx, karakter);
                        }
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _savasBaslat(BuildContext context, BuildContext bCtx, String karakter) {
    Navigator.pop(bCtx);
    context.read<SavasCubiti>().savasBaslat(
      karakter: karakter,
      ozelPrompt: _ozelPrompt,
    );
  }

  Future<void> _ozelKarakterDialogGoster(BuildContext bCtx) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: _ozelPrompt);
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: UygulamaRenkleri.yuzey,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(l10n.savasHazirlikHakemStili, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.savasHazirlikHakemAciklama,
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: controller,
                autofocus: true,
                maxLines: 3,
                maxLength: 100,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: l10n.savasHazirlikHakemHint,
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
          TextButton(onPressed: () => Navigator.pop(context), child: Text(l10n.iptal, style: const TextStyle(color: Colors.white70))),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                setState(() => _ozelPrompt = controller.text);
                Navigator.pop(context);
                _savasBaslat(context, bCtx, UygulamaMetinleri.karakterOzel);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: UygulamaRenkleri.anaRenk, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: Text(l10n.savasHazirlikBaslatButon, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Future<void> _kaynakSecimiGoster(BuildContext context, int sira) async {
    final kaynak = await ResimKaynakSecici.goster(context);
    if (kaynak != null && mounted) {
      context.read<SavasCubiti>().fotografSec(sira: sira, kaynak: kaynak);
    }
  }
}

class _FotoSecici extends StatelessWidget {
  final int indeks;
  const _FotoSecici({required this.indeks});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return BlocBuilder<SavasCubiti, SavasDurum>(
      builder: (context, durum) {
        File? foto;
        if (durum is SavasFotograflarGuncellendi) {
          foto = indeks == 1 ? durum.fotograf1 : durum.fotograf2;
        } else if (durum is SavasBasarili) {
          foto = indeks == 1 ? durum.fotograf1 : durum.fotograf2;
        }
        final hasFoto = foto != null;

        return GestureDetector(
          onTap: () {
            HapticFeedback.selectionClick();
            final state = context.findAncestorStateOfType<_SavasHazirlikIcerikState>();
            state?._kaynakSecimiGoster(context, indeks);
          },
          child: AspectRatio(
            aspectRatio: 0.8,
            child: CamKartV2(
              padding: EdgeInsets.zero,
              aktif: hasFoto,
              child: hasFoto
                  ? ClipRRect(
                      borderRadius: AppRadius.lgRadius,
                      child: Image.file(foto, fit: BoxFit.cover, width: double.infinity, height: double.infinity),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo_outlined, color: UygulamaRenkleri.anaRenk.withAlpha(180), size: 32),
                        const SizedBox(height: AppSpacing.xs),
                        Text(l10n.savasHazirlikKurbanEtiket(indeks), style: const TextStyle(fontSize: 10, color: UygulamaRenkleri.gri, letterSpacing: 1)),
                      ],
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _KarakterButon extends StatelessWidget {
  final String isim;
  final VoidCallback onTap;
  const _KarakterButon({required this.isim, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: ListTile(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        shape: RoundedRectangleBorder(borderRadius: AppRadius.mdRadius),
        tileColor: UygulamaRenkleri.anaRenk.withAlpha(25),
        leading: Icon(
          UygulamaMetinleri.karakterIkonu(isim),
          color: UygulamaMetinleri.karakterRengi(isim),
          size: 24,
        ),
        title: Text(isim, style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 0.5)),
        trailing: const Icon(Icons.chevron_right, color: Colors.white54, size: 20),
      ),
    );
  }
}
