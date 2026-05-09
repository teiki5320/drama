import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/scenario_loader.dart';
import '../models/day_entry.dart';

final scenarioLoaderProvider = Provider<ScenarioLoader>(
  (ref) => const ScenarioLoader(),
);

final scenarioProvider = FutureProvider<List<DayEntry>>((ref) async {
  final loader = ref.watch(scenarioLoaderProvider);
  return loader.loadAll();
});

/// Look up a specific day. Returns null if it isn't encoded yet.
final dayEntryProvider = Provider.family<DayEntry?, int>((ref, dayId) {
  final async = ref.watch(scenarioProvider);
  return async.maybeWhen(
    data: (days) => days.where((d) => d.id == dayId).cast<DayEntry?>().firstOrNull,
    orElse: () => null,
  );
});

extension _Iter<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
