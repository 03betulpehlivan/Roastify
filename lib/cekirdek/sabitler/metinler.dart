import 'package:flutter/material.dart';
import 'renkler.dart';
import 'tipler.dart';


class UygulamaMetinleri {
  static const String uygulamaAdi = "Kapak Olsun";
  static const String slogan = "Gerçekler Can Yakar!";

  // Roast Modları
  static const String modNazik = "Tatlı Sert";
  static const String modOrta = "Biberli";
  static const String modAcimasiz = "Acımasız";
  static const String modOvgulu = "Övgü & Motivasyon";

  // Karakterler ve Prompt Yönergeleri
  static const String karakterHacerTeyze = "Hacer Teyze";
  static const String karakterZKusagi = "Sarkastik Z Kuşağı";
  static const String karakterShakespeare = "Shakespeare";
  static const String karakterGordonRamsay = "Mutfak Şefi";
  static const String karakterBehzatC = "Behzat Ç.";
  static const String karakterBurhanAltintop = "Burhan Altıntop";
  static const String karakterBihterYoreoglu = "Bihter Yöreoğlu";
  static const String karakterRamizDayi = "Ramiz Dayı";
  static const String karakterDrHouse = "Dr. House";
  static const String karakterMatmazel = "Matmazel";
  static const String karakterDanlaBilic = "Danla Bilic";
  static const String karakterMuratOvuc = "Murat Övüç";
  static const String karakterKerimcanDurmaz = "Kerimcan Durmaz";
  static const String karakterFatihTerim = "Fatih Terim";
  static const String karakterMugeAnli = "Müge Anlı";
  static const String karakterIlberOrtayli = "İlber Ortaylı";
  static const String karakterAykutElmas = "Aykut Elmas";
  static const String karakterYildizTilbe = "Yıldız Tilbe";
  static const String karakterSedaSayan = "Seda Sayan";
  static const String karakterOzel = "Kendi Karakterin";

  // Tüm Karakterlerin Listesi
  static List<String> get tumKarakterler => [
    karakterFatihTerim,
    karakterMugeAnli,
    karakterIlberOrtayli,
    karakterAykutElmas,
    karakterYildizTilbe,
    karakterSedaSayan,
    karakterDanlaBilic,
    karakterMuratOvuc,
    karakterKerimcanDurmaz,
    karakterHacerTeyze,
    karakterGordonRamsay,
    karakterBehzatC,
    karakterBurhanAltintop,
    karakterBihterYoreoglu,
    karakterRamizDayi,
    karakterDrHouse,
    karakterMatmazel,
    karakterZKusagi,
    karakterShakespeare,
    karakterOzel,
  ];

  // Karakter İkonları
  static IconData karakterIkonu(String karakter) {
    switch (karakter) {
      case karakterFatihTerim: return Icons.sports_soccer;
      case karakterMugeAnli: return Icons.search;
      case karakterIlberOrtayli: return Icons.menu_book;
      case karakterAykutElmas: return Icons.videocam;
      case karakterYildizTilbe: return Icons.music_note;
      case karakterSedaSayan: return Icons.mic;
      case karakterDanlaBilic: return Icons.vaping_rooms;
      case karakterMuratOvuc: return Icons.volume_up;
      case karakterKerimcanDurmaz: return Icons.auto_awesome;
      case karakterHacerTeyze: return Icons.elderly;
      case karakterGordonRamsay: return Icons.restaurant_menu;
      case karakterBehzatC: return Icons.local_police;
      case karakterBurhanAltintop: return Icons.sentiment_very_satisfied;
      case karakterBihterYoreoglu: return Icons.diamond;
      case karakterRamizDayi: return Icons.auto_awesome; 
      case karakterDrHouse: return Icons.medical_services;
      case karakterMatmazel: return Icons.face_retouching_natural;
      case karakterZKusagi: return Icons.phone_android;
      case karakterShakespeare: return Icons.history_edu;
      case karakterOzel: return Icons.add_circle_outline_rounded;
      default: return Icons.person;
    }
  }

  // Karakter Renkleri
  static Color karakterRengi(String karakter) {
    switch (karakter) {
      case karakterFatihTerim: return Colors.amber;
      case karakterMugeAnli: return Colors.blue;
      case karakterIlberOrtayli: return Colors.deepPurple;
      case karakterAykutElmas: return Colors.redAccent;
      case karakterYildizTilbe: return Colors.indigo;
      case karakterSedaSayan: return Colors.yellowAccent;
      case karakterDanlaBilic: return Colors.greenAccent;
      case karakterMuratOvuc: return Colors.orangeAccent;
      case karakterKerimcanDurmaz: return Colors.pinkAccent;
      case karakterHacerTeyze: return UygulamaRenkleri.neonTuruncu;
      case karakterGordonRamsay: return UygulamaRenkleri.neonPembe;
      case karakterBehzatC: return Colors.blueGrey;
      case karakterBurhanAltintop: return Colors.purpleAccent;
      case karakterBihterYoreoglu: return Colors.redAccent;
      case karakterRamizDayi: return Colors.brown;
      case karakterDrHouse: return Colors.blueAccent;
      case karakterMatmazel: return Colors.tealAccent;
      case karakterZKusagi: return UygulamaRenkleri.vurguRenk;
      case karakterShakespeare: return UygulamaRenkleri.anaRenk;
      case karakterOzel: return Colors.white;
      default: return Colors.grey;
    }
  }

  // Karakter Açıklamaları
  static String karakterAciklama(String karakter) {
    switch (karakter) {
      case karakterHacerTeyze: return "Terliği yemeye hazır mısın evladım?";
      case karakterZKusagi: return "L Bozo, çok cringe duruyorsun...";
      case karakterShakespeare: return "Ey fani, bu ne sefil bir haldir?";
      case karakterGordonRamsay: return "REAZALET! Sen ne olduğunu sanıyorsun?";
      case karakterBehzatC: return "Saçma sapan konuşma la!";
      case karakterBurhanAltintop: return "Ay bayılazam! Vizyonsuz seni!";
      case karakterBihterYoreoglu: return "Behlül kaçar şekerim...";
      case karakterRamizDayi: return "Anlat yeğen, anlat ki gülelim...";
      case karakterDrHouse: return "Herkes yalan söyler, tipin hariç.";
      case karakterMatmazel: return "Adab-ı muaşeret yerlerde matmazel...";
      case karakterDanlaBilic: return "Yılanlığım tuttu yine aşkım...";
      case karakterMuratOvuc: return "Seni gidi fırfır! Dalgana bak!";
      case karakterKerimcanDurmaz: return "Ablan kurban olsun sana olay!";
      case karakterFatihTerim: return "What can I do sometimes? İmparator sahnede.";
      case karakterMugeAnli: return "Tatlı sert bir sorguya hazır mısın?";
      case karakterIlberOrtayli: return "Cahil kalmışsın evladım, çok yazık.";
      case karakterAykutElmas: return "Anladın mı? Napıyon sen ya!";
      case karakterYildizTilbe: return "Aşkım sen ne yaşıyorsun şu an?";
      case karakterSedaSayan: return "Bacım seni seviyorum ama bu hal ne?";
      case karakterOzel: return "Kendi tarzını konuştur...";
      default: return "Standart bir roast.";
    }
  }

  // Prompt Direktifleri
  static String karakterPrompt(String karakter) {
    switch (karakter) {
      case karakterHacerTeyze:
        return "Anadolu jargonlu, huysuz ama komik bir teyze gibi davran. 'Evladım', 'Ayol', 'Tüüh' gibi ifadeler kullan. Terlik fırlatır gibi eleştir.";
      case karakterZKusagi:
        return "Z kuşağı jargonuyla konuş. 'Aynen kanka', 'Ratio', 'Skill issue', 'L Bozo', 'Cringe' gibi kelimeler kullan. Çok sarkastik ve umursamaz ol.";
      case karakterShakespeare:
        return "16. yüzyıl felsefi ve şairane İngiliz edebiyatı tarzında (Türkçe) konuş. Ağır benzetmeler ve ağdalı bir dil kullan ama kısa ve öz bir şekilde iğnele.";
      case karakterGordonRamsay:
        return "Dünyaca ünlü sert bir şef gibi davran. 'Raw!', 'Disaster!', 'What are you?!' tadında bağırır gibi ve çok disiplinli bir dille yerin dibine sok.";
      case karakterBehzatC:
        return "Sert, kaba ama dürüst bir Ankaralı emniyet amiri gibi konuş. 'La', 'Saçma sapan konuşma la', 'Hayalet gelsin baksın' gibi tabirler kullan. Cinayet çözermişçesine analiz et.";
      case karakterBurhanAltintop:
        return "Aşırı dramatik, kendini beğenmiş ama komik bir üslup. 'Ay ben bayılazam', 'Çok vizyonsuzsun şekerim' gibi tabirler kullan. Şuh kahkahalar atar gibi dalga geç.";
      case karakterBihterYoreoglu:
        return "Zengin, elit ve moda ikonu bir kadın gibi konuş. Karşındakini fakirliğiyle veya rüküşlüğüyle küçümse. 'Nihalin suçu ne?', 'Aptallık etme' gibi ikonik laflarını kullan.";
      case karakterRamizDayi:
        return "Derin ve felsefi konuş. Sözlerine 'Yeğen' diye başla. Ağır abi metaforları kullan ama lafı dolandırmadan, kısa ve sert bir şekilde eleştir.";
      case karakterDrHouse:
        return "Aşırı zeki, tıbbi terimler kullanan, kimseyi beğenmeyen bir dahi gibi konuş. Alaycı ol ve karşındakine 'herkes yalan söyler' tarzında bak.";
      case karakterMatmazel:
        return "Saygılı, disiplinli, asil ama alttan alta iğneleyici bir üslup kullan. Fransızca kelimeler (pardonnez-moi vb.) ekleyebilirsin ama Türkçe konuş.";
      case karakterDanlaBilic:
        return "Aşırı sarkastik, umursamaz, her şeye bir kulp bulan bir influencer gibi davran. 'Yılanlığım tuttu', 'Aşkım sen ne giydin?', 'Şaka mı?' gibi ifadeler kullan. Soğuk ama eğlenceli bir dille yerin dibine sok.";
      case karakterMuratOvuc:
        return "Çok yüksek enerjili, bağıra çağıra konuşan, her cümlesine bir nida ekleyen bir fenomen ol. 'Seni gidi fırfır', 'Dalganıza bakın', 'Yanıyorsun Fuat Abi' gibi ikonik tabirler kullan. Vurucu ve öz bir dille, lafı uzatmadan roast yap.";
      case karakterKerimcanDurmaz:
        return "Aşırı lüks ve gösteriş meraklısı, her şeyi 'vıck vıck' ve 'bayıldım' arasında bir tonda yorumlayan bir fenomen ol. 'Ablan kurban olsun sana', 'Olayyy', 'Vay be' gibi tabirler kullan. Karşındakini rüküşlüğüyle veya vizyonsuzluğuyla vur.";
      case karakterFatihTerim:
        return "İmparator lakaplı otoriter bir teknik direktör gibi davran. 'What can I do sometimes', 'Biz bitti demeden bitmez', 'Takım oyunu önemli' gibi ifadeler kullan. Sert ama babacan bir dille eleştir.";
      case karakterMugeAnli:
        return "Müge Anlı gibi davran. Suçlu arar gibi sorgula, her detayı yargıla. 'Nerde o katil?', 'Korkma anlat canım', 'Biz burda gerçekleri arıyoruz' gibi ifadeler kullan. Çok disiplinli ve şüpheci ol.";
      case karakterIlberOrtayli:
        return "İlber Ortaylı gibi davran. Karşındakini cahillikle suçla. 'Cahil', 'Hiç okumuyorlar', 'Bu bir rezalettir' gibi kelimeler kullan. Çok entelektüel, tarihi referanslar veren ama bir o kadar da küçümseyen bir dil kullan.";
      case karakterAykutElmas:
        return "Aykut Elmas'ın tiplemeleri gibi davran. 'Anladın mı?', 'Napıyon sen?', 'Bak şimdi evladım' gibi replikler kullan. Çok sinirli, absürt ve bir o kadar da komik bir üslup takın. Durum komedisi yapar gibi eleştir.";
      case karakterYildizTilbe:
        return "Yıldız Tilbe gibi davran. Şiirsel ama tamamen kaotik bir dil kullan. 'Aşk laftan anlamaz', 'Çabuk olalım aşkım', 'Ben zaten her zaman öyleyim' gibi ilginç cümleler kur. Kendine has, öngörülemez ve duygusal bir dille roast yap.";
      case karakterSedaSayan:
        return "Seda Sayan gibi davran. 'Bacım', 'Seviyorum seni', 'Sahte seni', 'Gülüyorum şu an' gibi ifadeler kullan. Çok yüksek enerjili ol, her iğnelemenden sonra bir kahkaha efekti veriyormuşsun gibi davran.";
      default:
        return "Acımasız ve komik bir komedyen gibi davran.";
    }
  }

  // Asama Mesajları
  static String asamaMesaji(RoastAsamasi asama) {
    switch (asama) {
      case RoastAsamasi.analiz:
        return "Görsel analiz ediliyor...";
      case RoastAsamasi.tonAyari:
        return "Karakter tonu ayarlanıyor...";
      case RoastAsamasi.metinUretimi:
        return "Roast metni üretiliyor...";
      case RoastAsamasi.savasAnalizi:
        return "Yapay zeka iki yarışmacıyı da süzüyor...";
      default:
        return "İşlem devam ediyor...";
    }
  }

  // Hata Mesajları
  static String hataMesaji(RoastHataTipi tip, {String? ekMesaj}) {
    switch (tip) {
      case RoastHataTipi.baglanti:
        return "İnternet bağlantısı yok veya zayıf. Lütfen kontrol edin.";
      case RoastHataTipi.zamanAsimi:
        return "İşlem zaman aşımına uğradı. İnternetiniz çok yavaş olabilir.";
      case RoastHataTipi.gunlukLimit:
        return "Limit doldu (5/5). Haklar 24 saat sonra yenilenir.";
      case RoastHataTipi.guvenlikFiltresi:
        return "İçerik güvenlik filtresine takıldı. Farklı bir fotoğraf deneyin.";
      case RoastHataTipi.apiHatasi:
        return "Yapay zeka servisinde bir sorun oluştu. Lütfen az sonra tekrar dene.";
      case RoastHataTipi.fotografSecimi:
        return "Fotoğraf seçilirken bir hata oluştu veya seçim iptal edildi.";
      case RoastHataTipi.bilinmeyen:
      default:
        return ekMesaj ?? "Beklenmeyen bir hata oluştu. Lütfen tekrar dene.";
    }
  }
}

