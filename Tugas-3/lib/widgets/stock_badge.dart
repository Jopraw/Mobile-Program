import 'package:flutter/material.dart';

/// Widget StockBadge - menampilkan badge status stok dengan warna berbeda
/// StatelessWidget karena hanya menampilkan data tanpa state internal
class StockBadge extends StatelessWidget {
  final int stock;

  const StockBadge({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    // Menentukan label dan warna berdasarkan jumlah stok
    String label;
    Color warnaBadge;

    if (stock > 10) {
      label = 'Tersedia Banyak';
      warnaBadge = Colors.green;
    } else if (stock > 0) {
      label = 'Stok Terbatas';
      warnaBadge = Colors.orange;
    } else {
      label = 'Habis';
      warnaBadge = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: warnaBadge.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: warnaBadge, width: 1),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.bold,
          color: warnaBadge,
        ),
      ),
    );
  }
}
