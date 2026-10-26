// ============================================================
// widgets/price_label.dart
// Widget untuk memformat angka harga ke format mata uang Rupiah
// ============================================================

import 'package:flutter/material.dart';

class PriceLabel extends StatelessWidget {
  final double harga;
  final double fontSize;
  final Color? color;
  final FontWeight fontWeight;

  const PriceLabel({
    super.key,
    required this.harga,
    this.fontSize = 15,
    this.color,
    this.fontWeight = FontWeight.bold,
  });

  @override
  Widget build(BuildContext context) {
    final formatted = harga.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );

    return Text(
      'Rp $formatted',
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Colors.deepOrange,
      ),
    );
  }
}
