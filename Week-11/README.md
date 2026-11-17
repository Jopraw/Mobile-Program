# Week 11 — Aplikasi Flutter CRUD dengan JSONPlaceholder (`/posts`)

Aplikasi Flutter CRUD sederhana dan modern yang menggunakan **1 objek seragam (`Post`)** dari endpoint resmi [`https://jsonplaceholder.typicode.com/posts`](https://jsonplaceholder.typicode.com/posts).

---

## 📌 Struktur Proyek (Hanya 4 File Utama — Mudah Dijelaskan!)

```text
Week-11/
└── lib/
    ├── main.dart                  # 1. Pintu masuk aplikasi & tema Material 3
    ├── models/
    │   └── post.dart              # 2. Model data Post (id, title, body) + fromJson & toJson
    ├── services/
    │   └── api_service.dart       # 3. 4 fungsi HTTP CRUD (GET, POST, PUT, DELETE)
    └── screens/
        └── post_page.dart         # 4. Halaman UI Daftar Post, Form Tambah/Edit, & Hapus
```

---

## 🔄 Penjelasan 4 Fungsi CRUD (`lib/services/api_service.dart`)

| Operasi CRUD | Method HTTP | Fungsi di Kode | Endpoint | Kode Status Sukses |
| :--- | :--- | :--- | :--- | :--- |
| **1. Read (Baca Data)** | `http.get` | `getPosts()` | `GET /posts` | `200 OK` |
| **2. Create (Tambah Data)** | `http.post` | `createPost(title, body)` | `POST /posts` | `201 Created` |
| **3. Update (Edit Data)** | `http.put` | `updatePost(id, title, body)` | `PUT /posts/{id}` | `200 OK` |
| **4. Delete (Hapus Data)** | `http.delete` | `deletePost(id)` | `DELETE /posts/{id}` | `200 OK` |

---

## 💡 Cara Menjelaskan Kode ke Dosen (3 Poin Inti)

1. **Model `Post` (`lib/models/post.dart`):**
   - Menyimpan 3 properti dari `/posts`: `id` (`int`), `title` (`String`), dan `body` (`String`).
   - Memiliki `factory Post.fromJson(...)` untuk mengubah JSON dari server menjadi objek Dart saat menerima respons.
2. **Service `ApiService` (`lib/services/api_service.dart`):**
   - Memisahkan logika internet (`http`) dari kode tampilan UI.
   - Menggunakan `jsonDecode` saat membaca respons dari server, dan `jsonEncode` saat mengirim data baru/edit ke server.
3. **UI `PostPage` (`lib/screens/post_page.dart`):**
   - Menggunakan `StatefulWidget` yang menyimpan `List<Post> _posts`.
   - Menggunakan **1 fungsi bottom sheet (`_showFormDialog`)** untuk dua keperluan sekaligus: jika parameter `post` kosong berarti **Tambah Baru (POST)**, jika berisi objek `post` berarti **Edit Data (PUT)**.
   - Karena JSONPlaceholder adalah *fake REST API* (tidak menyimpan perubahan secara permanen di database mereka), setelah server merespons `201` (POST) atau `200` (PUT/DELETE), kita memperbarui `_posts` di memori lokal dengan `setState()` agar perubahan langsung terlihat nyata di layar.
