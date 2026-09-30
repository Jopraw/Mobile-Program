// ============================================================
// screens/home_screen.dart
// SCREEN 1: Home / Landing Page
// Hero section dengan foto profil, nama, tagline, dan CTA
// ============================================================

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/app_theme.dart';
import '../widgets/primary_button.dart';
import 'about_screen.dart';
import 'contact_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // ── Background dekoratif ──
          Positioned(
            top: -80, right: -80,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.accent.withValues(alpha: 0.12),
              ),
            ),
          ),
          Positioned(
            bottom: 100, left: -60,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppTheme.primary.withValues(alpha: 0.07),
              ),
            ),
          ),

          // ── Konten utama ──
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                  horizontal: 28, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Top bar ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Portofolio',
                        style: AppTheme.bodyMedium.copyWith(
                          letterSpacing: 2,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.primary,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(context,
                          MaterialPageRoute(
                              builder: (_) => const ContactScreen())),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppTheme.primary.withValues(alpha: 0.3)),
                            borderRadius:
                                BorderRadius.circular(AppTheme.radiusFull),
                          ),
                          child: Row(
                            children: [
                              const FaIcon(FontAwesomeIcons.envelope,
                                  size: 12, color: AppTheme.primary),
                              const SizedBox(width: 6),
                              Text('Kontak',
                                  style: AppTheme.labelBold
                                      .copyWith(color: AppTheme.primary)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 48),

                  // ── Foto profil (placeholder) ──
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Ring dekoratif luar
                        Container(
                          width: 140,
                          height: 140,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: AppTheme.accent.withValues(alpha: 0.5),
                              width: 2.5,
                            ),
                          ),
                        ),
                        // Placeholder foto profil
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppTheme.primary.withValues(alpha: 0.08),
                            border: Border.all(
                              color: AppTheme.primary.withValues(alpha: 0.15),
                              width: 1.5,
                            ),
                          ),
                          child: const Center(
                            child: FaIcon(
                              FontAwesomeIcons.user,
                              size: 48,
                              color: AppTheme.primary,
                            ),
                          ),
                        ),
                        // Badge "Aktif"
                        Positioned(
                          bottom: 6, right: 6,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E),
                              borderRadius:
                                  BorderRadius.circular(AppTheme.radiusFull),
                              border: Border.all(
                                  color: Colors.white, width: 2),
                            ),
                            child: const Text(
                              '● Aktif',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Teks hero ──
                  Center(
                    child: Column(
                      children: [
                        Text(
                          'Hai, Saya',
                          style: AppTheme.bodyLarge.copyWith(
                            color: AppTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Jojo Prawinata Situmeang',
                          style: AppTheme.displayLarge.copyWith(
                            color: AppTheme.primary,
                            fontSize: 26,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        // Tagline dengan aksen italic Playfair Display
                        RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Game Dev  ',
                                style: AppTheme.headlineLarge.copyWith(
                                  color: AppTheme.textSecondary,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              TextSpan(
                                text: '& Web Dev',
                                style: AppTheme.headlineAccent,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ── Deskripsi singkat ──
                  Center(
                    child: Text(
                      'Mahasiswa Informatika Semester 5 di Universitas Sultan '
                      'Ageng Tirtayasa. Passionate di Game Dev, Web Dev, '
                      'dan membuat art asset untuk game.',
                      style: AppTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),

                  const SizedBox(height: 36),

                  // ── Statistik ──
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _stat('1+', 'Tahun\nPengalaman'),
                      _divider(),
                      _stat('Sem 5', 'Informatika\nUntirta'),
                      _divider(),
                      _stat('3+', 'Bidang\nMinat'),
                    ],
                  ),

                  const SizedBox(height: 40),

                  // ── CTA Buttons ──
                  Row(
                    children: [
                      Expanded(
                        child: PrimaryButton(
                          label: 'Lihat Proyek',
                          icon: FontAwesomeIcons.folderOpen,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const ContactScreen()),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          label: 'Tentang Saya',
                          isOutlined: true,
                          icon: FontAwesomeIcons.userTie,
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AboutScreen()),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // ── Social media links ──
                  Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _socialButton(
                          FontAwesomeIcons.github,
                          const Color(0xFF333333),
                        ),
                        const SizedBox(width: 16),
                        _socialButton(
                          FontAwesomeIcons.linkedin,
                          const Color(0xFF0077B5),
                        ),
                        const SizedBox(width: 16),
                        _socialButton(
                          FontAwesomeIcons.instagram,
                          const Color(0xFFE1306C),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _stat(String value, String label) => Column(
    children: [
      Text(
        value,
        style: AppTheme.displayMedium.copyWith(color: AppTheme.primary),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style: AppTheme.caption,
        textAlign: TextAlign.center,
      ),
    ],
  );

  Widget _divider() => Container(
    width: 1,
    height: 40,
    color: AppTheme.primary.withValues(alpha: 0.15),
  );

  Widget _socialButton(IconData icon, Color color) => GestureDetector(
    onTap: () {},
    child: Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.09),
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Center(
        child: FaIcon(icon, size: 18, color: color),
      ),
    ),
  );
}
