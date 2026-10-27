// ============================================================
// widgets/project_card.dart
// Komponen Visual 5: PROJECT CARD
// Kartu proyek dengan gambar jaringan, gradient overlay, tag
// ============================================================

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../core/app_theme.dart';

class ProjectData {
  final String title;
  final String description;
  final String imageUrl;
  final List<String> tags;
  final String type;
  final IconData typeIcon;
  final Color accentColor;

  const ProjectData({
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.tags,
    required this.type,
    required this.typeIcon,
    required this.accentColor,
  });
}

/// ProjectCard — kartu proyek bergradient dengan gambar
class ProjectCard extends StatelessWidget {
  final ProjectData project;

  const ProjectCard({super.key, required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        borderRadius: BorderRadius.circular(AppTheme.radiusMd),
        boxShadow: AppTheme.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Gambar proyek ──
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppTheme.radiusMd),
            ),
            child: Stack(
              children: [
                Image.network(
                  project.imageUrl,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, _, _) => Container(
                    height: 160,
                    color: project.accentColor.withValues(alpha: 0.15),
                    child: Center(
                      child: FaIcon(
                        project.typeIcon,
                        size: 48,
                        color: project.accentColor.withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),
                // Gradient overlay di bagian bawah gambar
                Positioned(
                  bottom: 0, left: 0, right: 0,
                  child: Container(
                    height: 70,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.primary.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ),
                // Badge tipe proyek di pojok kanan atas
                Positioned(
                  top: 12, right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: project.accentColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FaIcon(project.typeIcon,
                            size: 10, color: Colors.white),
                        const SizedBox(width: 5),
                        Text(
                          project.type,
                          style: AppTheme.caption
                              .copyWith(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Isi kartu ──
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(project.title, style: AppTheme.headlineLarge),
                const SizedBox(height: 6),
                Text(project.description, style: AppTheme.bodyMedium,
                    maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 12),
                // Tag teknologi
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: project.tags.map((tag) => Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppTheme.cardBg,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(tag, style: AppTheme.caption),
                  )).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Data dummy proyek ──────────────────────────────────────
final List<ProjectData> projectList = [
  ProjectData(
    title: 'TokoKita App',
    description: 'Aplikasi e-commerce Flutter dengan daftar produk, '
        'badge diskon, dan fitur favorit produk.',
    imageUrl: 'https://images.unsplash.com/photo-1556742049-0cfed4f6a45d'
        '?w=600&q=80',
    tags: ['Flutter', 'Dart', 'Firebase'],
    type: 'Mobile',
    typeIcon: FontAwesomeIcons.mobile,
    accentColor: const Color(0xFF54C5F8),
  ),
  ProjectData(
    title: 'Sistem Manajemen Data',
    description: 'Web dashboard manajemen data mahasiswa berbasis Python '
        'dengan visualisasi grafik interaktif.',
    imageUrl: 'https://images.unsplash.com/photo-1551288049-bebda4e38f71'
        '?w=600&q=80',
    tags: ['Python', 'Django', 'Chart.js'],
    type: 'Web',
    typeIcon: FontAwesomeIcons.globe,
    accentColor: const Color(0xFF3776AB),
  ),
  ProjectData(
    title: 'Portofolio Personal',
    description: 'Website portofolio responsif dengan animasi modern, '
        'dark mode, dan integrasi form kontak.',
    imageUrl: 'https://images.unsplash.com/photo-1467232004584-a241de8bcf5d'
        '?w=600&q=80',
    tags: ['HTML', 'CSS', 'JavaScript'],
    type: 'Web',
    typeIcon: FontAwesomeIcons.code,
    accentColor: const Color(0xFF9C27B0),
  ),
];
