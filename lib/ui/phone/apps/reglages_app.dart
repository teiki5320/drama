import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/banque_data.dart';
import '../../../data/episodes.dart';
import '../../../data/epilogues.dart';
import '../../../models/phone_state.dart';
import '../../../providers/phone_state_provider.dart';
import '../../../providers/call_log_provider.dart';
import '../../../providers/epilogue_provider.dart';
import '../../../providers/instagram_state_provider.dart';
import '../../../providers/romance_threads_provider.dart';
import '../../../providers/tinder_state_provider.dart';
import '../../../providers/messages_arcs_provider.dart';
import '../../../providers/ubereats_stats_provider.dart';
import '../../../providers/portfolio_provider.dart';
import '../../../providers/map_visits_provider.dart';
import '../../../providers/lock_notifications_provider.dart';
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
                    value: p.dndEnabled ? 'Activé · 23h-7h' : 'Désactivé',
                  ),
                ]),
                const SizedBox(height: 18),
                // ── BATTERIE — santé qui décroît avec le jour
                _Section(title: 'BATTERIE', children: [
                  _Row(
                    label: 'Capacité maximale',
                    value: '${(98 - p.currentDay ~/ 4).clamp(70, 100)} %',
                  ),
                  _Row(
                    label: 'Cycles de charge',
                    value: '${312 + p.currentDay * 2}',
                  ),
                  _Row(
                    label: 'Recharge optimisée',
                    value: 'Activée',
                  ),
                ]),
                const SizedBox(height: 18),
                // ── TEMPS D'ÉCRAN
                _Section(title: "TEMPS D'ÉCRAN · cette semaine", children: [
                  _Row(label: 'Tinder', value: '${(2 + p.currentDay * 0.18).toStringAsFixed(1)} h'),
                  _Row(label: 'Instagram', value: '${(3.4 + p.currentDay * 0.21).toStringAsFixed(1)} h'),
                  _Row(label: 'Messages', value: '${(1.6 + p.currentDay * 0.09).toStringAsFixed(1)} h'),
                  _Row(label: 'Spotify', value: '${(0.8 + p.currentDay * 0.05).toStringAsFixed(1)} h'),
                  _Row(label: 'UberEats', value: '${(1.2 + p.currentDay * 0.08).toStringAsFixed(1)} h'),
                  _Row(
                      label: 'Total quotidien moyen',
                      value: '${(4.2 + p.currentDay * 0.12).toStringAsFixed(1)} h'),
                ]),
                const SizedBox(height: 18),
                // ── FACE ID & code
                _Section(title: 'FACE ID & CODE', children: [
                  const _Row(label: 'Face ID', value: 'Configuré'),
                  const _Row(label: 'Code', value: '4 chiffres'),
                  _Row(
                    label: 'Échecs Face ID (24h)',
                    value: '${(p.currentDay % 4)}',
                  ),
                ]),
                const SizedBox(height: 18),
                // ── MISE À JOUR
                _Section(title: 'MISE À JOUR LOGICIELLE', children: [
                  _Row(
                    label: 'iOS actuel',
                    value: p.currentDay < 6 ? '18.4' : '18.5',
                  ),
                  _Row(
                    label: p.currentDay < 6
                        ? 'Mise à jour disponible'
                        : 'À jour',
                    value: p.currentDay < 6 ? 'iOS 18.5 · 1,82 Go' : '✓',
                  ),
                ]),
                const SizedBox(height: 18),
                // ── À PROPOS
                _Section(title: 'À PROPOS', children: [
                  const _Row(label: 'Nom', value: 'iPhone de Shen'),
                  const _Row(label: 'Modèle', value: 'iPhone 15 Pro'),
                  const _Row(label: 'Capacité', value: '128 Go'),
                  const _Row(label: 'IMEI', value: '359 247 081 642 195'),
                  const _Row(
                    label: 'Numéro de série',
                    value: 'X2K9Q7L4MNTP',
                  ),
                ]),
                const SizedBox(height: 24),
                // Revoir la fin — seulement une fois l'épilogue joué.
                if (ref.watch(sentRepliesProvider
                    .select((r) => r.containsKey('epilogue_j112'))))
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _DangerRow(
                      label: 'Revoir l\'épilogue',
                      onTap: () => _replayEpilogue(ref),
                    ),
                  ),
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

  /// Recalcule et réaffiche l'épilogue mérité (même logique que la fin
  /// de partie dans PhoneShell : solde réel + choix pivots + mood).
  void _replayEpilogue(WidgetRef ref) {
    HapticFeedback.selectionClick();
    final p = ref.read(phoneStateProvider);
    var balance = kStartingBalance;
    for (final m in kMovements) {
      if (m.day <= p.currentDay) balance += m.amount;
    }
    for (final m in p.dynamicMovements) {
      if (m.day <= p.currentDay) balance += m.amount;
    }
    balance += ref.read(portfolioMarketValueProvider).round();
    final replies = ref.read(sentRepliesProvider);
    ref.read(epilogueProvider.notifier).state = resolveEpilogue(
      finalBalance: balance,
      mood: p.mood,
      repliesByBeat: {
        for (final e in replies.entries) e.key: e.value.text,
      },
    );
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
              await ref.read(instagramStateProvider.notifier).reset();
              // Notifiers autonomes : sans purge, la nouvelle partie hérite
              // des matchs Tinder, arcs SMS, stats livreur, bourse et lieux.
              await ref.read(romanceThreadsProvider.notifier).reset();
              await ref.read(tinderStateProvider.notifier).reset();
              await ref.read(callLogProvider.notifier).reset();
              await ref.read(messagesArcsProvider.notifier).reset();
              ref.read(uberStatsProvider.notifier).reset();
              ref.read(portfolioProvider.notifier).reset();
              ref.read(mapVisitsProvider.notifier).reset();
              ref.read(lockNotificationsProvider.notifier).clear();
              ref.read(epilogueProvider.notifier).state = null;
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
