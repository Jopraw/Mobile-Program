// ============================================================
// main.dart — Entry point aplikasi TokoKita Pertemuan 7
// Topik: HTTP Networking & Konsumsi REST API (Fake Store API)
// ============================================================

import 'package:flutter/material.dart';
import 'screens/main_page.dart';
import 'screens/product_detail_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TokoKita — REST API Edition (Pertemuan 7)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          primary: Colors.deepOrange,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainPage(),
        '/cart': (context) => const MainPage(initialIndex: 1),
        '/profile': (context) => const MainPage(initialIndex: 2),
        '/detail': (context) => const ProductDetailPage(),

        // Rute bantuan untuk pengujian & dokumentasi visual tangkapan layar
        '/loading_demo': (context) => const LoadingStateDemoPage(),
        '/error_demo': (context) => const ErrorStateDemoPage(),
      },
    );
  }
}

/// Halaman demonstrasi tampilan status Loading (Langkah 4)
class LoadingStateDemoPage extends StatelessWidget {
  const LoadingStateDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        title: const Text('TokoKita — Mengambil Data API'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(
              color: Colors.deepOrange,
              strokeWidth: 3,
            ),
            const SizedBox(height: 18),
            const Text(
              'Mengambil data dari Fake Store API...',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'GET https://fakestoreapi.com/products',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}

/// Halaman demonstrasi tampilan status Error & Tombol Coba Lagi (Langkah 5)
class ErrorStateDemoPage extends StatelessWidget {
  const ErrorStateDemoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        title: const Text('TokoKita — Status Jaringan'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  size: 48,
                  color: Colors.red,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Gagal Memuat Produk',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Tidak dapat terhubung ke server fakestoreapi.com.\nPeriksa koneksi internet Anda atau coba lagi beberapa saat lagi.',
                style: TextStyle(fontSize: 13, color: Colors.grey, height: 1.4),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
                icon: const Icon(Icons.refresh, size: 18),
                label: const Text(
                  'Coba Lagi',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
