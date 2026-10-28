// ============================================================
// models/order.dart
// Model riwayat pesanan TokoKita — Pertemuan 9 (SQLite)
// ============================================================

import 'dart:convert';

/// Satu baris item di dalam sebuah pesanan (disimpan sebagai JSON di kolom daftarItem)
class OrderItem {
  final int productId;
  final String name;
  final int quantity;
  final double unitPrice;

  const OrderItem({
    required this.productId,
    required this.name,
    required this.quantity,
    required this.unitPrice,
  });

  double get subtotal => unitPrice * quantity;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'name': name,
        'quantity': quantity,
        'unitPrice': unitPrice,
      };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        productId: json['productId'] as int,
        name: json['name'] as String,
        quantity: json['quantity'] as int,
        unitPrice: (json['unitPrice'] as num).toDouble(),
      );
}

/// Status yang dikenal pada riwayat pesanan
class OrderStatus {
  static const String diproses = 'Diproses';
  static const String selesai = 'Selesai';
  static const List<String> all = [diproses, selesai];
}

/// Entitas pesanan — memetakan satu baris pada tabel `orders`
class OrderRecord {
  final int? id;
  final DateTime tanggal;
  final List<OrderItem> daftarItem;
  final double totalHarga;
  final String status;

  const OrderRecord({
    this.id,
    required this.tanggal,
    required this.daftarItem,
    required this.totalHarga,
    this.status = OrderStatus.diproses,
  });

  int get totalUnit => daftarItem.fold(0, (sum, i) => sum + i.quantity);

  Map<String, dynamic> toMap() => {
        if (id != null) 'id': id,
        'tanggal': tanggal.toIso8601String(),
        'daftarItem': jsonEncode(daftarItem.map((i) => i.toJson()).toList()),
        'totalHarga': totalHarga,
        'status': status,
      };

  factory OrderRecord.fromMap(Map<String, Object?> map) {
    final raw = jsonDecode(map['daftarItem'] as String) as List<dynamic>;
    return OrderRecord(
      id: map['id'] as int?,
      tanggal: DateTime.parse(map['tanggal'] as String),
      daftarItem: raw
          .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalHarga: (map['totalHarga'] as num).toDouble(),
      status: map['status'] as String,
    );
  }
}
