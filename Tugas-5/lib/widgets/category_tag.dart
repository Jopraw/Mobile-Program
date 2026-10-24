// ============================================================
// widgets/category_tag.dart
// Widget chip/tag kategori produk berwarna
// StatelessWidget — hanya menampilkan label dan ikon kategori
// ============================================================

import 'package:flutter/material.dart';

/// CategoryTag — menampilkan label kategori produk sebagai chip visual
class CategoryTag extends StatelessWidget {
  final String category;
  final double fontSize;
  final double iconSize;

  const CategoryTag({
    super.key,
    required this.category,
    this.fontSize = 11,
    this.iconSize = 12,
  });

  // Warna aksen berdasarkan nama kategori
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

  // Ikon pendukung berdasarkan kategori
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
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(_getIcon(), size: iconSize, color: color),
          const SizedBox(width: 4),
          Text(
            category,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
