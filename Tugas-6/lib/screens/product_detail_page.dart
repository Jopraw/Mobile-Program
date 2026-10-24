// ============================================================
// screens/product_detail_page.dart
// Halaman Detail Produk TokoKita — Pertemuan 6
//
// Langkah 3: Dependency Injection Get.find<CartController>() & Badge Reaktif via Obx
// Langkah 3: Tombol 'Tambah ke Keranjang' memanggil cartController.addToCart()
// Langkah 4: Navigasi kembali menggunakan Get.back()
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../controllers/cart_controller.dart';
import '../controllers/navigation_controller.dart';
import '../widgets/price_label.dart';
import '../widgets/category_tag.dart';
import 'checkout_page.dart';

/// ProductDetailPage — Menampilkan detail lengkap produk dan aksi belanja.
class ProductDetailPage extends StatefulWidget {
  final Product? product;
  final int initialQuantity;

  const ProductDetailPage({
    super.key,
    this.product,
    this.initialQuantity = 1,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  /// Mendapatkan objek Product (dari parameter widget atau Get.arguments)
  Product _getProduct() {
    if (widget.product != null) {
      return widget.product!;
    }
    if (Get.arguments != null && Get.arguments is Product) {
      return Get.arguments as Product;
    }
    final modalArgs = ModalRoute.of(context)?.settings.arguments;
    if (modalArgs != null && modalArgs is Product) {
      return modalArgs;
    }
    return daftarProduk.first;
  }

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

  void _incrementQuantity(int maxStock) {
    if (maxStock <= 0) return;
    if (_quantity < maxStock) {
      setState(() {
        _quantity++;
      });
    } else {
      Get.snackbar(
        'Batas Stok',
        'Maksimal pembelian $maxStock unit sesuai stok tersedia.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
      );
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  Color _getStockColor(int stock) {
    if (stock > 10) return Colors.green;
    if (stock > 0) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    // ── Langkah 3: Ambil instance CartController via Get.find() ──
    final CartController cartController = Get.find<CartController>();
    final Product product = _getProduct();
    final DiscountedProduct? discounted =
        product is DiscountedProduct ? product : null;
    final bool hasDiscount = discounted != null;
    final double activePrice = discounted?.discountedPrice ?? product.price;
    final double subtotal = activePrice * _quantity;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        // ── Langkah 4: Navigasi kembali menggunakan Get.back() ──
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Kembali (Get.back)',
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Detail Produk',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          // ── Langkah 3: Ikon Keranjang pada AppBar dengan Obx & Badge Reaktif ──
          Obx(() {
            final int count = cartController.totalItem;
            return IconButton(
              icon: Badge(
                isLabelVisible: count > 0,
                label: Text(
                  count > 99 ? '99+' : '$count',
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepOrange,
                  ),
                ),
                backgroundColor: Colors.white,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              tooltip: 'Keranjang Belanja ($count item)',
              onPressed: () {
                // Berpindah ke tab Keranjang
                if (Get.isRegistered<NavigationController>()) {
                  Get.find<NavigationController>().toCart();
                }
                Get.back(); // Kembali ke MainPage pada tab Keranjang
              },
            );
          }),
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Bagikan',
            onPressed: () {
              Get.snackbar(
                'Bagikan Produk',
                'Tautan ${product.name} telah disalin.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.grey.shade800,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Gambar Produk Utama
            Container(
              width: double.infinity,
              height: 260,
              color: Colors.white,
              child: Stack(
                children: [
                  Center(
                    child: Hero(
                      tag: 'product-${product.id}',
                      child: Container(
                        width: 140,
                        height: 140,
                        decoration: BoxDecoration(
                          color: Colors.deepOrange.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          _getProductIcon(product.category),
                          size: 72,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ),
                  ),

                  // Badge Diskon Besar
                  if (hasDiscount)
                    Positioned(
                      top: 16,
                      left: 16,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.red.withValues(alpha: 0.3),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          'DISKON ${discounted.discountPercent.toInt()}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Status Stok
                  Positioned(
                    bottom: 16,
                    left: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: _getStockColor(product.stock),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.inventory_2_outlined, size: 14, color: Colors.white),
                          const SizedBox(width: 4),
                          Text(
                            'Stok: ${product.stock} (${product.getStatusStok()})',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Kontainer Informasi Produk
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CategoryTag(category: product.category),
                  const SizedBox(height: 8),

                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 10),

                  // Harga & Diskon
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      PriceLabel(harga: activePrice, fontSize: 22),
                      if (hasDiscount) ...[
                        const SizedBox(width: 10),
                        Text(
                          _formatRupiah(product.price),
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                  const Divider(height: 24),

                  // Deskripsi
                  const Text(
                    'Deskripsi Produk',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    product.description ?? 'Belum ada deskripsi lengkap untuk produk ini.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade700,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Stepper Jumlah Pembelian & Info Subtotal
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Jumlah Pembelian',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Stepper (- / +)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: product.stock > 0 ? _decrementQuantity : null,
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              child: Text(
                                '$_quantity',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: product.stock > 0
                                  ? () => _incrementQuantity(product.stock)
                                  : null,
                            ),
                          ],
                        ),
                      ),

                      // Kalkulasi Subtotal
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Subtotal:',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                          Text(
                            _formatRupiah(subtotal),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.deepOrange,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100), // Spasi untuk bottom bar
          ],
        ),
      ),

      // ── Langkah 3 & 4: Bottom Action Bar ──
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // ── Langkah 3: Tombol Tambah ke Keranjang (GetX CartController) ──
              Expanded(
                flex: 1,
                child: OutlinedButton.icon(
                  // Hubungkan langsung ke CartController.addToCart tanpa setState
                  onPressed: product.stock > 0
                      ? () {
                          cartController.addToCart(product, quantity: _quantity);
                        }
                      : null,
                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                  label: const Text(
                    'Tambah ke Keranjang',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.deepOrange,
                    side: const BorderSide(color: Colors.deepOrange, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Tombol Beli Sekarang (Direct Checkout)
              Expanded(
                flex: 1,
                child: ElevatedButton(
                  onPressed: product.stock > 0
                      ? () {
                          cartController.addToCart(product,
                              quantity: _quantity, showNotification: false);
                          Get.to(() => const CheckoutPage());
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Beli Sekarang',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getProductIcon(String category) {
    switch (category) {
      case 'Elektronik':
        return Icons.devices;
      case 'Fashion':
      case 'Pakaian':
        return Icons.checkroom;
      case 'Makanan':
        return Icons.restaurant;
      case 'Olahraga':
        return Icons.sports_soccer;
      default:
        return Icons.shopping_bag_outlined;
    }
  }
}
