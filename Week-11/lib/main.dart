import 'package:flutter/material.dart';
import 'screens/post_page.dart';

void main() {
  runApp(const CrudPostsApp());
}

class CrudPostsApp extends StatelessWidget {
  const CrudPostsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JSONPlaceholder CRUD Posts',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4F46E5), // Indigo modern
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const PostPage(),
    );
  }
}
