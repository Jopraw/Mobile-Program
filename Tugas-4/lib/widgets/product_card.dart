// ============================================================
// widgets/product_card.dart
// Kartu produk utama — StatefulWidget (ada tombol favorit)
//
// Pertemuan 4 — Perubahan dari Pertemuan 3:
//   Langkah 2 → Container dengan padding, shadow, borderRadius
//   Langkah 3 → Stack + Positioned untuk badge diskon & badge stok
//   Langkah 5 → Expanded pada Column info produk
// ============================================================

import 'package:flutter/material.dart';
import '../models/product.dart';
import 'price_label.dart';
import 'category_tag.dart';

/// ProductCard — kartu satu produk dalam daftar TokoKita
///
/// StatefulWidget dipilih karena menyimpan state [isFavorite]
/// yang bisa berubah saat tombol favorit ditekan (setState).
class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // ── State internal: status favorit ──
  bool isFavorite = false;

  // ── LIFECYCLE ──

  @override
  void initState() {
    super.initState();
    // dipanggil SEKALI saat widget pertama kali dibuat
    debugPrint('initState() → ${widget.product.name}');
  }

  @override
  void dispose() {
    // dipanggil saat widget dihapus dari widget tree
    debugPrint('dispose() → ${widget.product.name}');
    super.dispose();
  }

  // ── Getter: apakah produk ini DiscountedProduct? ──
  bool get _hasDiscount => widget.product is DiscountedProduct;
  double get _discountPercent =>
      _hasDiscount ? (widget.product as DiscountedProduct).discountPercent : 0;

  // ── Helper: warna & label StockBadge ──
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

  @override
  Widget build(BuildContext context) {
    debugPrint('build() → ${widget.product.name}');

    // ── Langkah 2: Container sebagai pembungkus utama ──
    // Container memberi margin antar kartu, warna latar, sudut
    // membulat, dan BoxShadow agar terlihat "terangkat".
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        // BoxShadow → memberikan efek bayangan / elevasi
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      // Padding dalam Container
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          // Row utama: [Gambar] | [Info Produk] | [Tombol Favorit]
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Langkah 3: Stack untuk gambar + badge ──
            // Stack memungkinkan badge ditumpuk di atas gambar.
            Stack(
              clipBehavior: Clip.none,
              children: [
                // Layer bawah: placeholder gambar produk
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.image_outlined,
                    size: 36,
                    color: Colors.grey,
                  ),
                ),

                // Layer atas (Langkah 3): Badge DISKON di pojok kanan atas
                // Positioned hanya ditampilkan bila produk punya diskon
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

                // Tugas Mandiri 2: Badge STOK di pojok kiri bawah
                // Positioned di posisi berbeda dari badge diskon
                Positioned(
                  bottom: -4,
                  left: -4,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 5,
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

            // ── Langkah 5: Expanded pada Column info produk ──
            // Expanded mengisi SEMUA sisa ruang horizontal di Row,
            // sehingga teks panjang tidak menyebabkan overflow.
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
                    ),
                    // maxLines + overflow → antisipasi nama produk panjang
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),

                  // Harga produk (pakai PriceLabel dari Pertemuan 3)
                  PriceLabel(harga: widget.product.price),

                  // Jika produk punya diskon, tampilkan harga coret + harga diskon
                  if (_hasDiscount) ...[
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          'Rp ${widget.product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const SizedBox(width: 6),
                        PriceLabel(
                          harga:
                              (widget.product as DiscountedProduct)
                                  .discountedPrice,
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 6),

                  // Tag kategori (widget custom dari Pertemuan 3)
                  CategoryTag(category: widget.product.category),

                  // Deskripsi produk (jika ada)
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

            // Tombol Favorit (Pertemuan 3 — StatefulWidget)
            IconButton(
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
                debugPrint(
                  'Favorit ditekan! ${widget.product.name} → $isFavorite',
                );
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
                size: 24,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
