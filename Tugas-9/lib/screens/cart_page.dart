// ============================================================
// screens/cart_page.dart
// Halaman Keranjang Belanja TokoKita — Pertemuan 6
//
// Langkah 3: Ambil instance CartController via Get.find()
// Langkah 5: Tampilan daftar belanja nyata dengan Obx & ListView.builder
// Tugas Mandiri 1: Ubah kuantitas per item (+ / -) dengan update totalHarga otomatis
// Tugas Mandiri 2: Tombol 'Kosongkan Keranjang' dengan dialog konfirmasi
// Tugas Mandiri 3: Tombol Lanjut ke Checkout menuju CheckoutPage
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/navigation_controller.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import 'checkout_page.dart';

/// CartPage — Menampilkan isi keranjang belanja secara reaktif menggunakan GetX.
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  String _formatRupiah(double amount) {
    final int val = amount.round();
    final String s = val.toString();
    final StringBuffer sb = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      sb.write(s[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        sb.write('.');
      }
    }
    return 'Rp ${sb.toString().split('').reversed.join('')}';
  }

  @override
  Widget build(BuildContext context) {
    // ── Langkah 3: Dependency Injection via Get.find() ──
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Keranjang Belanja',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // Langkah 3: Subtitle reaktif menunjukkan jumlah item
            Obx(() => Text(
                  '${cartController.totalItem} barang di keranjang',
                  style: const TextStyle(fontSize: 12, color: Colors.white70),
                )),
          ],
        ),
        actions: [
          // Tugas Mandiri 2: Tombol Kosongkan Keranjang dengan konfirmasi
          Obx(() {
            if (cartController.isCartEmpty) {
              return const SizedBox.shrink();
            }
            return IconButton(
              icon: const Icon(Icons.delete_sweep_outlined),
              tooltip: 'Kosongkan Keranjang',
              onPressed: () => cartController.confirmClearCart(),
            );
          }),
        ],
      ),

      // ── Langkah 5 & Obx: Mengamati perubahan state keranjang ──
      body: Obx(() {
        if (cartController.isCartEmpty) {
          return _buildEmptyCart(context);
        }

        return Column(
          children: [
            // Bar Informasi Penghematan (jika ada diskon)
            if (cartController.totalHemat > 0)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Colors.green.shade50,
                child: Row(
                  children: [
                    Icon(Icons.discount_outlined, size: 16, color: Colors.green.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Anda hemat ${_formatRupiah(cartController.totalHemat)} untuk pesanan ini!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.green.shade800,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            // Daftar Item Keranjang
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: cartController.items.length,
                separatorBuilder: (context, index) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final cartItem = cartController.items[index];
                  return _buildCartItemCard(context, cartController, cartItem);
                },
              ),
            ),

            // ── Langkah 5 & Tugas Mandiri 3: Bottom Summary Bar ──
            _buildBottomSummary(context, cartController),
          ],
        );
      }),
    );
  }

  /// Tampilan ketika keranjang masih kosong
  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.deepOrange.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.remove_shopping_cart_outlined,
                size: 68,
                color: Colors.deepOrange,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Keranjang Belanja Masih Kosong',
              style: TextStyle(
                fontSize: 19,
                fontWeight: FontWeight.bold,
                color: Color(0xFF212121),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Yuk cari dan pilih barang impian Anda di katalog\ndan tambahkan ke keranjang belanja!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Berpindah kembali ke tab Beranda
                if (Get.isRegistered<NavigationController>()) {
                  Get.find<NavigationController>().toHome();
                }
              },
              icon: const Icon(Icons.storefront_outlined),
              label: const Text('Mulai Belanja'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Kartu untuk satu item belanja di dalam keranjang
  Widget _buildCartItemCard(
    BuildContext context,
    CartController controller,
    CartItem item,
  ) {
    final product = item.product;
    final isDiscounted = product is DiscountedProduct;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Gambar / Placeholder Produk
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: Colors.deepOrange.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: Icon(
                    Icons.inventory_2_outlined,
                    size: 36,
                    color: Colors.deepOrange.shade400,
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Detail Informasi Produk
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Kategori Produk
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product.category,
                        style: TextStyle(fontSize: 10, color: Colors.grey.shade700),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Nama Produk
                    Text(
                      product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF212121),
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Harga Satuan & Diskon
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      spacing: 6,
                      children: [
                        Text(
                          _formatRupiah(item.unitPrice),
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                        if (isDiscounted)
                          Text(
                            _formatRupiah(product.price),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade500,
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),

              // Langkah 5: Tombol Hapus Produk dari Keranjang
              IconButton(
                icon: const Icon(Icons.delete_outline, size: 20),
                color: Colors.red.shade400,
                tooltip: 'Hapus Item',
                onPressed: () => controller.confirmRemoveSingleItem(product),
              ),
            ],
          ),

          const Divider(height: 16),

          // Tugas Mandiri 1: Stepper Pengubah Jumlah (Quantity) & Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Subtotal Item
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Subtotal',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                  Obx(() => Text(
                        _formatRupiah(item.subtotal),
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      )),
                ],
              ),

              // Stepper Kuantitas (+ / -)
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    // Tombol Kurang (-)
                    InkWell(
                      borderRadius: const BorderRadius.horizontal(left: Radius.circular(8)),
                      onTap: () => controller.decreaseQuantity(product),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Icon(
                          item.quantity.value == 1 ? Icons.delete_outline : Icons.remove,
                          size: 16,
                          color: item.quantity.value == 1 ? Colors.red : Colors.grey.shade800,
                        ),
                      ),
                    ),

                    // Nilai Kuantitas Reaktif
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Obx(() => Text(
                            '${item.quantity.value}',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          )),
                    ),

                    // Tombol Tambah (+)
                    InkWell(
                      borderRadius: const BorderRadius.horizontal(right: Radius.circular(8)),
                      onTap: () => controller.increaseQuantity(product),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: Icon(
                          Icons.add,
                          size: 16,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Panel Ringkasan Harga di Bawah Layar & Tombol Checkout
  Widget _buildBottomSummary(BuildContext context, CartController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Belanja (${controller.totalItem} item)',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      // Langkah 5: Total Harga Reaktif
                      Text(
                        _formatRupiah(controller.totalHarga),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepOrange,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),

                // Tugas Mandiri 3: Tombol Lanjut ke Checkout
                ElevatedButton.icon(
                  onPressed: () {
                    Get.to(
                      () => const CheckoutPage(),
                      transition: Transition.rightToLeft,
                    );
                  },
                  icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                  label: const Text(
                    'Checkout',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
