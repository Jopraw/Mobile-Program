// ============================================================
// widgets/primary_button.dart
// Komponen Visual 2: PRIMARY BUTTON
// Gradient navy-to-purple, gold accent, animasi scale tap
// ============================================================

import 'package:flutter/material.dart';
import '../core/app_theme.dart';

/// PrimaryButton — tombol utama bergaya premium
/// Dua varian: filled (default) dan outlined
class PrimaryButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isOutlined;
  final double? width;
  final Color? bgColor;

  const PrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isOutlined = false,
    this.width,
    this.bgColor,
  });

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 110),
    );
    _scale = Tween(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onPressed?.call(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scale,
        child: widget.isOutlined ? _outlined() : _filled(),
      ),
    );
  }

  Widget _filled() => Container(
    width: widget.width,
    height: 54,
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [
          widget.bgColor ?? AppTheme.primary,
          widget.bgColor != null
              ? widget.bgColor!.withValues(alpha: 0.75)
              : AppTheme.primaryLight,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
      boxShadow: AppTheme.buttonShadow,
    ),
    child: _content(Colors.white),
  );

  Widget _outlined() => Container(
    width: widget.width,
    height: 54,
    decoration: BoxDecoration(
      border: Border.all(color: AppTheme.primary, width: 1.8),
      borderRadius: BorderRadius.circular(AppTheme.radiusFull),
    ),
    child: _content(AppTheme.primary),
  );

  Widget _content(Color color) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    mainAxisSize: MainAxisSize.min,
    children: [
      if (widget.icon != null) ...[
        Icon(widget.icon, color: color, size: 19),
        const SizedBox(width: 8),
      ],
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Text(
          widget.label,
          style: AppTheme.buttonLabel.copyWith(color: color),
        ),
      ),
    ],
  );
}
