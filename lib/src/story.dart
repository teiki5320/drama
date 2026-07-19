import 'engine.dart';
import 'prologue.dart';
import 'story_days.dart';

/// L'épisode 1 : six journées, du premier message de Maman
/// à la réponse donnée à Tristan.
Future<void> runStory(GameEngine e) async {
  await runDay1(e);
  await runDay2(e);
  await runDay3(e);
  await runDay4(e);
  await runDay5(e);
  await runDay6(e);
  e.endStory('inconnu');
}
