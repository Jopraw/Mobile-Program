// ============================================================
// core/app_theme.dart
// Komponen Visual 1: DESIGN SYSTEM
// Primary Font: Playfair Display (heading elegant) + DM Sans (body)
// ============================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  AppTheme._();

  // ── COLOR PALETTE ──────────────────────────────────────────
  static const Color primary       = Color(0xFF2D2D5E); // navy deep
  static const Color primaryLight  = Color(0xFF5C5C9E);
  static const Color accent        = Color(0xFFE8C97D); // gold elegant
  static const Color accentLight   = Color(0xFFF5E5B0);
  static const Color background    = Color(0xFFFAF9F7); // warm white
  static const Color surface       = Color(0xFFFFFFFF);
  static const Color textPrimary   = Color(0xFF1C1C2E);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textLight     = Color(0xFFAAAAAA);
  static const Color cardBg        = Color(0xFFF4F3F8);

  // ── FONTS ──────────────────────────────────────────────────
  // Primary heading font: Playfair Display (elegant serif)
  static TextStyle get displayLarge => GoogleFonts.playfairDisplay(
    fontSize: 36,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1.2,
  );

  static TextStyle get displayMedium => GoogleFonts.playfairDisplay(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: textPrimary,
    height: 1.3,
  );

  static TextStyle get headlineLarge => GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle get headlineAccent => GoogleFonts.playfairDisplay(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: accent,
    fontStyle: FontStyle.italic,
  );

  // Body font: DM Sans (modern, clean, readable)
  static TextStyle get bodyLarge => GoogleFonts.dmSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: textPrimary,
    height: 1.7,
  );

  static TextStyle get bodyMedium => GoogleFonts.dmSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: textSecondary,
    height: 1.6,
  );

  static TextStyle get labelBold => GoogleFonts.dmSans(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: textPrimary,
    letterSpacing: 0.3,
  );

  static TextStyle get caption => GoogleFonts.dmSans(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    color: textLight,
    letterSpacing: 0.5,
  );

  static TextStyle get buttonLabel => GoogleFonts.dmSans(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0.5,
  );

  // ── SPACING ────────────────────────────────────────────────
  static const double radiusSm  = 8.0;
  static const double radiusMd  = 16.0;
  static const double radiusLg  = 24.0;
  static const double radiusFull = 999.0;

  // ── SHADOW ─────────────────────────────────────────────────
  static List<BoxShadow> get cardShadow => [
    BoxShadow(
      color: primary.withValues(alpha: 0.07),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get buttonShadow => [
    BoxShadow(
      color: primary.withValues(alpha: 0.30),
      blurRadius: 18,
      offset: const Offset(0, 7),
    ),
  ];

  // ── MATERIAL THEME ─────────────────────────────────────────
  static ThemeData get theme => ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primary,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: background,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: textPrimary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: GoogleFonts.playfairDisplay(
        fontSize: 20,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      ),
    ),
  );
}
