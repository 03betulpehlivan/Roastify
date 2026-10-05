import 'package:equatable/equatable.dart';
import '../veri/vitrin_gonderisi_model.dart';

abstract class VitrinDurum extends Equatable {
  const VitrinDurum();

  @override
  List<Object?> get props => [];
}

class VitrinBaslangic extends VitrinDurum {}

class VitrinYukleniyor extends VitrinDurum {}

class VitrinPaylasiliyor extends VitrinDurum {
  final String mesaj;

  const VitrinPaylasiliyor({this.mesaj = 'Paylaşılıyor...'});

  @override
  List<Object?> get props => [mesaj];
}

class VitrinPaylasimBasarili extends VitrinDurum {}

class VitrinBasarili extends VitrinDurum {
  final List<VitrinGonderisiModel> akis;
  final bool dahaFazlaVar;
  final bool dahaFazlaYukleniyor;
  final Object? sonBelge; // QueryDocumentSnapshot tipinde ama abstract class'ta Object? tutuyoruz

  const VitrinBasarili(
    this.akis, {
    this.dahaFazlaVar = true,
    this.dahaFazlaYukleniyor = false,
    this.sonBelge,
  });

  VitrinBasarili copyWith({
    List<VitrinGonderisiModel>? akis,
    bool? dahaFazlaVar,
    bool? dahaFazlaYukleniyor,
    Object? sonBelge,
  }) {
    return VitrinBasarili(
      akis ?? this.akis,
      dahaFazlaVar: dahaFazlaVar ?? this.dahaFazlaVar,
      dahaFazlaYukleniyor: dahaFazlaYukleniyor ?? this.dahaFazlaYukleniyor,
      sonBelge: sonBelge ?? this.sonBelge,
    );
  }

  @override
  List<Object?> get props => [akis, dahaFazlaVar, dahaFazlaYukleniyor, sonBelge];
}

class VitrinHata extends VitrinDurum {
  final String mesaj;

  const VitrinHata(this.mesaj);

  @override
  List<Object?> get props => [mesaj];
}
