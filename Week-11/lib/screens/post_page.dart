import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/post.dart';
import '../services/api_service.dart';

/// Halaman utama CRUD Posts JSONPlaceholder.
/// Menampilkan daftar Post (Read), form Tambah (Create), Edit (Update), dan Hapus (Delete).
class PostPage extends StatefulWidget {
  final ApiService? apiService;

  const PostPage({super.key, this.apiService});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  static const String _storageKey = 'cached_posts_v1';

  late final ApiService _api;
  final List<Post> _posts = [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _api = widget.apiService ?? ApiService();
    _loadInitialPosts();
  }

  // Membaca dari penyimpanan lokal terlebih dahulu agar data yang ditambah/diedit
  // tidak hilang saat aplikasi di-restart. Jika belum ada, ambil dari API.
  Future<void> _loadInitialPosts() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final savedJson = prefs.getString(_storageKey);

      if (savedJson != null && savedJson.isNotEmpty) {
        final List<dynamic> decoded = jsonDecode(savedJson);
        final cachedPosts = decoded
            .map((e) => Post.fromJson(e as Map<String, dynamic>))
            .toList();
        if (!mounted) return;
        setState(() {
          _posts
            ..clear()
            ..addAll(cachedPosts);
          _isLoading = false;
        });
        return;
      }
    } catch (_) {
      // Jika cache gagal dibaca, lanjut ambil dari API
    }

    await _fetchFromServer();
  }

  // Menyimpan perubahan daftar _posts ke penyimpanan lokal
  Future<void> _saveToLocalCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final encoded = jsonEncode(_posts.map((p) => p.toJson()).toList());
      await prefs.setString(_storageKey, encoded);
    } catch (_) {}
  }

  // ── 1. READ: Ambil ulang 100 data asli dari server JSONPlaceholder ──
  Future<void> _fetchFromServer({bool showNotif = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final data = await _api.getPosts();
      if (!mounted) return;
      setState(() {
        _posts
          ..clear()
          ..addAll(data);
        _isLoading = false;
      });
      await _saveToLocalCache();
      if (showNotif) {
        _showSnack('Data di-reset ke 100 Post asli server (GET 200)', Colors.indigo);
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  // ── 2 & 3. CREATE & UPDATE: Dialog Form (Satu fungsi untuk Tambah & Edit) ──
  Future<void> _showFormDialog({Post? post}) async {
    final isEdit = post != null;
    final titleController = TextEditingController(text: post?.title ?? '');
    final bodyController = TextEditingController(text: post?.body ?? '');
    final formKey = GlobalKey<FormState>();

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(sheetContext).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 28),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    isEdit ? 'Edit Post #${post.id}' : 'Tambah Post Baru',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Input Judul Post
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: 'Judul Post (title)',
                      hintText: 'Masukkan judul catatan...',
                      prefixIcon: const Icon(Icons.title_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (val) => (val == null || val.trim().isEmpty)
                        ? 'Judul tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 14),

                  // Input Isi Post
                  TextFormField(
                    controller: bodyController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: 'Isi Post (body)',
                      hintText: 'Tulis isi pesan atau artikel...',
                      prefixIcon: const Icon(Icons.notes_rounded),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    validator: (val) => (val == null || val.trim().isEmpty)
                        ? 'Isi post tidak boleh kosong'
                        : null,
                  ),
                  const SizedBox(height: 20),

                  // Tombol Simpan
                  FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (!formKey.currentState!.validate()) return;

                      final title = titleController.text.trim();
                      final body = bodyController.text.trim();
                      Navigator.pop(sheetContext);

                      if (isEdit) {
                        await _handleUpdate(post.id, title, body);
                      } else {
                        await _handleCreate(title, body);
                      }
                    },
                    icon: Icon(isEdit ? Icons.save_rounded : Icons.add_rounded),
                    label: Text(
                      isEdit ? 'Simpan Perubahan (PUT)' : 'Kirim Post Baru (POST)',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Eksekusi CREATE ke API lalu tambahkan ke urutan teratas List & simpan lokal
  Future<void> _handleCreate(String title, String body) async {
    try {
      final created = await _api.createPost(title, body);
      if (!mounted) return;
      setState(() {
        final nextId = _posts.isEmpty
            ? 1
            : (_posts.map((e) => e.id).reduce((a, b) => a > b ? a : b) + 1);
        _posts.insert(
          0,
          Post(id: nextId, title: created.title, body: created.body),
        );
      });
      await _saveToLocalCache();
      _showSnack('Post berhasil ditambahkan & disimpan (POST 201)', Colors.green.shade700);
    } catch (e) {
      _showSnack('Gagal menambah post: $e', Colors.red.shade700);
    }
  }

  // Eksekusi UPDATE ke API lalu perbarui item di dalam List & simpan lokal
  Future<void> _handleUpdate(int id, String title, String body) async {
    try {
      final updated = await _api.updatePost(id, title, body);
      if (!mounted) return;
      setState(() {
        final index = _posts.indexWhere((item) => item.id == id);
        if (index != -1) {
          _posts[index] = updated;
        }
      });
      await _saveToLocalCache();
      _showSnack('Post #$id berhasil diperbarui & disimpan (PUT 200)', Colors.indigo);
    } catch (e) {
      _showSnack('Gagal mengubah post: $e', Colors.red.shade700);
    }
  }

  // ── 4. DELETE: Hapus data di API lalu hapus dari List & simpan lokal ──
  Future<void> _handleDelete(Post post) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Hapus Post?'),
        content: Text('Yakin ingin menghapus Post #${post.id} "${post.title}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus (DELETE)'),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await _api.deletePost(post.id);
      if (!mounted) return;
      setState(() {
        _posts.removeWhere((item) => item.id == post.id);
      });
      await _saveToLocalCache();
      _showSnack('Post #${post.id} berhasil dihapus (DELETE 200)', Colors.red.shade700);
    } catch (e) {
      _showSnack('Gagal menghapus post: $e', Colors.red.shade700);
    }
  }

  void _showSnack(String message, Color bgColor) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: AppBar(
        backgroundColor: colorScheme.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'JSONPlaceholder CRUD (/posts)',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        actions: [
          IconButton(
            tooltip: 'Reset ke 100 Data Asli Server (GET)',
            onPressed: () => _fetchFromServer(showNotif: true),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          // ── Banner Ringkasan di Atas Daftar ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(24),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Objek: Postingan Teks (/posts)',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Total Data Aktif: ${_posts.length} Post',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'GET • POST • PUT • DELETE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Isi Utama (Loading / Error / Daftar Post) ──
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.error_outline, size: 48, color: Colors.red),
                              const SizedBox(height: 12),
                              Text(_errorMessage!, textAlign: TextAlign.center),
                              const SizedBox(height: 16),
                              FilledButton.icon(
                                onPressed: _fetchFromServer,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Coba Lagi'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                        // itemExtent mengunci tinggi tiap item (152px) sehingga
                        // saat scrollbar ditarik jauh dari atas ke bawah, Flutter
                        // tidak perlu menghitung ulang 100 kartu satu per satu (0 lag!).
                        itemExtent: 152,
                        itemCount: _posts.length,
                        itemBuilder: (context, index) {
                          final post = _posts[index];
                          return _buildPostCard(post, colorScheme);
                        },
                      ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showFormDialog(),
        icon: const Icon(Icons.add_rounded),
        label: const Text('Tambah Post'),
      ),
    );
  }

  // Widget kartu untuk menampilkan 1 item Post beserta tombol Edit & Hapus
  Widget _buildPostCard(Post post, ColorScheme colorScheme) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        side: BorderSide(color: Color(0xFFE5E7EB)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                // Badge ID Post
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.all(Radius.circular(8)),
                  ),
                  child: Text(
                    'POST #${post.id}',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onPrimaryContainer,
                    ),
                  ),
                ),
                const Spacer(),
                // Tombol Edit (UPDATE / PUT) — tanpa Tooltip berat agar scroll cepat 60fps
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  onPressed: () => _showFormDialog(post: post),
                  icon: Icon(Icons.edit_outlined, size: 20, color: colorScheme.primary),
                ),
                const SizedBox(width: 4),
                // Tombol Hapus (DELETE)
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                  onPressed: () => _handleDelete(post),
                  icon: const Icon(Icons.delete_outline_rounded, size: 20, color: Color(0xFFE53935)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            // Judul Post (maksimal 1 baris agar tinggi kartu seragam & bebas lag)
            Text(
              post.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 4),
            // Isi Post (maksimal 2 baris)
            Expanded(
              child: Text(
                post.body.replaceAll('\n', ' '),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.35,
                  color: Color(0xFF64748B),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
