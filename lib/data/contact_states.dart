/// Statut « vivant » des contacts — change au fil des jours pour
/// rendre l'app Messages crédible. Affiché sous le nom dans la liste
/// des conversations et dans l'en-tête du thread (à la façon WhatsApp
/// « Vu à 14:32 », « En ligne », « Tape… »).

class ContactStatus {
  /// À partir de quel jour ce statut s'applique.
  final int fromDay;
  /// Texte affiché.
  final String label;
  /// Emoji optionnel.
  final String? emoji;

  const ContactStatus({
    required this.fromDay,
    required this.label,
    this.emoji,
  });
}

/// Évolution des statuts par contact — pris du plus récent applicable.
const Map<String, List<ContactStatus>> kContactStatuses = {
  'maman': [
    ContactStatus(fromDay: 1, label: 'En ligne'),
    ContactStatus(fromDay: 4, label: 'Vu il y a 2 min'),
    ContactStatus(fromDay: 11, label: 'Vu hier · 22:08', emoji: '🌙'),
    ContactStatus(fromDay: 24, label: 'En ligne'),
    ContactStatus(fromDay: 39, label: 'En ligne · 4h du matin', emoji: '🌙'),
    ContactStatus(fromDay: 45, label: 'À Tenon · disponible', emoji: '🏥'),
    ContactStatus(fromDay: 80, label: 'Fujian · GMT+8', emoji: '🍵'),
  ],
  'camille': [
    ContactStatus(fromDay: 1, label: 'En ligne'),
    ContactStatus(fromDay: 4, label: 'Tape…', emoji: '🥐'),
    ContactStatus(fromDay: 13, label: 'En ligne', emoji: '🔥'),
    ContactStatus(fromDay: 26, label: 'Vu il y a 8 jours…', emoji: '🥲'),
    ContactStatus(fromDay: 29, label: 'En ligne', emoji: '🥐'),
    ContactStatus(fromDay: 60, label: 'Master · bibliothèque', emoji: '📚'),
    ContactStatus(fromDay: 95, label: 'En ligne', emoji: '🥐'),
  ],
  'tristan': [
    ContactStatus(fromDay: 1, label: 'Hors ligne'),
    ContactStatus(fromDay: 7, label: 'Tour Heng · 47ᵉ', emoji: '🏢'),
    ContactStatus(fromDay: 9, label: 'En ligne'),
    ContactStatus(fromDay: 32, label: 'Hong Kong · GMT+8', emoji: '🏙️'),
    ContactStatus(fromDay: 41, label: 'En ligne'),
    ContactStatus(fromDay: 53, label: 'Vu · ne tape pas', emoji: '🧊'),
    ContactStatus(fromDay: 95, label: 'Tape… puis s\'arrête', emoji: '🧊'),
  ],
  'madame_heng': [
    ContactStatus(fromDay: 12, label: 'Sur invitation'),
    ContactStatus(fromDay: 19, label: 'Lit à 21h précises', emoji: '🍵'),
    ContactStatus(fromDay: 46, label: 'En ligne · silencieuse', emoji: '🍵'),
  ],
  'vincent_heng': [
    ContactStatus(fromDay: 10, label: 'En ligne · toujours', emoji: '💼'),
    ContactStatus(fromDay: 52, label: 'Genève · GMT+1', emoji: '💼'),
  ],
  'banque': [
    ContactStatus(fromDay: 1, label: 'Notifications BNP'),
  ],
  'numericable': [
    ContactStatus(fromDay: 1, label: 'Numéro promotionnel'),
  ],
  'plateforme': [
    ContactStatus(fromDay: 1, label: 'Livraisons Pro'),
    ContactStatus(fromDay: 9, label: 'Compte suspendu', emoji: '⚠️'),
  ],
  'tante_mei': [
    ContactStatus(fromDay: 35, label: 'Fuzhou · GMT+8', emoji: '🍊'),
    ContactStatus(fromDay: 78, label: 'En ligne', emoji: '🏮'),
  ],
};

/// Renvoie le statut applicable au jour donné — le plus récent ≤ day.
ContactStatus? statusForContact(String contactId, int day) {
  final list = kContactStatuses[contactId];
  if (list == null || list.isEmpty) return null;
  ContactStatus? best;
  for (final s in list) {
    if (s.fromDay <= day) {
      if (best == null || s.fromDay > best.fromDay) best = s;
    }
  }
  return best;
}
