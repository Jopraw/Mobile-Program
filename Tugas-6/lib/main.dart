// ============================================================
// main.dart — Entry point aplikasi TokoKita Pertemuan 6
//
// Langkah 1: Root widget diubah menjadi GetMaterialApp
// Langkah 2: Registrasi CartController secara global
// Langkah 4: Routing terstruktur dengan getPages (GetPage)
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controllers/cart_controller.dart';
import 'controllers/navigation_controller.dart';
import 'screens/main_page.dart';
import 'screens/cart_page.dart';
import 'screens/product_detail_page.dart';
import 'screens/checkout_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

/// GlobalBindings — Mendaftarkan controller utama secara eager saat aplikasi mulai
class GlobalBindings extends Bindings {
  @override
  void dependencies() {
    Get.put<CartController>(CartController(), permanent: true);
    Get.put<NavigationController>(NavigationController(), permanent: true);
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // ── Langkah 1: Ubah root widget dari MaterialApp menjadi GetMaterialApp ──
    return GetMaterialApp(
      title: 'TokoKita — Pertemuan 6 GetX',
      debugShowCheckedModeBanner: false,
      initialBinding: GlobalBindings(),
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

      // ── Langkah 4: Rute GetX menggunakan getPages ──
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => const MainPage(),
        ),
        GetPage(
          name: '/cart',
          page: () => const CartPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/detail',
          page: () => const ProductDetailPage(),
          transition: Transition.rightToLeft,
        ),
        GetPage(
          name: '/checkout',
          page: () => const CheckoutPage(),
          transition: Transition.rightToLeft,
        ),
      ],
    );
  }
}
