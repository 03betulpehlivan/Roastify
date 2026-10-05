import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../roast/sunum/ana_sayfa.dart';
import '../../vitrin/sunum/vitrin_sayfasi.dart';
import '../../gecmis/sunum/gecmis_sayfasi.dart';
import 'dart:ui';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../cekirdek/is_mantigi/ayarlar_cubiti.dart';

class AnaKapsayiciSayfa extends StatefulWidget {
  final List<Widget>? testSayfalar;

  const AnaKapsayiciSayfa({super.key, this.testSayfalar});

  @override
  State<AnaKapsayiciSayfa> createState() => _AnaKapsayiciSayfaState();
}

class _AnaKapsayiciSayfaState extends State<AnaKapsayiciSayfa> {
  int _seciliIndeks = 0;

  late final List<Widget> _sayfalar;

  @override
  void initState() {
    super.initState();
    _sayfalar = widget.testSayfalar ??
        const [
          AnaSayfa(),
          VitrinSayfasi(),
          GecmisSayfasi(),
        ];
  }

  void _sayfaDegistir(int index) {
    if (_seciliIndeks != index) {
      HapticFeedback.selectionClick();
      setState(() {
        _seciliIndeks = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AyarlarCubiti>().state;
    final isEn = state.dilSecimi == 'en';

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          // Sayfa İçeriği
          IndexedStack(
            index: _seciliIndeks,
            children: _sayfalar,
          ),
          
          // Bottom Navigation Bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface.withOpacity(0.85),
                    border: Border(
                      top: BorderSide(
                        color: Theme.of(context).dividerColor.withOpacity(0.1),
                        width: 1,
                      ),
                    ),
                  ),
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Semantics(
                        container: true,
                        label: isEn ? 'Main navigation tabs' : 'Ana gezinti sekmeleri',
                        child: NavigationBar(
                          backgroundColor: Colors.transparent,
                          indicatorColor: UygulamaRenkleri.anaRenk.withOpacity(0.2),
                          selectedIndex: _seciliIndeks,
                          onDestinationSelected: _sayfaDegistir,
                          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                          elevation: 0,
                          height: 55,
                          destinations: [
                            NavigationDestination(
                              icon: Icon(Icons.home_outlined, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                              selectedIcon: const Icon(Icons.home_rounded, color: UygulamaRenkleri.anaRenk),
                              label: isEn ? 'Home' : 'Ana Sayfa',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.public_outlined, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                              selectedIcon: const Icon(Icons.public_rounded, color: UygulamaRenkleri.vurguRenk),
                              label: isEn ? 'Showcase' : 'Onur Tablosu',
                            ),
                            NavigationDestination(
                              icon: Icon(Icons.history_outlined, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
                              selectedIcon: const Icon(Icons.history_rounded, color: UygulamaRenkleri.neonPembe),
                              label: isEn ? 'History' : 'Geçmiş',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
