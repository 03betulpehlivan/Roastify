import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr')
  ];

  /// No description provided for @uygulamaAdi.
  ///
  /// In tr, this message translates to:
  /// **'AI Roast Battle'**
  String get uygulamaAdi;

  /// No description provided for @battleSonucu.
  ///
  /// In tr, this message translates to:
  /// **'BATTLE SONUCU'**
  String get battleSonucu;

  /// No description provided for @hakem.
  ///
  /// In tr, this message translates to:
  /// **'HAKEM'**
  String get hakem;

  /// No description provided for @kazanan.
  ///
  /// In tr, this message translates to:
  /// **'KAZANAN'**
  String get kazanan;

  /// No description provided for @yarismaci.
  ///
  /// In tr, this message translates to:
  /// **'YARIŞMACI'**
  String get yarismaci;

  /// No description provided for @savasiPaylas.
  ///
  /// In tr, this message translates to:
  /// **'SAVAŞI PAYLAŞ'**
  String get savasiPaylas;

  /// No description provided for @hazirlaniyor.
  ///
  /// In tr, this message translates to:
  /// **'HAZIRLANIYOR'**
  String get hazirlaniyor;

  /// No description provided for @tekrarSavas.
  ///
  /// In tr, this message translates to:
  /// **'TEKRAR SAVAŞ'**
  String get tekrarSavas;

  /// No description provided for @paylasilamadi.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşılamadı.'**
  String get paylasilamadi;

  /// No description provided for @paylasMesaj.
  ///
  /// In tr, this message translates to:
  /// **'🔥 Arkadaşımla fena kapıştık! Kim kazandı dersin? #RoastBattle #KapakAI'**
  String get paylasMesaj;

  /// No description provided for @anaSayfaBaslik.
  ///
  /// In tr, this message translates to:
  /// **'AI ROAST BATTLE'**
  String get anaSayfaBaslik;

  /// No description provided for @fotoSec.
  ///
  /// In tr, this message translates to:
  /// **'FOTOĞRAF SEÇ'**
  String get fotoSec;

  /// No description provided for @savasBaslat.
  ///
  /// In tr, this message translates to:
  /// **'SAVAŞI BAŞLAT'**
  String get savasBaslat;

  /// No description provided for @analizEdiliyor.
  ///
  /// In tr, this message translates to:
  /// **'ANALİZ EDİLİYOR...'**
  String get analizEdiliyor;

  /// No description provided for @karakterSec.
  ///
  /// In tr, this message translates to:
  /// **'BİR JUDGE SEÇ'**
  String get karakterSec;

  /// No description provided for @onboardingHosGeldinizBaslik.
  ///
  /// In tr, this message translates to:
  /// **'HOS GELDINIZ'**
  String get onboardingHosGeldinizBaslik;

  /// No description provided for @onboardingHosGeldinizAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaslarinizin fotograflarini yukleyin ve yapay zekanin onlari yerin dibine sokmesini izleyin!'**
  String get onboardingHosGeldinizAciklama;

  /// No description provided for @onboardingJudgeSecinBaslik.
  ///
  /// In tr, this message translates to:
  /// **'JUDGE SECIN'**
  String get onboardingJudgeSecinBaslik;

  /// No description provided for @onboardingJudgeSecinAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Birbirinden farkli karakterlerle savasin hakemini belirleyin. Her karakterin tarzi farklidir!'**
  String get onboardingJudgeSecinAciklama;

  /// No description provided for @onboardingZafereUlasinBaslik.
  ///
  /// In tr, this message translates to:
  /// **'ZAFERE ULASIN'**
  String get onboardingZafereUlasinBaslik;

  /// No description provided for @onboardingZafereUlasinAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Savasin galibi kim olacak? Sonuclari paylasin ve eglenceyi katlayin!'**
  String get onboardingZafereUlasinAciklama;

  /// No description provided for @onboardingSonraki.
  ///
  /// In tr, this message translates to:
  /// **'SONRAKI'**
  String get onboardingSonraki;

  /// No description provided for @onboardingAtla.
  ///
  /// In tr, this message translates to:
  /// **'ATLA'**
  String get onboardingAtla;

  /// No description provided for @onboardingBaslayalim.
  ///
  /// In tr, this message translates to:
  /// **'BASLAYALIM'**
  String get onboardingBaslayalim;

  /// No description provided for @vitrinBaslik.
  ///
  /// In tr, this message translates to:
  /// **'ONUR TABLOSU'**
  String get vitrinBaslik;

  /// No description provided for @vitrinBosDurum.
  ///
  /// In tr, this message translates to:
  /// **'Henüz paylaşılan savaş yok.\nİlk sen paylaş!'**
  String get vitrinBosDurum;

  /// No description provided for @vitrinTekrarDene.
  ///
  /// In tr, this message translates to:
  /// **'TEKRAR DENE'**
  String get vitrinTekrarDene;

  /// No description provided for @vitrinAkisiYenile.
  ///
  /// In tr, this message translates to:
  /// **'Akısı yenile'**
  String get vitrinAkisiYenile;

  /// No description provided for @anaOzelKarakterBaslik.
  ///
  /// In tr, this message translates to:
  /// **'KENDİ KARAKTERİN'**
  String get anaOzelKarakterBaslik;

  /// No description provided for @anaOzelKarakterAciklama.
  ///
  /// In tr, this message translates to:
  /// **'AI\'nın seni hangi tarzda gömmesini istersin? (Örn: \'Huysuz bir tarih profesörü\', \'Aşırı kibar bir uşak\')'**
  String get anaOzelKarakterAciklama;

  /// No description provided for @anaOzelKarakterHint.
  ///
  /// In tr, this message translates to:
  /// **'Karakterini tarif et...'**
  String get anaOzelKarakterHint;

  /// No description provided for @anaOzelKarakterBosHata.
  ///
  /// In tr, this message translates to:
  /// **'Lütfen bir tarif gir'**
  String get anaOzelKarakterBosHata;

  /// No description provided for @iptal.
  ///
  /// In tr, this message translates to:
  /// **'İPTAL'**
  String get iptal;

  /// No description provided for @tamam.
  ///
  /// In tr, this message translates to:
  /// **'TAMAM'**
  String get tamam;

  /// No description provided for @anaBaglamPozitifVibe.
  ///
  /// In tr, this message translates to:
  /// **'POZİTİF VİBE'**
  String get anaBaglamPozitifVibe;

  /// No description provided for @anaBaglamRoastGuclendir.
  ///
  /// In tr, this message translates to:
  /// **'ROAST\'U GÜÇLENDİR'**
  String get anaBaglamRoastGuclendir;

  /// No description provided for @anaBaglamKapakla.
  ///
  /// In tr, this message translates to:
  /// **'KAPAKLA'**
  String get anaBaglamKapakla;

  /// No description provided for @anaBaglamYucelt.
  ///
  /// In tr, this message translates to:
  /// **'YÜCELT'**
  String get anaBaglamYucelt;

  /// No description provided for @anaBaglamPozitifAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Nasıl bir bağınız var? Ona göre daha içten bir şeyler söylesin.'**
  String get anaBaglamPozitifAciklama;

  /// No description provided for @anaBaglamRoastAciklama.
  ///
  /// In tr, this message translates to:
  /// **'AI\'nın ona özel kapak yapması için biraz dedikodu ver (İsteğe bağlı).'**
  String get anaBaglamRoastAciklama;

  /// No description provided for @anaBaglamKisiHint.
  ///
  /// In tr, this message translates to:
  /// **'Bu kişi sana neyin? (Örn: arkadaş, patron)'**
  String get anaBaglamKisiHint;

  /// No description provided for @anaBaglamPozitifOzellikHint.
  ///
  /// In tr, this message translates to:
  /// **'En sevdiğin özelliği ne?'**
  String get anaBaglamPozitifOzellikHint;

  /// No description provided for @anaBaglamNegatifOzellikHint.
  ///
  /// In tr, this message translates to:
  /// **'En sinir olduğun özelliği ne?'**
  String get anaBaglamNegatifOzellikHint;

  /// No description provided for @anaBaglamPozitifSirHint.
  ///
  /// In tr, this message translates to:
  /// **'Neden motivasyona ihtiyacı var?'**
  String get anaBaglamPozitifSirHint;

  /// No description provided for @anaBaglamNegatifSirHint.
  ///
  /// In tr, this message translates to:
  /// **'Bir sırrı var mı? (opsiyonel)'**
  String get anaBaglamNegatifSirHint;

  /// No description provided for @anaBaglamBosver.
  ///
  /// In tr, this message translates to:
  /// **'BOŞVER'**
  String get anaBaglamBosver;

  /// No description provided for @anaYeniKapakHazirlaniyor.
  ///
  /// In tr, this message translates to:
  /// **'Yeni kapak hazırlanıyor...'**
  String get anaYeniKapakHazirlaniyor;

  /// No description provided for @anaStiliniSec.
  ///
  /// In tr, this message translates to:
  /// **'STİLİNİ SEÇ'**
  String get anaStiliniSec;

  /// No description provided for @anaTekliKapakBaslik.
  ///
  /// In tr, this message translates to:
  /// **'TEKLİ KAPAK'**
  String get anaTekliKapakBaslik;

  /// No description provided for @anaTekliKapakAltBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Kendini AI\'ya teslim et'**
  String get anaTekliKapakAltBaslik;

  /// No description provided for @anaBattleModuBaslik.
  ///
  /// In tr, this message translates to:
  /// **'KAPIŞMA MODU'**
  String get anaBattleModuBaslik;

  /// No description provided for @anaBattleModuAltBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Arkadaşınla kapış'**
  String get anaBattleModuAltBaslik;

  /// No description provided for @anaKalanHak.
  ///
  /// In tr, this message translates to:
  /// **'KALAN HAK'**
  String get anaKalanHak;

  /// No description provided for @anaYenilenme.
  ///
  /// In tr, this message translates to:
  /// **'YENILENME'**
  String get anaYenilenme;

  /// No description provided for @anaRoastEtiketi.
  ///
  /// In tr, this message translates to:
  /// **'ROAST'**
  String get anaRoastEtiketi;

  /// No description provided for @anaSimulasyonModu.
  ///
  /// In tr, this message translates to:
  /// **'SİMÜLASYON MODU'**
  String get anaSimulasyonModu;

  /// No description provided for @anaSimulasyonAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Kredi harcamadan test et'**
  String get anaSimulasyonAciklama;

  /// No description provided for @sonucVitrineGonderBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Vitrine Gönder'**
  String get sonucVitrineGonderBaslik;

  /// No description provided for @sonucVitrineGonderAciklamaTekli.
  ///
  /// In tr, this message translates to:
  /// **'Hala haşlanmak isteyen var mı? Tüm dünya görsün mü?'**
  String get sonucVitrineGonderAciklamaTekli;

  /// No description provided for @sonucVitrineGonderAciklamaSavas.
  ///
  /// In tr, this message translates to:
  /// **'Savaşın tüm dünya tarafından görülsün mü?'**
  String get sonucVitrineGonderAciklamaSavas;

  /// No description provided for @sonucAnonimPaylas.
  ///
  /// In tr, this message translates to:
  /// **'Anonim Paylaş'**
  String get sonucAnonimPaylas;

  /// No description provided for @sonucIsim.
  ///
  /// In tr, this message translates to:
  /// **'İsminiz'**
  String get sonucIsim;

  /// No description provided for @sonucIsimOrnek.
  ///
  /// In tr, this message translates to:
  /// **'Roaster 123'**
  String get sonucIsimOrnek;

  /// No description provided for @sonucPaylas.
  ///
  /// In tr, this message translates to:
  /// **'PAYLAŞ'**
  String get sonucPaylas;

  /// No description provided for @sonucAnonimRoaster.
  ///
  /// In tr, this message translates to:
  /// **'Anonim Roaster'**
  String get sonucAnonimRoaster;

  /// No description provided for @sonucIsimsiz.
  ///
  /// In tr, this message translates to:
  /// **'İsimsiz'**
  String get sonucIsimsiz;

  /// No description provided for @sonucPaylasHata.
  ///
  /// In tr, this message translates to:
  /// **'Paylaşım oluşturulurken bir hata oluştu: {error}'**
  String sonucPaylasHata(Object error);

  /// No description provided for @sonucPaylasHataKisa.
  ///
  /// In tr, this message translates to:
  /// **'Paylasilamadi: {error}'**
  String sonucPaylasHataKisa(Object error);

  /// No description provided for @sonucVitrineEklendi.
  ///
  /// In tr, this message translates to:
  /// **'Vitrine başarıyla eklendi! 🔥'**
  String get sonucVitrineEklendi;

  /// No description provided for @sonucTekrar.
  ///
  /// In tr, this message translates to:
  /// **'TEKRAR'**
  String get sonucTekrar;

  /// No description provided for @sonucPaylasButon.
  ///
  /// In tr, this message translates to:
  /// **'PAYLAS'**
  String get sonucPaylasButon;

  /// No description provided for @sonucVitrineGonderGlobal.
  ///
  /// In tr, this message translates to:
  /// **'VİTRİNE GÖNDER (GLOBAL)'**
  String get sonucVitrineGonderGlobal;

  /// No description provided for @sonucFarkliKarakterSec.
  ///
  /// In tr, this message translates to:
  /// **'FARKLI KARAKTER SEC'**
  String get sonucFarkliKarakterSec;

  /// No description provided for @sonucAyniFotoFarkliKarakter.
  ///
  /// In tr, this message translates to:
  /// **'AYNI FOTO + FARKLI KARAKTER'**
  String get sonucAyniFotoFarkliKarakter;

  /// No description provided for @savasSonucPaylasButon.
  ///
  /// In tr, this message translates to:
  /// **'SONUCU PAYLAS'**
  String get savasSonucPaylasButon;

  /// No description provided for @savasSonucYeniSavas.
  ///
  /// In tr, this message translates to:
  /// **'YENI SAVAS BASLAT'**
  String get savasSonucYeniSavas;

  /// No description provided for @gecmisBaslik.
  ///
  /// In tr, this message translates to:
  /// **'GECMIS'**
  String get gecmisBaslik;

  /// No description provided for @gecmisTemizleBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Gecmisi Temizle'**
  String get gecmisTemizleBaslik;

  /// No description provided for @gecmisTemizleAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Tum roast gecmisi silinecek. Emin misin?'**
  String get gecmisTemizleAciklama;

  /// No description provided for @gecmisTemizleOnay.
  ///
  /// In tr, this message translates to:
  /// **'TEMIZLE'**
  String get gecmisTemizleOnay;

  /// No description provided for @gecmisTemizlendi.
  ///
  /// In tr, this message translates to:
  /// **'Gecmis temizlendi'**
  String get gecmisTemizlendi;

  /// No description provided for @gecmisBosBaslik.
  ///
  /// In tr, this message translates to:
  /// **'Henuz roast gecmisin yok'**
  String get gecmisBosBaslik;

  /// No description provided for @gecmisBosAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Ilk roast ini yaptiktan sonra burada gorunecek!'**
  String get gecmisBosAciklama;

  /// No description provided for @gecmisHemenBasla.
  ///
  /// In tr, this message translates to:
  /// **'HEMEN BASLA'**
  String get gecmisHemenBasla;

  /// No description provided for @gecmisKopyala.
  ///
  /// In tr, this message translates to:
  /// **'KOPYALA'**
  String get gecmisKopyala;

  /// No description provided for @gecmisPanoyaKopyalandi.
  ///
  /// In tr, this message translates to:
  /// **'Panoya kopyalandi'**
  String get gecmisPanoyaKopyalandi;

  /// No description provided for @gecmisAzOnce.
  ///
  /// In tr, this message translates to:
  /// **'Az once'**
  String get gecmisAzOnce;

  /// No description provided for @gecmisDakikaOnce.
  ///
  /// In tr, this message translates to:
  /// **'{count} dk once'**
  String gecmisDakikaOnce(int count);

  /// No description provided for @gecmisSaatOnce.
  ///
  /// In tr, this message translates to:
  /// **'{count} saat once'**
  String gecmisSaatOnce(int count);

  /// No description provided for @gecmisGunOnce.
  ///
  /// In tr, this message translates to:
  /// **'{count} gun once'**
  String gecmisGunOnce(int count);

  /// No description provided for @savasHazirlikBaslik.
  ///
  /// In tr, this message translates to:
  /// **'ROAST BATTLE'**
  String get savasHazirlikBaslik;

  /// No description provided for @savasHazirlikIkiKurban.
  ///
  /// In tr, this message translates to:
  /// **'IKI KURBAN SEC'**
  String get savasHazirlikIkiKurban;

  /// No description provided for @savasHazirlikAltYazi.
  ///
  /// In tr, this message translates to:
  /// **'Yapay zeka kimin daha ezik olduguna karar verecek.'**
  String get savasHazirlikAltYazi;

  /// No description provided for @savasHazirlikBaslat.
  ///
  /// In tr, this message translates to:
  /// **'BATTLE BASLAT!'**
  String get savasHazirlikBaslat;

  /// No description provided for @savasHazirlikHakemSec.
  ///
  /// In tr, this message translates to:
  /// **'HAKEMI SEC'**
  String get savasHazirlikHakemSec;

  /// No description provided for @savasHazirlikHakemStili.
  ///
  /// In tr, this message translates to:
  /// **'HAKEM STILI'**
  String get savasHazirlikHakemStili;

  /// No description provided for @savasHazirlikHakemAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Savasi kim yonetmeli? (Orn: \'Cok elit bir moda elestirmeni\', \'Sokak jargonlu bir abi\')'**
  String get savasHazirlikHakemAciklama;

  /// No description provided for @savasHazirlikHakemHint.
  ///
  /// In tr, this message translates to:
  /// **'Hakemini tarif et...'**
  String get savasHazirlikHakemHint;

  /// No description provided for @savasHazirlikBaslatButon.
  ///
  /// In tr, this message translates to:
  /// **'BASLAT'**
  String get savasHazirlikBaslatButon;

  /// No description provided for @savasHazirlikKurbanEtiket.
  ///
  /// In tr, this message translates to:
  /// **'{index}. KURBAN'**
  String savasHazirlikKurbanEtiket(int index);

  /// No description provided for @ayarlarBaslik.
  ///
  /// In tr, this message translates to:
  /// **'AYARLAR'**
  String get ayarlarBaslik;

  /// No description provided for @ayarlarDilSecimiBaslik.
  ///
  /// In tr, this message translates to:
  /// **'DIL SECIMI / LANGUAGE SELECTION'**
  String get ayarlarDilSecimiBaslik;

  /// No description provided for @ayarlarTurkce.
  ///
  /// In tr, this message translates to:
  /// **'Turkce'**
  String get ayarlarTurkce;

  /// No description provided for @ayarlarIngilizce.
  ///
  /// In tr, this message translates to:
  /// **'English'**
  String get ayarlarIngilizce;

  /// No description provided for @ayarlarVeriSifirlaBaslik.
  ///
  /// In tr, this message translates to:
  /// **'VERILERI SIFIRLA'**
  String get ayarlarVeriSifirlaBaslik;

  /// No description provided for @ayarlarVeriSifirlaAciklama.
  ///
  /// In tr, this message translates to:
  /// **'Tum gecmisin ve istatistiklerin kalici olarak silinecek. Emin misin?'**
  String get ayarlarVeriSifirlaAciklama;

  /// No description provided for @ayarlarVazgec.
  ///
  /// In tr, this message translates to:
  /// **'VAZGEC'**
  String get ayarlarVazgec;

  /// No description provided for @ayarlarEvetSil.
  ///
  /// In tr, this message translates to:
  /// **'EVET, SIL'**
  String get ayarlarEvetSil;

  /// No description provided for @ayarlarVerilerTemizlendi.
  ///
  /// In tr, this message translates to:
  /// **'Tum veriler temizlendi. Uygulama sifirlandi.'**
  String get ayarlarVerilerTemizlendi;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'tr': return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
