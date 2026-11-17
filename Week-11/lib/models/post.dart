/// Model data untuk objek Post dari JSONPlaceholder (/posts).
/// Semua item di aplikasi ini menggunakan 1 model seragam ini.
class Post {
  final int id;
  final String title;
  final String body;

  const Post({
    required this.id,
    required this.title,
    required this.body,
  });

  /// Mengubah data Map JSON dari API menjadi objek Post (dipakai saat GET / POST / PUT)
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  /// Mengubah objek Post menjadi Map JSON untuk dikirim ke API (dipakai saat POST / PUT)
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'userId': 1,
    };
  }
}
