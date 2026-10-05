import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../cekirdek/sabitler/renkler.dart';
import '../../../../cekirdek/tasarim/tokenlar.dart';
import '../../is_mantigi/vitrin_cubiti.dart';
import '../../veri/vitrin_gonderisi_model.dart';

class VitrinKarti extends StatelessWidget {
  final VitrinGonderisiModel gonderi;

  const VitrinKarti({super.key, required this.gonderi});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.lg),
      decoration: BoxDecoration(
        color: UygulamaRenkleri.yuzey,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _GonderenBilgisi(gonderi: gonderi),
          if (gonderi.tip == VitrinGonderiTipi.savas)
            _SavasGorunumu(gonderi: gonderi)
          else
            _TekliGorunumu(gonderi: gonderi),
          _TepkiButonlari(gonderi: gonderi),
        ],
      ),
    );
  }
}

class _GonderenBilgisi extends StatelessWidget {
  final VitrinGonderisiModel gonderi;
  const _GonderenBilgisi({required this.gonderi});

  @override
  Widget build(BuildContext context) {
    final String baslik = gonderi.tip == VitrinGonderiTipi.savas 
        ? '${gonderi.savas?.karakter.toUpperCase()} HAKEMLİĞİNDE SAVAŞ' 
        : '${gonderi.tekliRoast?.karakter.toUpperCase()} HAŞLAMASI';

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: UygulamaRenkleri.anaRenk.withOpacity(0.2),
            child: Icon(
              gonderi.tip == VitrinGonderiTipi.savas ? Icons. whatshot : Icons.psychology,
              color: UygulamaRenkleri.anaRenk,
              size: 20,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  baslik,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                    color: UygulamaRenkleri.anaRenk,
                  ),
                ),
                Text(
                  gonderi.paylasanAdi,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
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

class _TekliGorunumu extends StatelessWidget {
  final VitrinGonderisiModel gonderi;
  const _TekliGorunumu({required this.gonderi});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 250,
          width: double.infinity,
          child: CachedNetworkImage(
            imageUrl: gonderi.thumbnail1Url,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.white10),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Text(
            gonderi.tekliRoast?.metin ?? '',
            style: const TextStyle(
              fontSize: 15,
              color: Colors.white70,
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ],
    );
  }
}

class _SavasGorunumu extends StatelessWidget {
  final VitrinGonderisiModel gonderi;
  const _SavasGorunumu({required this.gonderi});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Row(
            children: [
              Expanded(child: _SavasFotografi(url: gonderi.thumbnail1Url, kazandi: gonderi.savas?.kazananIndeksi == 1)),
              Container(
                width: 2,
                color: UygulamaRenkleri.arkaPlan,
              ),
              Expanded(child: _SavasFotografi(url: gonderi.thumbnail2Url ?? '', kazandi: gonderi.savas?.kazananIndeksi == 2)),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _RoastOzet(metin: gonderi.savas?.birinciRoast ?? '', sira: 1),
              const SizedBox(height: AppSpacing.sm),
              _RoastOzet(metin: gonderi.savas?.ikinciRoast ?? '', sira: 2),
              const SizedBox(height: AppSpacing.md),
              Text(
                'KAZANAN: ${gonderi.savas?.kazananIndeksi == 1 ? "SOL" : "SAĞ"} TARAF',
                style: const TextStyle(fontWeight: FontWeight.w900, color: UygulamaRenkleri.anaRenk, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SavasFotografi extends StatelessWidget {
  final String url;
  final bool kazandi;
  const _SavasFotografi({required this.url, required this.kazandi});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        CachedNetworkImage(
          imageUrl: url,
          fit: BoxFit.cover,
          placeholder: (context, url) => Container(color: Colors.white10),
        ),
        if (kazandi)
          Positioned(
            top: 8,
            left: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.amber, borderRadius: AppRadius.smRadius),
              child: const Text('WINNER', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.black)),
            ),
          ),
      ],
    );
  }
}

class _RoastOzet extends StatelessWidget {
  final String metin;
  final int sira;
  const _RoastOzet({required this.metin, required this.sira});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$sira.', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white30, fontSize: 12)),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            metin,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
        ),
      ],
    );
  }
}

class _TepkiButonlari extends StatelessWidget {
  final VitrinGonderisiModel gonderi;
  const _TepkiButonlari({required this.gonderi});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _TepkiButonu(gonderiId: gonderi.id, tip: 'rip', ikon: '💀', sayi: gonderi.tepkiler['rip'] ?? 0),
          _TepkiButonu(gonderiId: gonderi.id, tip: 'boom', ikon: '💥', sayi: gonderi.tepkiler['boom'] ?? 0),
          _TepkiButonu(gonderiId: gonderi.id, tip: 'fire', ikon: '🔥', sayi: gonderi.tepkiler['fire'] ?? 0),
        ],
      ),
    );
  }
}

class _TepkiButonu extends StatelessWidget {
  final String gonderiId;
  final String tip;
  final String ikon;
  final int sayi;

  const _TepkiButonu({
    required this.gonderiId,
    required this.tip,
    required this.ikon,
    required this.sayi,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.read<VitrinCubiti>().tepkiVer(gonderiId, tip),
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.xs),
        child: Row(
          children: [
            Text(ikon, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(
              sayi > 0 ? '$sayi' : 'OYLA',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: sayi > 0 ? Colors.white : Colors.white70,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
