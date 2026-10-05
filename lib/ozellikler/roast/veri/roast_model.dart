import 'package:equatable/equatable.dart';

class RoastModel extends Equatable {
  final String id;
  final String metin;
  final String karakter;
  final String mod;
  final DateTime tarih;

  const RoastModel({
    required this.id,
    required this.metin,
    required this.karakter,
    required this.mod,
    required this.tarih,
  });

  @override
  List<Object?> get props => [id, metin, karakter, mod, tarih];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'metin': metin,
      'karakter': karakter,
      'mod': mod,
      'tarih': tarih.toIso8601String(),
    };
  }

  factory RoastModel.fromJson(Map<String, dynamic> json) {
    return RoastModel(
      id: json['id'],
      metin: json['metin'],
      karakter: json['karakter'],
      mod: json['mod'],
      tarih: DateTime.parse(json['tarih']),
    );
  }
}
