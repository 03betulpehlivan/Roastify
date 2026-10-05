import 'dart:io';
import '../veri/savas_model.dart';

abstract class RoastServisi {
  Stream<String> roastUret({
    required File fotograf,
    required String karakter,
    required String mod,
    String? ozelPrompt,
    String? kisiYakinligi,
    String? sinirBozucuOzellik,
    String? sir,
  });

  Future<SavasModel> savasUret({
    required File fotograf1,
    required File fotograf2,
    required String karakter,
    String? ozelPrompt,
  });
}
