// ============================================================
// test/cart_controller_test.dart
// Unit Testing untuk CartController & Reaktivitas GetX TokoKita
// ============================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:tokokita/controllers/cart_controller.dart';
import 'package:tokokita/models/product.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Pengujian Unit CartController (GetX)', () {
    late CartController controller;
    late Product sampleNormalProduct;
    late DiscountedProduct sampleDiscountedProduct;

    setUp(() {
      controller = CartController();
      sampleNormalProduct = Product(
        id: 101,
        name: 'Keyboard Mechanical RGB',
        price: 500000.0,
        imageUrl: 'keyboard.png',
        category: 'Elektronik',
        stock: 5,
        description: 'Keyboard mechanical switch biru responsif.',
      );

      sampleDiscountedProduct = DiscountedProduct(
        id: 102,
        name: 'Mouse Gaming Wireless',
        price: 200000.0,
        imageUrl: 'mouse.png',
        category: 'Elektronik',
        stock: 4,
        description: 'Mouse sensor optik presisi tinggi.',
        discountPercent: 10, // Harga setelah diskon: 180.000
      );
    });

    test('Keranjang awal harus kosong', () {
      expect(controller.items.isEmpty, isTrue);
      expect(controller.totalItem, equals(0));
      expect(controller.totalHarga, equals(0.0));
      expect(controller.isCartEmpty, isTrue);
    });

    test('Langkah 2: addToCart menambah item baru dan memperbarui totalItem & totalHarga', () {
      controller.addToCart(sampleNormalProduct, quantity: 2, showNotification: false);

      expect(controller.items.length, equals(1));
      expect(controller.totalItem, equals(2));
      expect(controller.totalHarga, equals(1000000.0));
      expect(controller.isInCart(sampleNormalProduct), isTrue);
      expect(controller.getItemQuantity(sampleNormalProduct), equals(2));
    });

    test('Langkah 2: addToCart produk diskon memperhitungkan discountedPrice', () {
      controller.addToCart(sampleDiscountedProduct, quantity: 1, showNotification: false);

      expect(controller.items.length, equals(1));
      expect(controller.totalItem, equals(1));
      // Diskon 10% dari 200.000 = 180.000
      expect(controller.totalHarga, equals(180000.0));
      expect(controller.totalHemat, equals(20000.0));
    });

    test('Langkah 2 & 5: removeFromCart menghapus produk dari keranjang', () {
      controller.addToCart(sampleNormalProduct, quantity: 1, showNotification: false);
      controller.addToCart(sampleDiscountedProduct, quantity: 1, showNotification: false);
      expect(controller.items.length, equals(2));

      controller.removeFromCart(sampleNormalProduct, showNotification: false);
      expect(controller.items.length, equals(1));
      expect(controller.isInCart(sampleNormalProduct), isFalse);
      expect(controller.isInCart(sampleDiscountedProduct), isTrue);
    });

    test('Tugas Mandiri 1: increaseQuantity dan decreaseQuantity bekerja reaktif', () {
      controller.addToCart(sampleNormalProduct, quantity: 1, showNotification: false);
      expect(controller.totalItem, equals(1));
      expect(controller.totalHarga, equals(500000.0));

      // Tambah kuantitas
      controller.increaseQuantity(sampleNormalProduct);
      expect(controller.totalItem, equals(2));
      expect(controller.totalHarga, equals(1000000.0));

      // Kurang kuantitas
      controller.decreaseQuantity(sampleNormalProduct);
      expect(controller.totalItem, equals(1));
      expect(controller.totalHarga, equals(500000.0));
    });

    test('Tugas Mandiri 2: clearCart mengosongkan seluruh keranjang belanja', () {
      controller.addToCart(sampleNormalProduct, quantity: 2, showNotification: false);
      controller.addToCart(sampleDiscountedProduct, quantity: 1, showNotification: false);
      expect(controller.totalItem, equals(3));

      controller.clearCart(showNotification: false);
      expect(controller.items.isEmpty, isTrue);
      expect(controller.totalItem, equals(0));
      expect(controller.totalHarga, equals(0.0));
      expect(controller.isCartEmpty, isTrue);
    });

    test('Kuantitas tidak dapat melebihi stok yang tersedia', () {
      // sampleNormalProduct memiliki stock: 5
      controller.addToCart(sampleNormalProduct, quantity: 10, showNotification: false);
      expect(controller.getItemQuantity(sampleNormalProduct), equals(5));

      controller.increaseQuantity(sampleNormalProduct);
      expect(controller.getItemQuantity(sampleNormalProduct), equals(5));
    });
  });
}
