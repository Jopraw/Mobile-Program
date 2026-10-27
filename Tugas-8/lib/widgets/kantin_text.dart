import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Custom widget teks reusable menggunakan font Poppins dari Google Fonts.
// Alasan memilih font Poppins: Font sans-serif modern yang memiliki keterbacaan
// tinggi pada layar mobile, dengan variasi ketebalan (weight) yang luas sehingga
// cocok untuk judul, label, maupun teks deskriptif pada aplikasi kantin kampus.
class KantinText extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight fontWeight;
  final Color? color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const KantinText(
    this.text, {
    super.key,
    this.fontSize = 14,
    this.fontWeight = FontWeight.normal,
    this.color,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color ?? Theme.of(context).colorScheme.onSurface,
      ),
    );
  }
}
