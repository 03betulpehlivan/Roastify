// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get uygulamaAdi => 'AI Roast Battle';

  @override
  String get battleSonucu => 'BATTLE RESULT';

  @override
  String get hakem => 'JUDGE';

  @override
  String get kazanan => 'WINNER';

  @override
  String get yarismaci => 'PLAYER';

  @override
  String get savasiPaylas => 'SHARE BATTLE';

  @override
  String get hazirlaniyor => 'PREPARING';

  @override
  String get tekrarSavas => 'REBATTLE';

  @override
  String get paylasilamadi => 'Could not share.';

  @override
  String get paylasMesaj => '🔥 We had a brutal battle! Who do you think won? #RoastBattle #KapakAI';

  @override
  String get anaSayfaBaslik => 'AI ROAST BATTLE';

  @override
  String get fotoSec => 'SELECT PHOTO';

  @override
  String get savasBaslat => 'START BATTLE';

  @override
  String get analizEdiliyor => 'ANALYZING...';

  @override
  String get karakterSec => 'CHOOSE A JUDGE';

  @override
  String get onboardingHosGeldinizBaslik => 'WELCOME';

  @override
  String get onboardingHosGeldinizAciklama => 'Upload your friends\' photos and watch AI roast them mercilessly!';

  @override
  String get onboardingJudgeSecinBaslik => 'CHOOSE A JUDGE';

  @override
  String get onboardingJudgeSecinAciklama => 'Pick a unique character as the battle judge. Every character has a different style!';

  @override
  String get onboardingZafereUlasinBaslik => 'REACH VICTORY';

  @override
  String get onboardingZafereUlasinAciklama => 'Who will win the battle? Share the results and double the fun!';

  @override
  String get onboardingSonraki => 'NEXT';

  @override
  String get onboardingAtla => 'SKIP';

  @override
  String get onboardingBaslayalim => 'LET\'S START';

  @override
  String get vitrinBaslik => 'SHOWCASE';

  @override
  String get vitrinBosDurum => 'No battles have been shared yet.\nBe the first to share!';

  @override
  String get vitrinTekrarDene => 'TRY AGAIN';

  @override
  String get vitrinAkisiYenile => 'Refresh feed';

  @override
  String get anaOzelKarakterBaslik => 'YOUR OWN CHARACTER';

  @override
  String get anaOzelKarakterAciklama => 'How should AI roast you? (e.g. \'A grumpy history professor\', \'An overly polite butler\')';

  @override
  String get anaOzelKarakterHint => 'Describe your character...';

  @override
  String get anaOzelKarakterBosHata => 'Please enter a description';

  @override
  String get iptal => 'CANCEL';

  @override
  String get tamam => 'OK';

  @override
  String get anaBaglamPozitifVibe => 'POSITIVE VIBE';

  @override
  String get anaBaglamRoastGuclendir => 'POWER UP THE ROAST';

  @override
  String get anaBaglamKapakla => 'ROAST';

  @override
  String get anaBaglamYucelt => 'UPLIFT';

  @override
  String get anaBaglamPozitifAciklama => 'What is your relationship? It can respond more sincerely.';

  @override
  String get anaBaglamRoastAciklama => 'Give AI some details to make the roast more personal (optional).';

  @override
  String get anaBaglamKisiHint => 'Who is this person to you? (e.g. friend, boss)';

  @override
  String get anaBaglamPozitifOzellikHint => 'What is your favorite trait?';

  @override
  String get anaBaglamNegatifOzellikHint => 'What annoys you the most?';

  @override
  String get anaBaglamPozitifSirHint => 'Why do they need motivation?';

  @override
  String get anaBaglamNegatifSirHint => 'Any secret? (optional)';

  @override
  String get anaBaglamBosver => 'SKIP';

  @override
  String get anaYeniKapakHazirlaniyor => 'Preparing a new roast...';

  @override
  String get anaStiliniSec => 'CHOOSE YOUR STYLE';

  @override
  String get anaTekliKapakBaslik => 'SINGLE ROAST';

  @override
  String get anaTekliKapakAltBaslik => 'Surrender yourself to AI';

  @override
  String get anaBattleModuBaslik => 'BATTLE MODE';

  @override
  String get anaBattleModuAltBaslik => 'Battle with a friend';

  @override
  String get anaKalanHak => 'REMAINING';

  @override
  String get anaYenilenme => 'REFRESH';

  @override
  String get anaRoastEtiketi => 'ROAST';

  @override
  String get anaSimulasyonModu => 'SIMULATION MODE';

  @override
  String get anaSimulasyonAciklama => 'Test without spending credits';

  @override
  String get sonucVitrineGonderBaslik => 'Send to Showcase';

  @override
  String get sonucVitrineGonderAciklamaTekli => 'Want everyone to see this roast?';

  @override
  String get sonucVitrineGonderAciklamaSavas => 'Do you want the whole world to see this battle?';

  @override
  String get sonucAnonimPaylas => 'Share anonymously';

  @override
  String get sonucIsim => 'Your name';

  @override
  String get sonucIsimOrnek => 'Roaster 123';

  @override
  String get sonucPaylas => 'SHARE';

  @override
  String get sonucAnonimRoaster => 'Anonymous Roaster';

  @override
  String get sonucIsimsiz => 'Nameless';

  @override
  String sonucPaylasHata(Object error) {
    return 'An error occurred while preparing share: $error';
  }

  @override
  String sonucPaylasHataKisa(Object error) {
    return 'Could not share: $error';
  }

  @override
  String get sonucVitrineEklendi => 'Added to showcase successfully! 🔥';

  @override
  String get sonucTekrar => 'RETRY';

  @override
  String get sonucPaylasButon => 'SHARE';

  @override
  String get sonucVitrineGonderGlobal => 'SEND TO SHOWCASE (GLOBAL)';

  @override
  String get sonucFarkliKarakterSec => 'CHOOSE DIFFERENT CHARACTER';

  @override
  String get sonucAyniFotoFarkliKarakter => 'SAME PHOTO + DIFFERENT CHARACTER';

  @override
  String get savasSonucPaylasButon => 'SHARE RESULT';

  @override
  String get savasSonucYeniSavas => 'START NEW BATTLE';

  @override
  String get gecmisBaslik => 'HISTORY';

  @override
  String get gecmisTemizleBaslik => 'Clear history';

  @override
  String get gecmisTemizleAciklama => 'All roast history will be deleted. Are you sure?';

  @override
  String get gecmisTemizleOnay => 'CLEAR';

  @override
  String get gecmisTemizlendi => 'History cleared';

  @override
  String get gecmisBosBaslik => 'No roast history yet';

  @override
  String get gecmisBosAciklama => 'It will appear here after your first roast!';

  @override
  String get gecmisHemenBasla => 'START NOW';

  @override
  String get gecmisKopyala => 'COPY';

  @override
  String get gecmisPanoyaKopyalandi => 'Copied to clipboard';

  @override
  String get gecmisAzOnce => 'Just now';

  @override
  String gecmisDakikaOnce(int count) {
    return '$count min ago';
  }

  @override
  String gecmisSaatOnce(int count) {
    return '$count hr ago';
  }

  @override
  String gecmisGunOnce(int count) {
    return '$count day ago';
  }

  @override
  String get savasHazirlikBaslik => 'ROAST BATTLE';

  @override
  String get savasHazirlikIkiKurban => 'CHOOSE TWO TARGETS';

  @override
  String get savasHazirlikAltYazi => 'AI will decide who gets roasted harder.';

  @override
  String get savasHazirlikBaslat => 'START BATTLE!';

  @override
  String get savasHazirlikHakemSec => 'CHOOSE JUDGE';

  @override
  String get savasHazirlikHakemStili => 'JUDGE STYLE';

  @override
  String get savasHazirlikHakemAciklama => 'Who should run this battle? (e.g. \'An elite fashion critic\', \'A street-style tough guy\')';

  @override
  String get savasHazirlikHakemHint => 'Describe your judge...';

  @override
  String get savasHazirlikBaslatButon => 'START';

  @override
  String savasHazirlikKurbanEtiket(int index) {
    return 'TARGET $index';
  }

  @override
  String get ayarlarBaslik => 'SETTINGS';

  @override
  String get ayarlarDilSecimiBaslik => 'LANGUAGE SELECTION';

  @override
  String get ayarlarTurkce => 'Turkish';

  @override
  String get ayarlarIngilizce => 'English';

  @override
  String get ayarlarVeriSifirlaBaslik => 'RESET ALL DATA';

  @override
  String get ayarlarVeriSifirlaAciklama => 'All your history and stats will be permanently deleted. Are you sure?';

  @override
  String get ayarlarVazgec => 'CANCEL';

  @override
  String get ayarlarEvetSil => 'YES, DELETE';

  @override
  String get ayarlarVerilerTemizlendi => 'All data cleared. App reset.';
}
