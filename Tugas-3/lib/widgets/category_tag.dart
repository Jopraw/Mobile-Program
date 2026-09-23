import 'package:flutter/material.dart';

/// Widget CategoryTag - menampilkan kategori produk sebagai chip/tag berwarna
/// Tugas Mandiri 3: widget custom tambahan pada ProductCard
/// StatelessWidget karena hanya menampilkan data tanpa state internal
class CategoryTag extends StatelessWidget {
  final String category;

  const CategoryTag({super.key, required this.category});

  // Menentukan warna berdasarkan kategori
  Color _getColor() {
    switch (category) {
      case 'Elektronik':
        return Colors.blue;
      case 'Fashion':
        return Colors.purple;
      case 'Makanan':
        return Colors.teal;
      default:
        return Colors.grey;
    }
  }

  // Menentukan icon berdasarkan kategori
  IconData _getIcon() {
    switch (category) {
      case 'Elektronik':
        return Icons.devices;
      case 'Fashion':
        return Icons.checkroom;
      case 'Makanan':
        return Icons.restaurant;
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
          Icon(_getIcon(), size: 13, color: color),
          const SizedBox(width: 4),
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
