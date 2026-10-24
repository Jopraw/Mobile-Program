// ============================================================
// widgets/product_card.dart
// Kartu produk TokoKita — Pertemuan 6 (State Management & Routing GetX)
//
// Langkah 3: Reaktivitas tombol tambah cepat ke CartController
// Langkah 4: Navigasi ke ProductDetailPage menggunakan Get.to()
// Tugas Mandiri 4 & 5: Mempertahankan setState untuk status favorit lokal
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/product.dart';
import '../screens/product_detail_page.dart';
import '../controllers/cart_controller.dart';
import 'price_label.dart';
import 'category_tag.dart';

/// ProductCard — Kartu satu produk dalam katalog TokoKita
class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({
    super.key,
    required this.product,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // ── Tugas Mandiri 4 & 5: Local State menggunakan setState ──
  // Status favorit hanya relevan untuk satu widget kartu ini saja (ephemeral/local UI state),
  // sehingga lebih sederhana dan efisien menggunakan setState dibanding GetX global.
  bool isFavorite = false;

  bool get _hasDiscount => widget.product is DiscountedProduct;
  double get _discountPercent =>
      _hasDiscount ? (widget.product as DiscountedProduct).discountPercent : 0;

  Color _stockColor() {
    final s = widget.product.stock;
    if (s > 10) return Colors.green;
    if (s > 0) return Colors.orange;
    return Colors.red;
  }

  String _stockLabel() {
    final s = widget.product.stock;
    if (s > 10) return 'Banyak';
    if (s > 0) return 'Terbatas';
    return 'Habis';
  }

  /// Langkah 4: Navigasi ke halaman detail produk menggunakan Get.to()
  void _navigateToDetail() {
    Get.to(
      () => ProductDetailPage(product: widget.product),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          // Langkah 4: Panggil Get.to() saat kartu ditekan
          onTap: _navigateToDetail,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Bagian Gambar + Badges (Stack) ──
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        color: Colors.deepOrange.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getProductIcon(widget.product.category),
                        size: 38,
                        color: Colors.deepOrange.shade400,
                      ),
                    ),

                    // Badge Diskon (pojok kanan atas)
                    if (_hasDiscount)
                      Positioned(
                        top: -4,
                        right: -4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${_discountPercent.toInt()}%',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // Badge Stok (pojok kiri bawah)
                    Positioned(
                      bottom: -4,
                      left: -4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: _stockColor(),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          _stockLabel(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(width: 14),

                // ── Bagian Detail Teks (Expanded Column) ──
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama produk
                      Text(
                        widget.product.name,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),

                      // Harga
                      if (_hasDiscount) ...[
                        Wrap(
                          spacing: 6,
                          runSpacing: 2,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            PriceLabel(
                              harga:
                                  (widget.product as DiscountedProduct)
                                      .discountedPrice,
                              fontSize: 14,
                            ),
                            Text(
                              'Rp ${widget.product.price.toStringAsFixed(0)}',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.grey.shade500,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        PriceLabel(
                          harga: widget.product.price,
                          fontSize: 14,
                        ),
                      ],

                      const SizedBox(height: 6),

                      // Tag Kategori
                      CategoryTag(category: widget.product.category),

                      // Deskripsi singkat
                      if (widget.product.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          widget.product.description!,
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // ── Kolom Aksi Kanan (Favorit & Quick Add Cart) ──
                Column(
                  children: [
                    // Tombol Favorit (menggunakan setState)
                    IconButton(
                      tooltip: isFavorite ? 'Hapus Favorit' : 'Tambah Favorit',
                      onPressed: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                      },
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                        size: 22,
                      ),
                    ),

                    // Quick Add to Cart via GetX CartController
                    IconButton(
                      tooltip: 'Tambah ke Keranjang',
                      onPressed: () {
                        cartController.addToCart(widget.product, quantity: 1);
                      },
                      icon: const Icon(
                        Icons.add_shopping_cart,
                        size: 20,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
