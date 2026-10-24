// ============================================================
// models/cart_item.dart
// Model data item keranjang belanja untuk TokoKita — Pertemuan 6
// ============================================================

import 'package:get/get.dart';
import 'product.dart';

/// CartItem merepresentasikan satu produk di dalam keranjang belanja
/// beserta jumlah (kuantitas) yang dipesan.
class CartItem {
  final Product product;
  final RxInt quantity;

  CartItem({
    required this.product,
    int initialQuantity = 1,
  }) : quantity = initialQuantity.obs;

  /// Harga satuan yang berlaku (memperhitungkan diskon jika DiscountedProduct)
  double get unitPrice {
    if (product is DiscountedProduct) {
      return (product as DiscountedProduct).discountedPrice;
    }
    return product.price;
  }

  /// Subtotal harga untuk item ini (unitPrice * kuantitas)
  double get subtotal => unitPrice * quantity.value;

  /// Subtotal harga asli sebelum diskon
  double get originalSubtotal => product.price * quantity.value;

  /// Total potongan diskon yang didapat untuk item ini
  double get discountAmount => originalSubtotal - subtotal;
}
