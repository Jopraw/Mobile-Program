// ============================================================
// screens/wishlist_page.dart
// Halaman Wishlist — Pertemuan 9, Langkah 2
// Menampilkan produk yang ID-nya tersimpan di SharedPreferences
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/wishlist_controller.dart';
import '../models/product.dart';
import 'product_detail_page.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = Get.find<WishlistController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        title: const Text(
          'Wishlist Saya',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Obx(() {
        final items = daftarProduk
            .where((p) => wishlist.favoriteIds.contains(p.id))
            .toList();

        if (items.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.favorite_border,
                      size: 72, color: Colors.deepOrange.shade200),
                  const SizedBox(height: 16),
                  const Text(
                    'Wishlist masih kosong',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tekan ikon hati pada produk di Beranda untuk menyimpannya di sini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          separatorBuilder: (context, index) => const SizedBox(height: 10),
          itemBuilder: (context, index) {
            final product = items[index];
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: ListTile(
                onTap: () => Get.to(() => ProductDetailPage(product: product)),
                leading: CircleAvatar(
                  backgroundColor: Colors.deepOrange.withValues(alpha: 0.1),
                  child: const Icon(Icons.favorite, color: Colors.red),
                ),
                title: Text(
                  product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(product.category),
                trailing: IconButton(
                  tooltip: 'Hapus dari Wishlist',
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () => wishlist.removeFromWishlist(product.id),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
