import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

abstract class KimlikDogrulamaServisi {
  Future<User?> anonimGirisYap();
  User? get gecerliKullanici;
  Future<void> cikisYap();
}

class FirebaseKimlikDogrulamaServisi implements KimlikDogrulamaServisi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<User?> anonimGirisYap() async {
    try {
      final UserCredential userCredential = await _firebaseAuth.signInAnonymously();
      return userCredential.user;
    } catch (e) {
      debugPrint('Anonim giris hatasi: $e');
      return null;
    }
  }

  @override
  User? get gecerliKullanici => _firebaseAuth.currentUser;

  @override
  Future<void> cikisYap() async {
    await _firebaseAuth.signOut();
  }
}
