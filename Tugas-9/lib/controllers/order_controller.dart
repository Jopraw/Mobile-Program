// ============================================================
// controllers/order_controller.dart
// State reaktif riwayat pesanan di atas SQLite — Pertemuan 9
// ============================================================

import 'package:get/get.dart';
import '../models/order.dart';
import '../services/order_database.dart';
import 'cart_controller.dart';

class OrderController extends GetxController {
  final OrderDatabase db;
  OrderController({OrderDatabase? database}) : db = database ?? OrderDatabase();

  final RxList<OrderRecord> orders = <OrderRecord>[].obs;

  /// Kata kunci pencarian status (kosong = tampilkan semua)
  final RxString statusQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    refreshOrders();
  }

  /// Muat ulang daftar sesuai pencarian aktif (SELECT ... WHERE status LIKE ?)
  Future<void> refreshOrders() async {
    final query = statusQuery.value.trim();
    final result = query.isEmpty
        ? await db.getAllOrders()
        : await db.searchOrdersByStatus(query);
    orders.assignAll(result);
  }

  Future<void> search(String keyword) async {
    statusQuery.value = keyword;
    await refreshOrders();
  }

  /// Menyimpan isi keranjang sebagai pesanan baru lalu mengosongkan keranjang.
  /// Mengembalikan pesanan yang tersimpan (dengan id).
  Future<OrderRecord?> checkout(CartController cart) async {
    if (cart.items.isEmpty) return null;

    final order = OrderRecord(
      tanggal: DateTime.now(),
      daftarItem: cart.items
          .map((c) => OrderItem(
                productId: c.product.id,
                name: c.product.name,
                quantity: c.quantity.value,
                unitPrice: c.unitPrice,
              ))
          .toList(),
      totalHarga: cart.totalHarga,
    );

    final id = await db.insertOrder(order);
    cart.clearCart(showNotification: false);
    await refreshOrders();
    return OrderRecord(
      id: id,
      tanggal: order.tanggal,
      daftarItem: order.daftarItem,
      totalHarga: order.totalHarga,
      status: order.status,
    );
  }

  Future<void> updateStatus(int id, String status) async {
    await db.updateOrderStatus(id, status);
    await refreshOrders();
  }

  Future<void> deleteOrder(int id) async {
    await db.deleteOrder(id);
    await refreshOrders();
  }
}
