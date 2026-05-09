import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
      appBar: AppBar(
        title: Text('Jour ${state.currentDay}'),
        actions: [
          IconButton(
            tooltip: 'Réinitialiser',
            icon: const Icon(Icons.refresh),
            onPressed: () => _confirmReset(context, ref),
          ),
        ],
      ),
      body: Column(
        children: [
          _StatsBar(),
          const Divider(height: 1),
          Expanded(
            child: scenario.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, st) =>
                  Center(child: Text('Impossible de charger : $e')),
              data: (days) {
                final dayId = state.currentDay;

                if (state.ending != null) {
                  return _EndingView(endingId: state.ending!);
                }

                final day = days.where((d) => d.id == dayId).firstOrNull;
                if (day == null) {
                  return _MissingDayView(dayId: dayId);
                }
                return _DayBody(day: day);
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmReset(BuildContext context, WidgetRef ref) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Recommencer ?'),
        content: const Text(
          'La partie actuelle sera effacée. Cette action est définitive.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Recommencer'),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(gameStateProvider.notifier).reset();
    }
  }
}

class _StatsBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final s = ref.watch(gameStateProvider);
    return Container(
      color: AppColors.paperCream,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _Stat(label: '💰', value: '${s.argent} €'),
          _Stat(label: '😊', value: '${s.mood}/10'),
          _Stat(label: '⭐', value: '${s.reputation}'),
          _Stat(label: '📱', value: '${s.followers}'),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 6),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13.5,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _DayBody extends ConsumerWidget {
  const _DayBody({required this.day});
  final DayEntry day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.read(gameStateProvider.notifier);
    final hasChosen = controller.hasChosenForDay(day.id);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${day.date} · ${day.location} · ${day.time}',
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.textSecondary,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 16),
          DayNarrativeView(day: day),
          const SizedBox(height: 24),
          ChoiceCard(
            choice: day.choice,
            disabled: hasChosen,
            onPicked: (i, opt) async {
              await controller.chooseOption(
                dayId: day.id,
                optionIndex: i,
                option: opt,
              );
            },
          ),
          const SizedBox(height: 16),
          if (hasChosen)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => controller.nextDay(),
                child: const Text('Jour suivant'),
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
            const Icon(Icons.bookmark_outline, size: 48),
            const SizedBox(height: 12),
            Text(
              'Jour $dayId à venir',
              style: GoogleFonts.crimsonPro(
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cette journée n\'est pas encore encodée. Le scénario complet J1 → J112 sera ajouté progressivement à scenario.json.',
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
                fontSize: 28,
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
