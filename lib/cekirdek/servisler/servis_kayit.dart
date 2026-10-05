import 'package:get_it/get_it.dart';
import '../../ozellikler/roast/is_mantigi/roast_servisi.dart';
import '../../ozellikler/roast/is_mantigi/sahte_roast_servisi.dart';
import '../../ozellikler/roast/is_mantigi/gemini_roast_servisi.dart';
import '../../ozellikler/roast/is_mantigi/roast_cubiti.dart';
import '../../ozellikler/giris/is_mantigi/kimlik_dogrulama_servisi.dart';
import 'geri_bildirim_servisi.dart';
import 'titresim_servisi.dart';
import 'istatistik_servisi.dart';
import 'olay_izleme_servisi.dart';
import 'gecmis_servisi.dart';
import 'baglanti_servisi.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../ozellikler/roast/is_mantigi/savas_cubiti.dart';
import '../../ozellikler/vitrin/is_mantigi/vitrin_servisi.dart';
import '../../ozellikler/vitrin/is_mantigi/vitrin_cubiti.dart';
import '../is_mantigi/ayarlar_cubiti.dart';

final servisBulucu = GetIt.instance;

Future<void> servisleriKur() async {
  // Hive
  await Hive.initFlutter();
  await Hive.openBox('roast_gecmis');
  await Hive.openBox('vitrin_cache');

  // Servisler
  final prefs = await SharedPreferences.getInstance();
  servisBulucu.registerLazySingleton<SharedPreferences>(() => prefs);
  servisBulucu.registerLazySingleton<IstatistikServisi>(() => IstatistikServisi(prefs));
  servisBulucu.registerLazySingleton<GecmisServisi>(() => GecmisServisi());
  servisBulucu.registerLazySingleton<OlayIzlemeServisi>(
    () => OlayIzlemeServisi(servisBulucu<IstatistikServisi>()),
  );

  servisBulucu.registerLazySingleton<GeriBildirimServisi>(() => GeriBildirimServisi());
  servisBulucu.registerLazySingleton<TitresimServisi>(() => TitresimServisi());
  servisBulucu.registerLazySingleton<BaglantiServisi>(() => ConnectivityBaglantiServisi());
  servisBulucu.registerLazySingleton<KimlikDogrulamaServisi>(() => FirebaseKimlikDogrulamaServisi());
  servisBulucu.registerLazySingleton<RoastServisi>(() => GeminiRoastServisi(), instanceName: 'gemini');
  servisBulucu.registerLazySingleton<RoastServisi>(() => SahteRoastServisi(), instanceName: 'sahte');
  servisBulucu.registerLazySingleton<VitrinServisi>(() => VitrinServisi());

  // Cubitler
  servisBulucu.registerLazySingleton<AyarlarCubiti>(() => AyarlarCubiti(prefs));
  servisBulucu.registerFactory(() => RoastCubiti(
    servisBulucu<RoastServisi>(instanceName: 'gemini'),
    servisBulucu<RoastServisi>(instanceName: 'sahte'),
    servisBulucu<OlayIzlemeServisi>(),
    servisBulucu<GecmisServisi>(),
    servisBulucu<BaglantiServisi>(),
    servisBulucu<IstatistikServisi>(),
    servisBulucu<AyarlarCubiti>(),
  ));


  servisBulucu.registerFactory(() => SavasCubiti(
    servisBulucu<RoastServisi>(instanceName: 'gemini'),
    servisBulucu<RoastServisi>(instanceName: 'sahte'),
    servisBulucu<OlayIzlemeServisi>(),
    servisBulucu<BaglantiServisi>(),
    servisBulucu<IstatistikServisi>(),
    servisBulucu<AyarlarCubiti>(),
  ));

  servisBulucu.registerFactory(() => VitrinCubiti(
    servisBulucu<VitrinServisi>(),
  ));
}
