// ============================================================
// widgets/skill_chip.dart
// Komponen Visual 4: SKILL CHIP
// Tag kemampuan/teknologi dengan ikon dan warna custom
// ============================================================

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/app_theme.dart';

/// SkillChip — tag skill dengan ikon FontAwesome
class SkillChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;

  const SkillChip({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 13, color: color),
          const SizedBox(width: 7),
          Text(label, style: AppTheme.labelBold.copyWith(color: color)),
        ],
      ),
    );
  }
}

// ── Data skills Jojo ──────────────────────────────────────
final List<Map<String, dynamic>> skillList = [
  {'label': 'Flutter',    'icon': FontAwesomeIcons.mobile,       'color': const Color(0xFF54C5F8)},
  {'label': 'Dart',       'icon': FontAwesomeIcons.code,         'color': const Color(0xFF00BCD4)},
  {'label': 'HTML/CSS',   'icon': FontAwesomeIcons.html5,        'color': const Color(0xFFE34F26)},
  {'label': 'JavaScript', 'icon': FontAwesomeIcons.js,           'color': const Color(0xFFF7DF1E)},
  {'label': 'Unity',      'icon': FontAwesomeIcons.unity,        'color': const Color(0xFF444444)},
  {'label': 'Godot',      'icon': FontAwesomeIcons.gamepad,      'color': const Color(0xFF478CBF)},
  {'label': 'Git',        'icon': FontAwesomeIcons.gitAlt,       'color': const Color(0xFFF05032)},
  {'label': 'Digital Art', 'icon': FontAwesomeIcons.penNib,      'color': const Color(0xFF9C27B0)},
];
