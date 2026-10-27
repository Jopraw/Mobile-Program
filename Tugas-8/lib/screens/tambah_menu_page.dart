import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../models/menu_item.dart';
import '../widgets/kantin_text.dart';

/// Halaman Tambah Menu — Soal 3 (35 poin).
///
/// Struktur widget PERSIS sesuai Gambar 2 pada soal UTS:
/// Scaffold
/// ├── AppBar
/// │   └── Text (KantinText)
/// └── Padding (body)
///     └── Form
///         └── Column
///             ├── TextFormField (nama menu)
///             ├── SizedBox
///             ├── TextFormField (harga menu)
///             ├── SizedBox
///             └── ElevatedButton
///                 └── Text (KantinText)
class TambahMenuPage extends StatefulWidget {
  const TambahMenuPage({super.key});

  @override
  State<TambahMenuPage> createState() => _TambahMenuPageState();
}

class _TambahMenuPageState extends State<TambahMenuPage> {
  // Key & controller disimpan di State agar tidak dibuat ulang setiap rebuild.
  final formKey = GlobalKey<FormState>();
  final namaController = TextEditingController();
  final hargaController = TextEditingController();

  @override
  void dispose() {
    namaController.dispose();
    hargaController.dispose();
    super.dispose();
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
        iconTheme: const IconThemeData(color: Colors.white),
        // AppBar → Text (menggunakan KantinText custom widget)
        title: KantinText(
          'Tambah Menu Baru',
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),

      // ── Padding (body) ──
      body: Padding(
        padding: const EdgeInsets.all(20.0),

        // Padding → Form
        child: Form(
          key: formKey,

          // Form → Column
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Column → TextFormField (nama menu)
              TextFormField(
                controller: namaController,
                decoration: InputDecoration(
                  labelText: 'Nama Menu',
                  hintText: 'Contoh: Nasi Goreng Spesial',
                  prefixIcon: const Icon(Icons.fastfood),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  // Kolom nama tidak boleh kosong
                  if (value == null || value.trim().isEmpty) {
                    return 'Nama menu tidak boleh kosong';
                  }
                  return null;
                },
              ),

              // Column → SizedBox
              const SizedBox(height: 16),

              // Column → TextFormField (harga menu)
              TextFormField(
                controller: hargaController,
                decoration: InputDecoration(
                  labelText: 'Harga (Rp)',
                  hintText: 'Contoh: 15000',
                  prefixIcon: const Icon(Icons.attach_money),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                // Kolom harga hanya menerima angka
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) {
                  // Kolom harga tidak boleh kosong
                  if (value == null || value.trim().isEmpty) {
                    return 'Harga tidak boleh kosong';
                  }
                  // Harus divalidasi sebagai angka
                  final parsed = int.tryParse(value);
                  if (parsed == null || parsed <= 0) {
                    return 'Masukkan harga yang valid (angka > 0)';
                  }
                  return null;
                },
              ),

              // Column → SizedBox
              const SizedBox(height: 24),

              // Column → ElevatedButton
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    final menuBaru = MenuItem(
                      nama: namaController.text.trim(),
                      harga: int.parse(hargaController.text.trim()),
                    );
                    // Jika semua valid, data menu baru dikirim kembali
                    // ke halaman daftar menggunakan Get.back(result: ...)
                    Get.back(result: menuBaru);
                  }
                },

                // ElevatedButton → Text (menggunakan KantinText custom widget)
                child: KantinText(
                  'Simpan Menu',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
