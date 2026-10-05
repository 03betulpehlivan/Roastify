import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../sabitler/renkler.dart';

class YuklemeIskeleti extends StatelessWidget {
  final double genislik;
  final double yukseklik;
  final double kenarYaricap;

  const YuklemeIskeleti({
    super.key,
    required this.genislik,
    required this.yukseklik,
    this.kenarYaricap = 16,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: UygulamaRenkleri.yuzeyAcik,
      highlightColor: UygulamaRenkleri.koyuGri,
      child: Container(
        width: genislik,
        height: yukseklik,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(kenarYaricap),
        ),
      ),
    );
  }
}
