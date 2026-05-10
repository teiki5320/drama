import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/big_title.dart';
import '../../core/colors.dart';
import '../../core/formatters.dart';
import '../../engine/economy_engine.dart';
import '../../engine/ending_calculator.dart';
import '../../models/day_entry.dart';
import '../../models/game_state.dart';
import '../../providers/game_state_provider.dart';
import '../../providers/scenario_provider.dart';
import 'choice_card.dart';
import 'day_narrative_view.dart';

class CarnetScreen extends ConsumerWidget {
  const CarnetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(gameStateProvider);
    final scenario = ref.watch(scenarioProvider);

    return Scaffold(
      backgroundColor: AppColors.paperCream,
      body: scenario.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Impossible de charger : $e')),
        data: (days) {
          if (state.ending != null) {
            return _EndingView(endingId: state.ending!);
          }
          final dayId = state.currentDay;
          final day = days.where((d) => d.id == dayId).firstOrNull;
          if (day == null) {
            return _EpisodeEndView(state: state);
          }
          return _DayBody(day: day);
        },
      ),
    );
  }
}

class _DayBody extends ConsumerWidget {
  const _DayBody({required this.day});
  final DayEntry day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(gameStateProvider.notifier);
    final state = ref.watch(gameStateProvider);
    final hasChosen = state.choicesMade.containsKey(day.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BigTitle(
            'Jour ${day.id}',
            subtitle: '${day.date} · ${day.location} · ${day.time}',
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
            child: DayNarrativeView(day: day),
          ),
          const SizedBox(height: 24),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ChoiceCard(
              choice: day.choice,
              disabled: hasChosen,
              selectedIndex: state.choicesMade[day.id],
              onPicked: (i, opt) async {
                await controller.chooseOption(
                  dayId: day.id,
                  optionIndex: i,
                  option: opt,
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          if (hasChosen)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.mediumImpact();
                    controller.nextDay();
                  },
                  child: const Text('Jour suivant'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _EpisodeEndView extends StatelessWidget {
  const _EpisodeEndView({required this.state});
  final GameState state;

  @override
  Widget build(BuildContext context) {
    final daysPlayed = state.choicesMade.length;
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 22),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFFAE0CC), Color(0xFFFCEBC9)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'ÉPISODE 1',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.4,
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'À suivre…',
                  style: GoogleFonts.crimsonPro(
                    fontSize: 38,
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Tu as traversé les deux premières semaines avec Shen — Belleville, le Dr Aubin, la collision avenue Montaigne, le contrat Heng et les premiers dîners au 8e.',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'CE QUE TU LAISSES',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          _RecapCard(state: state, daysPlayed: daysPlayed),
          const SizedBox(height: 16),
          Text(
            'PROCHAINEMENT',
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.0,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
            decoration: BoxDecoration(
              color: AppColors.cardBg,
              border: Border.all(color: const Color(0x141A1A1A)),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Semaine 3 — Premières fissures',
                  style: GoogleFonts.crimsonPro(
                    fontSize: 19,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Hong Kong se rapproche, Vincent rôde, Maman demande des nouvelles que Shen ne sait plus comment formuler. La suite sera publiée bientôt.',
                  style: GoogleFonts.inter(
                    fontSize: 13.5,
                    color: AppColors.textSecondary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Center(
            child: Text(
              'Tu peux continuer à gérer la Banque, l\'Insta et les conversations dans les autres onglets.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12.5,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _RecapCard extends StatelessWidget {
  const _RecapCard({required this.state, required this.daysPlayed});
  final GameState state;
  final int daysPlayed;

  @override
  Widget build(BuildContext context) {
    final lines = <(String, String)>[
      ('Jours joués', '$daysPlayed / ${EconomyEngine.kMaxStoryDay}'),
      ('Argent en banque', formatMoney(state.argent)),
      ('Mood', '${state.mood} / 10'),
      ('Réputation', '★ ${state.reputation}'),
      ('Followers', '${state.followers}'),
      ('Contrat Heng',
          state.unlockedConversations.contains('tristan') ? 'Signé' : 'Refusé'),
      ('Traitement maman',
          state.isMomTreatmentPaid ? 'Payé' : 'Pas encore'),
    ];
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          for (var i = 0; i < lines.length; i++) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 11, 14, 11),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      lines[i].$1,
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ),
                  Text(
                    lines[i].$2,
                    style: GoogleFonts.inter(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),
            if (i < lines.length - 1)
              const Divider(height: 1, color: Color(0x0F1A1A1A)),
          ],
        ],
      ),
    );
  }
}

class _EndingView extends StatelessWidget {
  const _EndingView({required this.endingId});
  final String endingId;

  @override
  Widget build(BuildContext context) {
    final meta = kEndings[endingId];
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              meta?.title ?? endingId,
              textAlign: TextAlign.center,
              style: GoogleFonts.crimsonPro(
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              meta?.tagline ?? '',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 15,
                color: AppColors.textSecondary,
                height: 1.55,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

extension _Iter<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
