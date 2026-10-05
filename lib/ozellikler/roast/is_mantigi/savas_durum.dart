import 'dart:io';
import 'package:equatable/equatable.dart';
import '../veri/savas_model.dart';
import '../../../cekirdek/sabitler/tipler.dart';

abstract class SavasDurum extends Equatable {
  const SavasDurum();

  @override
  List<Object?> get props => [];
}

class SavasBaslangic extends SavasDurum {}

class SavasFotograflarGuncellendi extends SavasDurum {
  final File? fotograf1;
  final File? fotograf2;

  const SavasFotograflarGuncellendi(this.fotograf1, this.fotograf2);

  @override
  List<Object?> get props => [fotograf1, fotograf2];
}

class SavasYukleniyor extends SavasDurum {
  final RoastAsamasi asama;
  const SavasYukleniyor(this.asama);

  @override
  List<Object?> get props => [asama];
}

class SavasBasarili extends SavasDurum {
  final SavasModel savas;
  final File fotograf1;
  final File fotograf2;

  const SavasBasarili(this.savas, this.fotograf1, this.fotograf2);

  @override
  List<Object?> get props => [savas, fotograf1, fotograf2];
}

class SavasHata extends SavasDurum {
  final RoastHataTipi tip;
  final String? mesaj;
  const SavasHata(this.tip, {this.mesaj});

  @override
  List<Object?> get props => [tip, mesaj];
}

