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

}