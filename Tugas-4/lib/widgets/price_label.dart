// ============================================================
// widgets/price_label.dart
// Widget untuk menampilkan harga dalam format Rupiah
// StatelessWidget — tidak ada state yang berubah
// ============================================================

import 'package:flutter/material.dart';

/// PriceLabel — menampilkan harga dalam format "Rp 150.000"
/// Langkah 2: dipakai di dalam ProductCard
class PriceLabel extends StatelessWidget {
  final double harga;

  const PriceLabel({super.key, required this.harga});

  @override
  Widget build(BuildContext context) {
    // Regex untuk tambah titik setiap 3 digit (format ribuan)
    final formatted = harga.toStringAsFixed(0).replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );

    return Text(
      'Rp $formatted',
      style: const TextStyle(
        fontSize: 15,
        fontWeight: FontWeight.bold,
        color: Colors.deepOrange,
      ),
    );
  }
}
