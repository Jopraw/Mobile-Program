// ============================================================
// screens/checkout_page.dart
// Halaman Checkout TokoKita — Pertemuan 6
//
// Langkah 4 & Tugas Mandiri 3:
// Halaman Checkout sederhana yang menampilkan ringkasan pesanan
// dari CartController dan menggunakan Get.off() untuk berpindah
// ke OrderSuccessPage tanpa bisa kembali ke form checkout.
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import 'order_success_page.dart';

/// CheckoutPage menyajikan rekapitulasi pesanan sebelum konfirmasi akhir.
class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final CartController _cartController = Get.find<CartController>();

  String _selectedPaymentMethod = 'BCA Virtual Account';
  final double _shippingCost = 15000.0;

  final List<String> _paymentOptions = [
    'BCA Virtual Account',
    'Mandiri Livin',
    'GoPay / QRIS',
    'ShopeePay',
    'COD (Bayar di Tempat)',
  ];

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

  void _processPayment() {
    if (_cartController.items.isEmpty) {
      Get.snackbar(
        'Keranjang Kosong',
        'Tidak ada produk untuk di-checkout.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade700,
        colorText: Colors.white,
      );
      return;
    }

    final totalBayar = _cartController.totalHarga + _shippingCost;
    final totalItem = _cartController.totalItem;
    final orderId = 'TK-${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';

    // Kosongkan keranjang belanja setelah checkout
    _cartController.clearCart(showNotification: false);

    // ── Langkah 4 & Tugas Mandiri 3: Menggunakan Get.off() ──
    // Get.off() menggantikan halaman Checkout saat ini dengan OrderSuccessPage
    // sehingga pengguna tidak dapat menekan 'Back' untuk kembali ke form checkout.
    Get.off(
      () => OrderSuccessPage(
        orderId: orderId,
        totalAmount: totalBayar,
        totalItems: totalItem,
        paymentMethod: _selectedPaymentMethod,
      ),
      transition: Transition.fadeIn,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Kembali (Get.back)',
          // Langkah 4: Navigasi kembali menggunakan Get.back()
          onPressed: () => Get.back(),
        ),
        title: const Text(
          'Konfirmasi Checkout',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Obx(() {
        if (_cartController.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                const Text(
                  'Keranjang Anda Kosong',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text('Kembali Belanja'),
                ),
              ],
            ),
          );
        }

        final subtotalProduk = _cartController.totalHarga;
        final totalDiskon = _cartController.totalHemat;
        final totalAkhir = subtotalProduk + _shippingCost;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Alamat Pengiriman
              _buildSectionCard(
                title: 'Alamat Pengiriman',
                icon: Icons.location_on_outlined,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Text(
                            'Jojo Prawinata Situmeang (Utama)',
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '0812-3456-7890',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Jl. Kampus Untirta No. 12, Cilegon, Banten 42435',
                      style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.3),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Ringkasan Produk dari CartController
              _buildSectionCard(
                title: 'Ringkasan Produk (${_cartController.totalItem} item)',
                icon: Icons.shopping_bag_outlined,
                child: ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _cartController.items.length,
                  separatorBuilder: (context, index) => const Divider(height: 20),
                  itemBuilder: (context, index) {
                    final item = _cartController.items[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: Colors.deepOrange.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(Icons.inventory_2_outlined, color: Colors.deepOrange),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${item.quantity.value}x @ ${_formatRupiah(item.unitPrice)}',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _formatRupiah(item.subtotal),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),

              // Pilihan Metode Pembayaran
              _buildSectionCard(
                title: 'Metode Pembayaran',
                icon: Icons.payment_outlined,
                child: RadioGroup<String>(
                  groupValue: _selectedPaymentMethod,
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedPaymentMethod = val;
                      });
                    }
                  },
                  child: Column(
                    children: _paymentOptions.map((method) {
                      return RadioListTile<String>(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        activeColor: Colors.deepOrange,
                        title: Text(method, style: const TextStyle(fontSize: 13)),
                        value: method,
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Rincian Pembayaran
              _buildSectionCard(
                title: 'Rincian Pembayaran',
                icon: Icons.receipt_long_outlined,
                child: Column(
                  children: [
                    _buildRowItem('Subtotal Produk', _formatRupiah(subtotalProduk)),
                    const SizedBox(height: 8),
                    _buildRowItem('Biaya Pengiriman', _formatRupiah(_shippingCost)),
                    if (totalDiskon > 0) ...[
                      const SizedBox(height: 8),
                      _buildRowItem('Total Diskon Produk', '-${_formatRupiah(totalDiskon)}',
                          valueColor: const Color(0xFF2E7D32)),
                    ],
                    const Divider(height: 20),
                    _buildRowItem(
                      'Total Pembayaran',
                      _formatRupiah(totalAkhir),
                      isBold: true,
                      valueColor: Colors.deepOrange,
                      fontSize: 15,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Tombol Konfirmasi Pesanan dengan Get.off()
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _processPayment,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Bayar Sekarang (${_formatRupiah(totalAkhir)})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Center(
                child: Text(
                  'Navigasi hasil pesanan menggunakan Get.off()',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: Colors.deepOrange),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF212121),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const Divider(height: 20),
          child,
        ],
      ),
    );
  }

  Widget _buildRowItem(
    String label,
    String value, {
    bool isBold = false,
    Color? valueColor,
    double fontSize = 13,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize,
              color: isBold ? const Color(0xFF212121) : Colors.grey.shade600,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? const Color(0xFF212121),
          ),
        ),
      ],
    );
  }
}
