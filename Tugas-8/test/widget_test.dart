import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kantin_untirta/main.dart';

void main() {
  testWidgets('Halaman Daftar Menu tampil dengan benar', (tester) async {
    await tester.pumpWidget(const KantinApp());
    await tester.pumpAndSettle();

    // Verifikasi AppBar title
    expect(find.text('Menu Kantin Untirta'), findsOneWidget);

    // Verifikasi data awal minimal 5 menu
    expect(find.text('Nasi Goreng Spesial'), findsOneWidget);
    expect(find.text('Mie Ayam Bakso'), findsOneWidget);
    expect(find.text('Ayam Geprek Sambal Matah'), findsOneWidget);
    expect(find.text('Soto Betawi'), findsOneWidget);
    expect(find.text('Es Teh Manis'), findsOneWidget);

    // Verifikasi FAB ada
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('Navigasi ke halaman detail menu', (tester) async {
    await tester.pumpWidget(const KantinApp());
    await tester.pumpAndSettle();

    // Tap item pertama
    await tester.tap(find.text('Nasi Goreng Spesial'));
    await tester.pumpAndSettle();

    // Verifikasi halaman detail tampil
    expect(find.text('Detail Menu'), findsOneWidget);
    expect(find.text('Nasi Goreng Spesial'), findsOneWidget);
    expect(find.text('Rp 15.000'), findsOneWidget);
  });

  testWidgets('Navigasi ke halaman tambah menu', (tester) async {
    await tester.pumpWidget(const KantinApp());
    await tester.pumpAndSettle();

    // Tap FAB
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verifikasi halaman tambah menu tampil
    expect(find.text('Tambah Menu Baru'), findsOneWidget);
    expect(find.text('Simpan Menu'), findsOneWidget);
  });

  testWidgets('Validasi form tambah menu - kolom kosong', (tester) async {
    await tester.pumpWidget(const KantinApp());
    await tester.pumpAndSettle();

    // Buka halaman tambah
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Langsung tap simpan tanpa isi form
    await tester.tap(find.text('Simpan Menu'));
    await tester.pumpAndSettle();

    // Verifikasi pesan validasi
    expect(find.text('Nama menu tidak boleh kosong'), findsOneWidget);
    expect(find.text('Harga tidak boleh kosong'), findsOneWidget);
  });

  testWidgets('Form tambah menu menerima input dan validasi berhasil', (tester) async {
    await tester.pumpWidget(const KantinApp());
    await tester.pumpAndSettle();

    // Buka halaman tambah
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Isi form
    await tester.enterText(find.byType(TextFormField).at(0), 'Bakso Urat');
    await tester.enterText(find.byType(TextFormField).at(1), '13000');
    await tester.pumpAndSettle();

    // Verifikasi input terisi
    expect(find.text('Bakso Urat'), findsOneWidget);
    expect(find.text('13000'), findsOneWidget);

    // Tap simpan — tidak menghasilkan error validasi
    await tester.tap(find.text('Simpan Menu'));
    await tester.pumpAndSettle();

    // Tidak ada pesan error validasi yang muncul
    expect(find.text('Nama menu tidak boleh kosong'), findsNothing);
    expect(find.text('Harga tidak boleh kosong'), findsNothing);
  });
}
