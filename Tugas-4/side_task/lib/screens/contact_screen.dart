// ============================================================
// screens/contact_screen.dart
// SCREEN 3: Proyek & Kontak
// Daftar proyek + informasi kontak lengkap
// ============================================================

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/app_theme.dart';
import '../widgets/section_title.dart';
import '../widgets/project_card.dart';
import '../widgets/info_tile.dart';
import '../widgets/primary_button.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(
                  color: AppTheme.primary.withValues(alpha: 0.2)),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: const Icon(Icons.arrow_back_ios_new,
                size: 16, color: AppTheme.primary),
          ),
        ),
        title: const Text('Proyek & Kontak'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Header banner ──────────────────────────────────
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppTheme.accent.withValues(alpha: 0.15),
                      borderRadius:
                          BorderRadius.circular(AppTheme.radiusFull),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const FaIcon(FontAwesomeIcons.briefcase,
                            size: 11, color: AppTheme.accent),
                        const SizedBox(width: 6),
                        Text(
                          'KARYA TERBAIK',
                          style: AppTheme.caption.copyWith(
                            color: AppTheme.accent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Proyek yang\nTelah Saya Buat',
                      style: AppTheme.displayMedium),
                  const SizedBox(height: 8),
                  Text(
                    'Koleksi proyek yang dikerjakan selama perkuliahan '
                    'dan belajar mandiri.',
                    style: AppTheme.bodyMedium,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // ── Daftar proyek ─────────────────────────────────
            const SectionTitle(
              title: 'Proyek',
              subtitle: 'Portofolio karya',
            ),
            const SizedBox(height: 16),

            // ListView project cards
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: projectList.length,
              itemBuilder: (context, index) =>
                  ProjectCard(project: projectList[index]),
            ),

            const SizedBox(height: 28),

            // ── Kontak ────────────────────────────────────────
            const SectionTitle(
              title: 'Kontak',
              subtitle: 'Hubungi saya melalui',
            ),
            const SizedBox(height: 16),

            InfoTile(
              icon: FontAwesomeIcons.envelope,
              label: 'Email',
              value: 'mahasiswa@email.com',
              iconColor: const Color(0xFFEA4335),
              onTap: () {},
            ),
            InfoTile(
              icon: FontAwesomeIcons.phone,
              label: 'WhatsApp',
              value: '+62 812-3456-7890',
              iconColor: const Color(0xFF25D366),
              onTap: () {},
            ),
            InfoTile(
              icon: FontAwesomeIcons.linkedin,
              label: 'LinkedIn',
              value: 'linkedin.com/in/mahasiswa',
              iconColor: const Color(0xFF0077B5),
              onTap: () {},
            ),
            InfoTile(
              icon: FontAwesomeIcons.github,
              label: 'GitHub',
              value: 'github.com/mahasiswa',
              iconColor: const Color(0xFF333333),
              onTap: () {},
            ),
            InfoTile(
              icon: FontAwesomeIcons.locationDot,
              label: 'Lokasi',
              value: 'Kota, Indonesia',
              iconColor: const Color(0xFFEF4444),
            ),

            const SizedBox(height: 28),

            // ── CTA: kirim pesan ──────────────────────────────
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.accent.withValues(alpha: 0.15),
                    AppTheme.accentLight.withValues(alpha: 0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                border: Border.all(
                    color: AppTheme.accent.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  const FaIcon(FontAwesomeIcons.solidPaperPlane,
                      size: 32, color: AppTheme.accent),
                  const SizedBox(height: 12),
                  Text('Mari Berkolaborasi!',
                      style: AppTheme.headlineLarge),
                  const SizedBox(height: 8),
                  Text(
                    'Terbuka untuk proyek freelance, magang, '
                    'atau sekadar diskusi teknologi.',
                    style: AppTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  PrimaryButton(
                    label: 'Kirim Pesan',
                    icon: FontAwesomeIcons.paperPlane,
                    width: double.infinity,
                    bgColor: AppTheme.accent,
                    onPressed: () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Footer ───────────────────────────────────────
            Center(
              child: Text(
                'Dibuat dengan ❤ menggunakan Flutter',
                style: AppTheme.caption,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
