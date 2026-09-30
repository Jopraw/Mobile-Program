// ============================================================
// main.dart — Entry point aplikasi TokoKita Pertemuan 4
// Langkah 5: HalamanUtama dijadikan home pada MaterialApp
// ============================================================

import 'package:flutter/material.dart';
import 'screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TokoKita',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      // Langkah 5: HalamanUtama (dari screens/home_page.dart)
      // menggantikan halaman default Flutter
      home: const HalamanUtama(),
    );
  }
}
