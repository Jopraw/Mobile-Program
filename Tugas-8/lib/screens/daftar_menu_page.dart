import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/menu_item.dart';
import '../widgets/kantin_text.dart';
import 'detail_menu_page.dart';
import 'tambah_menu_page.dart';

/// Halaman Daftar Menu — Soal 2 (45 poin).
///
/// Struktur widget PERSIS sesuai Gambar 1 pada soal UTS:
/// Scaffold
/// ├── AppBar
/// │   └── Text (KantinText)
/// ├── Column (body)
/// │   ├── Padding
/// │   │   └── Text (KantinText)
/// │   └── Expanded
/// │       └── ListView.builder
/// │           └── Card
/// │               └── ListTile
/// │                   ├── Icon (leading)
/// │                   ├── Text (title — KantinText)
/// │                   ├── Text (subtitle — KantinText)
/// │                   └── Icon (trailing)
/// └── FloatingActionButton
///     └── Icon
class DaftarMenuPage extends StatefulWidget {
  const DaftarMenuPage({super.key});

  @override
  State<DaftarMenuPage> createState() => _DaftarMenuPageState();
}

class _DaftarMenuPageState extends State<DaftarMenuPage> {
  // Data menu disimpan dalam List biasa di dalam State, minimal 5 data awal.
  final List<MenuItem> _daftarMenu = [
    MenuItem(nama: 'Nasi Goreng Spesial', harga: 15000),
    MenuItem(nama: 'Mie Ayam Bakso', harga: 12000),
    MenuItem(nama: 'Ayam Geprek Sambal Matah', harga: 18000),
    MenuItem(nama: 'Soto Betawi', harga: 14000),
    MenuItem(nama: 'Es Teh Manis', harga: 5000),
    MenuItem(nama: 'Indomie Goreng Telur', harga: 10000),
    MenuItem(nama: 'Jus Alpukat', harga: 8000),
  ];

  /// Format harga ke Rupiah
  String _formatRupiah(int harga) {
    String angka = harga.toString();
    String hasil = '';
    int count = 0;
    for (int i = angka.length - 1; i >= 0; i--) {
      hasil = angka[i] + hasil;
      count++;
      if (count % 3 == 0 && i != 0) {
        hasil = '.$hasil';
      }
    }
    return 'Rp $hasil';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    // Scaffold (root)
    return Scaffold(
      // ── AppBar ──
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: colorScheme.primary,
        elevation: 2,
        // AppBar → Text (menggunakan KantinText custom widget)
        title: KantinText(
          'Menu Kantin Untirta',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // ── Column (body) ──
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column → Padding
          Padding(
            padding: const EdgeInsets.all(16.0),
            // Padding → Text (menggunakan KantinText custom widget)
            child: KantinText(
              'Daftar Menu (${_daftarMenu.length} item)',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: colorScheme.primary,
            ),
          ),

          // Column → Expanded
          Expanded(
            // Expanded → ListView.builder
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _daftarMenu.length,
              itemBuilder: (context, index) {
                final menu = _daftarMenu[index];

                // ListView.builder → Card
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),

                  // Card → ListTile
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    onTap: () {
                      // Ketika item ditekan, buka halaman detail
                      // menggunakan Get.to()
                      Get.to(() => DetailMenuPage(menu: menu));
                    },

                    // ListTile → Icon (leading)
                    leading: Icon(
                      Icons.restaurant_menu,
                      color: colorScheme.primary,
                      size: 28,
                    ),

                    // ListTile → Text (title) — KantinText
                    title: KantinText(
                      menu.nama,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),

                    // ListTile → Text (subtitle) — KantinText
                    subtitle: KantinText(
                      _formatRupiah(menu.harga),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: colorScheme.secondary,
                    ),

                    // ListTile → Icon (trailing)
                    trailing: Icon(
                      Icons.arrow_forward_ios,
                      color: colorScheme.outline,
                      size: 18,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),

      // ── FloatingActionButton ──
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        onPressed: () async {
          // Membuka halaman tambah menu menggunakan Get.to()
          // dan menerima hasil (result) dari Get.back()
          final result = await Get.to(() => const TambahMenuPage());
          if (result != null && result is MenuItem) {
            setState(() {
              _daftarMenu.add(result);
            });
          }
        },
        // FloatingActionButton → Icon
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
