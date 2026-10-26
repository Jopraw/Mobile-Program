// ============================================================
// test/widget_test.dart
// Widget Testing untuk Alur REST API, FutureBuilder, dan UI TokoKita
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokokita/main.dart';
import 'package:tokokita/models/product.dart';
import 'package:tokokita/services/product_service.dart';
import 'package:tokokita/screens/home_page.dart';
import 'package:tokokita/screens/main_page.dart';

// Mock ProductService untuk pengujian widget tanpa koneksi jaringan eksternal
class MockProductService extends ProductService {
  final bool shouldFail;

  MockProductService({this.shouldFail = false});

  @override
  Future<List<Product>> fetchProducts({bool forceSimulatedError = false}) async {
    await Future.delayed(const Duration(milliseconds: 50));
    if (shouldFail || forceSimulatedError) {
      throw Exception('Gagal menghubungi Fake Store API');
    }

    return [
      Product(
        id: 1,
        name: 'Tas Ransel Laptop Modern',
        price: 450000.0,
        rawUsdPrice: 30.0,
        imageUrl: '',
        category: 'Fashion',
        stock: 12,
        description: 'Tas ransel tahan air dengan kompartemen laptop 15 inci.',
        rating: 4.8,
        ratingCount: 88,
      ),
      Product(
        id: 2,
        name: 'Kemeja Casual Slim Fit',
        price: 250000.0,
        rawUsdPrice: 16.5,
        imageUrl: '',
        category: 'Fashion',
        stock: 5,
        description: 'Kemeja katun premium nyaman digunakan sehari-hari.',
        rating: 4.3,
        ratingCount: 42,
      ),
    ];
  }

  @override
  Future<Product> fetchProductDetail(int id, {bool forceSimulatedError = false}) async {
    return Product(
      id: id,
      name: 'Tas Ransel Laptop Modern',
      price: 450000.0,
      imageUrl: '',
      category: 'Fashion',
      stock: 12,
      description: 'Detail lengkap dari Fake Store API.',
    );
  }
}

void main() {
  testWidgets('Uji FutureBuilder Sukses: Loading Indicator dan Daftar Produk Ter-render',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final mockService = MockProductService(shouldFail: false);

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(productService: mockService),
      ),
    );

    // 1. Verifikasi Loading Indicator saat data masih dimuat (Langkah 4)
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('Mengambil data dari Fake Store API...'), findsOneWidget);

    // Selesaikan asynchronous Future
    await tester.pumpAndSettle();

    // 2. Verifikasi Data Sukses Tampil (Langkah 4)
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text('Tas Ransel Laptop Modern'), findsOneWidget);
    expect(find.text('Kemeja Casual Slim Fit'), findsOneWidget);
    expect(find.text('Katalog Produk Real-Time'), findsOneWidget);
  });

  testWidgets('Uji FutureBuilder Gagal: Tampilan Pesan Error dan Tombol Coba Lagi (Langkah 5)',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final mockService = MockProductService(shouldFail: true);

    await tester.pumpWidget(
      MaterialApp(
        home: HomePage(productService: mockService),
      ),
    );

    await tester.pumpAndSettle();

    // Verifikasi Kondisi Error Tampil Ramah Pengguna (Langkah 5)
    expect(find.text('Gagal Memuat Produk'), findsOneWidget);
    expect(find.byIcon(Icons.cloud_off_rounded), findsOneWidget);
    expect(find.text('Coba Lagi'), findsOneWidget);
  });

  testWidgets('Uji Navigasi Utama Aplikasi TokoKita Pertemuan 7',
      (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final mockService = MockProductService(shouldFail: false);

    await tester.pumpWidget(
      MaterialApp(
        home: MainPage(productService: mockService),
      ),
    );
    await tester.pumpAndSettle();

    // Verifikasi BottomNavigationBar
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Keranjang'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });
}
