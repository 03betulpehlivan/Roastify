import 'package:flutter/material.dart';
import '../../../cekirdek/sabitler/renkler.dart';
import '../../../cekirdek/tasarim/tokenlar.dart';

class GizlilikPolitikasiSayfasi extends StatelessWidget {
  const GizlilikPolitikasiSayfasi({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UygulamaRenkleri.arkaPlan,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "GİZLİLİK POLİTİKASI",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, letterSpacing: 1.5),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Kapak Olsun - Gizlilik Politikası ve Kullanım Koşulları",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              "Son Güncelleme: ${DateTime.now().day}.${DateTime.now().month}.${DateTime.now().year}",
              style: const TextStyle(fontSize: 12, color: Colors.white54),
            ),
            const SizedBox(height: AppSpacing.xl),
            _Madde(
              baslik: "1. Veri Toplama ve Kullanımı",
              icerik: "Kapak Olsun uygulaması, size daha iyi bir deneyim sunmak için sadece gerekli olan verileri toplar. Yüklediğiniz fotoğraflar yalnızca anlık analiz amacıyla yapay zeka servisine (Gemini API vb.) iletilir ve sunucularımızda kalıcı olarak saklanmaz.",
            ),
            _Madde(
              baslik: "2. Yapay Zeka (AI) Etkileşimi",
              icerik: "Uygulama içerisindeki 'Kapak' ve 'Yücelt' metinleri tamamen yapay zeka tarafından üretilmektedir. Üretilen içeriklerin mizah, eğlence ve hiciv amaçlı olduğunu kabul edersiniz. Kapak Olsun, bu içeriklerin doğruluğu veya uygunluğu konusunda yasal sorumluluk kabul etmez.",
            ),
            _Madde(
              baslik: "3. Cihaz İçi Veriler",
              icerik: "Geçmişiniz, kullandığınız haklar ve uygulama içi tercihleriniz (Dil, Tema) sadece kendi cihazınızda (lokal olarak) saklanır. İstediğiniz zaman 'Verileri Sıfırla' seçeneği ile bu verileri cihazınızdan silebilirsiniz.",
            ),
            _Madde(
              baslik: "4. Simülasyon Modu",
              icerik: "Simülasyon modunda yapılan işlemler için dış servislere veri gönderilmez. Sadece uygulama içindeki varsayılan (sahte) verilerle çalışır.",
            ),
            _Madde(
              baslik: "5. Yaş Sınırı ve Sorumluluk",
              icerik: "Uygulama, hiciv ve eğlence amaçlıdır. Kullanıcıların üretilen içerikleri başka şahıslara karşı zorbalık, hakaret veya kötü niyetli eylemlerde kullanması yasaktır. 13 yaşından küçük kullanıcıların ebeveyn gözetiminde kullanması tavsiye edilir.",
            ),
            const SizedBox(height: AppSpacing.xl),
            const Text(
              "Bu uygulamayı kullanarak yukarıdaki şartları ve gizlilik politikasını kabul etmiş sayılırsınız.",
              style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white70),
            ),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}

class _Madde extends StatelessWidget {
  final String baslik;
  final String icerik;

  const _Madde({required this.baslik, required this.icerik});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            baslik,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: UygulamaRenkleri.vurguRenk),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            icerik,
            style: const TextStyle(fontSize: 14, color: Colors.white70, height: 1.5),
          ),
        ],
      ),
    );
  }
}
