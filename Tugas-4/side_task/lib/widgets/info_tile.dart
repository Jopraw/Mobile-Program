// ============================================================
// widgets/info_tile.dart
// Komponen Visual 6: INFO TILE
// Baris informasi kontak/profil dengan ikon FontAwesome
// ============================================================

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/app_theme.dart';

/// InfoTile — baris info dengan ikon, label, dan value
class InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color iconColor;
  final VoidCallback? onTap;

  const InfoTile({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.iconColor = AppTheme.primary,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppTheme.surface,
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Row(
          children: [
            // Ikon dalam kotak berwarna
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconColor.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(AppTheme.radiusSm),
              ),
              child: Center(
                child: FaIcon(icon, size: 18, color: iconColor),
              ),
            ),
            const SizedBox(width: 14),
            // Label & value
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: AppTheme.caption),
                  const SizedBox(height: 2),
                  Text(value, style: AppTheme.labelBold),
                ],
              ),
            ),
            if (onTap != null)
              FaIcon(FontAwesomeIcons.chevronRight,
                  size: 12, color: AppTheme.textLight),
          ],
        ),
      ),
    );
  }
}
