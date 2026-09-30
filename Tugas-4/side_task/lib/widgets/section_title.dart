// ============================================================
// widgets/section_title.dart
// Komponen Visual 3: SECTION TITLE
// Judul seksi dengan garis dekoratif berwarna gold
// ============================================================

import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// SectionTitle — heading seksi dengan aksen garis gold
class SectionTitle extends StatelessWidget {
  final String title;
  final String? subtitle;
  final CrossAxisAlignment alignment;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.alignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        // Garis dekoratif di atas judul
        Row(
          mainAxisSize: alignment == CrossAxisAlignment.center
              ? MainAxisSize.min
              : MainAxisSize.max,
          children: [
            Container(
              width: 36,
              height: 3,
              decoration: BoxDecoration(
                color: AppTheme.accent,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 10,
              height: 3,
              decoration: BoxDecoration(
                color: AppTheme.accent.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(title, style: AppTheme.displayMedium),
        if (subtitle != null) ...[
          const SizedBox(height: 6),
          Text(subtitle!, style: AppTheme.bodyMedium),
        ],
      ],
    );
  }
}
