import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/menu_item.dart';
import '../widgets/kantin_text.dart';

/// Halaman Detail Menu — menampilkan nama dan harga menu yang dipilih.
/// Struktur bebas (tidak ditentukan diagram), tetapi harus bisa kembali ke daftar.
class DetailMenuPage extends StatelessWidget {
  final MenuItem menu;

  const DetailMenuPage({super.key, required this.menu});

  /// Format harga ke Rupiah
  String _formatRupiah(int harga) {
    String angka = harga.toString();
    String hasil = '';
    int count = 0;
    for (int i = angka.length - 1; i >= 0; i--) {
      hasil = angka[i] + hasil;
      count++;
      if (count % 3 == 0 && i != 0) {
        hasil = '.$hasil';
      }
    }
    return 'Rp $hasil';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        title: KantinText(
          'Detail Menu',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.restaurant,
                    size: 64,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(height: 20),
                  KantinText(
                    menu.nama,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: KantinText(
                      _formatRupiah(menu.harga),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.arrow_back),
                    label: KantinText(
                      'Kembali ke Daftar',
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
