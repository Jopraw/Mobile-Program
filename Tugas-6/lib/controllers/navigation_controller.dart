// ============================================================
// controllers/navigation_controller.dart
// Controller Manajemen Navigasi Tab Bottom Navigation — Pertemuan 6
// ============================================================

import 'package:get/get.dart';

/// NavigationController mengontrol indeks tab aktif pada BottomNavigationBar
/// sehingga perpindahan tab dapat dipicu dari controller mana saja secara reaktif.
class NavigationController extends GetxController {
  /// Indeks tab yang sedang aktif (0: Beranda, 1: Keranjang, 2: Profil)
  final RxInt currentIndex = 0.obs;

  /// Mengubah tab aktif
  void changeTab(int index) {
    if (index >= 0 && index <= 2) {
      currentIndex.value = index;
    }
  }

  /// Shortcut menuju tab Beranda
  void toHome() => changeTab(0);

  /// Shortcut menuju tab Keranjang
  void toCart() => changeTab(1);

  /// Shortcut menuju tab Profil
  void toProfile() => changeTab(2);
}
