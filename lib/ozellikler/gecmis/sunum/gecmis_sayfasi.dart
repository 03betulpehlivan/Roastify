import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../../cekirdek/sabitler/metinler.dart';
import '../../../cekirdek/servisler/gecmis_servisi.dart';
import '../../../cekirdek/servisler/servis_kayit.dart';
import '../../../cekirdek/tasarim/tokenlar.dart';
import '../../../cekirdek/tasarim/cam_kart_v2.dart';
import '../../../cekirdek/tasarim/bos_ekran.dart';
import '../../../cekirdek/tasarim/app_buton.dart';
import '../../../cekirdek/tasarim/durum_banner.dart';
import '../../roast/veri/roast_model.dart';
import '../../../cekirdek/servisler/istatistik_servisi.dart';
import '../../../l10n/app_localizations.dart';

class GecmisSayfasi extends StatefulWidget {
  const GecmisSayfasi({super.key});

  @override
  State<GecmisSayfasi> createState() => _GecmisSayfasiState();
}

class _GecmisSayfasiState extends State<GecmisSayfasi> {
  List<RoastModel> _gecmis = [];
  bool _yukleniyor = true;

  @override
  void initState() {
    super.initState();
    _verileriYukle();
  }

  Future<void> _verileriYukle() async {
    final veriler = await servisBulucu<GecmisServisi>().tumGecmis();
    if (mounted) {
      setState(() {
        _gecmis = veriler;
        _yukleniyor = false;
      });
    }
  }

  void _gecmisiTemizle() {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: UygulamaRenkleri.yuzey,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.lgRadius),
        title: Text(l10n.gecmisTemizleBaslik, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Text(l10n.gecmisTemizleAciklama, style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.iptal, style: const TextStyle(color: Colors.white70)),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await servisBulucu<GecmisServisi>().temizle();
              setState(() => _gecmis = []);
              if (mounted) {
                DurumBanner.goster(context, mesaj: l10n.gecmisTemizlendi, tip: DurumBannerTip.basari);
              }
            },
            child: Text(l10n.gecmisTemizleOnay, style: const TextStyle(color: UygulamaRenkleri.hata, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: UygulamaRenkleri.arkaPlan,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(l10n.gecmisBaslik, style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2)),
        centerTitle: true,
        actions: [
          if (_gecmis.isNotEmpty)
            IconButton(
              onPressed: _gecmisiTemizle,
              icon: const Icon(Icons.delete_outline, color: Colors.white54),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
            child: _SavageMeter(),
          ),
          Expanded(
            child: _yukleniyor
                ? const Center(child: CircularProgressIndicator(color: UygulamaRenkleri.anaRenk))
                : _gecmis.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            BosEkran(
                              ikon: Icons.history_rounded,
                              baslik: l10n.gecmisBosBaslik,
                              aciklama: l10n.gecmisBosAciklama,
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 40),
                              child: AppButon(
                                metin: l10n.gecmisHemenBasla,
                                ikon: Icons.add_rounded,
                                onTap: () => Navigator.pop(context),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: AppSpacing.sayfaPadding,
                        itemCount: _gecmis.length,
                        itemBuilder: (context, index) {
                          final roast = _gecmis[index];
                          return _GecmisKarti(roast: roast, index: index);
                        },
                      ),
          ),
        ],
      ),
    );
  }
}

class _GecmisKarti extends StatelessWidget {
  final RoastModel roast;
  final int index;

  const _GecmisKarti({required this.roast, required this.index});

  String _zamanFormat(DateTime tarih, AppLocalizations l10n) {
    final fark = DateTime.now().difference(tarih);
    if (fark.inMinutes < 1) return l10n.gecmisAzOnce;
    if (fark.inMinutes < 60) return l10n.gecmisDakikaOnce(fark.inMinutes);
    if (fark.inHours < 24) return l10n.gecmisSaatOnce(fark.inHours);
    if (fark.inDays < 7) return l10n.gecmisGunOnce(fark.inDays);
    return '${tarih.day}.${tarih.month}.${tarih.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final modRenk = roast.mod.contains('ovgu') ? UygulamaRenkleri.vurguRenk : UygulamaRenkleri.anaRenk;

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          _detayGoster(context);
        },
        child: CamKartV2(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    UygulamaMetinleri.karakterIkonu(roast.karakter),
                    color: UygulamaMetinleri.karakterRengi(roast.karakter),
                    size: 20,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      roast.karakter.toUpperCase(),
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 1, color: Colors.white54),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xs, vertical: 2),
                    decoration: BoxDecoration(
                      color: modRenk.withAlpha(30),
                      borderRadius: AppRadius.tamRadius,
                    ),
                    child: Text(
                      roast.mod.toUpperCase(),
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: modRenk, letterSpacing: 1),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                roast.metin,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.4),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                _zamanFormat(roast.tarih, l10n),
                style: const TextStyle(fontSize: 13, color: Colors.white54),
              ),
            ],
          ),
        ),
      ).animate().fadeIn(delay: Duration(milliseconds: 50 * index), duration: AppMotion.normal),
    );
  }

  void _detayGoster(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.65,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
            color: UygulamaRenkleri.yuzey,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
          ),
          child: ListView(
            controller: controller,
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.lg),
                  decoration: BoxDecoration(color: Colors.white54, borderRadius: AppRadius.tamRadius),
                ),
              ),
              Row(
                children: [
                  Icon(
                    UygulamaMetinleri.karakterIkonu(roast.karakter),
                    color: UygulamaMetinleri.karakterRengi(roast.karakter),
                    size: 28,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(roast.karakter.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1)),
                      Text(_zamanFormat(roast.tarih, l10n), style: const TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              SelectableText(
                roast.metin,
                style: const TextStyle(fontSize: 16, color: Colors.white, height: 1.6),
              ),
              const SizedBox(height: AppSpacing.xl),
              AppButon(
                metin: l10n.gecmisKopyala,
                ikon: Icons.copy_rounded,
                stil: AppButonStil.ikincil,
                onTap: () {
                  Clipboard.setData(ClipboardData(text: roast.metin));
                  Navigator.pop(context);
                  DurumBanner.goster(context, mesaj: l10n.gecmisPanoyaKopyalandi, tip: DurumBannerTip.basari);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SavageMeter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                        ? "KALAN HAK: ${stats.kalanHak} • YENILENME: ${stats.yenilenmeyeKalanYazi}"
                        : "KALAN HAK: ${stats.kalanHak}",
                    style: const TextStyle(color: Colors.white54, fontSize: 12, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xxs + 2),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(13),
                  borderRadius: AppRadius.tamRadius,
                  border: Border.all(color: Colors.white.withAlpha(18)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_fire_department_rounded, color: UygulamaRenkleri.neonTuruncu, size: 14),
                    const SizedBox(width: AppSpacing.xxs),
                    Text(
                      '${stats.toplamRoast} KAPAK',
                      style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w900),
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
                  color: Colors.white.withAlpha(13),
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
