// ============================================================
// test/product_service_test.dart
// Unit Testing untuk Model Product dan ProductService (REST API)
// Sesuai materi Slide PPT Pertemuan 7 (Unit Testing & Piramida Pengujian)
// ============================================================

import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokokita/models/product.dart';
import 'package:tokokita/services/product_service.dart';

void main() {
  group('Unit Test Model Product & Deserialisasi JSON (Pertemuan 7)', () {
    test('1. Product.fromJson berhasil memetakan JSON Fake Store API dengan tepat', () {
      final sampleJson = {
        'id': 1,
        'title': 'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops',
        'price': 109.95,
        'description': 'Your perfect pack for everyday use and walks in the forest.',
        'category': "men's clothing",
        'image': 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg',
        'rating': {
          'rate': 3.9,
          'count': 120,
        },
      };

      final product = Product.fromJson(sampleJson);

      expect(product.id, 1);
      expect(product.name, 'Fjallraven - Foldsack No. 1 Backpack, Fits 15 Laptops');
      expect(product.rawUsdPrice, 109.95);
      expect(product.price, 109.95 * 15000); // 1.649.250 Rupiah
      expect(product.imageUrl, 'https://fakestoreapi.com/img/81fPKd-2AYL._AC_SL1500_.jpg');
      expect(product.category, "Men's clothing");
      expect(product.rating, 3.9);
      expect(product.ratingCount, 120);
      expect(product.getStatusStok(), 'Tersedia Banyak');
    });

    test('2. Product.toJson berhasil men-serialisasi model kembali ke Map JSON', () {
      final product = Product(
        id: 2,
        name: 'Mens Casual Premium Slim Fit T-Shirts',
        price: 334500.0,
        rawUsdPrice: 22.3,
        imageUrl: 'https://fakestoreapi.com/img/71-3HjGNDUL._AC_SY879._SX._UX._SY._UY_.jpg',
        category: "Men's clothing",
        stock: 8,
        description: 'Slim-fitting style, contrast raglan long sleeve',
        rating: 4.1,
        ratingCount: 259,
      );

      final json = product.toJson();

      expect(json['id'], 2);
      expect(json['title'], 'Mens Casual Premium Slim Fit T-Shirts');
      expect(json['price'], 22.3);
      expect(json['image'], contains('fakestoreapi.com'));
      expect(json['rating']['rate'], 4.1);
    });

    test('3. Product.getStatusStok mengembalikan status yang akurat', () {
      final pBanyak = Product(id: 1, name: 'A', price: 100, imageUrl: '', category: 'C', stock: 15);
      final pTerbatas = Product(id: 2, name: 'B', price: 100, imageUrl: '', category: 'C', stock: 5);
      final pHabis = Product(id: 3, name: 'C', price: 100, imageUrl: '', category: 'C', stock: 0);

      expect(pBanyak.getStatusStok(), 'Tersedia Banyak');
      expect(pTerbatas.getStatusStok(), 'Stok Terbatas');
      expect(pHabis.getStatusStok(), 'Habis');
    });
  });

  group('Unit Test ProductService & Error Handling (Langkah 5)', () {
    test('4. Simulasi Error melempar SocketException dengan pesan informatif', () async {
      final service = ProductService();

      expect(
        () async => await service.fetchProducts(forceSimulatedError: true),
        throwsA(isA<SocketException>()),
      );
    });

    test('5. Simulasi Error pada fetchProductDetail melempar Exception', () async {
      final service = ProductService();

      expect(
        () async => await service.fetchProductDetail(99, forceSimulatedError: true),
        throwsA(isA<SocketException>()),
      );
    });
  });
}
