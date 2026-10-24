// ============================================================
// screens/product_detail_page.dart
// Halaman Detail Produk TokoKita — Pertemuan 5
//
// Langkah 1 → Navigator dasar (menerima Product, tombol back via pop)
// Langkah 2 → Mendukung Named Route '/detail' melalui ModalRoute arguments
// Langkah 3 → Tombol 'Tambah ke Keranjang' mengembalikan jumlah via Navigator.pop(context, jumlah)
// Tugas Mandiri 1 → Layout rapi dengan stepper jumlah & kalkulasi subtotal
// Bonus PPT 5 → Layout responsif (LayoutBuilder untuk phone vs tablet/landscape)
// ============================================================

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/price_label.dart';
import '../widgets/category_tag.dart';

/// ProductDetailPage — Menampilkan detail lengkap informasi produk
class ProductDetailPage extends StatefulWidget {
  final Product? product;
  final int initialQuantity;

  const ProductDetailPage({super.key, this.product, this.initialQuantity = 1});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  // Stepper jumlah barang (Tugas Mandiri 1)
  late int _quantity;

  @override
  void initState() {
    super.initState();
    _quantity = widget.initialQuantity;
  }

  // Mendapatkan objek Product (bisa dari constructor atau named route arguments)
  Product _getProduct(BuildContext context) {
    if (widget.product != null) {
      return widget.product!;
    }
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args != null && args is Product) {
      return args;
    }
    // Fallback jika tidak ada argumen
    return daftarProduk.first;
  }

  void _incrementQuantity(int maxStock) {
    if (maxStock <= 0) return;
    if (_quantity < maxStock) {
      setState(() {
        _quantity++;
      });
    } else {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Maksimal pembelian $maxStock unit (sesuai stok tersedia)'),
          duration: const Duration(seconds: 2),
        ),
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

  @override
  Widget build(BuildContext context) {
    final product = _getProduct(context);
    final hasDiscount = product is DiscountedProduct;
    final double discountPercent =
        hasDiscount ? product.discountPercent : 0.0;
    final double effectivePrice =
        hasDiscount ? product.discountedPrice : product.price;
    final double totalPrice = effectivePrice * _quantity;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        // Langkah 1: Tombol Back otomatis disediakan AppBar atau eksplisit via Navigator.pop
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Kembali ke Beranda',
          onPressed: () {
            // Navigator.pop kembali ke halaman sebelumnya
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Detail Produk',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Bagikan',
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            tooltip: 'Keranjang',
            onPressed: () {},
          ),
        ],
      ),

      // ── Tata Letak Responsif (Bonus PPT Pertemuan 5) ──
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 600;

          if (isWide) {
            // Tablet / Landscape: 2 Kolom berdampingan
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Kolom Kiri: Gambar Produk & Badge
                Expanded(
                  flex: 5,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: _buildImageSection(product, hasDiscount, discountPercent),
                  ),
                ),
                const VerticalDivider(width: 1),
                // Kolom Kanan: Rincian Produk, Stepper, & Tombol Aksi
                Expanded(
                  flex: 6,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildProductDetails(product, hasDiscount, discountPercent, effectivePrice),
                        const SizedBox(height: 24),
                        _buildQuantityStepper(product.stock, totalPrice),
                        const SizedBox(height: 24),
                        _buildAddToCartButton(product),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          // Ponsel: 1 Kolom vertikal yang nyaman di-scroll
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar Produk di bagian atas
                      _buildImageSection(product, hasDiscount, discountPercent),

                      // Card Konten Rincian Produk
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: _buildProductDetails(
                          product,
                          hasDiscount,
                          discountPercent,
                          effectivePrice,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Bottom Action Bar (Stepper + Tombol Tambah ke Keranjang)
              _buildBottomBar(product, totalPrice),
            ],
          );
        },
      ),
    );
  }

  /// Widget Gambar Produk dengan Stack Badge
  Widget _buildImageSection(Product product, bool hasDiscount, double discountPercent) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 220,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.deepOrange.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Icon(
                  _getProductIcon(product.category),
                  size: 96,
                  color: Colors.deepOrange.shade300,
                ),
              ),
            ),

            // Badge Diskon (Pojok Kanan Atas)
            if (hasDiscount)
              Positioned(
                top: 12,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.withValues(alpha: 0.4),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'HEMAT ${discountPercent.toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            // Badge Kategori (Pojok Kiri Atas)
            Positioned(
              top: 12,
              left: 12,
              child: CategoryTag(category: product.category, fontSize: 12, iconSize: 14),
            ),
          ],
        ),
      ),
    );
  }

  /// Widget Rincian Informasi Produk
  Widget _buildProductDetails(
    Product product,
    bool hasDiscount,
    double discountPercent,
    double effectivePrice,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Nama Produk
        Text(
          product.name,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
            height: 1.3,
          ),
        ),
        const SizedBox(height: 12),

        // Harga & Diskon
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Wrap(
            spacing: 16,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Harga Satuan',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 2),
                  PriceLabel(
                    harga: effectivePrice,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
              if (hasDiscount)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Harga Asli',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Rp ${product.price.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Status Stok & Informasi Garansi
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.inventory_2_outlined,
                      size: 18,
                      color: _getStockColor(product.stock),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        'Stok: ${product.stock} unit (${product.getStatusStok()})',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _getStockColor(product.stock),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              const Row(
                children: [
                  Icon(Icons.verified_outlined, size: 16, color: Colors.blue),
                  SizedBox(width: 4),
                  Text(
                    'Original 100%',
                    style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // Deskripsi Lengkap Produk
        const Text(
          'Deskripsi Produk',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
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
            product.description ?? 'Tidak ada deskripsi detail untuk produk ini.',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF424242),
              height: 1.6,
            ),
          ),
        ),
        const SizedBox(height: 18),

        // Fitur / Layanan Belanja
        const Text(
          'Layanan & Pengiriman',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Column(
            children: [
              Row(
                children: [
                  Icon(Icons.local_shipping_outlined, size: 20, color: Colors.deepOrange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text('Bebas Ongkir ke Seluruh Indonesia', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
              Divider(height: 16),
              Row(
                children: [
                  Icon(Icons.security_outlined, size: 20, color: Colors.deepOrange),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text('Garansi Resmi & Bebas Pengembalian 7 Hari', style: TextStyle(fontSize: 13)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Stepper Jumlah Barang (Tugas Mandiri 1)
  Widget _buildQuantityStepper(int stock, double totalPrice) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Atur Jumlah Pembelian',
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Kontrol Kurang - Nilai - Tambah
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, size: 18),
                      onPressed: stock > 0 ? _decrementQuantity : null,
                      color: Colors.deepOrange,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, size: 18),
                      onPressed: stock > 0 ? () => _incrementQuantity(stock) : null,
                      color: Colors.deepOrange,
                    ),
                  ],
                ),
              ),

              // Total Harga Dinamis
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Total Pembelian', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  PriceLabel(harga: totalPrice, fontSize: 17),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Tombol Tambah ke Keranjang untuk tampilan Wide / Tablet
  Widget _buildAddToCartButton(Product product) {
    final isOutOfStock = product.stock <= 0;

    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: isOutOfStock ? Colors.grey : Colors.deepOrange,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 2,
        ),
        // Langkah 3: Navigator.pop mengembalikan nilai _quantity
        onPressed: isOutOfStock
            ? null
            : () {
                Navigator.pop(context, _quantity);
              },
        icon: const Icon(Icons.add_shopping_cart),
        label: Text(
          isOutOfStock ? 'Stok Habis' : 'Tambah ke Keranjang',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  /// Bottom Bar untuk tampilan Ponsel (Langkah 3 & Tugas Mandiri 1)
  Widget _buildBottomBar(Product product, double totalPrice) {
    final isOutOfStock = product.stock <= 0;

    return Container(
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
            // Row Stepper Jumlah & Subtotal
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
                      InkWell(
                        onTap: isOutOfStock ? null : _decrementQuantity,
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: Icon(Icons.remove, size: 16, color: Colors.deepOrange),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '$_quantity',
                          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                        ),
                      ),
                      InkWell(
                        onTap: isOutOfStock ? null : () => _incrementQuantity(product.stock),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          child: Icon(Icons.add, size: 16, color: Colors.deepOrange),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('Subtotal', style: TextStyle(fontSize: 11, color: Colors.grey)),
                    PriceLabel(harga: totalPrice, fontSize: 16),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Tombol 'Tambah ke Keranjang'
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: isOutOfStock ? Colors.grey : Colors.deepOrange,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                // Langkah 3: Mengembalikan nilai _quantity ke HomePage menggunakan Navigator.pop
                onPressed: isOutOfStock
                    ? null
                    : () {
                        Navigator.pop(context, _quantity);
                      },
                icon: const Icon(Icons.add_shopping_cart, size: 18),
                label: Text(
                  isOutOfStock ? 'Stok Habis' : 'Tambah ke Keranjang',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
