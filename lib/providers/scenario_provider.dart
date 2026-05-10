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
