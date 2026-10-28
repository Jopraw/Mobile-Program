// ============================================================
// screens/order_history_page.dart
// Halaman Riwayat Pesanan (SQLite) — Pertemuan 9, Langkah 4
// Read (ListView), Update status, Delete, dan pencarian status (WHERE)
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/order_controller.dart';
import '../models/order.dart';

class OrderHistoryPage extends StatelessWidget {
  const OrderHistoryPage({super.key});

  static String formatRupiah(double amount) {
    final s = amount.round().toString();
    final sb = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) sb.write('.');
      sb.write(s[i]);
    }
    return 'Rp $sb';
  }

  static String formatTanggal(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${two(d.day)}/${two(d.month)}/${d.year} ${two(d.hour)}:${two(d.minute)}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<OrderController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        title: const Text(
          'Riwayat Pesanan',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          // Pencarian berdasarkan status (query SQL WHERE status LIKE ?)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
            child: TextField(
              onChanged: controller.search,
              decoration: InputDecoration(
                hintText: 'Cari berdasarkan status (mis. Diproses)',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Obx(() => Row(
                  children: [
                    for (final s in OrderStatus.all) ...[
                      ChoiceChip(
                        label: Text(s),
                        selected: controller.statusQuery.value == s,
                        selectedColor: Colors.deepOrange.shade100,
                        onSelected: (sel) => controller.search(sel ? s : ''),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ],
                )),
          ),
          Expanded(
            child: Obx(() {
              final orders = controller.orders;
              if (orders.isEmpty) {
                return Center(
                  child: Text(
                    controller.statusQuery.value.isEmpty
                        ? 'Belum ada riwayat pesanan.'
                        : 'Tidak ada pesanan dengan status tersebut.',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                );
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: orders.length,
                itemBuilder: (context, index) =>
                    _OrderCard(order: orders[index], controller: controller),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  final OrderRecord order;
  final OrderController controller;
  const _OrderCard({required this.order, required this.controller});

  @override
  Widget build(BuildContext context) {
    final done = order.status == OrderStatus.selesai;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Pesanan #${order.id}',
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: (done ? Colors.green : Colors.orange)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  order.status,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: done ? Colors.green.shade800 : Colors.orange.shade800,
                  ),
                ),
              ),
              PopupMenuButton<String>(
                tooltip: 'Aksi pesanan',
                onSelected: (value) {
                  if (value == 'delete') {
                    controller.deleteOrder(order.id!);
                  } else {
                    controller.updateStatus(order.id!, value);
                  }
                },
                itemBuilder: (context) => [
                  for (final s in OrderStatus.all)
                    if (s != order.status)
                      PopupMenuItem(value: s, child: Text('Ubah ke $s')),
                  const PopupMenuItem(value: 'delete', child: Text('Hapus')),
                ],
              ),
            ],
          ),
          Text(
            OrderHistoryPage.formatTanggal(order.tanggal),
            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
          ),
          const Divider(height: 18),
          for (final item in order.daftarItem)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Text(
                '${item.quantity}x ${item.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12),
              ),
            ),
          const SizedBox(height: 6),
          Text(
            'Total ${OrderHistoryPage.formatRupiah(order.totalHarga)}',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.deepOrange,
            ),
          ),
        ],
      ),
    );
  }
}
