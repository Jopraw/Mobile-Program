// ============================================================
// screens/order_success_page.dart
// Halaman Konfirmasi Pesanan Berhasil TokoKita — Pertemuan 6
//
// Langkah 4 & Tugas Mandiri 3:
// Menampilkan status berhasil setelah checkout dan menggunakan
// Get.offAll() untuk kembali ke MainPage (Beranda) secara bersih.
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'main_page.dart';
import '../controllers/navigation_controller.dart';

/// OrderSuccessPage menampilkan status checkout berhasil dan ringkasan pesanan.
class OrderSuccessPage extends StatelessWidget {
  final String orderId;
  final double totalAmount;
  final int totalItems;
  final String paymentMethod;

  const OrderSuccessPage({
    super.key,
    required this.orderId,
    required this.totalAmount,
    required this.totalItems,
    required this.paymentMethod,
  });

  String _formatRupiah(double amount) {
    final int val = amount.round();
    final String s = val.toString();
    final StringBuffer sb = StringBuffer();
    int count = 0;
    for (int i = s.length - 1; i >= 0; i--) {
      sb.write(s[i]);
      count++;
      if (count % 3 == 0 && i != 0) {
        sb.write('.');
      }
    }
    return 'Rp ${sb.toString().split('').reversed.join('')}';
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          // Cegah tombol back fisik kembali ke checkout, arahkan ke MainPage
          if (Get.isRegistered<NavigationController>()) {
            Get.find<NavigationController>().toHome();
          }
          Get.offAll(() => const MainPage());
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FA),
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          foregroundColor: Colors.white,
          automaticallyImplyLeading: false,
          elevation: 0,
          title: const Text(
            'Status Transaksi',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Ikon Sukses
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E7D32).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 64,
                      color: Color(0xFF2E7D32),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Judul
                const Text(
                  'Pembayaran Berhasil!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Pesanan Anda telah diterima dan sedang diproses oleh penjual.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 28),

                // Kartu Rincian Transaksi
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rincian Transaksi',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF212121),
                        ),
                      ),
                      const Divider(height: 24),
                      _buildRow('No. Pesanan', orderId, isBold: true),
                      const SizedBox(height: 12),
                      _buildRow('Metode Pembayaran', paymentMethod),
                      const SizedBox(height: 12),
                      _buildRow('Total Barang', '$totalItems unit'),
                      const SizedBox(height: 12),
                      _buildRow('Total Pembayaran', _formatRupiah(totalAmount),
                          valueColor: Colors.deepOrange, isBold: true),
                      const SizedBox(height: 12),
                      _buildRow('Status', 'Menunggu Pengiriman',
                          valueColor: const Color(0xFF2E7D32), isBold: true),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Kartu Informasi GetX Routing Note
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade800, size: 22),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Catatan GetX Routing: Halaman ini dibuka menggunakan Get.off() sehingga halaman checkout tidak dapat dibuka kembali via tombol Back. Tombol di bawah menggunakan Get.offAll() untuk mereset seluruh navigation stack.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.blue.shade900,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Tombol Kembali ke Beranda
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (Get.isRegistered<NavigationController>()) {
                        Get.find<NavigationController>().toHome();
                      }
                      Get.offAll(() => const MainPage());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Kembali ke Beranda (Get.offAll)',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value,
      {Color? valueColor, bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
            color: valueColor ?? const Color(0xFF212121),
          ),
        ),
      ],
    );
  }
}
