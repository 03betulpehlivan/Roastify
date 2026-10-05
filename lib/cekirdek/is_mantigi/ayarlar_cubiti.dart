import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AyarlarState extends Equatable {
  final bool simulasyonModu;
  final bool karanlikTema;
  final bool bildirimAcik;
  final bool titresimAcik;
  final String dilSecimi;

  const AyarlarState({
    required this.simulasyonModu,
    required this.karanlikTema,
    required this.bildirimAcik,
    required this.titresimAcik,
    required this.dilSecimi,
  });

  @override
  List<Object?> get props => [simulasyonModu, karanlikTema, bildirimAcik, titresimAcik, dilSecimi];

  AyarlarState copyWith({
    bool? simulasyonModu,
    bool? karanlikTema,
    bool? bildirimAcik,
    bool? titresimAcik,
    String? dilSecimi,
  }) {
    return AyarlarState(
      simulasyonModu: simulasyonModu ?? this.simulasyonModu,
      karanlikTema: karanlikTema ?? this.karanlikTema,
      bildirimAcik: bildirimAcik ?? this.bildirimAcik,
      titresimAcik: titresimAcik ?? this.titresimAcik,
      dilSecimi: dilSecimi ?? this.dilSecimi,
    );
  }
}

class AyarlarCubiti extends Cubit<AyarlarState> {
  final SharedPreferences _prefs;
  static const String _simKey = 'simulasyon_modu';
  static const String _temaKey = 'karanlik_tema';
  static const String _bildirimKey = 'bildirim_acik';
  static const String _titresimKey = 'titresim_acik';
  static const String _dilKey = 'dil_secimi';

  AyarlarCubiti(this._prefs) : super(AyarlarState(
    simulasyonModu: _prefs.getBool(_simKey) ?? false,
    karanlikTema: _prefs.getBool(_temaKey) ?? true,
    bildirimAcik: _prefs.getBool(_bildirimKey) ?? true,
    titresimAcik: _prefs.getBool(_titresimKey) ?? true,
    dilSecimi: _prefs.getString(_dilKey) ?? 'tr',
  ));

  void simulasyonModuDegistir(bool deger) {
    _prefs.setBool(_simKey, deger);
    emit(state.copyWith(simulasyonModu: deger));
  }

  void temaDegistir(bool deger) {
    _prefs.setBool(_temaKey, deger);
    emit(state.copyWith(karanlikTema: deger));
  }

  void bildirimDegistir(bool deger) {
    _prefs.setBool(_bildirimKey, deger);
    emit(state.copyWith(bildirimAcik: deger));
  }

  void titresimDegistir(bool deger) {
    _prefs.setBool(_titresimKey, deger);
    emit(state.copyWith(titresimAcik: deger));
  }

  void dilDegistir(String deger) {
    _prefs.setString(_dilKey, deger);
    emit(state.copyWith(dilSecimi: deger));
  }
}
