import 'package:flutter/material.dart';
import '../models/product.dart';
import 'price_label.dart';
import 'stock_badge.dart';
import 'category_tag.dart';

/// ProductCard - Widget kartu produk untuk aplikasi TokoKita
///
/// Langkah 1: Awalnya dibuat sebagai StatelessWidget
/// Langkah 2: Diubah menjadi StatefulWidget agar bisa menyimpan
///            status favorit (isFavorite) secara lokal
///
/// StatefulWidget dipilih karena widget ini memiliki state internal
/// yang bisa berubah (isFavorite), sehingga perlu memanggil setState()
/// untuk membangun ulang tampilan saat tombol favorit ditekan.
class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  // State internal: status favorit produk
  bool isFavorite = false;

  // --- LIFECYCLE METHODS ---

  @override
  void initState() {
    super.initState();
    // initState() dipanggil SEKALI saat widget pertama kali dibuat
    print('initState() dipanggil untuk: ${widget.product.name}');
  }

  @override
  Widget build(BuildContext context) {
    // build() dipanggil setiap kali widget perlu digambar ulang
    // (termasuk setelah setState() dipanggil)
    print('build() dipanggil untuk: ${widget.product.name}');

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Placeholder gambar produk (Icon)
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.image_outlined,
                size: 36,
                color: Colors.grey,
              ),
            ),

            const SizedBox(width: 12),

            // Informasi produk
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Nama produk
                  Text(
                    widget.product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Harga produk menggunakan widget PriceLabel (Langkah 3)
                  PriceLabel(harga: widget.product.price),
                  const SizedBox(height: 6),

                  // Baris bawah: CategoryTag & StockBadge (Langkah 3)
                  Row(
                    children: [
                      CategoryTag(category: widget.product.category),
                      const SizedBox(width: 8),
                      StockBadge(stock: widget.product.stock),
                    ],
                  ),
                ],
              ),
            ),

            // Tombol Favorit (Langkah 2)
            // Memanggil setState() untuk mengubah isFavorite
            IconButton(
              onPressed: () {
                setState(() {
                  isFavorite = !isFavorite;
                });
                print(
                  'Tombol favorit ditekan! ${widget.product.name} '
                  '-> isFavorite: $isFavorite',
                );
              },
              icon: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: isFavorite ? Colors.red : Colors.grey,
                size: 28,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // dispose() dipanggil saat widget dihapus dari widget tree secara permanen
    print('dispose() dipanggil untuk: ${widget.product.name}');
    super.dispose();
  }
}
