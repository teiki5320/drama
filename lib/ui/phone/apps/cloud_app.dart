import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
