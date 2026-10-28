// ============================================================
// models/product.dart
// Model data produk untuk aplikasi TokoKita — Pertemuan 5
// Dikembangkan dari Pertemuan 2, 3, & 4
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
// Data Dummy — 15 produk TokoKita
// (campuran Product biasa dan DiscountedProduct)
// ────────────────────────────────────────────────────────────
List<Product> daftarProduk = [
  // ── Elektronik ──
  DiscountedProduct(
    id: 1,
    name: 'Kipas Angin Mini Portable USB',
    price: 150000.0,
    imageUrl: 'kipas.png',
    category: 'Elektronik',
    stock: 12,
    description:
        'Kipas angin portable hemat listrik dengan baterai 2000mAh, 3 tingkat kecepatan angin, dan pengisian daya via USB Type-C yang praktis dibawa bepergian.',
    discountPercent: 10,
  ),
  Product(
    id: 2,
    name: 'Headset Gaming Surround 7.1 RGB',
    price: 350000.0,
    imageUrl: 'headset.png',
    category: 'Elektronik',
    stock: 8,
    description:
        'Headset gaming dengan teknologi audio 7.1 virtual surround sound, mikrofon noise-cancelling, bantalan telinga empuk, dan pencahayaan RGB dinamis.',
  ),
  DiscountedProduct(
    id: 3,
    name: 'Mouse Wireless Silent Click Ergonomis',
    price: 120000.0,
    imageUrl: 'mouse.png',
    category: 'Elektronik',
    stock: 2,
    description:
        'Mouse ergonomis nirkabel 2.4GHz tanpa suara klik bising (silent click), jangkauan hingga 10 meter, dan konsumsi daya sangat hemat.',
    discountPercent: 15,
  ),
  Product(
    id: 4,
    name: 'Keyboard Mekanikal TKL RGB Blue Switch',
    price: 450000.0,
    imageUrl: 'keyboard.png',
    category: 'Elektronik',
    stock: 15,
    description:
        'Keyboard mekanikal layout Tenkeyless (87 tombol) dengan tactile clicky blue switch, keycaps double-shot PBT, dan kabel type-C detachable.',
  ),
  DiscountedProduct(
    id: 5,
    name: 'Webcam Full HD 1080p Auto Focus',
    price: 275000.0,
    imageUrl: 'webcam.png',
    category: 'Elektronik',
    stock: 0,
    description:
        'Kamera webcam resolusi tinggi 1080p 30fps dengan sensor autofocus otomatis, mikrofon stereo internal, dan klip fleksibel untuk monitor/laptop.',
    discountPercent: 20,
  ),

  // ── Fashion ──
  Product(
    id: 6,
    name: 'Kaus Polos Cotton Combed 30s Premium',
    price: 65000.0,
    imageUrl: 'kaus.png',
    category: 'Fashion',
    stock: 25,
    description:
        'Kaus polos berbahan 100% cotton combed 30s adem, menyerap keringat dengan baik, jahitan rantai rapi, dan cocok untuk iklim tropis.',
  ),
  DiscountedProduct(
    id: 7,
    name: 'Jaket Hoodie Fleece Tebal Hangat',
    price: 185000.0,
    imageUrl: 'jaket.png',
    category: 'Fashion',
    stock: 5,
    description:
        'Jaket hoodie unisex berbahan fleece katun tebal dengan saku kanguru di depan, tali serut adjustable, dan manset elastis di pergelangan tangan.',
    discountPercent: 25,
  ),
  Product(
    id: 8,
    name: 'Celana Chino Slim Fit Stretch Pria',
    price: 140000.0,
    imageUrl: 'celana.png',
    category: 'Fashion',
    stock: 14,
    description:
        'Celana panjang chino bergaya modern slim fit dengan bahan katun twill stretch lentur, nyaman untuk kerja kantor maupun hangout santai.',
  ),
  DiscountedProduct(
    id: 9,
    name: 'Topi Baseball Bordir Klasik Vintage',
    price: 55000.0,
    imageUrl: 'topi.png',
    category: 'Fashion',
    stock: 3,
    description:
        'Topi baseball model retro klasik dengan bahan katun kanvas tahan luntur dan strap logam pengatur ukuran kepala di bagian belakang.',
    discountPercent: 10,
  ),
  Product(
    id: 10,
    name: 'Kemeja Flannel Kotak Casual Lengan Panjang',
    price: 165000.0,
    imageUrl: 'kemeja.png',
    category: 'Fashion',
    stock: 7,
    description:
        'Kemeja flannel motif kotak-kotak elegan berbahan katun lembut yang nyaman dipakai sebagai outer maupun kemeja formal santai.',
  ),

  // ── Makanan ──
  DiscountedProduct(
    id: 11,
    name: 'Kopi Arabika Gayo Single Origin 250g',
    price: 85000.0,
    imageUrl: 'kopi.png',
    category: 'Makanan',
    stock: 20,
    description:
        'Biji kopi pilihan roasted fresh dari dataran tinggi Aceh Gayo, aroma floral kaya, tingkat keasaman seimbang, dan aftertaste manis alami.',
    discountPercent: 12,
  ),
  Product(
    id: 12,
    name: 'Cokelat Hitam Artisan Dark Chocolate 70%',
    price: 45000.0,
    imageUrl: 'cokelat.png',
    category: 'Makanan',
    stock: 9,
    description:
        'Cokelat batangan premium dengan kadar kakao murni 70% dari perkebunan lokal, rendah gula dan kaya akan antioksidan alami.',
  ),
  DiscountedProduct(
    id: 13,
    name: 'Madu Hutan Liar Murni Alami 500ml',
    price: 110000.0,
    imageUrl: 'madu.png',
    category: 'Makanan',
    stock: 1,
    description:
        'Madu mentah (raw honey) langsung dari lebah hutan liar nusantara tanpa pemanis buatan, menjaga stamina dan meningkatkan kekebalan tubuh.',
    discountPercent: 15,
  ),

  // ── Olahraga ──
  Product(
    id: 14,
    name: 'Matras Yoga Anti Slip Tebal 8mm TPE',
    price: 130000.0,
    imageUrl: 'matras.png',
    category: 'Olahraga',
    stock: 11,
    description:
        'Matras senam yoga dan pilates berbahan ramah lingkungan TPE dengan tekstur anti slip ganda, ketebalan 8mm melindungi lutut dan sendi.',
  ),
  DiscountedProduct(
    id: 15,
    name: 'Botol Minum Olahraga Motivasi 2 Liter Tritan',
    price: 75000.0,
    imageUrl: 'botol.png',
    category: 'Olahraga',
    stock: 6,
    description:
        'Botol air minum kapasitas besar 2 liter bebas BPA (BPA-free) dengan sedotan silikon dan penanda waktu minum pengingat hidrasi harian.',
    discountPercent: 20,
  ),
];
