import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/episodes.dart';
import '../../../models/phone_state.dart';
import '../../../providers/phone_state_provider.dart';
import '../../../providers/relationships_provider.dart';
import '../../../providers/sent_replies_provider.dart';
import '../../../providers/app_tutorials_provider.dart';
import '../../../services/persistence_service.dart';
import '../onboarding_screen.dart';
import '../status_bar.dart';

/// App Réglages — iOS-like, fond gris perle. Quelques sections d'info
/// (épisode courant, jour, batterie) et un bouton Reset partie.
class ReglagesApp extends ConsumerWidget {
  const ReglagesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(phoneStateProvider);
    final ep = episodeById(p.currentEpisodeId);
    final beat = beatAt(
      episodeId: p.currentEpisodeId,
      beatIdx: p.currentBeatIdx,
    );

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFF4),
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Color(0xFF1A1A1A)),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 12),
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
                  'Réglages',
                  style: GoogleFonts.inter(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _Section(title: 'PARTIE', children: [
                  _Row(
                    label: 'Épisode',
                    value: ep == null
                        ? '—'
                        : 'Ep ${ep.number} · ${ep.title}',
                  ),
                  _Row(
                    label: 'Beat courant',
                    value: beat?.label ?? '—',
                  ),
                  _Row(label: 'Jour gameworld', value: 'J${p.currentDay}'),
                  _Row(label: 'Heure', value: p.timeLabel),
                ]),
                const SizedBox(height: 18),
                _Section(title: 'SHEN', children: [
                  _Row(label: 'Mood', value: '${p.mood}/10'),
                  _Row(label: 'Réputation', value: '${p.reputation}'),
                  _Row(
                    label: 'Items achetés',
                    value: '${p.ownedItems.length}',
                  ),
                  _Row(
                    label: 'Total dépensé',
                    value:
                        '${p.dynamicMovements.where((m) => m.amount < 0).fold<int>(0, (s, m) => s + (-m.amount))} €',
                  ),
                ]),
                const SizedBox(height: 18),
                _Section(title: 'TÉLÉPHONE', children: [
                  _Row(label: 'Batterie', value: '${p.battery} %'),
                  _Row(label: 'Signal', value: _signalLabel(p.signal)),
                  _Row(
                    label: 'Ne Pas Déranger',
                    value: p.dndEnabled ? 'Activé' : 'Désactivé',
                  ),
                ]),
                const SizedBox(height: 24),
                _DangerRow(
                  label: 'Réinitialiser la partie',
                  onTap: () => _confirmReset(context, ref),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Text(
                    'À Contre-Jour · 逆光',
                    style: GoogleFonts.crimsonPro(
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                      color: const Color(0xFF8E8E93),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _signalLabel(SignalType s) {
    switch (s) {
      case SignalType.wifi:
        return 'Wi-Fi';
      case SignalType.fiveG:
        return '5G';
      case SignalType.lte:
        return '4G';
      case SignalType.none:
        return 'Aucun';
    }
  }

  void _confirmReset(BuildContext context, WidgetRef ref) {
    HapticFeedback.mediumImpact();
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: Colors.white,
        title: Text(
          'Réinitialiser la partie ?',
          style: GoogleFonts.inter(fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Tu reprendras au tout début de l\'épisode Collision, '
          'avec toutes les jauges et réponses effacées.',
          style: GoogleFonts.inter(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              await PersistenceService.reset();
              await resetOnboarding();
              await ref.read(appsOpenedProvider.notifier).reset();
              ref.read(phoneStateProvider.notifier).hydrate(const PhoneState());
              ref.read(relationshipsProvider.notifier).reset();
              ref.read(sentRepliesProvider.notifier).reset();
              if (ctx.mounted) Navigator.of(ctx).pop();
            },
            child: const Text(
              'Réinitialiser',
              style: TextStyle(color: Color(0xFFE53935)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 6),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF6B6B6B),
              letterSpacing: 1.0,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 15,
              color: const Color(0xFF6B6B6B),
            ),
          ),
        ],
      ),
    );
  }
}

class _DangerRow extends StatelessWidget {
  const _DangerRow({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          child: Row(
            children: [
              const Icon(Icons.refresh, color: Color(0xFFE53935), size: 20),
              const SizedBox(width: 10),
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE53935),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
