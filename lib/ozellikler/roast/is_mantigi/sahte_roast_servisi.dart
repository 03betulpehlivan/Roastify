import 'dart:io';
import 'roast_servisi.dart';
import '../veri/savas_model.dart';
import '../../../cekirdek/sabitler/metinler.dart';

class SahteRoastServisi implements RoastServisi {
  @override
  Stream<String> roastUret({
    required File fotograf,
    required String karakter,
    required String mod,
    String? ozelPrompt,
    String? kisiYakinligi,
    String? sinirBozucuOzellik,
    String? sir,
  }) async* {
    // Yapay başlangıç gecikmesi
    await Future.delayed(const Duration(seconds: 1));

    String mockMesaj;
    
    switch (karakter) {
      case UygulamaMetinleri.karakterHacerTeyze:
        mockMesaj = "Aaaa bu ne hal evladım? Üstündeki o şeyi pazardan mı aldın yoksa bedavaya mı verdiler? Git de üstüne düzgün bir şey giy, terliği fırlattırma bana!";
        break;
      case UygulamaMetinleri.karakterZKusagi:
        mockMesaj = "Bro, bu vibe ne? Resmen 'skill issue' yaşıyorsun. Şaka mısın kanka? Çok cringe duruyor, acilen ratio yemen lazım.";
        break;
      case UygulamaMetinleri.karakterShakespeare:
        mockMesaj = "Ey talihsiz ruh! Bu ne rüküş bir endamdır ki görenin gözleri kan revan içinde kalır. Zarafetten nasibini almamış bedenin, bir sefalet abidesi misali arz-ı endam eyler.";
        break;
      case UygulamaMetinleri.karakterGordonRamsay:
        mockMesaj = "REAZALET! Sen kendine ne diyorsun?! Bu kıyafet seçimi resmen ÇİĞ! Git buradan ve bir daha geri gelme! DISASTER!";
        break;
      case UygulamaMetinleri.karakterBehzatC:
        mockMesaj = "Saçma sapan konuşma la! Adam gibi bir fotoğraf çekinmeyi de mi beceremedin? Hayalet bile senden daha düzgün dururdu şu karede. Yazıklar olsun.";
        break;
      case UygulamaMetinleri.karakterBurhanAltintop:
        mockMesaj = "Ay ben bayılazam şimdi şuracıkta! Senin bu vizyonsuzluğun, bu rüküşlüğün beni benden aldı şekerim. Sen git o Nişantaşı sokaklarında dolaşma, rezil rüsva olduk!";
        break;
      case UygulamaMetinleri.karakterBihterYoreoglu:
        mockMesaj = "Aptallık etme! Sen Bihter Ziyagil'in karşısına bu kılıkla mı çıkıyorsun? Nihal'in bile senden daha çok tarzı var. Zavallı, çok zavallı...";
        break;
      case UygulamaMetinleri.karakterRamizDayi:
        mockMesaj = "Yeğen... Sadakat güzel şeydir ama aynaya sadık kalmamışsın. Bu tip nedir? Sen seçtiğin yolu değil, seçemediğin kıyafetleri dert et kendine.";
        break;
      case UygulamaMetinleri.karakterDrHouse:
        mockMesaj = "Teşhisim belli: Akut estetik yoksunluğu ve kronik vizyonsuzluk. Maalesef tedavisi yok, sadece seni bu halde görmemek için gözlerimi kapatabilirim.";
        break;
      case UygulamaMetinleri.karakterMatmazel:
        mockMesaj = "Pardonnez-moi ama zarafet denilen şey sizin semtinize hiç uğramamış sanırım. Adab-ı muaşeret kuralları gereği bu fotoğrafı acilen yok etmelisiniz.";
        break;
      case UygulamaMetinleri.karakterDanlaBilic:
        mockMesaj = "Aşkım sen ne giydin? Şaka mısın? Yılanlığım tuttu yine, resmen skill issue yaşıyorsun. O saçlar, o kıyafet... Bu halinle ancak bloklanırsın tatlım.";
        break;
      case UygulamaMetinleri.karakterMuratOvuc:
        mockMesaj = "SENİ GİDİ FIRFIR! Bu ne hal?! Yanıyorsun Fuat Abi! Dalgana bak evladım, bu tiple sokağa mı çıkılır? Rezil rüsva olduk cümle aleme!";
        break;
      case UygulamaMetinleri.karakterKerimcanDurmaz:
        mockMesaj = "Ablan kurban olsun sana, olayyy! Ama bu rüküşlük şaka mı? Vıck vıck bir tarzın var, hiç beğenmedim şekerim. Sen git o vizyonunu bir tazele gel.";
        break;
      default:
        mockMesaj = "AI seni analiz etti ve sonucunda sadece 'üzücü' yazdı. Kendine gel.";
    }

    // Kelime kelime akışı simüle et
    final kelimeler = mockMesaj.split(' ');
    String birikmis = "";
    for (var i = 0; i < kelimeler.length; i++) {
        birikmis += (i == 0 ? "" : " ") + kelimeler[i];
        yield birikmis;
        await Future.delayed(const Duration(milliseconds: 100));
    }
  }


  @override
  Future<SavasModel> savasUret({
    required File fotograf1,
    required File fotograf2,
    required String karakter,
    String? ozelPrompt,
  }) async {
    await Future.delayed(const Duration(seconds: 4));
    return SavasModel(
      id: "sahte_savas_${DateTime.now().millisecondsSinceEpoch}",
      birinciRoast: "Birinci kişi resmen 1980'lerden kalma bir moda katliamı gibi duruyor. O gömleğin deseni ne öyle?",
      ikinciRoast: "İkinci kişi ise sanki yatağından yeni kalkmış da üstüne ne bulduysa geçirmiş gibi. Saçlar desen ayrı telden çalıyor.",
      kazananIndeksi: 1,
      kazanmaNedeni: "Birinci yarışmacının gömlek deseni, estetik kurallarını değil fizik kurallarını bile zorluyor. Bu vizyonsuzluk karşısında şapka çıkartıyorum.",
      puanlar: {
        "STİL": [85, 40],
        "AURA": [65, 35],
        "VİBE": [90, 20]
      },
      karakter: karakter,
      tarih: DateTime.now(),
    );
  }
}
