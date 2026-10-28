// ============================================================
// routes/go_router_example.dart
// Pengantar go_router — Alternatif Routing Modern Flutter (Langkah 4)
//
// File ini mendokumentasikan dan membandingkan struktur konfigurasi
// go_router (Navigator 2.0 deklaratif) vs Navigator 1.0 (imperatif)
// untuk TokoKita, sesuai panduan Langkah 4 Lembar Praktikum.
// ============================================================

/*
KONSEP DASAR GO_ROUTER (Flutter Navigator 2.0):
1. Deklaratif & URL-Driven:
   Rute diatur berdasarkan path string mirip URL web (misal '/' atau '/product/:id').
   Sangat ideal untuk deep linking dan aplikasi lintas platform (Web + Mobile).

2. Penanganan Parameter Mudah:
   Mendukung path parameters ('/product/:id') dan query parameters ('/search?q=sepatu').

3. Nested Routing (ShellRoute / StatefulShellRoute):
   Sangat cocok untuk BottomNavigationBar, di mana setiap tab dapat memiliki
   sub-stack navigasi sendiri tanpa kehilangan status tab lain.

CONTOH KONFIGURASI GO_ROUTER UNTUK TOKOKITA:
------------------------------------------------------------
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/product.dart';
import '../screens/main_page.dart';
import '../screens/product_detail_page.dart';

final GoRouter tokoKitaRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      name: 'home',
      builder: (BuildContext context, GoRouterState state) {
        return const MainPage();
      },
      routes: <RouteBase>[
        // Sub-rute untuk detail produk
        GoRoute(
          path: 'detail',
          name: 'product_detail',
          builder: (BuildContext context, GoRouterState state) {
            // Mengambil objek produk yang dikirim via 'extra'
            final product = state.extra as Product?;
            return ProductDetailPage(product: product);
          },
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => Scaffold(
    body: Center(
      child: Text('Halaman tidak ditemukan: ${state.error}'),
    ),
  ),
);

CARA NAVIGASI DENGAN GO_ROUTER:
------------------------------------------------------------
// 1. Pindah ke halaman detail dengan mengirim data objek:
context.go('/detail', extra: product);
// atau jika ingin push ke dalam stack:
context.push('/detail', extra: product);

// 2. Kembali ke halaman sebelumnya:
context.pop(jumlahItem);
------------------------------------------------------------
*/

/// Perbandingan Konseptual Navigator Dasar vs go_router
class RoutingComparisonNotes {
  static const String comparisonTitle =
      'Perbedaan Navigator Dasar (1.0) vs go_router (2.0)';

  static const List<Map<String, String>> points = [
    {
      'aspek': 'Paradigma',
      'navigator1': 'Imperatif (perintah manual push/pop stack)',
      'goRouter': 'Deklaratif (sinkronisasi state URL dengan UI)',
    },
    {
      'aspek': 'Deep Linking',
      'navigator1': 'Sulit dan membutuhkan banyak boilerplate parsing intent',
      'goRouter': 'Out-of-the-box (URL path otomatis membuka layar yang tepat)',
    },
    {
      'aspek': 'Nested Navigation',
      'navigator1': 'Memerlukan Navigator bertingkat manual (Nested Navigator)',
      'goRouter': 'Didukung penuh via ShellRoute & StatefulShellRoute',
    },
    {
      'aspek': 'Dukungan Web',
      'navigator1': 'Tombol back browser sering tidak sinkron dengan riwayat aplikasi',
      'goRouter': 'Sangat mulus, sinkron penuh dengan URL bar dan history browser',
    },
    {
      'aspek': 'Passing Data',
      'navigator1': 'Via constructor widget atau ModalRoute arguments',
      'goRouter': 'Via path params, query params, atau state.extra',
    },
  ];
}
