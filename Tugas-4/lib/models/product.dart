// ============================================================
// models/product.dart
// Model data produk untuk aplikasi TokoKita — Pertemuan 4
// Dikembangkan dari Pertemuan 2 & 3
// ============================================================

/// Class dasar untuk semua produk di TokoKita
class Product {
  final int id;
  final String name;
  final double price;
  final String imageUrl;
  final String category;
  final int stock;
  // Null Safety: String? artinya variabel ini boleh kosong (null)
  final String? description;

  // Constructor
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.stock,
    this.description, // tidak wajib (required) karena nullable
  });

  /// Mengembalikan label status stok berdasarkan jumlah
  String getStatusStok() {
    if (stock > 10) {
      return 'Tersedia Banyak';
    } else if (stock > 0) {
      return 'Stok Terbatas';
    } else {
      return 'Habis';
    }
  }
}

// ────────────────────────────────────────────────────────────
// Inheritance: DiscountedProduct adalah turunan dari Product
// ────────────────────────────────────────────────────────────
class DiscountedProduct extends Product {
  final double discountPercent;

  DiscountedProduct({
    required super.id,
    required super.name,
    required super.price,
    required super.imageUrl,
    required super.category,
    required super.stock,
    super.description,
    required this.discountPercent,
  });

  /// Getter → menghitung harga setelah diskon
  double get discountedPrice {
    return price - (price * (discountPercent / 100));
  }
}

// ────────────────────────────────────────────────────────────
// Data Dummy — 15 produk untuk Tugas Mandiri 1
// (campuran Product biasa dan DiscountedProduct)
// ────────────────────────────────────────────────────────────
List<Product> daftarProduk = [
  // ── Elektronik ──
  DiscountedProduct(
    id: 1,
    name: 'Kipas Angin Mini',
    price: 150000.0,
    imageUrl: 'kipas.png',
    category: 'Elektronik',
    stock: 10,
    description: 'Kipas angin portable hemat listrik',
    discountPercent: 10,
  ),
  Product(
    id: 2,
    name: 'Headset Gaming',
    price: 350000.0,
    imageUrl: 'headset.png',
    category: 'Elektronik',
    stock: 8,
    description: 'Headset surround sound 7.1',
  ),
  DiscountedProduct(
    id: 3,
    name: 'Mouse Wireless',
    price: 120000.0,
    imageUrl: 'mouse.png',
    category: 'Elektronik',
    stock: 2,
    description: 'Mouse ergonomis hemat baterai',
    discountPercent: 15,
  ),
  Product(
    id: 4,
    name: 'Keyboard Mechanical',
    price: 480000.0,
    imageUrl: 'keyboard.png',
    category: 'Elektronik',
    stock: 5,
    description: 'Keyboard gaming RGB backlit',
  ),
  DiscountedProduct(
    id: 5,
    name: 'Webcam HD 1080p',
    price: 275000.0,
    imageUrl: 'webcam.png',
    category: 'Elektronik',
    stock: 0,
    description: 'Webcam jernih untuk meeting & streaming',
    discountPercent: 20,
  ),

  // ── Fashion ──
  DiscountedProduct(
    id: 6,
    name: 'Kemeja Flannel',
    price: 250000.0,
    imageUrl: 'kemeja.png',
    category: 'Fashion',
    stock: 5,
    description: 'Kemeja kotak-kotak bahan halus dan nyaman',
    discountPercent: 20,
  ),
  Product(
    id: 7,
    name: 'Celana Jeans Slim',
    price: 280000.0,
    imageUrl: 'jeans.png',
    category: 'Fashion',
    stock: 0,
  ),
  Product(
    id: 8,
    name: 'Tas Ransel',
    price: 450000.0,
    imageUrl: 'tas.png',
    category: 'Fashion',
    stock: 12,
    description: 'Tas anti air cocok untuk travelling',
  ),
  DiscountedProduct(
    id: 9,
    name: 'Sepatu Sneakers',
    price: 320000.0,
    imageUrl: 'sepatu.png',
    category: 'Fashion',
    stock: 7,
    description: 'Sepatu kasual ringan dan nyaman',
    discountPercent: 25,
  ),
  Product(
    id: 10,
    name: 'Topi Baseball',
    price: 85000.0,
    imageUrl: 'topi.png',
    category: 'Fashion',
    stock: 20,
    description: 'Topi kasual bahan kanvas premium',
  ),

  // ── Makanan ──
  Product(
    id: 11,
    name: 'Mie Instan Box',
    price: 95000.0,
    imageUrl: 'mie.png',
    category: 'Makanan',
    stock: 50,
  ),
  DiscountedProduct(
    id: 12,
    name: 'Kopi Arabika 250g',
    price: 75000.0,
    imageUrl: 'kopi.png',
    category: 'Makanan',
    stock: 30,
    description: 'Kopi arabika single origin Gayo',
    discountPercent: 5,
  ),
  Product(
    id: 13,
    name: 'Cokelat Premium 200g',
    price: 55000.0,
    imageUrl: 'cokelat.png',
    category: 'Makanan',
    stock: 15,
    description: 'Dark chocolate 72% kakao',
  ),

  // ── Olahraga ──
  Product(
    id: 14,
    name: 'Raket Badminton',
    price: 185000.0,
    imageUrl: 'raket.png',
    category: 'Olahraga',
    stock: 9,
    description: 'Raket ringan cocok untuk pemula',
  ),
  DiscountedProduct(
    id: 15,
    name: 'Sepatu Lari',
    price: 520000.0,
    imageUrl: 'sepatu_lari.png',
    category: 'Olahraga',
    stock: 6,
    description: 'Sepatu running dengan bantalan tebal',
    discountPercent: 30,
  ),
];
