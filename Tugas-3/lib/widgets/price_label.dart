import 'package:flutter/material.dart';

/// Widget PriceLabel - menampilkan harga dalam format Rupiah
/// StatelessWidget karena hanya menampilkan data tanpa state internal
class PriceLabel extends StatelessWidget {
  final double harga;

  const PriceLabel({super.key, required this.harga});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Rp ${harga.toStringAsFixed(0).replaceAllMapped(
            RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
            (Match m) => '${m[1]}.',
          )}',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.deepOrange,
      ),
    );
  }
}
