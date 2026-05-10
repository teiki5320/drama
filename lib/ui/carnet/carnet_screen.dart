import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/big_title.dart';
import '../../core/colors.dart';
import '../../engine/ending_calculator.dart';
import '../../models/day_entry.dart';
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
            return _MissingDayView(dayId: dayId);
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
                  onPressed: () => controller.nextDay(),
                  child: const Text('Jour suivant'),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MissingDayView extends StatelessWidget {
  const _MissingDayView({required this.dayId});
  final int dayId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.bookmark_outline,
                size: 48, color: AppColors.textSecondary),
            const SizedBox(height: 12),
            Text(
              'Jour $dayId à venir',
              style: GoogleFonts.crimsonPro(
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cette journée n\'est pas encore encodée. Le scénario complet J1 → J112 sera ajouté progressivement.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
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
