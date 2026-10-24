// ============================================================
// main.dart — Entry point aplikasi TokoKita Pertemuan 5
//
// Langkah 2: Named routes didefinisikan pada properti routes di MaterialApp
// Langkah 5: MainPage dengan BottomNavigationBar dijadikan root aplikasi ('/')
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
      title: 'TokoKita — Mobile System Programming',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepOrange,
          primary: Colors.deepOrange,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
        ),
      ),

      // ── Langkah 2 & 5: Pengaturan Named Routes ──
      // initialRoute menentukan rute awal yang dibuka saat aplikasi berjalan
      initialRoute: '/',

      // routes mendefinisikan tabel pemetaan nama rute (String) ke widget pembangun
      routes: {
        // Rute '/' mengarah ke MainPage (Langkah 5: Beranda, Keranjang, Profil)
        '/': (context) => const MainPage(),
        '/cart': (context) => const MainPage(initialIndex: 1),
        '/profile': (context) => const MainPage(initialIndex: 2),

        // Rute '/detail' mengarah ke ProductDetailPage (Langkah 2)
        // Data produk diambil di dalam ProductDetailPage via ModalRoute.of(context)!.settings.arguments
        '/detail': (context) => const ProductDetailPage(),
        '/detail_stepper': (context) => const ProductDetailPage(initialQuantity: 2),
        '/snackbar': (context) => const SnackBarDemoPage(),
      },
    );
  }
}

class SnackBarDemoPage extends StatefulWidget {
  const SnackBarDemoPage({super.key});

  @override
  State<SnackBarDemoPage> createState() => _SnackBarDemoPageState();
}

class _SnackBarDemoPageState extends State<SnackBarDemoPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Berhasil menambahkan 2 item (Kipas Angin Mini Portable USB) ke keranjang!',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          duration: const Duration(seconds: 15),
          action: SnackBarAction(
            label: 'Lihat',
            textColor: Colors.yellowAccent,
            onPressed: () {},
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const MainPage();
  }
}
