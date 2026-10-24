// ============================================================
// screens/profile_page.dart
// Halaman Profil Pengguna TokoKita — Pertemuan 6
//
// Langkah 3: Dependency Injection via Get.find<CartController>()
// Mendemonstrasikan bahwa state keranjang dapat dibaca dari halaman mana saja
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/navigation_controller.dart';

/// ProfilePage — Tab Profil Pengguna TokoKita
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
    // ── Langkah 3: Get.find lintas halaman (Home, Detail, Keranjang, Profil) ──
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Profil Saya',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Pengaturan',
            onPressed: () {
              Get.snackbar(
                'Pengaturan',
                'Menu pengaturan akan hadir pada pembaruan berikutnya.',
                snackPosition: SnackPosition.TOP,
                backgroundColor: Colors.grey.shade800,
                colorText: Colors.white,
                duration: const Duration(seconds: 2),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            // ── Kartu Identitas Pengguna (Jojo Prawinata Situmeang) ──
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
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.deepOrange.shade100,
                    child: const Text(
                      'JP',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepOrange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Jojo Prawinata Situmeang',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'NIM: 3337240060 · Teknik Informatika',
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.deepOrange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.workspace_premium, size: 16, color: Colors.deepOrange),
                        SizedBox(width: 6),
                        Text(
                          'Member Gold TokoKita',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Kartu State Keranjang Terpusat (Obx GetX) ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.shopping_cart_outlined, color: Colors.deepOrange, size: 20),
                          SizedBox(width: 8),
                          Text(
                            'Status Keranjang Terpusat',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF212121),
                            ),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {
                          if (Get.isRegistered<NavigationController>()) {
                            Get.find<NavigationController>().toCart();
                          }
                        },
                        child: const Text('Buka Keranjang'),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Obx(() => Row(
                        children: [
                          Expanded(
                            child: _buildCartStat(
                              'Total Barang',
                              '${cartController.totalItem} unit',
                              Icons.inventory_2_outlined,
                            ),
                          ),
                          Container(width: 1, height: 40, color: Colors.grey.shade200),
                          Expanded(
                            child: _buildCartStat(
                              'Nilai Keranjang',
                              _formatRupiah(cartController.totalHarga),
                              Icons.payments_outlined,
                              valueColor: Colors.deepOrange,
                            ),
                          ),
                        ],
                      )),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ── Kartu Ringkasan Tugas Praktikum 6 ──
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Informasi Praktikum 6',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF212121),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Mata Kuliah', 'Pemrograman Sistem Mobile'),
                  _buildInfoRow('Topik', 'State Management dengan GetX'),
                  _buildInfoRow('Fitur Utama', 'CartController, Obx, RxList'),
                  _buildInfoRow('Navigasi', 'Get.to, Get.back, Get.off, Get.offAll'),
                  _buildInfoRow('Dependency', 'Get.put() & Get.find()'),
                  _buildInfoRow('Framework', 'Flutter 3.38 · Dart 3.10'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartStat(String label, String value, IconData icon,
      {Color? valueColor}) {
    return Column(
      children: [
        Icon(icon, size: 20, color: Colors.grey.shade600),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: valueColor ?? const Color(0xFF212121),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Color(0xFF212121),
            ),
          ),
        ],
      ),
    );
  }
}
