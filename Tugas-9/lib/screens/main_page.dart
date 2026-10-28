// ============================================================
// screens/main_page.dart
// Kerangka Bottom Navigation TokoKita — Pertemuan 6
//
// Langkah 2: Inisialisasi CartController dengan Get.put()
// Langkah 3: Badge ikon keranjang di BottomNavigationBar reaktif dengan Obx
// ============================================================

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/cart_controller.dart';
import '../controllers/navigation_controller.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

/// MainPage — Kerangka navigasi dasar tab bottom navigation TokoKita
class MainPage extends StatelessWidget {
  final int initialIndex;

  const MainPage({super.key, this.initialIndex = 0});

  @override
  Widget build(BuildContext context) {
    // ── Langkah 2: Dependency Injection via Get.put() ──
    // Daftarkan controller ke memori agar tersedia secara global di seluruh aplikasi
    final CartController cartController = Get.isRegistered<CartController>()
        ? Get.find<CartController>()
        : Get.put(CartController(), permanent: true);

    final NavigationController navController = Get.isRegistered<NavigationController>()
        ? Get.find<NavigationController>()
        : Get.put(NavigationController(), permanent: true);

    if (initialIndex != 0 && navController.currentIndex.value != initialIndex) {
      navController.changeTab(initialIndex);
    }

    final List<Widget> pages = [
      const HomePage(),
      const CartPage(),
      const ProfilePage(),
    ];

    return Scaffold(
      // Menggunakan Obx dan IndexedStack agar state halaman tetap terjaga saat ganti tab
      body: Obx(() => IndexedStack(
            index: navController.currentIndex.value,
            children: pages,
          )),

      // ── Langkah 3: BottomNavigationBar dengan Obx pada Badge Keranjang ──
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, -3),
            ),
          ],
        ),
        child: Obx(() => BottomNavigationBar(
              currentIndex: navController.currentIndex.value,
              onTap: (int index) => navController.changeTab(index),
              backgroundColor: Colors.white,
              selectedItemColor: Colors.deepOrange,
              unselectedItemColor: Colors.grey.shade600,
              selectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
              unselectedLabelStyle:
                  const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
              type: BottomNavigationBarType.fixed,
              elevation: 0,
              items: [
                const BottomNavigationBarItem(
                  icon: Icon(Icons.home_outlined),
                  activeIcon: Icon(Icons.home),
                  label: 'Beranda',
                  tooltip: 'Halaman Utama',
                ),

                // Tab Keranjang dengan Badge Reaktif via Obx
                BottomNavigationBarItem(
                  icon: Obx(() {
                    final int count = cartController.totalItem;
                    return Badge(
                      isLabelVisible: count > 0,
                      label: Text(
                        count > 99 ? '99+' : '$count',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.deepOrange,
                      child: const Icon(Icons.shopping_cart_outlined),
                    );
                  }),
                  activeIcon: Obx(() {
                    final int count = cartController.totalItem;
                    return Badge(
                      isLabelVisible: count > 0,
                      label: Text(
                        count > 99 ? '99+' : '$count',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      backgroundColor: Colors.deepOrange,
                      child: const Icon(Icons.shopping_cart),
                    );
                  }),
                  label: 'Keranjang',
                  tooltip: 'Keranjang Belanja',
                ),

                const BottomNavigationBarItem(
                  icon: Icon(Icons.person_outline),
                  activeIcon: Icon(Icons.person),
                  label: 'Profil',
                  tooltip: 'Profil Mahasiswa',
                ),
              ],
            )),
      ),
    );
  }
}
