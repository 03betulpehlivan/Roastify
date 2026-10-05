import 'package:flutter/foundation.dart';

import 'istatistik_servisi.dart';

class OlayIzlemeServisi {
  OlayIzlemeServisi(this._istatistikServisi);

  final IstatistikServisi _istatistikServisi;

  Future<void> olayGonder(String ad, {Map<String, Object?> ekVeri = const {}}) async {
    debugPrint('[event] $ad $ekVeri');
    await _istatistikServisi.olaySayaciniArtir(ad);
  }
}
