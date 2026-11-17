import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:crud_posts_app/models/post.dart';
import 'package:crud_posts_app/services/api_service.dart';
import 'package:crud_posts_app/screens/post_page.dart';

class FakeApiService extends ApiService {
  @override
  Future<List<Post>> getPosts() async {
    return const [
      Post(id: 1, title: 'Judul Pertama', body: 'Isi post pertama untuk uji coba.'),
      Post(id: 2, title: 'Judul Kedua', body: 'Isi post kedua untuk uji coba.'),
    ];
  }

  @override
  Future<Post> createPost(String title, String body) async {
    return Post(id: 101, title: title, body: body);
  }

  @override
  Future<Post> updatePost(int id, String title, String body) async {
    return Post(id: id, title: title, body: body);
  }

  @override
  Future<void> deletePost(int id) async {}
}

void main() {
  testWidgets('CRUD PostPage: Read, Create, Update, dan Delete berjalan lancar', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PostPage(apiService: FakeApiService()),
      ),
    );
    await tester.pumpAndSettle();

    // 1. READ: Pastikan 2 post awal tampil
    expect(find.text('Judul Pertama'), findsOneWidget);
    expect(find.text('Judul Kedua'), findsOneWidget);
    expect(find.text('Total Data Aktif: 2 Post'), findsOneWidget);

    // 2. CREATE: Klik tombol Tambah Post
    await tester.tap(find.text('Tambah Post'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextFormField).at(0), 'Post Baru Minggu 11');
    await tester.enterText(find.byType(TextFormField).at(1), 'Konten post baru CRUD Flutter.');
    await tester.tap(find.text('Kirim Post Baru (POST)'));
    await tester.pumpAndSettle();

    expect(find.text('Post Baru Minggu 11'), findsOneWidget);
    expect(find.text('Total Data Aktif: 3 Post'), findsOneWidget);
  });
}
