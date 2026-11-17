import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post.dart';

/// Service untuk menangani 4 operasi CRUD ke JSONPlaceholder (/posts).
class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/posts';

  // Header wajib agar JSONPlaceholder menerima body berformat JSON
  static const Map<String, String> _headers = {
    'Content-type': 'application/json; charset=UTF-8',
  };

  /// 1. READ (GET) — Mengambil daftar Post dari server
  Future<List<Post>> getPosts() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      // Ambil 15 item pertama agar daftar rapi dan ringan ditampilkan
      return jsonList
          .take(15)
          .map((item) => Post.fromJson(item as Map<String, dynamic>))
          .toList();
    } else {
      throw Exception('Gagal mengambil data posts (${response.statusCode})');
    }
  }

  /// 2. CREATE (POST) — Menambahkan Post baru ke server
  Future<Post> createPost(String title, String body) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: _headers,
      body: jsonEncode({
        'title': title,
        'body': body,
        'userId': 1,
      }),
    );

    // Status 201 Created menandakan data berhasil dibuat di server
    if (response.statusCode == 201) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Gagal menambahkan post (${response.statusCode})');
    }
  }

  /// 3. UPDATE (PUT) — Mengubah data Post berdasarkan ID
  Future<Post> updatePost(int id, String title, String body) async {
    // Catatan: JSONPlaceholder hanya menyediakan ID 1..100 di servernya.
    // Untuk ID <= 100 kita panggil PUT ke /posts/{id}.
    final targetId = id <= 100 ? id : 1;
    final response = await http.put(
      Uri.parse('$baseUrl/$targetId'),
      headers: _headers,
      body: jsonEncode({
        'id': id,
        'title': title,
        'body': body,
        'userId': 1,
      }),
    );

    if (response.statusCode == 200) {
      return Post(id: id, title: title, body: body);
    } else {
      throw Exception('Gagal mengubah post (${response.statusCode})');
    }
  }

  /// 4. DELETE (DELETE) — Menghapus Post berdasarkan ID
  Future<void> deletePost(int id) async {
    final response = await http.delete(Uri.parse('$baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus post (${response.statusCode})');
    }
  }
}
