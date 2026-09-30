// ============================================================
// widgets/category_tag.dart
// Widget chip/tag kategori produk berwarna
// StatelessWidget — hanya menampilkan data, tidak ada state
// ============================================================

import 'package:flutter/material.dart';

/// CategoryTag — menampilkan label kategori sebagai chip berwarna
/// Tugas Mandiri 3 (Pertemuan 3) — widget custom pada ProductCard
class CategoryTag extends StatelessWidget {
  final String category;

  const CategoryTag({super.key, required this.category});

  // Menentukan warna latar berdasarkan kategori
  Color _getColor() {
    switch (category) {
      case 'Elektronik':
        return Colors.blue;
      case 'Fashion':
        return Colors.purple;
      case 'Makanan':
        return Colors.teal;
      case 'Olahraga':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  // Menentukan ikon berdasarkan kategori
  IconData _getIcon() {
    switch (category) {
      case 'Elektronik':
        return Icons.devices;
      case 'Fashion':
        return Icons.checkroom;
      case 'Makanan':
        return Icons.restaurant;
      case 'Olahraga':
        return Icons.sports_soccer;
      default:
        return Icons.category;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _getColor();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(), size: 12, color: color),
          const SizedBox(width: 3),
          Text(
            category,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
