import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/phone_apps.dart';
import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// Mini App Store — section « À découvrir » (apps non installées) +
/// section « Tes apps » (déjà sur le home, désinstallables).
class AppStoreApp extends ConsumerWidget {
  const AppStoreApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unlocked = ref.watch(
      phoneStateProvider.select((s) => s.unlockedApps),
    );
    // L'App Store ne peut pas se proposer lui-même.
    final notInstalled = kAllApps
        .where((a) => !unlocked.contains(a.id) && a.id != 'appstore')
        .toList();
    final installed = kAllApps
        .where((a) => unlocked.contains(a.id) && a.id != 'appstore')
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
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
                Text(
                  'App Store',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                Icon(Icons.search, color: Colors.grey.shade600, size: 22),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _SectionHeader(title: 'À DÉCOUVRIR'),
                if (notInstalled.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 14),
                    child: Text(
                      'Tu as déjà tout installé.',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ),
                for (final a in notInstalled)
                  _AppRow(
                    meta: a,
                    description: _descriptionFor(a.id),
                    actionLabel: 'OBTENIR',
                    actionFilled: false,
                    onTap: () {
                      HapticFeedback.mediumImpact();
                      ref.read(phoneStateProvider.notifier).unlockApp(a.id);
                    },
                  ),
                const SizedBox(height: 18),
                _SectionHeader(title: 'TES APPS'),
                for (final a in installed)
                  _AppRow(
                    meta: a,
                    description: _descriptionFor(a.id),
                    actionLabel: 'OUVRIR',
                    actionFilled: true,
                    secondaryAction: a.id == 'reglages'
                        ? null
                        : (
                            label: 'Désinstaller',
                            onTap: () {
                              HapticFeedback.mediumImpact();
                              ref
                                  .read(phoneStateProvider.notifier)
                                  .removeApp(a.id);
                            },
                          ),
                    onTap: () {
                      HapticFeedback.selectionClick();
                      ref.read(phoneStateProvider.notifier).openApp(a.id);
                    },
                  ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _descriptionFor(String id) {
    return switch (id) {
      'spotify' => 'Musique en streaming. Pour Belleville pluvieux.',
      'strava' => 'Tracking vélo & courses. Sponsorisé par Plateforme.',
      'maps' => 'Plans, itinéraires. Indispensable en livraison.',
      'tinder' => 'Rencontres. Risqué quand on a un faux fiancé.',
      'instagram' => 'Photos, stories, vies parallèles.',
      'whatsapp' => 'Messages chiffrés. Tante Mei préfère.',
      'banque' => 'Comptes, investissement, achats.',
      'ubereats' => 'Livraison de plats. Aussi : ton boulot.',
      'photos' => 'Galerie locale. Zoome.',
      'notes' => 'Carnet intime. Bic vert.',
      'calendrier' => 'Rendez-vous. Maman + Heng.',
      'cloud' => 'Documents, lettres, archives.',
      'messages' => 'SMS iMessage. Le centre de gravité.',
      'telephone' => 'Appels et messagerie vocale.',
      'reglages' => 'Préférences système et reset.',
      _ => 'Application système.',
    };
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
      child: Text(
        title,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: Colors.grey.shade600,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _AppRow extends StatelessWidget {
  const _AppRow({
    required this.meta,
    required this.description,
    required this.actionLabel,
    required this.actionFilled,
    required this.onTap,
    this.secondaryAction,
  });

  final AppMeta meta;
  final String description;
  final String actionLabel;
  final bool actionFilled;
  final VoidCallback onTap;
  final ({String label, VoidCallback onTap})? secondaryAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 6, 16, 6),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: meta.color,
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(meta.icon, color: meta.fgColor, size: 30),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meta.label,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
                if (secondaryAction != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: GestureDetector(
                      onTap: secondaryAction!.onTap,
                      child: Text(
                        secondaryAction!.label,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: const Color(0xFFE53935),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: actionFilled
                    ? const Color(0xFF007AFF)
                    : const Color(0xFFEFEFEF),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                actionLabel,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: actionFilled
                      ? Colors.white
                      : const Color(0xFF007AFF),
                  letterSpacing: 0.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
