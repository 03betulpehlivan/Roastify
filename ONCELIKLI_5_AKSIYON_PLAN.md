# Oncelikli 5 Aksiyon Plani

- [x] 1) Secret temizligi: `dart_defines.env` repodan kaldirildi, `dart_defines.env.example` eklendi.
- [x] 2) Gemini cagrisini tamamen backend proxy uzerinden gecir (istemcide `GEMINI_API_KEY` kaldirildi).
- [x] 3) Backend auth + CORS allowlist + payload validation sertlestirmesi.
- [x] 4) Sunucu tarafi rate limiting (uid bazli, dakika penceresi) eklendi.
- [x] 5) CI pipeline'a `functions` lint/test/audit adimlari eklendi.

## Not

- [ ] Gercek anahtar rotasyonu manuel adimdir: Firebase Secret Manager'da `GEMINI_API_KEY` yeniden olusturulmali.

## Kritik Eksikler Uygulama Plani (Yuksek Oncelik)


- [x] 1) Firestore ve Storage security rules dosyalarini ekle, en az yetki prensibiyle sikilastir.
- [x] 2) Firebase App Check'i istemci tarafinda aktif et ve backend'de dogrulamayi zorunlu yap.
- [x] 3) In-memory rate limit yerine merkezi/persisted rate limit yapisina gec (Firestore tabanli).
- [x] 4) `roastKaydet` cagrisini sadece islem basarili olduktan sonra business katmaninda tetikle.
- [x] 5) Gemini yanit parse akisini kirilgan olmaktan cikar (guvenli JSON ayristirma + fallback).

## Siradaki Adim

- [x] Aktif: Tum kritik adimlar tamamlandi


## UI/UX Kritik Eksikler Uygulama Plani (Yuksek Oncelik)

- [ ] 1) Erişilebilirlik (a11y) geçişi: kritik buton, kart, dialog ve durum bileşenlerine `Semantics` etiketleri, anlamlı label/hint ve ekran okuyucu uyumu ekle.
- [ ] 2) Kontrast ve okunabilirlik standardizasyonu: dusuk opaklikli metinleri iyilestir, koyu/aydinlik tema metin-kontrast oranlarini kritik ekranlarda gözden geçir.
- [ ] 3) `ana_sayfa.dart` parcala: büyük ekrani daha bakimi kolay widget dosyalarina ayir (header, karakter secimi, mod kartlari, loading panel).
- [ ] 4) Lokalizasyon tamamlama: hardcoded metinleri `l10n` altina tasi ve TR/EN tutarliligini tum ana akislarda standartlastir.
- [ ] 5) Performans odakli animasyon profili: dusuk cihazlarda jank riskini azaltmak icin hafif animasyon modu ve gerektiğinde fallback davranislari ekle.

## Genel Oncelikli 5 Eksik (Tek Liste)

- [ ] 1) Guvenlik rules sertlestirme: Firestore update validasyonlarini sikilastir, Storage path-yetki baglantisini kullanici sahipligi ile netlestir.
- [x] 1.1) Firestore reaction update kurali sertlestirildi (yalnizca tek tip +1 artis ve diger alanlarin degismemesi).
- [x] 1.2) Storage path modeli `vitrin_medya/{userId}/{shareId}/{file}` olarak guvenli hale getirildi; yalnizca owner uid yazabilir.
- [x] 1.3) Istemci yukleme path'i yeni guvenli modele tasindi (`VitrinServisi`).
- [x] 1.4) Emulator tabanli rules testleri eklendi (`functions/rules.test.js`) ve CI'da Java 21 ile zorunlu kosacak sekilde baglandi.
- [ ] 2) Test kapsam derinligi: kritik akislar icin `integration_test` ve temel e2e senaryolari ekle.
- [x] 2.1) Baslangic adimi tamamlandi: `integration_test/onboarding_flow_test.dart` ile onboarding smoke testi eklendi ve calistirildi.
- [x] 2.2) Onboarding son sayfa smoke testi eklendi (`ZAFERE ULASIN` + `BASLAYALIM`) ve basariyla calistirildi.
- [x] 2.3) Alt navigasyon smoke testi eklendi (`integration_test/navigation_smoke_test.dart`) ve basariyla calistirildi.
- [x] 2.4) Vitrin akisina iki yeni test eklendi (`test/vitrin_cubiti_test.dart`): bos akis basarili durumu ve servis hatasinda hata durumu.
- [ ] 3) Ana ekran teknik borcu: `ana_sayfa.dart` dosyasini sorumluluklara gore parcalayip okunabilirligi ve testlenebilirligi artir.
- [ ] 4) UI kalite standardi: erisilebilirlik (`Semantics`), kontrast ve lokalizasyon (hardcoded metinlerin `l10n`'a tasinmasi) eksiklerini kapat.
- [x] 4.1) Erişilebilirlik başlangıcı tamamlandı: onboarding, ana navigasyon ve vitrin hata/yenile etkileşimlerine `Semantics`/`tooltip` etiketleri eklendi.
- [x] 4.2) Lokalizasyon başlangıcı tamamlandı: onboarding ve vitrin ekranındaki kritik hardcoded metinler `l10n` anahtarlarına taşındı (TR/EN).
- [x] 4.3) Ana ekran lokalizasyon adımı tamamlandı: `ana_sayfa.dart` içindeki kritik dialog/aksiyon metinleri ve simülasyon-sayaç etiketleri `l10n` anahtarlarına taşındı.
- [x] 4.4) Sonuç ekranları lokalizasyon adımı tamamlandı: `sonuc_sayfasi.dart` ve `savas_sonuc_sayfasi.dart` içindeki paylaşım/vitrin dialog ve ana aksiyon metinleri `l10n` anahtarlarına taşındı.
- [x] 4.5) Kalan kritik ekranlar lokalize edildi: `gecmis_sayfasi.dart`, `savas_hazirlik_sayfasi.dart` ve `ayarlar_sayfasi.dart` üzerindeki temel hardcoded metinler `l10n` anahtarlarına taşındı.
- [ ] 5) Repo hijyeni otomasyonu: artefaktlarin repoya sızmaması icin ignore kurallarini genislet, temiz repo kontrolunu CI adimiyla zorunlu hale getir.
