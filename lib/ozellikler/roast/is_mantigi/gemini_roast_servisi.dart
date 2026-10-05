import 'dart:io';
import 'dart:convert';
import 'dart:async';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'roast_servisi.dart';
import '../../../cekirdek/sabitler/metinler.dart';
import '../veri/savas_model.dart';

class GeminiRoastServisi implements RoastServisi {
  static const String _proxyBaseUrl = String.fromEnvironment('ROAST_PROXY_BASE_URL');
  static DateTime? _sonTaniCalisma;
  static const Duration _taniCooldown = Duration(minutes: 5);

  Uri get _proxyUri {
    if (_proxyBaseUrl.isEmpty) {
      throw Exception('Proxy URL ayarlanmamis. ROAST_PROXY_BASE_URL gerekli.');
    }
    return Uri.parse('$_proxyBaseUrl/generateContent');
  }

  Future<String> _taniYurut() async {
    final sonuclar = <String>[];
    
    // 1. DNS Kontrolü
    try {
      final lookup = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 3));
      if (lookup.isNotEmpty && lookup[0].rawAddress.isNotEmpty) {
        sonuclar.add('✅ DNS Çözümleme: OK');
      }
    } catch (e) {
      sonuclar.add('❌ DNS Hatası: İnternet erişimi yok veya DNS engelleniyor.');
      return sonuclar.join('\n');
    }

    // 2. SSL/HTTPS Kontrolü
    try {
      await http.head(Uri.parse('https://firebase.google.com')).timeout(const Duration(seconds: 4));
      sonuclar.add('✅ SSL/Firebase: OK');
    } catch (e) {
      if (e is HandshakeException || e.toString().contains('SSL') || e.toString().contains('handshake')) {
        sonuclar.add('❌ SSL Hatası: Handshake başarısız. Cihaz saati veya sertifika sorunu.');
      } else {
        sonuclar.add('❌ Bağlantı Hatası: ${e.toString().split(':').last.trim()}');
      }
    }

    // 3. Proxy Kontrolü
    try {
      final res = await http.head(Uri.parse(_proxyBaseUrl)).timeout(const Duration(seconds: 4));
      sonuclar.add('✅ Proxy: OK (${res.statusCode})');
    } catch (e) {
      sonuclar.add('❌ Proxy Hatası: Sunucuya ulaşılamıyor veya bağlantı resetlendi.');
    }

    return '\n\nAĞ TANI RAPORU:\n${sonuclar.join('\n')}';
  }

  Future<String> _hataIcinTaniRaporu() async {
    if (!kDebugMode) {
      return '';
    }
    final simdi = DateTime.now();
    if (_sonTaniCalisma != null && simdi.difference(_sonTaniCalisma!) < _taniCooldown) {
      return '';
    }
    _sonTaniCalisma = simdi;
    return _taniYurut();
  }

  Future<Uint8List> _optimizeImageBytes(
    File fotograf, {
    required int hedefMaksBytes,
  }) async {
    final orijinal = await fotograf.readAsBytes();
    if (orijinal.length <= hedefMaksBytes) {
      return orijinal;
    }

    final kaliteListesi = [70, 60, 50, 40, 32];
    final boyutListesi = [768, 640, 512, 384];
    Uint8List? enIyiAday;

    for (final boyut in boyutListesi) {
      for (final kalite in kaliteListesi) {
        final sikistirilmis = await FlutterImageCompress.compressWithFile(
          fotograf.path,
          format: CompressFormat.jpeg,
          quality: kalite,
          minWidth: boyut,
          minHeight: boyut,
        );
        if (sikistirilmis == null || sikistirilmis.isEmpty) {
          continue;
        }
        final aday = Uint8List.fromList(sikistirilmis);
        enIyiAday = aday;
        if (aday.length <= hedefMaksBytes) {
          return aday;
        }
      }
    }

    return enIyiAday ?? orijinal;
  }

  Future<String> _tokenAlDayanikli() async {
    Future<String> tekDeneme() async {
      var user = FirebaseAuth.instance.currentUser;
      user ??= (await FirebaseAuth.instance.signInAnonymously()).user;
      if (user == null) {
        throw Exception('Kullanici oturumu bulunamadi. Lutfen tekrar deneyin.');
      }

      final cachedToken = await user.getIdToken(false);
      if (cachedToken != null && cachedToken.isNotEmpty) {
        return cachedToken;
      }

      final refreshedToken = await user.getIdToken(true);
      if (refreshedToken == null || refreshedToken.isEmpty) {
        throw Exception('Kimlik dogrulama tokeni alinamadi.');
      }
      return refreshedToken;
    }

    try {
      return await tekDeneme();
    } catch (e) {
      if (e.toString().contains('network-request-failed')) {
        final rapor = await _taniYurut();
        throw Exception('Firebase Ag Hatasi: $e$rapor');
      }
      
      // Gecici ag kopmalarinda kisa bir backoff ile tek sefer daha dene.
      await Future.delayed(const Duration(milliseconds: 700));
      await FirebaseAuth.instance.signOut();
      return tekDeneme();
    }
  }

  Future<Map<String, String>> _headers() async {
    final idToken = await _tokenAlDayanikli();
    final appCheckToken = await FirebaseAppCheck.instance.getToken();
    if (appCheckToken == null || appCheckToken.isEmpty) {
      throw Exception('App Check tokeni alinamadi. Lutfen tekrar deneyin.');
    }
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $idToken',
      'X-Firebase-AppCheck': appCheckToken,
    };
  }

  Map<String, dynamic> _parseBattleResponse(String rawText) {
    if (rawText.trim().isEmpty) {
      throw const FormatException('Bos yanit');
    }

    try {
      final decoded = jsonDecode(rawText);
      if (decoded is Map<String, dynamic>) {
        return decoded;
      }
    } catch (_) {
      // Bir sonraki adimda fenced/icerik JSON ayiklama denenir.
    }

    final fencedMatch = RegExp(r'```(?:json)?\s*([\s\S]*?)\s*```', caseSensitive: false).firstMatch(rawText);
    if (fencedMatch != null) {
      final fencedContent = fencedMatch.group(1)?.trim() ?? '';
      if (fencedContent.isNotEmpty) {
        try {
          final decoded = jsonDecode(fencedContent);
          if (decoded is Map<String, dynamic>) {
            return decoded;
          }
        } catch (_) {
          // Bir sonraki fallback denenecek.
        }
      }
    }

    final jsonStart = rawText.indexOf('{');
    final jsonEnd = rawText.lastIndexOf('}');
    if (jsonStart < 0 || jsonEnd < 0 || jsonEnd <= jsonStart) {
      throw const FormatException('JSON govdesi bulunamadi');
    }

    final candidate = rawText.substring(jsonStart, jsonEnd + 1);
    final decoded = jsonDecode(candidate);
    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    throw const FormatException('JSON map formatinda degil');
  }

  int _parseWinnerIndex(dynamic winnerValue) {
    if (winnerValue is int && (winnerValue == 1 || winnerValue == 2)) {
      return winnerValue;
    }
    if (winnerValue is String) {
      final parsed = int.tryParse(winnerValue.trim());
      if (parsed != null && (parsed == 1 || parsed == 2)) {
        return parsed;
      }
    }
    return 1;
  }

  Map<String, List<int>> _parseScores(dynamic scores) {
    if (scores is! Map) {
      return const {
        'STIL': [5, 5],
        'AURA': [5, 5],
        'VIBE': [5, 5],
      };
    }

    final parsed = <String, List<int>>{};
    for (final entry in scores.entries) {
      final key = entry.key?.toString() ?? '';
      final value = entry.value;
      if (key.isEmpty || value is! List || value.length < 2) {
        continue;
      }

      final first = value[0];
      final second = value[1];
      final left = first is int ? first : int.tryParse(first.toString());
      final right = second is int ? second : int.tryParse(second.toString());
      if (left == null || right == null) {
        continue;
      }
      parsed[key] = [left, right];
    }

    if (parsed.isEmpty) {
      return const {
        'STIL': [5, 5],
        'AURA': [5, 5],
        'VIBE': [5, 5],
      };
    }

    return parsed;
  }

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
    try {
      final bytes = await _optimizeImageBytes(fotograf, hedefMaksBytes: 90000);
      final isOvgu = mod == UygulamaMetinleri.modOvgulu;

      final promptText = _promptOlustur(
        isOvgu: isOvgu,
        karakter: karakter,
        ozelPrompt: ozelPrompt,
        kisiYakinligi: kisiYakinligi,
        sinirBozucuOzellik: sinirBozucuOzellik,
        sir: sir,
      );

      final payload = {
        'contents': [
          {
            'parts': [
              {'text': promptText},
              {'inline_data': {'mime_type': 'image/jpeg', 'data': base64Encode(bytes)}},
            ],
          },
        ],
      };

      final response = await http.post(
        _proxyUri,
        headers: await _headers(),
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw Exception(data['error']?.toString() ?? 'API hatasi');
      }

      final candidates = data['candidates'] as List<dynamic>? ?? const [];
      final first = candidates.isNotEmpty ? candidates.first as Map<String, dynamic> : const {};
      final content = first['content'] as Map<String, dynamic>? ?? const {};
      final parts = content['parts'] as List<dynamic>? ?? const [];
      final fullText = parts
          .map((part) => (part as Map<String, dynamic>)['text']?.toString() ?? '')
          .join('')
          .trim();
      if (fullText.isEmpty) {
        throw Exception('Yapay zeka herhangi bir cevap uretmedi. Lutfen farkli bir fotograf deneyin.');
      }

      yield fullText;
    } catch (e) {
      final rapor = await _hataIcinTaniRaporu();
      throw Exception('Gemini Hatasi: ${e.toString()}$rapor');
    }
  }

  @override
  Future<SavasModel> savasUret({
    required File fotograf1,
    required File fotograf2,
    required String karakter,
    String? ozelPrompt,
  }) async {
    try {
      final bytes1 = await _optimizeImageBytes(fotograf1, hedefMaksBytes: 65000);
      final bytes2 = await _optimizeImageBytes(fotograf2, hedefMaksBytes: 65000);

      final promptText = """
      Sen dünyanın en gözlemci ve iğneleyici 'roast master'ısın.
      Rolün: ${karakter == UygulamaMetinleri.karakterOzel ? ozelPrompt : karakter}.
      Direktif: ${karakter == UygulamaMetinleri.karakterOzel ? ozelPrompt : UygulamaMetinleri.karakterPrompt(karakter)}
      
      İki kurbanı incele:
      1. Fotoğraf 1'i roastla (roast1).
      2. Fotoğraf 2'yi roastla (roast2).
      3. Hangisi daha 'perişan' duruyorsa kazanan o (winner: 1 veya 2).
      4. Nedenini açıkla (winner_reason).
      5. Puan ver (STİL, AURA, VİBE).
      
      ÖNEMLİ: Roast metinleri (roast1 ve roast2) çok uzun olmasın. Her biri en fazla 2 kısa paragraf veya 5-6 vurucu cümle olsun. Gereksiz laf kalabalığından kaçın, direkt sadede gel ama karakterin ruhunu yansıt.

      SADECE bu JSON formatında dön:
      {
        "roast1": "...",
        "roast2": "...",
        "winner": 1,
        "winner_reason": "...",
        "scores": {
          "STİL": [skor1, skor2],
          "AURA": [skor1, skor2],
          "VİBE": [skor1, skor2]
        }
      }
      """;

      final payload = {
        'generationConfig': {'responseMimeType': 'application/json'},
        'contents': [
          {
            'parts': [
              {'text': promptText},
              {'inline_data': {'mime_type': 'image/jpeg', 'data': base64Encode(bytes1)}},
              {'inline_data': {'mime_type': 'image/jpeg', 'data': base64Encode(bytes2)}},
            ],
          },
        ],
      };
      final response = await http.post(
        _proxyUri,
        headers: await _headers(),
        body: jsonEncode(payload),
      );
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      if (response.statusCode >= 400) {
        throw Exception(data['error']?.toString() ?? 'API hatasi');
      }

      final candidates = data['candidates'] as List<dynamic>? ?? const [];
      final first = candidates.isNotEmpty ? candidates.first as Map<String, dynamic> : const {};
      final content = first['content'] as Map<String, dynamic>? ?? const {};
      final parts = content['parts'] as List<dynamic>? ?? const [];
      final rawText = parts
          .map((part) => (part as Map<String, dynamic>)['text']?.toString() ?? '')
          .join('')
          .trim();
      if (rawText.isEmpty) {
        throw Exception('API tarafindan veri uretilemedi.');
      }
      final parsed = _parseBattleResponse(rawText);
      final puanlar = _parseScores(parsed['scores']);

      return SavasModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        birinciRoast: parsed['roast1']?.toString() ?? '',
        ikinciRoast: parsed['roast2']?.toString() ?? '',
        kazananIndeksi: _parseWinnerIndex(parsed['winner']),
        kazanmaNedeni: parsed['winner_reason']?.toString() ?? '',
        puanlar: puanlar,
        karakter: karakter,
        tarih: DateTime.now(),
      );
    } catch (e) {
      final rapor = await _hataIcinTaniRaporu();
      throw Exception('Savas Modu Hatasi: ${e.toString()}$rapor');
    }
  }

  String _promptOlustur({
    required bool isOvgu,
    required String karakter,
    String? ozelPrompt,
    String? kisiYakinligi,
    String? sinirBozucuOzellik,
    String? sir,
  }) {
    final anaGorev = isOvgu ? "Pozitif motive edicisin." : "İğneleyici roast master'ısın.";
    return """
    $anaGorev Karakter: ${karakter == UygulamaMetinleri.karakterOzel ? ozelPrompt : karakter}.
    Detaylı Direktif: ${karakter == UygulamaMetinleri.karakterOzel ? ozelPrompt : UygulamaMetinleri.karakterPrompt(karakter)}
    Görseldeki kişiyi somut detaylarla ${isOvgu ? 'öv' : 'roastla'}.
    ${kisiYakinligi != null ? 'Ek bilgi (Metne mutlaka yedir): $kisiYakinligi, $sinirBozucuOzellik, $sir' : ''}
    
    KURALLAR:
    1. Sadece karakterin ağzından konuş.
    2. Metin en fazla 2 kısa paragraf veya 5-6 cümle olsun.
    3. Kullanıcının verdiği ek bilgileri (varsa) mutlaka metne doğal bir şekilde dahil et ama lafı uzatma.
    4. Çok uzun metinlerden kaçın, vurucu ve öz ol.
    """;
  }
}
