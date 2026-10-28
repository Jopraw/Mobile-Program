// ============================================================
// controllers/wishlist_controller.dart
// Wishlist TokoKita dengan SharedPreferences — Pertemuan 9
//
// Langkah 1: simpan daftar ID favorit via setStringList, muat via getStringList
// Langkah 2: dasar halaman Wishlist (hapus item memperbarui prefs & tampilan)
// ============================================================

import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WishlistController extends GetxController {
  static const String prefsKey = 'wishlist_product_ids';

  /// ID produk favorit (reaktif)
  final RxSet<int> favoriteIds = <int>{}.obs;

  /// True setelah data dari SharedPreferences selesai dimuat
  final RxBool isLoaded = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWishlist();
  }

  bool isFavorite(int productId) => favoriteIds.contains(productId);

  /// Muat daftar ID dari SharedPreferences
  Future<void> loadWishlist() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList(prefsKey) ?? <String>[];
    favoriteIds
      ..clear()
      ..addAll(saved.map(int.tryParse).whereType<int>());
    isLoaded.value = true;
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
      prefsKey,
      favoriteIds.map((id) => id.toString()).toList(),
    );
  }

  /// Tambah/hapus favorit lalu simpan
  Future<void> toggleFavorite(int productId) async {
    if (!favoriteIds.remove(productId)) {
      favoriteIds.add(productId);
    }
    await _persist();
  }

  Future<void> removeFromWishlist(int productId) async {
    favoriteIds.remove(productId);
    await _persist();
  }
}
