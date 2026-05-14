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

  // J6 — Camille apporte le tailleur, prêche la posture
  'camille_tailleur_j6': SmsChoice(
    beatId: 'camille_tailleur_j6',
    contactId: 'camille',
    options: [
      SmsChoiceOption(
        label: 'Acceptation',
        reply: 'Merci. J\'arrive avec le dossier sur dix ans, taux légal.',
        delta: RelationshipDelta(trust: 5, loyalty: 3),
      ),
      SmsChoiceOption(
        label: 'Doute',
        reply: 'Et si je n\'y allais pas ?',
        delta: RelationshipDelta(trust: -3, dependency: 4, suspicion: 2),
      ),
      SmsChoiceOption(
        label: 'Vanne',
        reply: '38, sérieux ? Je l\'épouse pas, je négocie un prêt.',
        delta: RelationshipDelta(attraction: 3, loyalty: 2),
      ),
    ],
  ),

  // J6 — Tristan : confirmation rdv Tour Heng
  'tristan_rdv_j6': SmsChoice(
    beatId: 'tristan_rdv_j6',
    contactId: 'tristan',
    options: [
      SmsChoiceOption(
        label: 'Confirmé',
        reply: 'Confirmé. À jeudi 11h.',
        delta: RelationshipDelta(trust: 3, attraction: 1),
      ),
      SmsChoiceOption(
        label: 'Reprends le pouvoir',
        reply: 'Jeudi 11h, oui. Et merci de ne pas confondre rendez-vous et faveur.',
        delta: RelationshipDelta(attraction: 4, suspicion: 2, trust: -1),
      ),
      SmsChoiceOption(
        label: 'Annule',
        reply: 'Je passe mon tour.',
        delta: RelationshipDelta(trust: -8, attraction: -5, loyalty: -3),
      ),
    ],
  ),

  // J11 — Maman, premier mensonge sur le stage
  'maman_stage_j11': SmsChoice(
    beatId: 'maman_stage_j11',
    contactId: 'maman',
    options: [
      SmsChoiceOption(
        label: 'Mensonge construit',
        reply: 'La courge du potager a doublé en deux jours. Lao Chen dit que c\'est l\'humidité.',
        delta: RelationshipDelta(trust: -4, suspicion: 8, attraction: -1),
      ),
      SmsChoiceOption(
        label: 'Demi-vérité',
        reply: 'Compliqué à raconter en SMS. Je passe dimanche.',
        delta: RelationshipDelta(trust: 2, suspicion: 4, dependency: 3),
      ),
      SmsChoiceOption(
        label: 'Reverse',
        reply: 'Et toi, comment tu te sens vraiment ?',
        delta: RelationshipDelta(trust: 5, attraction: 4, suspicion: -2),
      ),
    ],
  ),

  // J13 — Camille « QUEL THÉ »
  'camille_quel_the_j13': SmsChoice(
    beatId: 'camille_quel_the_j13',
    contactId: 'camille',
    options: [
      SmsChoiceOption(
        label: 'Long Jing',
        reply: 'Long Jing première récolte. Si elle me sert autre chose, je le verrai.',
        delta: RelationshipDelta(trust: 4, attraction: 3, loyalty: 2),
      ),
      SmsChoiceOption(
        label: 'Pu\'er',
        reply: 'Pu\'er sans doute. Vieux, fermenté, intimidant. Comme elle.',
        delta: RelationshipDelta(attraction: 2, loyalty: 1),
      ),
      SmsChoiceOption(
        label: 'Je sais pas',
        reply: 'Je sais pas. J\'improviserai.',
        delta: RelationshipDelta(trust: -2, dependency: 2, suspicion: 1),
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
