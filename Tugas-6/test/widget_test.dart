// ============================================================
// test/widget_test.dart
// Pengujian Widget, State Management GetX, Obx, & Routing TokoKita Pertemuan 6
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tokokita/main.dart';
import 'package:tokokita/controllers/cart_controller.dart';
import 'package:tokokita/controllers/navigation_controller.dart';
import 'package:tokokita/models/product.dart';

void main() {
  setUp(() {
    // Bersihkan dependency GetX sebelum setiap pengujian
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Uji Siklus Penuh State Management GetX, Obx, dan Routing TokoKita',
      (WidgetTester tester) async {
    // Konfigurasi viewport layar ponsel
    tester.view.physicalSize = const Size(412, 1000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    // 1. Jalankan aplikasi utama GetMaterialApp
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verifikasi berada di Beranda
    expect(find.text('TokoKita'), findsOneWidget);
    expect(find.text('Katalog Produk'), findsOneWidget);
    expect(find.text('0 di keranjang'), findsOneWidget);

    // Verifikasi controller terdaftar di memory
    expect(Get.isRegistered<CartController>(), isTrue);
    expect(Get.isRegistered<NavigationController>(), isTrue);
    final cartController = Get.find<CartController>();

    // 2. Verifikasi Tab Keranjang awalnya kosong
    await tester.tap(find.text('Keranjang'));
    await tester.pumpAndSettle();
    expect(find.text('Keranjang Belanja Masih Kosong'), findsOneWidget);

    // Kembali ke Beranda lewat tombol Mulai Belanja
    await tester.tap(find.text('Mulai Belanja'));
    await tester.pumpAndSettle();
    expect(find.text('Katalog Produk'), findsOneWidget);

    // 3. Langkah 4: Buka Detail Produk via Get.to()
    final firstProduct = daftarProduk.first;
    await tester.tap(find.text(firstProduct.name));
    await tester.pumpAndSettle();

    // Pastikan berada di Detail Produk
    expect(find.text('Detail Produk'), findsOneWidget);
    expect(find.text('Jumlah Pembelian'), findsOneWidget);

    // 4. Ubah kuantitas stepper di halaman detail
    final addIcon = find.byIcon(Icons.add).first;
    await tester.ensureVisible(addIcon);
    await tester.tap(addIcon);
    await tester.pumpAndSettle();
    expect(find.text('2'), findsWidgets);

    // 5. Langkah 3: Tambah ke Keranjang dan amati reaktivitas Obx
    final addToCartBtn = find.text('Tambah ke Keranjang');
    await tester.ensureVisible(addToCartBtn);
    await tester.tap(addToCartBtn);
    await tester.pumpAndSettle();

    // Verifikasi CartController memiliki 2 item
    expect(cartController.totalItem, equals(2));
    expect(cartController.isInCart(firstProduct), isTrue);

    // 6. Langkah 4: Navigasi kembali menggunakan Get.back()
    final backBtn = find.byTooltip('Kembali (Get.back)');
    await tester.tap(backBtn);
    await tester.pumpAndSettle();

    // Verifikasi kembali di Beranda dan badge menunjukkan 2 item
    expect(find.text('Katalog Produk'), findsOneWidget);
    expect(find.text('2 di keranjang'), findsOneWidget);

    // 7. Langkah 5: Buka Keranjang Belanja yang kini berisi produk
    await tester.tap(find.text('Keranjang'));
    await tester.pumpAndSettle();
    expect(find.text('Keranjang Belanja'), findsOneWidget);
    expect(find.text('2 barang di keranjang'), findsOneWidget);
    expect(find.text(firstProduct.name), findsOneWidget);

    // 8. Tugas Mandiri 1: Tambah kuantitas di halaman keranjang (+ tombol)
    final plusBtnInCart = find.byIcon(Icons.add).last;
    await tester.ensureVisible(plusBtnInCart);
    await tester.tap(plusBtnInCart);
    await tester.pumpAndSettle();

    // Verifikasi jumlah bertambah jadi 3 secara reaktif
    expect(cartController.totalItem, equals(3));
    expect(find.text('3 barang di keranjang'), findsOneWidget);

    // 9. Tugas Mandiri 3: Masuk ke Halaman Checkout
    final checkoutBtn = find.text('Checkout');
    await tester.ensureVisible(checkoutBtn);
    await tester.tap(checkoutBtn);
    await tester.pumpAndSettle();

    expect(find.text('Konfirmasi Checkout'), findsOneWidget);
    expect(find.text('Alamat Pengiriman'), findsOneWidget);
    expect(find.text('Metode Pembayaran'), findsOneWidget);
    expect(find.textContaining('Ringkasan Produk (3 item)'), findsOneWidget);

    // 10. Langkah 4 & Tugas Mandiri 3: Tekan Bayar Sekarang yang memanggil Get.off()
    final payBtn = find.textContaining('Bayar Sekarang');
    await tester.ensureVisible(payBtn);
    await tester.tap(payBtn);
    await tester.pumpAndSettle();

    // Verifikasi berada di halaman sukses transaksi
    expect(find.text('Pembayaran Berhasil!'), findsOneWidget);
    expect(find.text('Status Transaksi'), findsOneWidget);
    expect(find.textContaining('Catatan GetX Routing'), findsOneWidget);

    // Verifikasi keranjang telah dikosongkan setelah checkout
    expect(cartController.isCartEmpty, isTrue);

    // 11. Langkah 4: Kembali ke Beranda menggunakan Get.offAll()
    final returnHomeBtn = find.text('Kembali ke Beranda (Get.offAll)');
    await tester.ensureVisible(returnHomeBtn);
    await tester.tap(returnHomeBtn);
    await tester.pumpAndSettle();

    // Verifikasi telah kembali ke halaman Beranda
    expect(find.text('TokoKita'), findsOneWidget);
    expect(find.text('0 di keranjang'), findsOneWidget);
  });
}
