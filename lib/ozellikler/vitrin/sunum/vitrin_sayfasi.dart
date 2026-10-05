import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../../cekirdek/tasarim/tokenlar.dart';
import '../../../l10n/app_localizations.dart';
import '../is_mantigi/vitrin_cubiti.dart';
import '../is_mantigi/vitrin_durum.dart';
import 'bilesenler/vitrin_karti.dart';

class VitrinSayfasi extends StatefulWidget {
  const VitrinSayfasi({super.key});

  @override
  State<VitrinSayfasi> createState() => _VitrinSayfasiState();
}

class _VitrinSayfasiState extends State<VitrinSayfasi> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 400) {
      context.read<VitrinCubiti>().dahaFazlaYukle();
    }
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
        title: Text(
          l10n.vitrinBaslik,
          style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 2, fontSize: 18),
        ),
        actions: [
          IconButton(
            tooltip: l10n.vitrinAkisiYenile,
            onPressed: () => context.read<VitrinCubiti>().akisiYukle(),
            icon: const Icon(Icons.refresh_rounded, color: UygulamaRenkleri.anaRenk),
          ),
        ],
      ),
      body: BlocBuilder<VitrinCubiti, VitrinDurum>(
        builder: (context, state) {
          if (state is VitrinYukleniyor) {
            return const Center(
              child: CircularProgressIndicator(color: UygulamaRenkleri.anaRenk),
            );
          } else if (state is VitrinBasarili) {
            if (state.akis.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.public_off_rounded, size: 64, color: Colors.white.withAlpha(50)),
                    const SizedBox(height: AppSpacing.md),
                    Text(
                      l10n.vitrinBosDurum,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () => context.read<VitrinCubiti>().akisiYukle(),
              color: UygulamaRenkleri.anaRenk,
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(AppSpacing.lg),
                itemCount: state.akis.length + (state.dahaFazlaVar ? 1 : 0),
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  if (index == state.akis.length) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                      child: Center(child: CircularProgressIndicator(color: UygulamaRenkleri.anaRenk)),
                    );
                  }
                  return VitrinKarti(gonderi: state.akis[index])
                      .animate()
                      .fadeIn(delay: (index % 10 * 100).ms)
                      .slideY(begin: 0.1);
                },
              ),
            );
          } else if (state is VitrinHata) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline_rounded, size: 48, color: UygulamaRenkleri.hata),
                  const SizedBox(height: AppSpacing.md),
                  Text(state.mesaj, style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: AppSpacing.lg),
                  Semantics(
                    button: true,
                    label: 'Vitrin akisinda tekrar dene',
                    child: ElevatedButton(
                      onPressed: () => context.read<VitrinCubiti>().akisiYukle(),
                      child: Text(l10n.vitrinTekrarDene),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
