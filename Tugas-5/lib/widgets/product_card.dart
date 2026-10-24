// ============================================================
// widgets/product_card.dart
// Kartu produk TokoKita — Pertemuan 5 (Navigasi & Routing)
//
// Langkah 1 & 2: onTap kartu membuka ProductDetailPage via named route '/detail'
// Langkah 3: Menerima nilai kembalian pop (jumlah item) dan memicu SnackBar
// ============================================================

import 'package:flutter/material.dart';
import '../models/product.dart';
import 'price_label.dart';
import 'category_tag.dart';

/// ProductCard — Kartu satu produk dalam daftar TokoKita
class ProductCard extends StatefulWidget {
  final Product product;
  final Function(int count, Product product)? onAddToCartReturn;

  const ProductCard({
    super.key,
    required this.product,
    this.onAddToCartReturn,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // State internal: status favorit
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

  /// Navigasi ke halaman detail produk via Named Routes (Langkah 2 & 3)
  Future<void> _navigateToDetail() async {
    // Langkah 2: Menggunakan named routes '/detail' dengan argument data produk
    // Langkah 3: await hasil Navigator.pop dari ProductDetailPage
    final result = await Navigator.pushNamed(
      context,
      '/detail',
      arguments: widget.product,
    );

    // Pastikan widget masih aktif setelah async gap
    if (!mounted) return;

    // Jika user menambahkan ke keranjang dan menekan tombol di detail page
    if (result != null && result is int && result > 0) {
      if (widget.onAddToCartReturn != null) {
        widget.onAddToCartReturn!(result, widget.product);
      } else {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle_outline, color: Colors.white),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Berhasil menambahkan $result item (${widget.product.name}) ke keranjang!',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
            backgroundColor: const Color(0xFF2E7D32),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Lihat',
              textColor: Colors.yellowAccent,
              onPressed: () {},
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          // Langkah 1 & 2: Aksi ketika kartu ditekan
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
                          fontSize: 15,
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
                              fontSize: 15,
                            ),
                            Text(
                              'Rp ${widget.product.price.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ] else ...[
                        PriceLabel(
                          harga: widget.product.price,
                          fontSize: 15,
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
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),

                // ── Tombol Favorit (terisolasi dari onTap kartu) ──
                IconButton(
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
