import 'package:equatable/equatable.dart';
import '../veri/roast_model.dart';
import '../../../cekirdek/sabitler/tipler.dart';
import 'dart:io';

abstract class RoastDurum extends Equatable {
  const RoastDurum();

  @override
  List<Object?> get props => [];
}

class RoastBaslangic extends RoastDurum {}

class RoastYukleniyor extends RoastDurum {
  final RoastAsamasi asama;
  final String? kismiMetin;
  const RoastYukleniyor(this.asama, {this.kismiMetin});
  
  @override
  List<Object?> get props => [asama, kismiMetin];
}

class RoastFotografSecildi extends RoastDurum {
  final File fotograf;
  const RoastFotografSecildi(this.fotograf);
  
  @override
  List<Object?> get props => [fotograf];
}

class RoastBasarili extends RoastDurum {
  final RoastModel roast;
  final File fotograf;
  const RoastBasarili(this.roast, this.fotograf);
  
  @override
  List<Object?> get props => [roast, fotograf];
}

class RoastHata extends RoastDurum {
  final RoastHataTipi tip;
  final String? mesaj;
  const RoastHata(this.tip, {this.mesaj});
  
  @override
  List<Object?> get props => [tip, mesaj];
}

