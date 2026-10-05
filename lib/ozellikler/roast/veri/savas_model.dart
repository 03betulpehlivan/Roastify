import 'package:equatable/equatable.dart';

class SavasModel extends Equatable {
  final String id;
  final String birinciRoast;
  final String ikinciRoast;
  final int kazananIndeksi; // 1 veya 2
  final String kazanmaNedeni; // AI Hakem Kararı Gerekçesi
  final Map<String, List<int>> puanlar; // {"Stil": [85, 40], "Aura": [70, 30]}
  final String karakter;
  final DateTime tarih;

  const SavasModel({
    required this.id,
    required this.birinciRoast,
    required this.ikinciRoast,
    required this.kazananIndeksi,
    required this.kazanmaNedeni,
    required this.puanlar,
    required this.karakter,
    required this.tarih,
  });

  @override
  List<Object?> get props => [id, birinciRoast, ikinciRoast, kazananIndeksi, kazanmaNedeni, puanlar, karakter, tarih];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'birinciRoast': birinciRoast,
      'ikinciRoast': ikinciRoast,
      'kazananIndeksi': kazananIndeksi,
      'kazanmaNedeni': kazanmaNedeni,
      'puanlar': puanlar,
      'karakter': karakter,
      'tarih': tarih.toIso8601String(),
    };
  }

  factory SavasModel.fromJson(Map<String, dynamic> json) {
    return SavasModel(
      id: json['id'],
      birinciRoast: json['birinciRoast'],
      ikinciRoast: json['ikinciRoast'],
      kazananIndeksi: json['kazananIndeksi'],
      kazanmaNedeni: json['kazanmaNedeni'] ?? "Daha rüküş olduğu için kazandı.",
      puanlar: (json['puanlar'] as Map<String, dynamic>?)?.map(
            (k, v) => MapEntry(k, (v as List).map((i) => i as int).toList()),
          ) ??
          {
            "STİL": [70, 50],
            "AURA": [60, 40],
            "VİBE": [80, 20]
          },
      karakter: json['karakter'],
      tarih: DateTime.parse(json['tarih']),
    );
  }
}
