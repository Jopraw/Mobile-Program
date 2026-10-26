// ============================================================
// services/product_service.dart
// Service layer untuk konsumsi REST API produk TokoKita
//
// Langkah 1 → Setup service class dengan package http
// Langkah 2 → Request GET ke endpoint https://fakestoreapi.com/products
// Langkah 3 → Parsing JSON response body ke List<Product> via Product.fromJson
// Langkah 5 → Try-catch error handling & pengecekan response.statusCode == 200
// Tugas Mandiri 1 → fetchProductDetail(int id) untuk rincian produk tunggal
// ============================================================

import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/product.dart';

class ProductService {
  // Endpoint dasar Fake Store API (REST API publik produk)
  static const String baseUrl = 'https://fakestoreapi.com';

  final http.Client client;

  // Constructor dengan dukungan dependency injection client (memudahkan testing)
  ProductService({http.Client? client}) : client = client ?? http.Client();

  /// ── Langkah 2 & 3: Mengambil seluruh daftar produk dari REST API ──
  /// [forceSimulatedError]: parameter opsional untuk memicu skenario error (Langkah 5)
  Future<List<Product>> fetchProducts({bool forceSimulatedError = false}) async {
    // Simulasi kegagalan jika diaktifkan (untuk pengujian Langkah 5)
    if (forceSimulatedError) {
      await Future.delayed(const Duration(milliseconds: 600));
      throw const SocketException(
        'Simulasi Error: Gagal terhubung ke Fake Store API (Koneksi Terputus).',
      );
    }

    final Uri url = Uri.parse('$baseUrl/products');

    try {
      if (kDebugMode) {
        print('🌐 [ProductService] Mengirim GET request ke: $url');
      }

      // Langkah 2: Mengirim HTTP GET request secara asynchronous
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ).timeout(const Duration(seconds: 15));

      // Langkah 2: Mencetak status code dan ringkasan body ke console
      if (kDebugMode) {
        print('📡 [ProductService] Response Status Code: ${response.statusCode}');
        print('📦 [ProductService] Response Body Length: ${response.body.length} karakter');
      }

      // Langkah 5: Pengecekan response.statusCode sebelum data diproses
      if (response.statusCode == 200) {
        // Langkah 3: Mengubah JSON string menjadi struktur data Dart List of Map
        final List<dynamic> jsonList = jsonDecode(response.body);

        // Langkah 3: Memetakan setiap item JSON menjadi instance Product
        final List<Product> products = jsonList
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();

        if (kDebugMode) {
          print('✅ [ProductService] Berhasil mem-parsing ${products.length} produk.');
        }

        return products;
      } else {
        // Status code selain 200 (misalnya 404, 500, 502)
        throw HttpException(
          'Server merespons dengan kesalahan status code: ${response.statusCode}',
        );
      }
    } on SocketException catch (e) {
      // Menangkap error jaringan offline / DNS failure
      if (kDebugMode) print('❌ [ProductService] Kesalahan Jaringan (SocketException): $e');
      throw const SocketException(
        'Tidak dapat terhubung ke internet. Periksa koneksi data atau Wi-Fi Anda.',
      );
    } on http.ClientException catch (e) {
      if (kDebugMode) print('❌ [ProductService] ClientException: $e');
      throw Exception('Gagal melakukan permintaan HTTP: ${e.message}');
    } catch (e) {
      if (kDebugMode) print('❌ [ProductService] Terjadi kesalahan tak terduga: $e');
      rethrow;
    }
  }

  /// ── Tugas Mandiri 1: Mengambil detail satu produk spesifik berdasarkan ID ──
  /// Endpoint: https://fakestoreapi.com/products/{id}
  Future<Product> fetchProductDetail(int id, {bool forceSimulatedError = false}) async {
    if (forceSimulatedError) {
      await Future.delayed(const Duration(milliseconds: 600));
      throw const SocketException('Simulasi Error Detail: Tidak ada respon dari server.');
    }

    final Uri url = Uri.parse('$baseUrl/products/$id');

    try {
      if (kDebugMode) {
        print('🌐 [ProductService] Mengambil detail produk ID: $id dari $url');
      }

      final response = await client.get(
        url,
        headers: {'Accept': 'application/json'},
      ).timeout(const Duration(seconds: 15));

      if (kDebugMode) {
        print('📡 [ProductService] Detail Status Code: ${response.statusCode}');
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return Product.fromJson(jsonMap);
      } else {
        throw HttpException(
          'Gagal mengambil rincian produk (Kode Status: ${response.statusCode})',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ [ProductService] Gagal memuat detail produk ID $id: $e');
      }
      rethrow;
    }
  }
}
