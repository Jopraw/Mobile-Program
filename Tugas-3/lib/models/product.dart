// Class Product dari Pertemuan 2 (tanpa fungsi main dan demo)

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

  // Method getStatusStok() dari Tugas Mandiri Pertemuan 2
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

// Inheritance: DiscountedProduct adalah turunan dari Product
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

  // Getter untuk menghitung harga setelah diskon
  double get discountedPrice {
    return price - (price * (discountPercent / 100));
  }
}

// Data dummy 8 produk untuk aplikasi TokoKita
List<Product> daftarProduk = [
  Product(
    id: 1,
    name: 'Kipas Angin Mini',
    price: 150000.0,
    imageUrl: 'kipas.png',
    category: 'Elektronik',
    stock: 10,
  ),
  Product(
    id: 2,
    name: 'Kemeja Flannel',
    price: 250000.0,
    imageUrl: 'kemeja.png',
    category: 'Fashion',
    stock: 5,
    description: 'Kemeja kotak-kotak bahan halus',
  ),
  Product(
    id: 3,
    name: 'Mie Instan Box',
    price: 95000.0,
    imageUrl: 'mie.png',
    category: 'Makanan',
    stock: 50,
  ),
  Product(
    id: 4,
    name: 'Headset Gaming',
    price: 350000.0,
    imageUrl: 'headset.png',
    category: 'Elektronik',
    stock: 8,
    description: 'Headset surround sound 7.1',
  ),
  Product(
    id: 5,
    name: 'Celana Jeans Slim',
    price: 280000.0,
    imageUrl: 'jeans.png',
    category: 'Fashion',
    stock: 0,
  ),
  Product(
    id: 6,
    name: 'Kopi Arabika 250g',
    price: 75000.0,
    imageUrl: 'kopi.png',
    category: 'Makanan',
    stock: 30,
  ),
  Product(
    id: 7,
    name: 'Mouse Wireless',
    price: 120000.0,
    imageUrl: 'mouse.png',
    category: 'Elektronik',
    stock: 2,
    description: 'Mouse ergonomis hemat baterai',
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
];
