import '../models/game_state.dart';

/// One of: a_parts_egales, la_cage_doree, le_deuil_et_la_route, belleville,
/// lentre_deux. Cf. ROADMAP §4.7.
String computeEnding(GameState s) {
  if (!s.isMomTreatmentPaid) return 'le_deuil_et_la_route';
  if (s.argent >= 30000 && s.mood >= 70 && s.reputation >= 10) {
    return 'a_parts_egales';
  }
  if (s.argent >= 30000 && s.mood < 50 && s.reputation >= 15) {
    return 'la_cage_doree';
  }
  if (s.mood >= 80 && s.reputation <= 5) return 'belleville';
  return 'lentre_deux';
}

class EndingMeta {
  final String id;
  final String title;
  final String tagline;
  const EndingMeta(this.id, this.title, this.tagline);
}

const Map<String, EndingMeta> kEndings = {
  'a_parts_egales': EndingMeta(
    'a_parts_egales',
    'À parts égales',
    'La fin canonique. Lentement, sans bague, sans sauveur.',
  ),
  'la_cage_doree': EndingMeta(
    'la_cage_doree',
    'La cage dorée',
    'Tu as l\'argent et le statut. Le reste s\'est éteint en route.',
  ),
  'le_deuil_et_la_route': EndingMeta(
    'le_deuil_et_la_route',
    'Le deuil et la route',
    'La deadline est passée. Il reste à apprendre à vivre après.',
  ),
  'belleville': EndingMeta(
    'belleville',
    'Belleville',
    'Pas de tour, pas de gala. Juste les amis, la mère, et toi.',
  ),
  'lentre_deux': EndingMeta(
    'lentre_deux',
    'L\'entre-deux',
    'Ni l\'une ni l\'autre. La vie continue, à mi-chemin.',
  ),
};
