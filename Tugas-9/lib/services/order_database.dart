// ============================================================
// services/order_database.dart
// Helper SQLite (sqflite) untuk riwayat pesanan — Pertemuan 9
//
// Langkah 3: Inisialisasi database & pembuatan tabel orders
// Langkah 4: CRUD — insertOrder, getAllOrders, updateOrderStatus, deleteOrder
// Tugas Mandiri 3: searchOrdersByStatus memakai klausa WHERE
// ============================================================

import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';
import '../models/order.dart';

class OrderDatabase {
  static const String _dbName = 'tokokita_orders.db';
  static const String table = 'orders';

  /// Path database dapat diganti (mis. inMemoryDatabasePath) untuk pengujian.
  final String? customPath;
  Database? _db;

  OrderDatabase({this.customPath});

  Future<Database> get database async {
    return _db ??= await _open();
  }

  Future<Database> _open() async {
    final path = customPath ?? p.join(await getDatabasesPath(), _dbName);
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $table (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            tanggal TEXT NOT NULL,
            daftarItem TEXT NOT NULL,
            totalHarga REAL NOT NULL,
            status TEXT NOT NULL
          )
        ''');
      },
    );
  }

  /// Create — menyimpan pesanan baru, mengembalikan id baris yang dibuat
  Future<int> insertOrder(OrderRecord order) async {
    final db = await database;
    return db.insert(table, order.toMap());
  }

  /// Read — seluruh riwayat, terbaru di atas
  Future<List<OrderRecord>> getAllOrders() async {
    final db = await database;
    final rows = await db.query(table, orderBy: 'tanggal DESC, id DESC');
    return rows.map(OrderRecord.fromMap).toList();
  }

  /// Read dengan WHERE — pencarian berdasarkan status (LIKE, tidak peka huruf besar/kecil)
  Future<List<OrderRecord>> searchOrdersByStatus(String keyword) async {
    final db = await database;
    final rows = await db.query(
      table,
      where: 'status LIKE ?',
      whereArgs: ['%${keyword.trim()}%'],
      orderBy: 'tanggal DESC, id DESC',
    );
    return rows.map(OrderRecord.fromMap).toList();
  }

  /// Update — mengubah status satu pesanan
  Future<int> updateOrderStatus(int id, String status) async {
    final db = await database;
    return db.update(
      table,
      {'status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete — menghapus satu pesanan
  Future<int> deleteOrder(int id) async {
    final db = await database;
    return db.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
