// ============================================================
// test/widget_test.dart
// Alur UI Pertemuan 9: wishlist persisten, checkout -> SQLite -> riwayat
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tokokita/controllers/cart_controller.dart';
import 'package:tokokita/controllers/navigation_controller.dart';
import 'package:tokokita/controllers/order_controller.dart';
import 'package:tokokita/controllers/wishlist_controller.dart';
import 'package:tokokita/main.dart';
import 'package:tokokita/models/product.dart';
import 'package:tokokita/services/order_database.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  setUp(() => Get.reset());
  tearDown(() => Get.reset());

  testWidgets('Wishlist tersimpan & checkout masuk riwayat SQLite',
      (tester) async {
    // Favorit produk id=2 sudah tersimpan dari "sesi sebelumnya"
    SharedPreferences.setMockInitialValues({
      WishlistController.prefsKey: ['2'],
    });
    tester.view.physicalSize = const Size(412, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    // Daftarkan controller dengan database in-memory sebelum app berjalan
    Get.put(CartController(), permanent: true);
    Get.put(NavigationController(), permanent: true);
    Get.put(WishlistController(), permanent: true);
    final orderDb = OrderDatabase(customPath: inMemoryDatabasePath);
    Get.put(OrderController(database: orderDb), permanent: true);

    await tester.runAsync(() async {
      await Get.find<WishlistController>().loadWishlist();
      await Get.find<OrderController>().refreshOrders();
    });

    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Favorit dimuat dari SharedPreferences
    expect(Get.find<WishlistController>().isFavorite(2), isTrue);
    expect(find.byIcon(Icons.favorite), findsOneWidget);

    // Tandai produk pertama sebagai favorit
    await tester.tap(find.byIcon(Icons.favorite_border).first);
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite), findsNWidgets(2));

    // Tambah ke keranjang lalu checkout
    final cart = Get.find<CartController>();
    cart.addToCart(daftarProduk.first, quantity: 2, showNotification: false);
    await tester.tap(find.text('Keranjang'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    final pay = find.ancestor(
      of: find.textContaining('Bayar Sekarang'),
      matching: find.byType(ElevatedButton),
    );
    await tester.ensureVisible(pay);
    await tester.pumpAndSettle();
    await tester.runAsync(() async {
      final btn = tester.widget<ElevatedButton>(pay);
      btn.onPressed!();
      for (int i = 0;
          i < 50 && Get.find<OrderController>().orders.isEmpty;
          i++) {
        await Future.delayed(const Duration(milliseconds: 20));
      }
      await Future.delayed(const Duration(milliseconds: 50));
    });
    await tester.pumpAndSettle();

    expect(find.text('Pembayaran Berhasil!'), findsOneWidget);
    expect(cart.isCartEmpty, isTrue);
    expect(Get.find<OrderController>().orders.length, 1);

    // Kembali ke beranda -> Profil -> Riwayat Pesanan
    final back = find.text('Kembali ke Beranda (Get.offAll)');
    await tester.ensureVisible(back);
    await tester.pumpAndSettle();
    await tester.tap(back);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Riwayat Pesanan').first);
    await tester.pumpAndSettle();

    expect(find.text('Pesanan #1'), findsOneWidget);
    expect(find.text('Diproses'), findsWidgets);

    await tester.runAsync(() async {
      await orderDb.close();
    });
  });
}
