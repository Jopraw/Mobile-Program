// ============================================================
// test/storage_test.dart
// Pengujian SharedPreferences (wishlist) & SQLite (riwayat pesanan)
// ============================================================

import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tokokita/controllers/cart_controller.dart';
import 'package:tokokita/controllers/order_controller.dart';
import 'package:tokokita/controllers/wishlist_controller.dart';
import 'package:tokokita/models/order.dart';
import 'package:tokokita/models/product.dart';
import 'package:tokokita/services/order_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  setUp(() => Get.reset());

  group('Wishlist (SharedPreferences)', () {
    test('toggle menyimpan ID dan dimuat ulang pada instance baru', () async {
      SharedPreferences.setMockInitialValues({});
      final c1 = WishlistController();
      await c1.loadWishlist();
      await c1.toggleFavorite(3);
      await c1.toggleFavorite(7);
      expect(c1.isFavorite(3), isTrue);

      // simulasi aplikasi ditutup & dibuka kembali
      final c2 = WishlistController();
      await c2.loadWishlist();
      expect(c2.favoriteIds, {3, 7});

      await c2.removeFromWishlist(3);
      final c3 = WishlistController();
      await c3.loadWishlist();
      expect(c3.favoriteIds, {7});
    });
  });

  group('Riwayat pesanan (SQLite)', () {
    late OrderDatabase db;

    OrderRecord sample(double total, [String status = OrderStatus.diproses]) =>
        OrderRecord(
          tanggal: DateTime(2026, 10, 28, 10),
          daftarItem: const [
            OrderItem(productId: 1, name: 'Kipas', quantity: 2, unitPrice: 5000),
          ],
          totalHarga: total,
          status: status,
        );

    setUp(() {
      db = OrderDatabase(customPath: inMemoryDatabasePath);
    });
    tearDown(() => db.close());

    test('insert & getAllOrders', () async {
      final id = await db.insertOrder(sample(10000));
      final all = await db.getAllOrders();
      expect(all.length, 1);
      expect(all.first.id, id);
      expect(all.first.daftarItem.first.name, 'Kipas');
      expect(all.first.totalUnit, 2);
    });

    test('updateOrderStatus & deleteOrder', () async {
      final id = await db.insertOrder(sample(10000));
      await db.updateOrderStatus(id, OrderStatus.selesai);
      expect((await db.getAllOrders()).first.status, OrderStatus.selesai);
      await db.deleteOrder(id);
      expect(await db.getAllOrders(), isEmpty);
    });

    test('searchOrdersByStatus memakai WHERE', () async {
      await db.insertOrder(sample(1000));
      await db.insertOrder(sample(2000, OrderStatus.selesai));
      final r = await db.searchOrdersByStatus('selesai');
      expect(r.length, 1);
      expect(r.first.totalHarga, 2000);
    });

    test('OrderController.checkout menyimpan pesanan & mengosongkan keranjang',
        () async {
      final cart = CartController();
      cart.addToCart(daftarProduk[0], quantity: 2, showNotification: false);
      final orders = OrderController(database: db);
      final saved = await orders.checkout(cart);

      expect(saved?.id, isNotNull);
      expect(cart.isCartEmpty, isTrue);
      expect(orders.orders.length, 1);
      expect(orders.orders.first.totalUnit, 2);
    });
  });
}
