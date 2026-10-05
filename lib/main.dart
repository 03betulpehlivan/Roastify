import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'firebase_options.dart';
import 'cekirdek/tema/uygulama_temasi.dart';
import 'cekirdek/sabitler/metinler.dart';
import 'cekirdek/servisler/servis_kayit.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ozellikler/giris/is_mantigi/kimlik_dogrulama_servisi.dart';
import 'cekirdek/servisler/geri_bildirim_servisi.dart';
import 'cekirdek/servisler/olay_izleme_servisi.dart';
import 'ozellikler/roast/is_mantigi/roast_cubiti.dart';
import 'ozellikler/roast/is_mantigi/savas_cubiti.dart';
import 'ozellikler/vitrin/is_mantigi/vitrin_cubiti.dart';
import 'cekirdek/is_mantigi/ayarlar_cubiti.dart';

import 'ozellikler/giris/sunum/splash_sayfasi.dart';

void main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    await FirebaseAppCheck.instance.activate(
      androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
      appleProvider: kDebugMode ? AppleProvider.debug : AppleProvider.deviceCheck,
    );

    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    await servisleriKur();

    await servisBulucu<KimlikDogrulamaServisi>().anonimGirisYap();
    await servisBulucu<OlayIzlemeServisi>().olayGonder('app_open');

    runApp(const KapakAI());
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace, fatal: true);
  });
}

/// Uygulamanın ana giriş noktası olan Widget.
class KapakAI extends StatelessWidget {
  const KapakAI({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RoastCubiti>(create: (context) => servisBulucu<RoastCubiti>()),
        BlocProvider<SavasCubiti>(create: (context) => servisBulucu<SavasCubiti>()),
        BlocProvider<VitrinCubiti>(create: (context) => servisBulucu<VitrinCubiti>()..akisiYukle()),
        BlocProvider<AyarlarCubiti>(create: (context) => servisBulucu<AyarlarCubiti>()),
      ],
      child: BlocBuilder<AyarlarCubiti, AyarlarState>(
        builder: (context, ayarlarState) {
          return MaterialApp(
            title: UygulamaMetinleri.uygulamaAdi,
            debugShowCheckedModeBanner: false,
            scaffoldMessengerKey: servisBulucu<GeriBildirimServisi>().messengerKey,
            theme: UygulamaTemasi.aydinlikTema,
            darkTheme: UygulamaTemasi.karanlikTema,
            themeMode: ayarlarState.karanlikTema ? ThemeMode.dark : ThemeMode.light,
            locale: Locale(ayarlarState.dilSecimi),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('tr', ''),
              Locale('en', ''),
            ],
            home: const SplashSayfasi(),
          );
        },
      ),
    );
  }
}
