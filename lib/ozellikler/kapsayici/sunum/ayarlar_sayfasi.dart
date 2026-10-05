import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../../cekirdek/tasarim/tokenlar.dart';
import '../../../cekirdek/tasarim/durum_banner.dart';
import '../../../cekirdek/is_mantigi/ayarlar_cubiti.dart';
import '../../../l10n/app_localizations.dart';
import 'gizlilik_politikasi_sayfasi.dart';

class AyarlarSayfasi extends StatelessWidget {
  const AyarlarSayfasi({super.key});

  void _verileriTemizlemeDialogu(BuildContext context, String seciliDil) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.ayarlarVeriSifirlaBaslik, style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
        content: Text(l10n.ayarlarVeriSifirlaAciklama, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(l10n.ayarlarVazgec, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color))),
          TextButton(
            onPressed: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              if (context.mounted) {
                Navigator.pop(ctx);
                DurumBanner.goster(context, mesaj: l10n.ayarlarVerilerTemizlendi, tip: DurumBannerTip.bilgi);
                SystemNavigator.pop();
              }
            },
            child: Text(l10n.ayarlarEvetSil, style: const TextStyle(color: UygulamaRenkleri.hata, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  void _dilSecimDialogu(BuildContext context, AyarlarCubiti cubit, String seciliDil) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Text(l10n.ayarlarDilSecimiBaslik, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              ListTile(
                title: Text(l10n.ayarlarTurkce),
                trailing: seciliDil == 'tr' ? const Icon(Icons.check, color: UygulamaRenkleri.anaRenk) : null,
                onTap: () {
                  HapticFeedback.selectionClick();
                  cubit.dilDegistir('tr');
                  Navigator.pop(ctx);
                },
              ),
              ListTile(
                title: Text(l10n.ayarlarIngilizce),
                trailing: seciliDil == 'en' ? const Icon(Icons.check, color: UygulamaRenkleri.anaRenk) : null,
                onTap: () {
                  HapticFeedback.selectionClick();
                  cubit.dilDegistir('en');
                  Navigator.pop(ctx);
                },
              ),
              const SizedBox(height: AppSpacing.md),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final state = context.watch<AyarlarCubiti>().state;
    final cubit = context.read<AyarlarCubiti>();

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          l10n.ayarlarBaslik,
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18, letterSpacing: 2, color: Theme.of(context).textTheme.displayLarge?.color),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        physics: const BouncingScrollPhysics(),
        children: [
          _KategoriBasligi(state.dilSecimi == 'en' ? "Personalization" : "Kişiselleştirme"),
          _AyarTile(
            ikon: Icons.dark_mode_outlined,
            baslik: state.dilSecimi == 'en' ? "Dark Theme" : "Karanlık Tema",
            trailing: Switch(
              value: state.karanlikTema,
              onChanged: (val) {
                HapticFeedback.lightImpact();
                cubit.temaDegistir(val);
              },
              activeColor: UygulamaRenkleri.anaRenk,
            ),
          ),
          _AyarTile(
            ikon: Icons.language_outlined,
            baslik: state.dilSecimi == 'en' ? "Language Selection" : "Dil Seçimi",
            altBaslik: state.dilSecimi == 'tr' ? "Türkçe" : "English",
            onTap: () {
              HapticFeedback.selectionClick();
              _dilSecimDialogu(context, cubit, state.dilSecimi);
            },
          ),
          
          const SizedBox(height: AppSpacing.lg),
          _KategoriBasligi(state.dilSecimi == 'en' ? "Preferences" : "Tercihler"),
          _AyarTile(
            ikon: Icons.notifications_none_rounded,
            baslik: state.dilSecimi == 'en' ? "Notifications" : "Bildirimler",
            trailing: Switch(
              value: state.bildirimAcik,
              onChanged: (val) {
                HapticFeedback.lightImpact();
                cubit.bildirimDegistir(val);
              },
              activeColor: UygulamaRenkleri.anaRenk,
            ),
          ),
          _AyarTile(
            ikon: Icons.vibration_rounded,
            baslik: state.dilSecimi == 'en' ? "Vibration & Haptic Feedback" : "Titreşim ve Haptik Geri Bildirim",
            trailing: Switch(
              value: state.titresimAcik,
              onChanged: (val) {
                HapticFeedback.lightImpact();
                cubit.titresimDegistir(val);
              },
              activeColor: UygulamaRenkleri.anaRenk,
            ),
          ),

          const SizedBox(height: AppSpacing.lg),
          _KategoriBasligi(state.dilSecimi == 'en' ? "About & Privacy" : "Hakkında & Gizlilik"),
          _AyarTile(
            ikon: Icons.privacy_tip_outlined,
            baslik: state.dilSecimi == 'en' ? "Privacy Policy" : "Gizlilik Politikası",
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GizlilikPolitikasiSayfasi()),
              );
            },
          ),
          _AyarTile(
            ikon: Icons.info_outline_rounded,
            baslik: state.dilSecimi == 'en' ? "App Version" : "Uygulama Sürümü",
            altBaslik: "v1.0.0 (Beta)",
            onTap: null,
          ),

          const SizedBox(height: AppSpacing.xl),
          _KategoriBasligi(state.dilSecimi == 'en' ? "Data & Security" : "Veri & Güvenlik", renk: UygulamaRenkleri.hata),
          _AyarTile(
            ikon: Icons.delete_forever_rounded,
            ikonRenk: UygulamaRenkleri.hata,
            baslik: state.dilSecimi == 'en' ? "Reset All Data" : "Tüm Verileri Sıfırla",
            altBaslik: state.dilSecimi == 'en' ? "Permanently deletes history and stats" : "Geçmişi ve istatistikleri kalıcı siler",
            baslikRenk: UygulamaRenkleri.hata,
            onTap: () {
              HapticFeedback.mediumImpact();
              _verileriTemizlemeDialogu(context, state.dilSecimi);
            },
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}

class _KategoriBasligi extends StatelessWidget {
  final String baslik;
  final Color? renk;

  const _KategoriBasligi(this.baslik, {this.renk});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm, left: AppSpacing.xs, top: AppSpacing.md),
      child: Text(
        baslik.toUpperCase(),
        style: TextStyle(
          color: renk ?? (Theme.of(context).brightness == Brightness.dark 
              ? UygulamaRenkleri.vurguRenk 
              : UygulamaRenkleri.anaRenk),
          fontSize: 12,
          fontWeight: FontWeight.w900,
          letterSpacing: 1.5,
        ),
      ),
    );
  }
}

class _AyarTile extends StatelessWidget {
  final IconData ikon;
  final String baslik;
  final String? altBaslik;
  final Widget? trailing;
  final VoidCallback? onTap;
  final Color? ikonRenk;
  final Color? baslikRenk;

  const _AyarTile({
    required this.ikon,
    required this.baslik,
    this.altBaslik,
    this.trailing,
    this.onTap,
    this.ikonRenk,
    this.baslikRenk,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
        leading: Icon(ikon, color: ikonRenk ?? Theme.of(context).iconTheme.color),
        title: Text(
          baslik,
          style: TextStyle(
            color: baslikRenk ?? Theme.of(context).textTheme.bodyLarge?.color,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
        ),
        subtitle: altBaslik != null 
            ? Text(altBaslik!, style: TextStyle(color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7), fontSize: 12))
            : null,
        trailing: trailing ?? (onTap != null ? Icon(Icons.chevron_right_rounded, color: Theme.of(context).iconTheme.color?.withOpacity(0.5)) : null),
      ),
    );
  }
}
