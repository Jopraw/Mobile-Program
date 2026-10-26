// ============================================================
// screens/product_detail_page.dart
// Halaman Detail Produk TokoKita — Pertemuan 7
//
// Tugas Mandiri 1 → Memanfaatkan fetchProductDetail(int id) untuk mengambil
// data produk terkini langsung dari endpoint https://fakestoreapi.com/products/{id}
// ============================================================

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/price_label.dart';
import '../widgets/category_tag.dart';

class ProductDetailPage extends StatefulWidget {
  final Product? product;
  final int? productId;
  final int initialQuantity;

  const ProductDetailPage({
    super.key,
    this.product,
    this.productId,
    this.initialQuantity = 1,
  });

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final ProductService _service = ProductService();
  late int _quantity;
  Future<Product>? _detailFuture;
  Product? _cachedProduct;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_cachedProduct == null) {
      if (widget.product != null) {
        _cachedProduct = widget.product;
      } else {
        final args = ModalRoute.of(context)?.settings.arguments;
        if (args is Product) {
          _cachedProduct = args;
        }
      }

      // Tugas Mandiri 1: Inisialisasi fetchProductDetail dari API jika ID tersedia
      final id = _cachedProduct?.id ?? widget.productId ?? 1;
      _detailFuture = _service.fetchProductDetail(id);
    }
  }

  void _incrementQuantity(int maxStock) {
    if (_quantity < maxStock) {
      setState(() => _quantity++);
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() => _quantity--);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail Produk',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Sinkronisasi dengan API',
            onPressed: () {
              final id = _cachedProduct?.id ?? 1;
              setState(() {
                _detailFuture = _service.fetchProductDetail(id);
              });
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Menyinkronkan data terbaru dari Fake Store API...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),

      // ── Tugas Mandiri 1: FutureBuilder untuk fetchProductDetail(id) ──
      body: FutureBuilder<Product>(
        future: _detailFuture,
        builder: (context, snapshot) {
          // Jika masih loading dan belum ada cache awal, tampilkan spinner
          if (snapshot.connectionState == ConnectionState.waiting && _cachedProduct == null) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.deepOrange),
                  SizedBox(height: 14),
                  Text('Memuat rincian produk dari server...'),
                ],
              ),
            );
          }

          // Gunakan data hasil fetch terbaru dari API jika sukses, atau fallback ke cachedProduct
          final product = snapshot.data ?? _cachedProduct;

          if (product == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 12),
                  const Text('Gagal memuat rincian produk.'),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Kembali'),
                  ),
                ],
              ),
            );
          }

          final hasDiscount = product is DiscountedProduct;
          final double effectivePrice =
              hasDiscount ? product.discountedPrice : product.price;
          final double totalPrice = effectivePrice * _quantity;

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar Produk Jarak Jauh (Network Image)
                      Container(
                        width: double.infinity,
                        height: 250,
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        child: Center(
                          child: product.imageUrl.isNotEmpty && product.imageUrl.startsWith('http')
                              ? Image.network(
                                  product.imageUrl,
                                  fit: BoxFit.contain,
                                  errorBuilder: (context, error, stackTrace) => const Icon(
                                    Icons.image_not_supported_outlined,
                                    size: 64,
                                    color: Colors.grey,
                                  ),
                                )
                              : const Icon(
                                  Icons.shopping_bag_outlined,
                                  size: 80,
                                  color: Colors.deepOrange,
                                ),
                        ),
                      ),

                      // Konten Rincian
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Kategori & Rating
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CategoryTag(category: product.category, fontSize: 12, iconSize: 14),
                                Row(
                                  children: [
                                    const Icon(Icons.star, size: 18, color: Colors.amber),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${product.rating}',
                                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    ),
                                    Text(
                                      ' (${product.ratingCount} ulasan)',
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            // Nama Produk
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121),
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 12),

                            // Harga
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Harga Rupiah (Konversi API)', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                      const SizedBox(height: 2),
                                      PriceLabel(harga: effectivePrice, fontSize: 20),
                                    ],
                                  ),
                                  if (product.rawUsdPrice > 0)
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      children: [
                                        const Text('Harga Asli API', style: TextStyle(fontSize: 11, color: Colors.grey)),
                                        const SizedBox(height: 2),
                                        Text(
                                          '\$ ${product.rawUsdPrice.toStringAsFixed(2)} USD',
                                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.blueGrey),
                                        ),
                                      ],
                                    ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Status Stok
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.inventory_2_outlined, size: 18, color: Colors.green),
                                      const SizedBox(width: 8),
                                      Text(
                                        'Stok Tersedia: ${product.stock} unit',
                                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.green),
                                      ),
                                    ],
                                  ),
                                  const Text('REST API Sync: OK', style: TextStyle(fontSize: 11, color: Colors.blue, fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Deskripsi
                            const Text(
                              'Deskripsi Produk (Fake Store API)',
                              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Text(
                                product.description ?? 'Tidak ada deskripsi dari API.',
                                style: const TextStyle(fontSize: 13, height: 1.6, color: Color(0xFF424242)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Action Bar
              Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
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
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove, size: 16, color: Colors.deepOrange),
                                  onPressed: _decrementQuantity,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 10),
                                  child: Text(
                                    '$_quantity',
                                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add, size: 16, color: Colors.deepOrange),
                                  onPressed: () => _incrementQuantity(product.stock),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text('Total Pembelian', style: TextStyle(fontSize: 11, color: Colors.grey)),
                              PriceLabel(harga: totalPrice, fontSize: 16),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        height: 46,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.deepOrange,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            Navigator.pop(context, _quantity);
                          },
                          icon: const Icon(Icons.add_shopping_cart, size: 18),
                          label: const Text(
                            'Tambah ke Keranjang',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
