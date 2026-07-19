import 'engine.dart';
import 'prologue.dart';
import 'story_days.dart';

/// Les jours de l'épisode 1, dans l'ordre.
typedef DayRunner = Future<void> Function(GameEngine);

final List<DayRunner> _days = [
  runDay1,
  runDay2,
  runDay3,
  runDay4,
  runDay5,
  runDay6,
];

/// Libellés pour le menu debug (index 0 = jour 1).
const List<String> kDayLabels = [
  'Mercredi 15 juillet — l\'accident',
  'Jeudi 16 juillet — Tenon',
  'Vendredi 17 juillet — la banque',
  'Samedi 18 juillet — le message',
  'Dimanche 19 juillet — les dumplings',
  'Lundi 20 juillet — la proposition',
];

/// L'épisode 1 en entier.
Future<void> runStory(GameEngine e) => runStoryFrom(e, 1);

/// L'épisode 1 à partir d'un jour donné (1-based) — menu debug.
Future<void> runStoryFrom(GameEngine e, int startDay) async {
  final from = startDay.clamp(1, _days.length);
  for (var i = from - 1; i < _days.length; i++) {
    await _days[i](e);
  }
  e.endStory('inconnu');
}
