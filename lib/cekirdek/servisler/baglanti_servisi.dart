import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class BaglantiServisi {
  Future<bool> get internetVarMi;
  Stream<bool> get baglantiDegisimYayini;
}

class ConnectivityBaglantiServisi implements BaglantiServisi {
  final Connectivity _connectivity = Connectivity();

  @override
  Future<bool> get internetVarMi async {
    final result = await _connectivity.checkConnectivity();
    return !result.contains(ConnectivityResult.none);
  }

  @override
  Stream<bool> get baglantiDegisimYayini {
    return _connectivity.onConnectivityChanged.map((results) {
      return !results.contains(ConnectivityResult.none);
    });
  }
}
