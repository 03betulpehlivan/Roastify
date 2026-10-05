import 'package:equatable/equatable.dart';
import '../../roast/veri/savas_model.dart';
import '../../roast/veri/roast_model.dart';

enum VitrinGonderiTipi { savas, tekli }

class VitrinGonderisiModel extends Equatable {
  final String id;
  final VitrinGonderiTipi tip;
  final SavasModel? savas; // Savaş modu için
  final RoastModel? tekliRoast; // Tekli roast için
  final String fotograf1Url;
  final String? fotograf2Url; // Savaş modu için zorunlu
  final String thumbnail1Url; // Yeni: Küçük boyutlu resim
  final String? thumbnail2Url; // Yeni: Küçük boyutlu resim (Savaş modu için)
  final String paylasanId;
  final String paylasanAdi;
  final Map<String, int> tepkiler;
  final DateTime tarih;

  const VitrinGonderisiModel({
    required this.id,
    required this.tip,
    this.savas,
    this.tekliRoast,
    required this.fotograf1Url,
    this.fotograf2Url,
    required this.thumbnail1Url,
    this.thumbnail2Url,
    required this.paylasanId,
    required this.paylasanAdi,
    required this.tepkiler,
    required this.tarih,
  });

  @override
  List<Object?> get props => [
        id,
        tip,
        savas,
        tekliRoast,
        fotograf1Url,
        fotograf2Url,
        thumbnail1Url,
        thumbnail2Url,
        paylasanId,
        paylasanAdi,
        tepkiler,
        tarih,
      ];

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'tip': tip.name,
      'savas': savas?.toJson(),
      'tekliRoast': tekliRoast?.toJson(),
      'fotograf1Url': fotograf1Url,
      'fotograf2Url': fotograf2Url,
      'thumbnail1Url': thumbnail1Url,
      'thumbnail2Url': thumbnail2Url,
      'paylasanId': paylasanId,
      'paylasanAdi': paylasanAdi,
      'tepkiler': tepkiler,
      'tarih': tarih.toIso8601String(),
    };
  }

  factory VitrinGonderisiModel.fromJson(Map<String, dynamic> json) {
    return VitrinGonderisiModel(
      id: json['id'],
      tip: VitrinGonderiTipi.values.byName(json['tip'] ?? 'savas'),
      savas: json['savas'] != null ? SavasModel.fromJson(json['savas']) : null,
      tekliRoast: json['tekliRoast'] != null ? RoastModel.fromJson(json['tekliRoast']) : null,
      fotograf1Url: json['fotograf1Url'],
      fotograf2Url: json['fotograf2Url'],
      thumbnail1Url: json['thumbnail1Url'] ?? json['fotograf1Url'], // Fallback for old data
      thumbnail2Url: json['thumbnail2Url'] ?? json['fotograf2Url'],
      paylasanId: json['paylasanId'],
      paylasanAdi: json['paylasanAdi'],
      tepkiler: Map<String, int>.from(json['tepkiler'] ?? {}),
      tarih: DateTime.parse(json['tarih']),
    );
  }

  VitrinGonderisiModel copyWith({
    String? id,
    VitrinGonderiTipi? tip,
    SavasModel? savas,
    RoastModel? tekliRoast,
    String? fotograf1Url,
    String? fotograf2Url,
    String? paylasanId,
    String? paylasanAdi,
    Map<String, int>? tepkiler,
    DateTime? tarih,
  }) {
    return VitrinGonderisiModel(
      id: id ?? this.id,
      tip: tip ?? this.tip,
      savas: savas ?? this.savas,
      tekliRoast: tekliRoast ?? this.tekliRoast,
      fotograf1Url: fotograf1Url ?? this.fotograf1Url,
      fotograf2Url: fotograf2Url ?? this.fotograf2Url,
      thumbnail1Url: thumbnail1Url ?? this.thumbnail1Url,
      thumbnail2Url: thumbnail2Url ?? this.thumbnail2Url,
      paylasanId: paylasanId ?? this.paylasanId,
      paylasanAdi: paylasanAdi ?? this.paylasanAdi,
      tepkiler: tepkiler ?? this.tepkiler,
      tarih: tarih ?? this.tarih,
    );
  }
}
