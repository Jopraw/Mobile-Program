// ============================================================
// test/generate_screenshots_test.dart
// Generator Screenshot Otomatis untuk Laporan Praktikum 6 GetX
// ============================================================

import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:tokokita/main.dart';
import 'package:tokokita/controllers/cart_controller.dart';
import 'package:tokokita/models/product.dart';

Future<void> _captureWidget(WidgetTester tester, GlobalKey key, String path) async {
  await tester.pumpAndSettle();
  final boundary = key.currentContext?.findRenderObject() as RenderRepaintBoundary?;
  if (boundary != null) {
    final image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData != null) {
      final file = File(path);
      file.parent.createSync(recursive: true);
      file.writeAsBytesSync(byteData.buffer.asUint8List());
    }
  }
}

void main() {
  setUp(() {
    Get.reset();
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('Generate all screenshots for Tugas-6', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    final GlobalKey rootKey = GlobalKey();

    await tester.pumpWidget(
      RepaintBoundary(
        key: rootKey,
        child: const MyApp(),
      ),
    );
    await tester.pumpAndSettle();

    final cartController = Get.find<CartController>();

    // Tambahkan 2 produk untuk demo
    cartController.addToCart(daftarProduk[0], quantity: 2, showNotification: false);
    cartController.addToCart(daftarProduk[1], quantity: 1, showNotification: false);
    await tester.pumpAndSettle();

    // 1. Beranda dengan Badge Keranjang Obx
    await _captureWidget(tester, rootKey, 'screenshots/01_beranda_dengan_badge_obx.png');

    // 2. Detail Produk
    await tester.tap(find.text(daftarProduk[0].name));
    await tester.pumpAndSettle();
    await _captureWidget(tester, rootKey, 'screenshots/02_detail_produk_tambah_keranjang.png');

    // Kembali ke Beranda
    await tester.tap(find.byTooltip('Kembali (Get.back)'));
    await tester.pumpAndSettle();

    // 3. Tab Keranjang Obx
    await tester.tap(find.text('Keranjang'));
    await tester.pumpAndSettle();
    await _captureWidget(tester, rootKey, 'screenshots/03_halaman_keranjang_obx.png');

    // 4. Stepper Kuantitas
    final plusBtn = find.byIcon(Icons.add).last;
    await tester.tap(plusBtn);
    await tester.pumpAndSettle();
    await _captureWidget(tester, rootKey, 'screenshots/04_stepper_kuantitas_subtotal.png');

    // 5. Dialog Konfirmasi Kosongkan Keranjang
    await tester.tap(find.byTooltip('Kosongkan Keranjang'));
    await tester.pumpAndSettle();
    await _captureWidget(tester, rootKey, 'screenshots/05_dialog_konfirmasi_kosongkan_keranjang.png');

    // Tutup dialog
    await tester.tap(find.text('Batal'));
    await tester.pumpAndSettle();

    // 6. Halaman Checkout
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    await _captureWidget(tester, rootKey, 'screenshots/06_halaman_checkout_get_off.png');

    // 7. Status Transaksi Berhasil
    final payBtn = find.textContaining('Bayar Sekarang');
    await tester.ensureVisible(payBtn);
    await tester.tap(payBtn);
    await tester.pumpAndSettle();
    await _captureWidget(tester, rootKey, 'screenshots/07_halaman_transaksi_berhasil_get_offall.png');
  });
}
