import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import '../veri/vitrin_gonderisi_model.dart';
import '../../roast/veri/savas_model.dart';
import '../../roast/veri/roast_model.dart';

abstract class VitrinServisArayuzu {
  Future<void> paylasSavas({
    required SavasModel savas,
    required File fotograf1,
    required File fotograf2,
    required String paylasanAdi,
    Function(String)? onAsamaDegisti,
  });

  Future<void> paylasTekli({
    required RoastModel roast,
    required File fotograf,
    required String paylasanAdi,
    Function(String)? onAsamaDegisti,
  });

  Future<(List<VitrinGonderisiModel>, QueryDocumentSnapshot?)> akisiGetir({
    QueryDocumentSnapshot? sonBelge,
    int limit = 10,
  });

  Future<void> tepkiVer(String shareId, String tepkiTipi);
}

class VitrinServisi implements VitrinServisArayuzu {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const String _collectionPath = 'vitrin';
  static const String _storagePath = 'vitrin_medya';
  static DateTime? _sonTaniCalisma;
  static const Duration _taniCooldown = Duration(minutes: 5);

  Future<String> _taniYurut() async {
    final sonuclar = <String>[];
    try {
      final lookup = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 3));
      if (lookup.isNotEmpty) sonuclar.add('✅ DNS Çözümleme: OK');
    } catch (e) {
      sonuclar.add('❌ DNS Hatası: İnternet bulunamadı.');
      return sonuclar.join('\n');
    }

    try {
      await http.head(Uri.parse('https://firestore.googleapis.com')).timeout(const Duration(seconds: 4));
      sonuclar.add('✅ Firebase Firestore Erişimi: OK');
      await http.head(Uri.parse('https://firebasestorage.googleapis.com')).timeout(const Duration(seconds: 4));
      sonuclar.add('✅ Firebase Storage Erişimi: OK');
    } catch (e) {
      sonuclar.add('❌ Firebase SSL/Erişim Hatası: ${e.toString()}');
    }

    return '\n\nVITRİN TANI RAPORU:\n${sonuclar.join('\n')}';
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

  Future<File> _gorselSikistir(File dosya, {int kalite = 70, int genislik = 1024}) async {
    final tempDir = await getTemporaryDirectory();
    final hedefPath = p.join(
      tempDir.path, 
      'comp_${kalite}_${DateTime.now().millisecondsSinceEpoch}${p.extension(dosya.path)}'
    );

    final xFile = await FlutterImageCompress.compressAndGetFile(
      dosya.absolute.path,
      hedefPath,
      quality: kalite,
      minWidth: genislik,
      minHeight: genislik,
    );

    if (xFile == null) return dosya;
    return File(xFile.path);
  }

  Future<void> paylasSavas({
    required SavasModel savas,
    required File fotograf1,
    required File fotograf2,
    required String paylasanAdi,
    Function(String)? onAsamaDegisti,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Kullanıcı girişi yapılmamış.');

    try {
      final String shareId = DateTime.now().millisecondsSinceEpoch.toString();

      onAsamaDegisti?.call('Görseller optimize ediliyor...');
      final s1 = await _gorselSikistir(fotograf1);
      final s2 = await _gorselSikistir(fotograf2);
      final t1 = await _gorselSikistir(fotograf1, kalite: 40, genislik: 250);
      final t2 = await _gorselSikistir(fotograf2, kalite: 40, genislik: 250);

      onAsamaDegisti?.call('Görseller yükleniyor...');
      final f1Url = await _dosyaYukle(s1, user.uid, shareId, 'foto1.jpg');
      final f2Url = await _dosyaYukle(s2, user.uid, shareId, 'foto2.jpg');
      final t1Url = await _dosyaYukle(t1, user.uid, shareId, 'thumb1.jpg');
      final t2Url = await _dosyaYukle(t2, user.uid, shareId, 'thumb2.jpg');

      onAsamaDegisti?.call('Kaydediliyor...');
      final gonderi = VitrinGonderisiModel(
        id: shareId,
        tip: VitrinGonderiTipi.savas,
        savas: savas,
        fotograf1Url: f1Url,
        fotograf2Url: f2Url,
        thumbnail1Url: t1Url,
        thumbnail2Url: t2Url,
        paylasanId: user.uid,
        paylasanAdi: paylasanAdi,
        tepkiler: const {'rip': 0, 'boom': 0, 'fire': 0},
        tarih: DateTime.now(),
      );

      await _firestore.collection(_collectionPath).doc(shareId).set(gonderi.toJson())
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      if (e is TimeoutException) {
        throw Exception('İşlem zaman aşımına uğradı. İnternet bağlantınız çok yavaş olabilir.');
      }
      final rapor = await _hataIcinTaniRaporu();
      throw Exception('Vitrin Paylaşım Hatası: ${e.toString()}$rapor');
    }
  }

  Future<void> paylasTekli({
    required RoastModel roast,
    required File fotograf,
    required String paylasanAdi,
    Function(String)? onAsamaDegisti,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('Kullanıcı girişi yapılmamış.');

    try {
      final String shareId = DateTime.now().millisecondsSinceEpoch.toString();

      onAsamaDegisti?.call('Görsel optimize ediliyor...');
      final s1 = await _gorselSikistir(fotograf);
      final t1 = await _gorselSikistir(fotograf, kalite: 40, genislik: 250);

      onAsamaDegisti?.call('Görseller yükleniyor...');
      final fotoUrl = await _dosyaYukle(s1, user.uid, shareId, 'foto.jpg');
      final thumbUrl = await _dosyaYukle(t1, user.uid, shareId, 'thumb.jpg');

      onAsamaDegisti?.call('Kaydediliyor...');
      final gonderi = VitrinGonderisiModel(
        id: shareId,
        tip: VitrinGonderiTipi.tekli,
        tekliRoast: roast,
        fotograf1Url: fotoUrl,
        thumbnail1Url: thumbUrl,
        paylasanId: user.uid,
        paylasanAdi: paylasanAdi,
        tepkiler: const {'rip': 0, 'boom': 0, 'fire': 0},
        tarih: DateTime.now(),
      );

      await _firestore.collection(_collectionPath).doc(shareId).set(gonderi.toJson())
          .timeout(const Duration(seconds: 30));
    } catch (e) {
      if (e is TimeoutException) {
        throw Exception('İşlem zaman aşımına uğradı. İnternet bağlantınız çok yavaş olabilir.');
      }
      final rapor = await _hataIcinTaniRaporu();
      throw Exception('Vitrin Paylaşım Hatası: ${e.toString()}$rapor');
    }
  }

  Future<(List<VitrinGonderisiModel>, QueryDocumentSnapshot?)> akisiGetir({
    QueryDocumentSnapshot? sonBelge,
    int limit = 10,
  }) async {
    final box = Hive.box('vitrin_cache');
    
    try {
      var query = _firestore
          .collection(_collectionPath)
          .orderBy('tarih', descending: true)
          .limit(limit);

      if (sonBelge != null) {
        query = query.startAfterDocument(sonBelge);
      }

      final snapshot = await query.get().timeout(const Duration(seconds: 8));

      final gonderiler = snapshot.docs
          .map((doc) => VitrinGonderisiModel.fromJson(doc.data()))
          .toList();

      final yeniSonBelge = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;

      // Sadece ilk sayfayı önbelleğe al (performans ve tutarlılık için)
      if (sonBelge == null) {
        await box.put('son_akis', gonderiler.map((e) => e.toJson()).toList());
      }
      
      return (gonderiler, yeniSonBelge);
    } catch (e) {
      // Çevrimdışıysak veya hata aldıysak ve ilk sayfadaysak önbellekten dön
      if (sonBelge == null) {
        final cached = box.get('son_akis') as List?;
        if (cached != null) {
          final gonderiler = cached.map((e) => VitrinGonderisiModel.fromJson(Map<String, dynamic>.from(e))).toList();
          return (gonderiler, null);
        }
      }
      return (<VitrinGonderisiModel>[], null);
    }
  }

  Future<void> tepkiVer(String shareId, String tepkiTipi) async {
    await _firestore.collection(_collectionPath).doc(shareId).update({
      'tepkiler.$tepkiTipi': FieldValue.increment(1),
    });
  }

  Future<String> _dosyaYukle(
    File dosya,
    String userId,
    String shareId,
    String fileName,
  ) async {
    final ref = _storage.ref().child('$_storagePath/$userId/$shareId/$fileName');
    final uploadTask = await ref.putFile(
      dosya,
      SettableMetadata(contentType: 'image/jpeg'),
    ).timeout(const Duration(seconds: 60));
    return await uploadTask.ref.getDownloadURL();
  }
}
