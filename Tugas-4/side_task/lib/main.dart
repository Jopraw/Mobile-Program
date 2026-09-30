// ============================================================
// main.dart — Entry point Portofolio App
// ============================================================

import 'package:flutter/material.dart';
import 'core/app_theme.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const PortofolioApp());
}

class PortofolioApp extends StatelessWidget {
  const PortofolioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Portofolio Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const HomeScreen(),
    );
  }
}
