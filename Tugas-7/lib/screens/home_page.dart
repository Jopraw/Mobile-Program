// ============================================================
// screens/home_page.dart
// Halaman Utama TokoKita — Pertemuan 7 (HTTP Networking & REST API)
//
// Langkah 4 → FutureBuilder untuk konsumsi asynchronous fetchProducts()
// Langkah 4 → Loading indicator (CircularProgressIndicator)
// Langkah 5 → Error state ramah pengguna & tombol 'Coba Lagi'
// Tugas Mandiri 2 → Pull-to-refresh dengan RefreshIndicator
// ============================================================

import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/product_service.dart';
import '../widgets/product_card.dart';

class HomePage extends StatefulWidget {
  final ProductService? productService;

  const HomePage({super.key, this.productService});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final ProductService _service;
  late Future<List<Product>> _productsFuture;

  // State untuk pengujian simulasi error (Langkah 5)
  bool _simulateError = false;

  @override
  void initState() {
    super.initState();
    _service = widget.productService ?? ProductService();
    _loadProducts();
  }

  /// Memuat atau memuat ulang data produk dari API
  void _loadProducts() {
    setState(() {
      // Langkah 4: Menginisialisasi Future pemanggilan fetchProducts()
      _productsFuture = _service.fetchProducts(forceSimulatedError: _simulateError);
    });
  }

  /// Tugas Mandiri 2: Callback untuk RefreshIndicator (Pull-to-Refresh)
  Future<void> _handleRefresh() async {
    _loadProducts();
    await _productsFuture;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),

      // ── AppBar TokoKita ──
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'TokoKita',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              'Live REST API: fakestoreapi.com',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
        actions: [
          // Tombol Simulasi Error (Langkah 5)
          IconButton(
            icon: Icon(
              _simulateError ? Icons.wifi_off : Icons.wifi,
              color: _simulateError ? Colors.yellowAccent : Colors.white,
            ),
            tooltip: _simulateError
                ? 'Mode Simulasi Error Aktif (Klik untuk matikan)'
                : 'Aktifkan Simulasi Error (Langkah 5)',
            onPressed: () {
              setState(() {
                _simulateError = !_simulateError;
                _loadProducts();
              });
              ScaffoldMessenger.of(context).hideCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _simulateError
                        ? 'Mode Simulasi Error Diaktifkan (Langkah 5).'
                        : 'Mode Normal Diaktifkan (Koneksi Online).',
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Muat Ulang Data',
            onPressed: _loadProducts,
          ),
        ],
      ),

      // ── Tugas Mandiri 2: RefreshIndicator membungkus body untuk pull-to-refresh ──
      body: RefreshIndicator(
        color: Colors.deepOrange,
        onRefresh: _handleRefresh,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Info Katalog
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Katalog Produk Real-Time',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF212121),
                          ),
                        ),
                        Text(
                          'Data langsung dari Fake Store API',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _simulateError
                          ? Colors.red.withValues(alpha: 0.1)
                          : Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.circle,
                          size: 8,
                          color: _simulateError ? Colors.red : Colors.green,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          _simulateError ? 'Simulasi Offline' : 'Online',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: _simulateError ? Colors.red : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // ── Langkah 4: FutureBuilder untuk mengonsumsi data asynchronous ──
            Expanded(
              child: FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  // 1. Kondisi Loading: Request masih berlangsung (ConnectionState.waiting)
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const CircularProgressIndicator(
                            color: Colors.deepOrange,
                            strokeWidth: 3,
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Mengambil data dari Fake Store API...',
                            style: TextStyle(
                              fontSize: 14,
                              color: Color(0xFF424242),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Menunggu response server...',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                          ),
                        ],
                      ),
                    );
                  }

                  // 2. Kondisi Error: Request gagal atau status code != 200 (Langkah 5)
                  if (snapshot.hasError) {
                    return Center(
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 90,
                              height: 90,
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.cloud_off_rounded,
                                size: 48,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Gagal Memuat Produk',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF212121),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              snapshot.error.toString().replaceAll('Exception: ', ''),
                              style: const TextStyle(
                                fontSize: 13,
                                color: Colors.grey,
                                height: 1.4,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 24),

                            // Langkah 5: Tombol 'Coba Lagi'
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepOrange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                  vertical: 12,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                elevation: 2,
                              ),
                              onPressed: () {
                                // Reset simulasi error jika sedang aktif dan muat ulang
                                if (_simulateError) {
                                  setState(() {
                                    _simulateError = false;
                                  });
                                }
                                _loadProducts();
                              },
                              icon: const Icon(Icons.refresh, size: 18),
                              label: const Text(
                                'Coba Lagi',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  // 3. Kondisi Data Kosong
                  final products = snapshot.data ?? [];
                  if (products.isEmpty) {
                    return const Center(
                      child: Text(
                        'Tidak ada produk yang tersedia.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  }

                  // 4. Kondisi Sukses: Menampilkan List Produk dengan ListView.builder (Langkah 4)
                  return ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.only(top: 4, bottom: 20),
                    itemCount: products.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ProductCard(product: products[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
