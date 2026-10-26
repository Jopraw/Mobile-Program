// ============================================================
// models/product.dart
// Model data produk TokoKita — Pertemuan 7 (REST API & JSON Parsing)
//
// Langkah 3: Menambahkan factory Product.fromJson() dan method toJson()
// untuk mapping field API (id, title, price, description, category, image)
// ============================================================

/// Class model utama Product untuk aplikasi TokoKita
class Product {
  final int id;
  final String name;
  final double price; // Disimpan dalam Rupiah (dikonversi dari USD pada API)
  final double rawUsdPrice; // Harga asli USD dari API
  final String imageUrl;
  final String category;
  final int stock;
  final String? description;
  final double rating;
  final int ratingCount;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.rawUsdPrice = 0.0,
    required this.imageUrl,
    required this.category,
    required this.stock,
    this.description,
    this.rating = 4.5,
    this.ratingCount = 0,
  });

  /// ── Langkah 3: Factory constructor untuk deserialisasi JSON dari REST API ──
  /// Memetakan field Fake Store API:
  /// - 'id'          -> id
  /// - 'title'       -> name
  /// - 'price'       -> dikonversi ke Rupiah (x 15.000)
  /// - 'image'       -> imageUrl
  /// - 'category'    -> category (diformat huruf kapital)
  /// - 'description' -> description
  /// - 'rating'      -> rating.rate & rating.count
  factory Product.fromJson(Map<String, dynamic> json) {
    final rawPrice = (json['price'] as num?)?.toDouble() ?? 0.0;
    // Konversi kurs rata-rata USD ke IDR agar sesuai tema TokoKita
    final idrPrice = rawPrice * 15000;

    // Parsing nested rating objek jika tersedia pada response Fake Store API
    double parsedRating = 4.5;
    int parsedRatingCount = 10;
    if (json['rating'] != null && json['rating'] is Map<String, dynamic>) {
      parsedRating = (json['rating']['rate'] as num?)?.toDouble() ?? 4.5;
      parsedRatingCount = (json['rating']['count'] as num?)?.toInt() ?? 10;
    }

    // Format kategori agar rapi (kapital di awal)
    final rawCat = json['category']?.toString() ?? 'Umum';
    final formattedCat = rawCat.isNotEmpty
        ? rawCat[0].toUpperCase() + rawCat.substring(1)
        : 'Umum';

    // Estimasi stok berdasarkan rating count atau default 15
    final calculatedStock = parsedRatingCount > 0 ? (parsedRatingCount % 25) + 1 : 12;

    return Product(
      id: json['id'] as int? ?? 0,
      name: json['title'] as String? ?? 'Produk Tanpa Nama',
      price: idrPrice > 0 ? idrPrice : rawPrice,
      rawUsdPrice: rawPrice,
      imageUrl: json['image'] as String? ?? '',
      category: formattedCat,
      stock: calculatedStock,
      description: json['description'] as String?,
      rating: parsedRating,
      ratingCount: parsedRatingCount,
    );
  }

  /// ── Method untuk serialisasi model kembali ke JSON Map (POST / Update) ──
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': name,
      'price': rawUsdPrice > 0 ? rawUsdPrice : (price / 15000),
      'description': description,
      'category': category.toLowerCase(),
      'image': imageUrl,
      'rating': {
        'rate': rating,
        'count': ratingCount,
      },
    };
  }

  /// Mengembalikan status ketersediaan stok
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
// Inheritance: DiscountedProduct (Pertemuan 2, 3, 4)
// ────────────────────────────────────────────────────────────
class DiscountedProduct extends Product {
  final double discountPercent;

  DiscountedProduct({
    required super.id,
    required super.name,
    required super.price,
    super.rawUsdPrice,
    required super.imageUrl,
    required super.category,
    required super.stock,
    super.description,
    super.rating,
    super.ratingCount,
    required this.discountPercent,
  });

  double get discountedPrice {
    return price - (price * (discountPercent / 100));
  }
}
