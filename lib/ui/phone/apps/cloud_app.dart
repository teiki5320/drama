import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/format.dart';
import '../../../data/cloud_data.dart';
import '../../../providers/phone_state_provider.dart';
import '../../../providers/relationships_provider.dart';
import '../status_bar.dart';

/// App Cloud (iCloud-like) — fichiers organisés par dossier, possibilité
/// d'afficher les fichiers supprimés (« Récupérer ») qui contiennent
/// des indices narratifs cachés.
class CloudApp extends ConsumerStatefulWidget {
  const CloudApp({super.key});

  @override
  ConsumerState<CloudApp> createState() => _CloudAppState();
}

class _CloudAppState extends ConsumerState<CloudApp> {
  bool _showDeleted = false;

  @override
  Widget build(BuildContext context) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final attractionTristan =
        ref.watch(relationshipsProvider)['tristan']?.attraction ?? 0;
    final all = kCloudItems.where((i) {
      if (i.day > day) return false;
      if (i.requiresAttractionTristan != null &&
          attractionTristan < i.requiresAttractionTristan!) {
        return false;
      }
      return true;
    }).toList();
    final visible = all.where((i) => i.isDeleted == _showDeleted).toList();
    final byFolder = <String, List<CloudItem>>{};
    for (final item in visible) {
      byFolder.putIfAbsent(item.folder ?? 'Divers', () => []).add(item);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F7),
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Color(0xFF1A1A1A)),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Color(0xFF007AFF), size: 20),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ref.read(phoneStateProvider.notifier).closeApp();
                  },
                ),
                const SizedBox(width: 4),
                Text(
                  _showDeleted ? 'Récemment supprimés' : 'Fichiers',
                  style: GoogleFonts.crimsonPro(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
          if (!_showDeleted) _StorageHeader(day: day),
          if (!_showDeleted) _FamilySharingCard(day: day),
          if (!_showDeleted && day >= 33) _HKAlertCard(day: day),
          // Toggle Récents / Supprimés
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: const Color(0xFFE5E5EA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  _Tab(
                    label: 'Mes fichiers',
                    selected: !_showDeleted,
                    onTap: () => setState(() => _showDeleted = false),
                  ),
                  _Tab(
                    label: 'Récemment supprimés',
                    selected: _showDeleted,
                    onTap: () => setState(() => _showDeleted = true),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: visible.isEmpty
                ? Center(
                    child: Text(
                      _showDeleted ? 'Rien à récupérer.' : 'Aucun fichier.',
                      style: GoogleFonts.inter(
                        color: Colors.grey.shade500,
                        fontSize: 13,
                      ),
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    children: byFolder.entries.map((entry) {
                      return _FolderSection(
                        folder: entry.key,
                        items: entry.value,
                      );
                    }).toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          onTap();
        },
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 7),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
              color: const Color(0xFF1A1A1A),
            ),
          ),
        ),
      ),
    );
  }
}

class _FolderSection extends StatelessWidget {
  const _FolderSection({required this.folder, required this.items});
  final String folder;
  final List<CloudItem> items;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6),
            child: Text(
              folder.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.grey.shade600,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                for (var i = 0; i < items.length; i++) ...[
                  _CloudRow(item: items[i]),
                  if (i < items.length - 1)
                    Padding(
                      padding: const EdgeInsets.only(left: 54),
                      child:
                          Container(height: 0.5, color: Colors.grey.shade300),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CloudRow extends StatelessWidget {
  const _CloudRow({required this.item});
  final CloudItem item;

  IconData get _icon {
    switch (item.kind) {
      case CloudKind.document:
        return Icons.description;
      case CloudKind.photo:
        return Icons.photo;
      case CloudKind.audio:
        return Icons.audiotrack;
      case CloudKind.video:
        return Icons.movie;
    }
  }

  Color get _color {
    switch (item.kind) {
      case CloudKind.document:
        return const Color(0xFF007AFF);
      case CloudKind.photo:
        return const Color(0xFFFF6B6B);
      case CloudKind.audio:
        return const Color(0xFFFF9F0A);
      case CloudKind.video:
        return const Color(0xFF6B5B95);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (item.body == null && item.imagePath == null) return;
        HapticFeedback.selectionClick();
        showModalBottomSheet(
          context: context,
          backgroundColor: const Color(0xFFFBF7EF),
          isScrollControlled: true,
          builder: (_) => _DocumentSheet(item: item),
        );
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          children: [
            // Vignette : image réelle si dispo, sinon icône
            if (item.imagePath != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.asset(
                  item.imagePath!,
                  width: 36,
                  height: 36,
                  fit: BoxFit.cover,
                ),
              )
            else
              Icon(_icon, color: _color, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  if (item.subtitle != null)
                    Text(
                      item.subtitle!,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.grey.shade600,
                      ),
                    ),
                ],
              ),
            ),
            if (item.isDeleted)
              Icon(Icons.restore_from_trash,
                  color: Colors.grey.shade500, size: 18),
            Icon(Icons.chevron_right, color: Colors.grey.shade400, size: 18),
          ],
        ),
      ),
    );
  }
}

class _DocumentSheet extends StatelessWidget {
  const _DocumentSheet({required this.item});
  final CloudItem item;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.subtitle ?? '',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              item.title,
              style: GoogleFonts.crimsonPro(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 16),
            if (item.imagePath != null)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    item.imagePath!,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            if (item.imagePath != null && item.body != null)
              const SizedBox(height: 16),
            if (item.body != null)
              Text(
                item.body!,
                style: GoogleFonts.crimsonPro(
                  fontSize: 16,
                  color: const Color(0xFF1A1A1A),
                  height: 1.5,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Header de stockage iCloud avec barre de progression dynamique.
/// La storage utilisée grimpe avec le jour (1.8 GB à J1 → 4.6 GB à J45).
class _StorageHeader extends StatelessWidget {
  const _StorageHeader({required this.day});
  final int day;

  @override
  Widget build(BuildContext context) {
    // Storage simulée : 1.8 + (day * 0.06) GB, plafonnée à 4.95 GB
    final used = (1.8 + day * 0.06).clamp(0.0, 4.95);
    const total = 5.0;
    final pct = used / total;
    final isWarning = pct > 0.85;
    final lastBackup = day >= 1
        ? 'Dernière sauvegarde · hier 23:00'
        : 'Jamais sauvegardé';
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.cloud, color: Color(0xFF007AFF), size: 18),
                const SizedBox(width: 8),
                Text(
                  'iCloud · marchand.shen@gmail.com',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                Text(
                  '${frDec(used, 2)} / $total Go',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: isWarning
                        ? const Color(0xFFE53935)
                        : Colors.grey.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: pct,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation(
                  isWarning
                      ? const Color(0xFFE53935)
                      : const Color(0xFF007AFF),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Text(
                  lastBackup,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.grey.shade600,
                  ),
                ),
                const Spacer(),
                if (isWarning)
                  Text(
                    'Acheter +50 Go · 0,99 €/mois',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: const Color(0xFF007AFF),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte « Famille — Papa connecté il y a 4 ans 3 mois ». Spectre fantôme.
class _FamilySharingCard extends StatelessWidget {
  const _FamilySharingCard({required this.day});
  final int day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200, width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.group, color: Color(0xFF007AFF), size: 18),
                const SizedBox(width: 8),
                Text(
                  'Partage familial',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            _MemberRow(
              name: 'Shen Marchand',
              status: 'Vous',
              statusColor: const Color(0xFF2E7D32),
              emoji: '🌿',
            ),
            const SizedBox(height: 6),
            _MemberRow(
              name: 'Hélène Marchand',
              status: 'En ligne · maintenant',
              statusColor: const Color(0xFF2E7D32),
              emoji: '👩',
            ),
            const SizedBox(height: 6),
            const _MemberRow(
              name: 'Wei Marchand',
              status: 'Connecté il y a 4 ans 3 mois',
              statusColor: Color(0xFF9E9E9E),
              emoji: '🕊️',
            ),
            const SizedBox(height: 8),
            Text(
              'Tu ne peux pas retirer Wei du partage familial : son '
              'compte est dans un état suspendu (« souvenir Apple »).',
              style: GoogleFonts.inter(
                fontSize: 10,
                fontStyle: FontStyle.italic,
                color: Colors.grey.shade500,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MemberRow extends StatelessWidget {
  const _MemberRow({
    required this.name,
    required this.status,
    required this.statusColor,
    required this.emoji,
  });
  final String name;
  final String status;
  final Color statusColor;
  final String emoji;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(emoji, style: const TextStyle(fontSize: 14)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
              Text(
                status,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: statusColor,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 7,
          height: 7,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}

/// Alerte de connexion depuis Hong Kong (apparaît J33+).
class _HKAlertCard extends StatelessWidget {
  const _HKAlertCard({required this.day});
  final int day;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
              color: const Color(0xFFE53935).withValues(alpha: 0.4), width: 1),
        ),
        child: Row(
          children: [
            const Icon(Icons.warning, color: Color(0xFFE53935), size: 18),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Nouvelle connexion · Hong Kong',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFC62828),
                    ),
                  ),
                  Text(
                    'Causeway Bay · iPhone 15 Pro · J33 09:14',
                    style: GoogleFonts.inter(
                      fontSize: 9,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
