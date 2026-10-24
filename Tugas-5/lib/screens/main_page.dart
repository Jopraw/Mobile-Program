// ============================================================
// screens/main_page.dart
// Kerangka Bottom Navigation TokoKita — Pertemuan 5
//
// Langkah 5:
// Halaman utama aplikasi (home pada MaterialApp) dengan
// BottomNavigationBar berisi 3 menu: Beranda, Keranjang, dan Profil
// ============================================================

import 'package:flutter/material.dart';
import 'home_page.dart';
import 'cart_page.dart';
import 'profile_page.dart';

/// MainPage — Kerangka navigasi dasar tab bottom navigation TokoKita
class MainPage extends StatefulWidget {
  final int initialIndex;

  const MainPage({super.key, this.initialIndex = 0});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // Index tab yang sedang aktif (0 = Beranda, 1 = Keranjang, 2 = Profil)
  late int _currentIndex;

  // Daftar halaman tab utama
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pages = [
      const HomePage(),
      CartPage(
        onExplorePressed: () {
          // Beralih ke tab Beranda jika tombol ditekan di tab Keranjang
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
      const ProfilePage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Menggunakan IndexedStack agar status scroll halaman tetap tersimpan
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),

      // ── Langkah 5: BottomNavigationBar TokoKita ──
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
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (int index) {
            setState(() {
              _currentIndex = index;
            });
          },
          backgroundColor: Colors.white,
          selectedItemColor: Colors.deepOrange,
          unselectedItemColor: Colors.grey.shade600,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.normal, fontSize: 12),
          type: BottomNavigationBarType.fixed,
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Beranda',
              tooltip: 'Halaman Utama',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart_outlined),
              activeIcon: Icon(Icons.shopping_cart),
              label: 'Keranjang',
              tooltip: 'Keranjang Belanja',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
              tooltip: 'Profil Saya',
            ),
          ],
        ),
      ),
    );
  }
}
