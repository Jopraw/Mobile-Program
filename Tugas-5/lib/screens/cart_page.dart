// ============================================================
// screens/cart_page.dart
// Halaman Keranjang Belanja TokoKita — Pertemuan 5
//
// Langkah 5 & Tugas Mandiri 3:
// Halaman placeholder Keranjang pada Bottom Navigation
// dengan judul dan pesan khusus yang berbeda dari menu lainnya
// ============================================================

import 'package:flutter/material.dart';

/// CartPage — Tab Keranjang Belanja TokoKita
class CartPage extends StatelessWidget {
  final VoidCallback? onExplorePressed;

  const CartPage({super.key, this.onExplorePressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Keranjang Belanja',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Kosongkan Keranjang',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Keranjang saat ini kosong.')),
              );
            },
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Ilustrasi Keranjang
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                  size: 72,
                  color: Colors.deepOrange,
                ),
              ),
              const SizedBox(height: 24),

              // Judul & Pesan Placeholder (Tugas Mandiri 3)
              const Text(
                'Keranjang Belanja Masih Kosong',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF212121),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                'Belum ada produk yang ditambahkan ke keranjang belanja Anda.\nPilih produk favorit Anda di Beranda dan tekan "Tambah ke Keranjang".',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),

              // Kartu Ringkasan Belanja Dummy
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: const Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Produk', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        Text('0 item', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Total Estimasi', style: TextStyle(color: Colors.grey, fontSize: 13)),
                        Text('Rp 0', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Colors.deepOrange)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // Tombol Jelajahi Produk
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrange,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                onPressed: () {
                  if (onExplorePressed != null) {
                    onExplorePressed!();
                  } else {
                    // Navigasi kembali ke Beranda (named route '/')
                    Navigator.pushReplacementNamed(context, '/');
                  }
                },
                icon: const Icon(Icons.storefront_outlined),
                label: const Text(
                  'Mulai Belanja Sekarang',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
