// ============================================================
// screens/home_page.dart
// Halaman utama aplikasi TokoKita — Pertemuan 4
//
// Langkah 1 → Header dengan Row (spaceBetween) & Column (start)
// Langkah 4 → Daftar produk dengan ListView.builder
// ============================================================

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';

/// HalamanUtama — Halaman utama aplikasi TokoKita
///
/// StatelessWidget karena halaman ini sendiri tidak menyimpan
/// state (state favorit ada di dalam masing-masing ProductCard).
class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      // ── AppBar standar Flutter ──
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        // Langkah 1: Judul AppBar menggunakan Column (nama toko + subjudul)
        title: Column(
          // crossAxisAlignment.start → ratakan ke kiri (sumbu silang = horizontal)
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'TokoKita',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Belanja jadi lebih mudah',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        // Langkah 1: Row otomatis dibuat AppBar → [title] spaceBetween [actions]
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            tooltip: 'Keranjang',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Cari produk',
            onPressed: () {},
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header bagian badan halaman ──
          // Langkah 1: Row dengan mainAxisAlignment.spaceBetween
          // agar teks kiri dan tombol kanan berada di ujung berlawanan
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
            child: Row(
              // mainAxisAlignment.spaceBetween → elemen pertama & terakhir
              // menempel ke tepi, sisanya merata di antara keduanya
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              // crossAxisAlignment.center → semua anak sejajar vertikal tengah
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Langkah 1: Column untuk judul & subjudul bagian produk
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Semua Produk',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                    Text(
                      '15 item tersedia',
                      style: TextStyle(fontSize: 13, color: Colors.grey),
                    ),
                  ],
                ),
                // Tombol filter di sisi kanan (pasangan Row spaceBetween)
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list, size: 16),
                  label: const Text('Filter'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.deepOrange,
                    side: const BorderSide(color: Colors.deepOrange),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    textStyle: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
          ),

          // ── Langkah 4: ListView.builder untuk daftar produk ──
          // Expanded diperlukan agar ListView mengisi sisa ruang
          // di dalam Column tanpa menyebabkan layout error.
          Expanded(
            child: ListView.builder(
              // padding atas/bawah agar produk pertama/terakhir tidak
              // terlalu rapat ke tepi layar
              padding: const EdgeInsets.only(top: 4, bottom: 16),

              // itemCount = jumlah item yang akan dibuat
              itemCount: daftarProduk.length,

              // ListView.builder hanya memanggil itemBuilder untuk item
              // yang SAAT INI terlihat di layar (lazy loading).
              // Ini jauh lebih efisien daripada ListView biasa yang
              // membuat SEMUA item sekaligus saat aplikasi dimulai.
              itemBuilder: (BuildContext context, int index) {
                return ProductCard(product: daftarProduk[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
