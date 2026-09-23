void main(){
  var deskripsiProduk = "Handpicked Top Grade Quality Goods";
  final String kodeProduk = "PRD-01";
  const String namaToko = "Toko Kita Berqualitas";

  deskripsiProduk = "Produk oke";

  String namaProduk ="MSI BRAVO 15 B7ED";
  int stokProduk = 13;
  double hargaProduk =15000000.00;
  bool statusProduk =true;

  print('----DETAIL PRODUK----');
  print('Nama Toko    : $namaToko');
  print('Nama Produk  : $namaProduk');
  print('Harga Produk : $hargaProduk');
  print('Stok Produk  : $stokProduk');
  print('Status Produk: ${statusProduk ? "Tersedia" : "Habis"}');

  List<String> daftarKategori = ['Elektronik', 'Gadget', 'Laptop'];
  Map<String, dynamic> produkMentah = {
    'id_produk'   : 101,
    'nama_produk' : namaProduk,
    'harga_produk': hargaProduk,
    'stok_produk' : stokProduk,
    'Kategori'    : daftarKategori[0],
    'is_active'   : statusProduk,
    'tags' : ['gaming','laptop','promo']
  };

  print('\n---Koleksi Data---');
  print('Daftar Kategori : $daftarKategori');
  print('Data Mentah : $produkMentah');
  
  int jumlahBeli = 3;
  double totalHarga = hargaProduk * jumlahBeli; // Operator * (Perkalian)
  int sisaStok = stokProduk - jumlahBeli;       // Operator - (Pengurangan)
  
  print('Jumlah Beli : $jumlahBeli item');
  print('Total Harga : Rp $totalHarga');
  print('Sisa Stok   : $sisaStok item');
  
  bool stokAman = sisaStok > 5; 
  
  // cek apakah harga produk lbih mahal dari 10 juta
  bool mahal = hargaProduk >= 10000000;
  
  print('Apakah stok aman? (> 5) : $stokAman');
  print('Apakah produk mahal? (>= 10jt) : $mahal');

  // apakah [roduk layak ditampilkan di toko JIKA stoknya lebih dari 0 DAN statusnya aktif (true)
  bool layakTampil = (sisaStok > 0) && statusProduk;
  
  print('Apakah produk layak tampil di halaman utama? : $layakTampil');

    print('\n--- Langkah 3: Control Flow ---');
  
  // 1. If-Else: Menentukan label status stok
  String labelStok;
  if (sisaStok > 10) {
    labelStok = 'Tersedia Banyak';
  } else if (sisaStok > 0) {
    labelStok = 'Stok Terbatas';
  } else {
    labelStok = 'Habis';
  }
  print('Status Stok Saat Ini: $labelStok');

  // 2. For Loop: Menjumlahkan total belanja dari list harga
  List<double> keranjangBelanja = [15000000.0, 500000.0, 150000.0];
  double totalBelanjaan = 0;
  for (int i = 0; i < keranjangBelanja.length; i++) {
    totalBelanjaan += keranjangBelanja[i];
  }
  print('\nTotal Belanjaan (For Loop): Rp $totalBelanjaan');

  // 3. While Loop: Simulasi pengurangan stok satu per satu
  int stokSimulasi = 3; // kita buat stok kecil agar tidak terlalu panjang
  print('\nMulai Flash Sale!');
  while (stokSimulasi > 0) {
    print('Barang terjual 1. Sisa stok: ${stokSimulasi - 1}');
    stokSimulasi--;
  }
  print('Flash Sale Selesai, barang habis!');

  // 4. Switch-Case: Menentukan diskon berdasarkan kategori produk
  String kategoriPromo = daftarKategori[0]; // Mengambil 'Elektronik'
  int persenDiskon;
  
  switch (kategoriPromo) {
    case 'Elektronik':
      persenDiskon = 10;
      break;
    case 'Fashion':
      persenDiskon = 15;
      break;
    case 'Makanan':
      persenDiskon = 5;
      break;
    default:
      persenDiskon = 0;
  }
  
  print('\nKategori: $kategoriPromo, Anda mendapat diskon: $persenDiskon%');

  print('\n--- Langkah 4: Functions ---');
  double hargaAwal = 200000.0;
  
  // Memanggil function tanpa diskon (akan memakai nilai default diskon = 0)
  double hargaNormal = hitungHargaSetelahDiskon(hargaAwal);
  
  // Memanggil function dengan menyertakan named parameter diskon 15%
  double hargaDiskon = hitungHargaSetelahDiskon(hargaAwal, persenDiskon: 15);
  
  // Menggunakan arrow function untuk mencetak harga yang sudah diubah ke String 'Rp'
  print('Harga Awal  : ${formatRupiah(hargaAwal)}');
  print('Harga Normal: ${formatRupiah(hargaNormal)}');
  print('Harga Diskon (15%): ${formatRupiah(hargaDiskon)}');

  print('\n--- Langkah 5: OOP & Null Safety ---');
  
  // Membuat objek Product biasa (description sengaja dikosongkan/null)
  Product produk1 = Product(
    id: 1,
    name: 'Kipas Angin Mini',
    price: 150000.0,
    imageUrl: 'kipas.png',
    category: 'Elektronik',
    stock: 10,
  );
  produk1.displayProduct();
  print('    Status: ${produk1.getStatusStok()}');

  // Membuat objek dari Class turunan (DiscountedProduct)
  DiscountedProduct produk2 = DiscountedProduct(
    id: 2,
    name: 'Kemeja Flannel',
    price: 250000.0,
    imageUrl: 'kemeja.png',
    category: 'Fashion',
    stock: 5,
    description: 'Kemeja kotak-kotak bahan halus dan nyaman',
    discountPercent: 20,
  );
  produk2.displayProduct();
  print('    Status: ${produk2.getStatusStok()}');

  // ===== TUGAS MANDIRI =====
  print('\n--- Tugas Mandiri ---');

  // Tugas 2: List<Product> berisi minimal 8 produk dummy
  List<Product> daftarProduk = [
    Product(id: 1, name: 'Kipas Angin Mini', price: 150000.0, imageUrl: 'kipas.png', category: 'Elektronik', stock: 10),
    Product(id: 2, name: 'Kemeja Flannel', price: 250000.0, imageUrl: 'kemeja.png', category: 'Fashion', stock: 5, description: 'Kemeja kotak-kotak bahan halus'),
    Product(id: 3, name: 'Mie Instan Box', price: 95000.0, imageUrl: 'mie.png', category: 'Makanan', stock: 50),
    Product(id: 4, name: 'Headset Gaming', price: 350000.0, imageUrl: 'headset.png', category: 'Elektronik', stock: 8, description: 'Headset surround sound 7.1'),
    Product(id: 5, name: 'Celana Jeans Slim', price: 280000.0, imageUrl: 'jeans.png', category: 'Fashion', stock: 0),
    Product(id: 6, name: 'Kopi Arabika 250g', price: 75000.0, imageUrl: 'kopi.png', category: 'Makanan', stock: 30),
    Product(id: 7, name: 'Mouse Wireless', price: 120000.0, imageUrl: 'mouse.png', category: 'Elektronik', stock: 2, description: 'Mouse ergonomis hemat baterai'),
    Product(id: 8, name: 'Tas Ransel', price: 450000.0, imageUrl: 'tas.png', category: 'Fashion', stock: 12, description: 'Tas anti air cocok untuk travelling'),
  ];

  print('\nDaftar 8 Produk TokoKita:');
  for (var p in daftarProduk) {
    // Tugas 1: Menggunakan method getStatusStok()
    print('  [${p.id}] ${p.name} - ${formatRupiah(p.price)} | Stok: ${p.stock} -> ${p.getStatusStok()}');
  }

  // Tugas 3: Function hitungTotalBelanja
  // Simulasi keranjang belanja: ambil produk ke-0, 3, dan 7
  List<Product> keranjang = [daftarProduk[0], daftarProduk[3], daftarProduk[7]];
  double totalKeranjang = hitungTotalBelanja(keranjang);

  print('\nKeranjang Belanja:');
  for (var item in keranjang) {
    print('  - ${item.name}: ${formatRupiah(item.price)}');
  }
  print('Total Belanja: ${formatRupiah(totalKeranjang)}');

} // Akhir dari fungsi main()

// --- Function untuk Langkah 4 (Taruh di LUAR fungsi main) ---

// 1 & 2. Function biasa dengan Named Parameter (persenDiskon memiliki nilai default 0)
double hitungHargaSetelahDiskon(double harga, {int persenDiskon = 0}) {
  double nominalDiskon = harga * (persenDiskon / 100);
  return harga - nominalDiskon;
}

// 3. Arrow Function (function yang ringkas hanya 1 baris)
String formatRupiah(double harga) => 'Rp ${harga.toStringAsFixed(0)}';

// Tugas Mandiri 3: Function untuk menghitung total belanja dari list produk
double hitungTotalBelanja(List<Product> keranjang) {
  double total = 0;
  for (var produk in keranjang) {
    total += produk.price;
  }
  return total;
}

// --- Langkah 5: Class & Null Safety (DI LUAR MAIN) ---

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

  // Tugas Mandiri 1: Method getStatusStok()
  String getStatusStok() {
    if (stock > 10) {
      return 'Tersedia Banyak';
    } else if (stock > 0) {
      return 'Stok Terbatas';
    } else {
      return 'Habis';
    }
  }

  // Method untuk menampilkan info produk
  void displayProduct() {
    print('[$id] $name - Rp $price | Kategori: $category | Stok: $stock');
    if (description != null) {
      print('    Deskripsi: $description');
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

  // Override method dari class induk (Product)
  @override
  void displayProduct() {
    super.displayProduct(); // Panggil fungsi aslinya
    print('    Diskon: $discountPercent% -> Harga Final: Rp $discountedPrice');
  }
}