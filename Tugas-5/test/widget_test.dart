// ============================================================
// test/widget_test.dart
// Pengujian Navigasi, Routing, dan Interaksi TokoKita Pertemuan 5
// ============================================================

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tokokita/main.dart';
import 'package:tokokita/models/product.dart';

void main() {
  testWidgets('Uji Navigasi Utama, Named Routes, dan Bottom Navigation TokoKita',
      (WidgetTester tester) async {
    // Atur ukuran viewport agar menyerupai layar ponsel modern
    tester.view.physicalSize = const Size(412, 915);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);

    // 1. Render aplikasi utama TokoKita
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    // Verifikasi berada di Beranda dengan judul TokoKita
    expect(find.text('TokoKita'), findsOneWidget);
    expect(find.text('Katalog Produk'), findsOneWidget);

    // 2. Verifikasi 3 Menu BottomNavigationBar (Langkah 5)
    expect(find.text('Beranda'), findsOneWidget);
    expect(find.text('Keranjang'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);

    // 3. Uji perpindahan tab ke Keranjang
    await tester.tap(find.text('Keranjang'));
    await tester.pumpAndSettle();
    expect(find.text('Keranjang Belanja Masih Kosong'), findsOneWidget);

    // 4. Uji perpindahan tab ke Profil
    await tester.tap(find.text('Profil'));
    await tester.pumpAndSettle();
    expect(find.text('Jojo Prawinata Situmeang'), findsOneWidget);
    expect(find.text('NIM: 3337240060 · Teknik Informatika'), findsOneWidget);

    // 5. Kembali ke Beranda
    await tester.tap(find.text('Beranda'));
    await tester.pumpAndSettle();
    expect(find.text('Katalog Produk'), findsOneWidget);

    // 6. Uji Navigasi ke Halaman Detail Produk via Named Route (Langkah 1 & 2)
    final firstProductName = daftarProduk.first.name;
    expect(find.text(firstProductName), findsOneWidget);

    await tester.tap(find.text(firstProductName));
    await tester.pumpAndSettle();

    // Pastikan halaman Detail Produk terbuka
    expect(find.text('Detail Produk'), findsOneWidget);
    expect(find.text('Deskripsi Produk'), findsOneWidget);
    expect(find.text('Tambah ke Keranjang'), findsOneWidget);

    // 7. Uji Stepper Jumlah Pembelian (Tugas Mandiri 1)
    expect(find.text('1'), findsWidgets); // jumlah awal 1
    final addBtn = find.byIcon(Icons.add).last;
    await tester.ensureVisible(addBtn);
    await tester.tap(addBtn);
    await tester.pumpAndSettle();
    expect(find.text('2'), findsWidgets); // bertambah jadi 2

    // 8. Uji Kembali & Mengirim Data Nilai Kembalian (Langkah 3)
    final addToCartBtn = find.text('Tambah ke Keranjang').last;
    await tester.ensureVisible(addToCartBtn);
    await tester.tap(addToCartBtn);
    await tester.pumpAndSettle();

    // Verifikasi kembali ke Beranda dan SnackBar muncul dengan jumlah 2
    expect(find.text('Katalog Produk'), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('Berhasil menambahkan 2 item'), findsOneWidget);
  });
}
