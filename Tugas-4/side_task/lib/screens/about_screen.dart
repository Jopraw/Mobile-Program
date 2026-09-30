// ============================================================
// screens/about_screen.dart
// SCREEN 2: About Me
// Profil lengkap, skills, dan pendidikan
// ============================================================

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/app_theme.dart';
import '../widgets/section_title.dart';
import '../widgets/skill_chip.dart';
import '../widgets/primary_button.dart';
import 'contact_screen.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

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
        title: const Text('Tentang Saya'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // ── Bio card ──────────────────────────────────────
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.primary,
                    AppTheme.primary.withValues(alpha: 0.75),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(AppTheme.radiusLg),
                boxShadow: AppTheme.buttonShadow,
              ),
              child: Row(
                children: [
                  // Mini avatar (placeholder)
                  Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white24,
                    ),
                    child: const Icon(Icons.person,
                        color: Colors.white70, size: 32),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Jojo Prawinata Situmeang',
                          style: AppTheme.headlineLarge
                              .copyWith(color: Colors.white),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'NIM: 3337240060',
                          style: AppTheme.bodyMedium
                              .copyWith(color: Colors.white70),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const FaIcon(FontAwesomeIcons.locationDot,
                                size: 11, color: Colors.white60),
                            const SizedBox(width: 4),
                            Text(
                              'Bakauheni, Lampung',
                              style: AppTheme.caption
                                  .copyWith(color: Colors.white60),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // ── Tentang diri ──────────────────────────────────
            const SectionTitle(
              title: 'Siapa Saya',
              subtitle: 'Perkenalan singkat',
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppTheme.surface,
                borderRadius: BorderRadius.circular(AppTheme.radiusMd),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Text(
                'Saya Jojo Prawinata Situmeang, mahasiswa Informatika '
                'Semester 5 di Universitas Sultan Ageng Tirtayasa (Untirta). '
                'Lahir di Bakauheni, 16 Agustus 2005.\n\n'
                'Saya memiliki ketertarikan kuat di bidang Game Development, '
                'Web Development, dan membuat digital art sebagai asset game. '
                'Di luar kuliah, saya senang mendengarkan lagu dan aktif '
                'membangun keterampilan kreatif serta teknis secara mandiri.\n\n'
                'Memiliki pengalaman kerja 1 tahun di loket PPOB yang melatih '
                'kemampuan komunikasi dan ketelitian dalam pelayanan.',
                style: AppTheme.bodyLarge,
              ),
            ),

            const SizedBox(height: 32),

            // ── Pendidikan ────────────────────────────────────
            const SectionTitle(
              title: 'Pendidikan',
              subtitle: 'Latar belakang akademik',
            ),
            const SizedBox(height: 16),
            _educationTile(
              icon: FontAwesomeIcons.buildingColumns,
              institution: 'Universitas Sultan Ageng Tirtayasa',
              degree: 'S1 Informatika — Semester 5',
              year: '2024 — Skrg',
              color: AppTheme.primary,
            ),
            const SizedBox(height: 10),
            _educationTile(
              icon: FontAwesomeIcons.school,
              institution: 'SMKN 1 Cilegon',
              degree: 'Teknik Komputer & Jaringan',
              year: '2021 — 2024',
              color: const Color(0xFF22C55E),
            ),
            const SizedBox(height: 10),
            _educationTile(
              icon: FontAwesomeIcons.briefcase,
              institution: 'Loket PPOB',
              degree: 'Operator Kasir',
              year: '1+ Tahun',
              color: const Color(0xFFF59E0B),
            ),

            const SizedBox(height: 32),

            // ── Skills ────────────────────────────────────────
            const SectionTitle(
              title: 'Keahlian',
              subtitle: 'Teknologi yang dikuasai',
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: skillList.map((s) => SkillChip(
                label: s['label'] as String,
                icon: s['icon'] as IconData,
                color: s['color'] as Color,
              )).toList(),
            ),

            const SizedBox(height: 32),

            // ── Minat ─────────────────────────────────────────
            const SectionTitle(
              title: 'Minat',
              subtitle: 'Bidang yang saya gemari',
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _interestCard(
                    FontAwesomeIcons.gamepad, 'Game Dev',
                    AppTheme.primary),
                const SizedBox(width: 12),
                _interestCard(
                    FontAwesomeIcons.globe, 'Web Dev',
                    const Color(0xFF0EA5E9)),
                const SizedBox(width: 12),
                _interestCard(
                    FontAwesomeIcons.penNib, 'Game Art',
                    const Color(0xFF9C27B0)),
              ],
            ),

            const SizedBox(height: 36),

            // ── CTA ──────────────────────────────────────────
            PrimaryButton(
              label: 'Lihat Proyek Saya',
              icon: FontAwesomeIcons.arrowRight,
              width: double.infinity,
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactScreen()),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _educationTile({
    required IconData icon,
    required String institution,
    required String degree,
    required String year,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusSm),
            ),
            child: Center(
              child: FaIcon(icon, size: 20, color: color),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(institution, style: AppTheme.labelBold),
                const SizedBox(height: 2),
                Text(degree, style: AppTheme.bodyMedium),
              ],
            ),
          ),
          Text(year, style: AppTheme.caption),
        ],
      ),
    );
  }

  Widget _interestCard(IconData icon, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(AppTheme.radiusMd),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            FaIcon(icon, size: 24, color: color),
            const SizedBox(height: 8),
            Text(label, style: AppTheme.caption, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
