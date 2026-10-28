// ============================================================
// controllers/cart_controller.dart
// State Management Keranjang Belanja TokoKita — Pertemuan 6
//
// Langkah 2: CartController & Variabel Reaktif
// Langkah 3: Obx & Reaktivitas Tampilan
// Tugas Mandiri 1 & 2: Ubah Kuantitas & Kosongkan Keranjang dengan Konfirmasi
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../models/cart_item.dart';

/// CartController mengelola seluruh state keranjang belanja TokoKita secara
/// terpusat menggunakan library GetX (GetxController & Rx).
class CartController extends GetxController {
  /// Daftar item di dalam keranjang belanja. Bersifat reaktif (RxList).
  final RxList<CartItem> items = <CartItem>[].obs;

  // ────────────────────────────────────────────────────────────
  // Getter Reaktif (Computed Properties)
  // ────────────────────────────────────────────────────────────

  /// Menghitung total seluruh unit barang yang ada di keranjang
  int get totalItem {
    return items.fold<int>(0, (sum, item) => sum + item.quantity.value);
  }

  /// Menghitung total harga seluruh belanjaan (memperhitungkan diskon)
  double get totalHarga {
    return items.fold<double>(0.0, (sum, item) => sum + item.subtotal);
  }

  /// Menghitung total harga sebelum diskon (harga normal)
  double get totalHargaNormal {
    return items.fold<double>(0.0, (sum, item) => sum + item.originalSubtotal);
  }

  /// Menghitung total nominal penghematan dari diskon
  double get totalHemat {
    return totalHargaNormal - totalHarga;
  }

  /// Memeriksa apakah keranjang dalam keadaan kosong
  bool get isCartEmpty => items.isEmpty;

  /// Memeriksa apakah sebuah produk sudah berada di keranjang
  bool isInCart(Product product) {
    return items.any((item) => item.product.id == product.id);
  }

  /// Mengambil jumlah kuantitas produk tertentu di keranjang (0 jika tidak ada)
  int getItemQuantity(Product product) {
    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      return items[index].quantity.value;
    }
    return 0;
  }

  // ────────────────────────────────────────────────────────────
  // Method Mutasi State Keranjang
  // ────────────────────────────────────────────────────────────

  /// Langkah 2 & 3: Menambahkan produk ke keranjang belanja
  void addToCart(Product product, {int quantity = 1, bool showNotification = true}) {
    if (product.stock <= 0) {
      if (showNotification && Get.context != null) {
        Get.snackbar(
          'Stok Habis',
          'Maaf, produk ${product.name} sedang tidak tersedia.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: const Color(0xFFC62828),
          colorText: Colors.white,
          icon: const Icon(Icons.error_outline, color: Colors.white),
          margin: const EdgeInsets.all(12),
          borderRadius: 10,
          duration: const Duration(seconds: 2),
        );
      }
      return;
    }

    final index = items.indexWhere((item) => item.product.id == product.id);

    if (index != -1) {
      // Produk sudah ada, periksa batas stok sebelum menambah kuantitas
      final currentQty = items[index].quantity.value;
      if (currentQty + quantity > product.stock) {
        items[index].quantity.value = product.stock;
        items.refresh();
        if (showNotification && Get.context != null) {
          Get.snackbar(
            'Batas Stok Tercapai',
            'Jumlah maksimal yang dapat dipesan adalah ${product.stock} item.',
            snackPosition: SnackPosition.TOP,
            backgroundColor: const Color(0xFFEF6C00),
            colorText: Colors.white,
            icon: const Icon(Icons.warning_amber_rounded, color: Colors.white),
            margin: const EdgeInsets.all(12),
            borderRadius: 10,
            duration: const Duration(seconds: 2),
          );
        }
        return;
      }
      items[index].quantity.value += quantity;
      items.refresh();
    } else {
      // Produk belum ada di keranjang, buat CartItem baru
      final validQty = quantity > product.stock ? product.stock : quantity;
      items.add(CartItem(product: product, initialQuantity: validQty));
    }

    if (showNotification && Get.context != null) {
      Get.snackbar(
        'Berhasil Ditambahkan',
        '$quantity item "${product.name}" dimasukkan ke keranjang belanja.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: const Color(0xFF2E7D32),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Langkah 2 & 5: Menghapus produk dari keranjang belanja
  void removeFromCart(Product product, {bool showNotification = true}) {
    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      final removedName = items[index].product.name;
      items.removeAt(index);

      if (showNotification && Get.context != null) {
        Get.snackbar(
          'Dihapus dari Keranjang',
          '"$removedName" telah dihapus dari keranjang belanja.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF424242),
          colorText: Colors.white,
          icon: const Icon(Icons.delete_outline, color: Colors.white),
          margin: const EdgeInsets.all(12),
          borderRadius: 10,
          duration: const Duration(seconds: 2),
        );
      }
    }
  }

  /// Tugas Mandiri 1: Tambah kuantitas satu item keranjang
  void increaseQuantity(Product product, {bool showNotification = true}) {
    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      if (items[index].quantity.value < product.stock) {
        items[index].quantity.value++;
        items.refresh();
      } else if (showNotification && Get.context != null) {
        Get.snackbar(
          'Stok Maksimal',
          'Jumlah tidak dapat melebihi stok yang tersedia (${product.stock} unit).',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFFEF6C00),
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          margin: const EdgeInsets.all(12),
          borderRadius: 10,
        );
      }
    }
  }

  /// Tugas Mandiri 1: Kurangi kuantitas satu item keranjang
  void decreaseQuantity(Product product, {bool showNotification = true}) {
    final index = items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      if (items[index].quantity.value > 1) {
        items[index].quantity.value--;
        items.refresh();
      } else {
        // Jika kuantitas 1 dan dikurangi, konfirmasi hapus item
        if (Get.context != null) {
          confirmRemoveSingleItem(product);
        } else {
          removeFromCart(product, showNotification: false);
        }
      }
    }
  }

  /// Dialog konfirmasi untuk menghapus satu produk saat kuantitas mencapai 0
  void confirmRemoveSingleItem(Product product) {
    Get.defaultDialog(
      title: 'Hapus Produk?',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      middleText: 'Apakah Anda ingin menghapus "${product.name}" dari keranjang?',
      middleTextStyle: const TextStyle(fontSize: 14),
      textConfirm: 'Hapus',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: const Color(0xFFC62828),
      cancelTextColor: Colors.grey.shade700,
      radius: 12,
      onConfirm: () {
        removeFromCart(product);
        Get.back(); // Tutup dialog
      },
    );
  }

  /// Tugas Mandiri 2: Mengosongkan seluruh item keranjang belanja
  void clearCart({bool showNotification = true}) {
    items.clear();
    if (showNotification && Get.context != null) {
      Get.snackbar(
        'Keranjang Dikosongkan',
        'Seluruh item di dalam keranjang belanja telah dibersihkan.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF424242),
        colorText: Colors.white,
        icon: const Icon(Icons.remove_shopping_cart_outlined, color: Colors.white),
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
        duration: const Duration(seconds: 2),
      );
    }
  }

  /// Tugas Mandiri 2: Menampilkan dialog konfirmasi sebelum mengosongkan keranjang
  void confirmClearCart() {
    if (items.isEmpty) {
      Get.snackbar(
        'Keranjang Masih Kosong',
        'Tidak ada produk yang perlu dikosongkan.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.grey.shade800,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        margin: const EdgeInsets.all(12),
        borderRadius: 10,
      );
      return;
    }

    Get.defaultDialog(
      title: 'Kosongkan Keranjang?',
      titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      middleText:
          'Seluruh $totalItem produk di dalam keranjang belanja Anda akan dihapus secara permanen. Anda yakin?',
      middleTextStyle: const TextStyle(fontSize: 14),
      textConfirm: 'Ya, Kosongkan',
      textCancel: 'Batal',
      confirmTextColor: Colors.white,
      buttonColor: Colors.deepOrange,
      cancelTextColor: Colors.grey.shade700,
      radius: 12,
      onConfirm: () {
        clearCart();
        Get.back(); // Tutup dialog konfirmasi
      },
    );
  }
}
