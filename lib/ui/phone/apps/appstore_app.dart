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
                // ── Today : carte éditoriale featured ────────────
                _TodayFeaturedCard(),
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
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: meta.color,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(meta.icon, color: meta.fgColor, size: 32),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meta.label,
                  style: GoogleFonts.inter(
                    fontSize: 15,
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
                    fontSize: 12,
                    color: Colors.grey.shade600,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(Icons.star,
                        color: Color(0xFFFF9500), size: 11),
                    const SizedBox(width: 2),
                    Text(
                      _ratingFor(meta.id),
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '· ${_reviewsFor(meta.id)}',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
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

String _ratingFor(String id) {
  return switch (id) {
    'tinder' => '4.2',
    'instagram' => '4.6',
    'spotify' => '4.8',
    'whatsapp' => '4.7',
    'banque' => '4.1',
    'ubereats' => '3.8',
    'photos' => '4.5',
    'notes' => '4.6',
    'maps' => '4.4',
    'cloud' => '3.9',
    _ => '4.3',
  };
}

String _reviewsFor(String id) {
  return switch (id) {
    'tinder' => '8,4 M',
    'instagram' => '12,8 M',
    'spotify' => '6,2 M',
    'whatsapp' => '14,1 M',
    'banque' => '482 K',
    'ubereats' => '1,2 M',
    'maps' => '892 K',
    _ => '128 K',
  };
}

/// Carte « Today » éditoriale au-dessus de la liste — change selon le
/// jour pour évoquer le rythme d'une vraie page d'accueil App Store.
class _TodayFeaturedCard extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final featured = _featuredFor(day);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 14),
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(featured.gradient.first),
              Color(featured.gradient.last),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              featured.eyebrow.toUpperCase(),
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Colors.white.withValues(alpha: 0.8),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              featured.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.crimsonPro(
                fontSize: 26,
                fontWeight: FontWeight.w700,
                fontStyle: FontStyle.italic,
                color: Colors.white,
                height: 1.05,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: Text(featured.emoji,
                      style: const TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        featured.app,
                        style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        featured.tagline,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.85),
                        ),
                      ),
                    ],
                  ),
                ),
                _FeaturedInstallButton(
                  appId: featured.appId,
                  appLabel: featured.app,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _Featured _featuredFor(int day) {
    // Rotation hebdomadaire pour donner l'impression d'une vraie homepage
    final pool = <_Featured>[
      _Featured(
        eyebrow: 'app du jour',
        title: 'Comprendre le silence d\'une mère',
        app: 'Notes',
        appId: 'notes',
        emoji: '📔',
        tagline: 'Écrire sans envoyer. Bic vert recommandé.',
        gradient: [0xFFD97757, 0xFF6B3D2A],
      ),
      _Featured(
        eyebrow: 'sélection éditoriale',
        title: 'Investir à 24 ans, sans paniquer',
        app: 'Banque',
        appId: 'banque',
        emoji: '🏦',
        tagline: 'PEA, sparkline, plus-value latente.',
        gradient: [0xFF1F4F8B, 0xFF0E2A50],
      ),
      _Featured(
        eyebrow: 'collection',
        title: 'Soirs où Paris s\'éteint sans toi',
        app: 'Spotify',
        appId: 'spotify',
        emoji: '🎻',
        tagline: 'Playlists pour pluvieux fonctionnels.',
        gradient: [0xFF1DB954, 0xFF0F5E2A],
      ),
      _Featured(
        eyebrow: 'jeu du jour',
        title: 'Quand tu swipes pour ne pas pleurer',
        app: 'Tinder',
        appId: 'tinder',
        emoji: '🔥',
        tagline: '27 archétypes. Aucun ne te sauvera.',
        gradient: [0xFFFD297B, 0xFF8B164A],
      ),
      _Featured(
        eyebrow: 'app à découvrir',
        title: 'La carte de tes silences',
        app: 'Plans',
        appId: 'maps',
        emoji: '🗺️',
        tagline: 'Lieux visités, lieux fuis, lieux jamais nommés.',
        gradient: [0xFF34A853, 0xFF1B5E2C],
      ),
    ];
    return pool[(day ~/ 3) % pool.length];
  }
}

class _Featured {
  final String eyebrow;
  final String title;
  final String app;
  /// Id interne (`kAllApps`) à débloquer quand le joueur tape OBTENIR.
  final String appId;
  final String emoji;
  final String tagline;
  final List<int> gradient;
  const _Featured({
    required this.eyebrow,
    required this.title,
    required this.app,
    required this.appId,
    required this.emoji,
    required this.tagline,
    required this.gradient,
  });
}

/// Bouton OBTENIR/OUVRIR du Today featured card. Installé = ouvre l'app,
/// pas encore installé = unlockApp + snack confirmation.
class _FeaturedInstallButton extends ConsumerWidget {
  const _FeaturedInstallButton({required this.appId, required this.appLabel});
  final String appId;
  final String appLabel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final installed = ref.watch(
      phoneStateProvider.select((s) => s.unlockedApps.contains(appId)),
    );
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        final notifier = ref.read(phoneStateProvider.notifier);
        if (installed) {
          notifier.openApp(appId);
        } else {
          notifier.unlockApp(appId);
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '$appLabel installée.',
                style: GoogleFonts.inter(fontSize: 13),
              ),
              behavior: SnackBarBehavior.floating,
              duration: const Duration(milliseconds: 1400),
              backgroundColor: const Color(0xFF1A1A1A),
            ),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Text(
          installed ? 'OUVRIR' : 'OBTENIR',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF007AFF),
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}
