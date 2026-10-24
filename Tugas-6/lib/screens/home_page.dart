// ============================================================
// screens/home_page.dart
// Halaman Beranda TokoKita — Pertemuan 6
//
// Langkah 3: Dependency Injection via Get.find() & Badge Keranjang Reaktif via Obx
// Langkah 4: Navigasi ke ProductDetailPage menggunakan Get.to()
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../widgets/product_card.dart';
import '../controllers/cart_controller.dart';
import '../controllers/navigation_controller.dart';

/// HomePage / HalamanUtama — Tab Beranda aplikasi TokoKita
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _selectedCategory = 'Semua';

  final List<String> _categories = [
    'Semua',
    'Elektronik',
    'Pakaian',
    'Makanan',
    'Olahraga',
    'Aksesoris',
  ];

  @override
  Widget build(BuildContext context) {
    // ── Langkah 3: Ambil instance CartController via Get.find() ──
    final CartController cartController = Get.find<CartController>();

    final filteredProducts = _selectedCategory == 'Semua'
        ? daftarProduk
        : daftarProduk.where((p) => p.category.toLowerCase() == _selectedCategory.toLowerCase()).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),

      // ── AppBar TokoKita ──
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
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
              'Belanja jadi lebih mudah & hemat',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          // ── Langkah 3: Ikon Keranjang pada Header dengan Obx & Badge Reaktif ──
          Obx(() {
            final int total = cartController.totalItem;
            return IconButton(
              icon: Badge(
                isLabelVisible: total > 0,
                label: Text(
                  total > 99 ? '99+' : '$total',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                backgroundColor: Colors.white,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              tooltip: 'Keranjang Belanja ($total item)',
              onPressed: () {
                // Beralih ke tab Keranjang via NavigationController
                if (Get.isRegistered<NavigationController>()) {
                  Get.find<NavigationController>().toCart();
                }
              },
            );
          }),

          IconButton(
            icon: const Icon(Icons.notifications_none),
            tooltip: 'Notifikasi',
            onPressed: () {
              Get.snackbar(
                'Notifikasi',
                'Belum ada pemberitahuan baru saat ini.',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.grey.shade800,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
            },
          ),
        ],
      ),

      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Kategori Filter Chips ──
          Container(
            height: 48,
            margin: const EdgeInsets.only(top: 8),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final cat = _categories[index];
                final isSelected = _selectedCategory == cat;
                return ChoiceChip(
                  label: Text(cat),
                  selected: isSelected,
                  selectedColor: Colors.deepOrange,
                  labelStyle: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF424242),
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    fontSize: 12,
                  ),
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    color: isSelected ? Colors.deepOrange : Colors.grey.shade300,
                  ),
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedCategory = cat;
                      });
                    }
                  },
                );
              },
            ),
          ),

          // ── Header Ringkasan Produk ──
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedCategory == 'Semua' ? 'Katalog Produk' : 'Kategori: $_selectedCategory',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      Text(
                        '${filteredProducts.length} produk siap dipesan',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                // Status Keranjang Info Badge
                Obx(() => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shopping_bag_outlined, size: 14, color: Colors.deepOrange),
                          const SizedBox(width: 4),
                          Text(
                            '${cartController.totalItem} di keranjang',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    )),
              ],
            ),
          ),

          // ── Daftar Produk dengan ListView.builder ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.only(top: 4, bottom: 20),
              itemCount: filteredProducts.length,
              itemBuilder: (BuildContext context, int index) {
                // Tiap ProductCard dapat ditekan untuk membuka ProductDetailPage via Get.to()
                return ProductCard(product: filteredProducts[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}
