// ============================================================
// widgets/category_tag.dart
// Widget chip/tag kategori produk
// ============================================================

import 'package:flutter/material.dart';

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

  Color _getColor() {
    final cat = category.toLowerCase();
    if (cat.contains('elec')) return Colors.blue;
    if (cat.contains('jewel')) return Colors.amber.shade800;
    if (cat.contains('men')) return Colors.indigo;
    if (cat.contains('women')) return Colors.purple;
    if (cat.contains('food') || cat.contains('makan')) return Colors.teal;
    if (cat.contains('sport') || cat.contains('olahraga')) return Colors.green;
    return Colors.deepOrange;
  }

  IconData _getIcon() {
    final cat = category.toLowerCase();
    if (cat.contains('elec')) return Icons.devices;
    if (cat.contains('jewel')) return Icons.diamond_outlined;
    if (cat.contains('men')) return Icons.male;
    if (cat.contains('women')) return Icons.female;
    if (cat.contains('food')) return Icons.restaurant;
    return Icons.local_offer_outlined;
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
