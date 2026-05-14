import '../models/relationship.dart';

/// Choix de réponse SMS pour un beat narratif donné. Quand un contact
/// envoie un message qui débloque un choix, Shen voit 3 options en
/// bas de la conversation. Chaque choix :
/// - répond avec un texte (qui s'ajoute aux messages)
/// - applique des deltas sur la relation avec le contact
/// - peut déclencher d'autres événements (à venir en PR 8)

class SmsChoice {
  /// Identifiant du beat (correspond à un point du scénario).
  final String beatId;

  /// Contact concerné (vers qui Shen répond).
  final String contactId;

  /// Les 3 options visibles.
  final List<SmsChoiceOption> options;

  const SmsChoice({
    required this.beatId,
    required this.contactId,
    required this.options,
  });
}

class SmsChoiceOption {
  /// Texte qui sera ajouté comme message de Shen si l'option est choisie.
  final String reply;

  /// Court label affiché sur le bouton de choix (sinon = reply).
  final String? label;

  /// Effets sur la relation avec le contact.
  final RelationshipDelta delta;

  const SmsChoiceOption({
    required this.reply,
    this.label,
    this.delta = const RelationshipDelta(),
  });
}

/// Catalogue de choix indexés par `beatId`. Plus de choix s'ajouteront
/// quand on étendra le scénario.
const Map<String, SmsChoice> kSmsChoices = {
  // J1 — Maman "Tu as mangé ?" — Shen ment ou pas ?
  'maman_petit_dej_j1': SmsChoice(
    beatId: 'maman_petit_dej_j1',
    contactId: 'maman',
    options: [
      SmsChoiceOption(
        label: 'Vérité',
        reply: 'Pain au chocolat de la veille trempé dans du thé. Ça m\'a tenu.',
        delta: RelationshipDelta(trust: 4, suspicion: -2, dependency: 2),
      ),
      SmsChoiceOption(
        label: 'Mensonge tendre',
        reply: 'Un truc équilibré, t\'inquiète.',
        delta: RelationshipDelta(trust: -3, suspicion: 5),
      ),
      SmsChoiceOption(
        label: 'Esquive',
        reply: 'Maman, je suis sur le vélo, on parle ce soir.',
        delta: RelationshipDelta(dependency: -3, suspicion: 3),
      ),
    ],
  ),

  // J1 — Maman "Couvre-toi, il pleut" — registre tendresse
  'maman_couvre_toi_j1': SmsChoice(
    beatId: 'maman_couvre_toi_j1',
    contactId: 'maman',
    options: [
      SmsChoiceOption(
        label: 'Réciproque',
        reply: 'Toi couvre-toi surtout.',
        delta: RelationshipDelta(attraction: 3, loyalty: 2, dependency: 2),
      ),
      SmsChoiceOption(
        label: 'Court',
        reply: 'Oui Maman.',
        delta: RelationshipDelta(attraction: 1),
      ),
      SmsChoiceOption(
        label: 'Inquiète',
        reply: 'Tu as bien pris tes gélules de 16h hier ?',
        delta: RelationshipDelta(dependency: 4, suspicion: 2, trust: 1),
      ),
    ],
  ),

  // J4 — Camille "Tu as gardé sa carte, hein."
  'camille_carte_j4': SmsChoice(
    beatId: 'camille_carte_j4',
    contactId: 'camille',
    options: [
      SmsChoiceOption(
        label: 'Avouer',
        reply: 'Oui. Je l\'ai recollée hier soir.',
        delta: RelationshipDelta(trust: 6, dependency: 4),
      ),
      SmsChoiceOption(
        label: 'Nier',
        reply: 'Non, je l\'ai déchirée pour de bon.',
        delta: RelationshipDelta(trust: -8, suspicion: 6, loyalty: -2),
      ),
      SmsChoiceOption(
        label: 'Détourner',
        reply: 'Camille. La vraie question c\'est : 18 000 euros.',
        delta: RelationshipDelta(trust: 1, dependency: -1),
      ),
    ],
  ),
};

/// Renvoie le choix associé à un beat, ou null si pas de choix défini.
SmsChoice? choiceForBeat(String beatId) => kSmsChoices[beatId];
