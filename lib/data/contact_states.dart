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
  ],
  'camille': [
    ContactStatus(fromDay: 1, label: 'En ligne'),
    ContactStatus(fromDay: 4, label: 'Tape…', emoji: '🥐'),
    ContactStatus(fromDay: 13, label: 'En ligne', emoji: '🔥'),
  ],
  'tristan': [
    ContactStatus(fromDay: 1, label: 'Hors ligne'),
    ContactStatus(fromDay: 7, label: 'Tour Heng · 47ᵉ', emoji: '🏢'),
    ContactStatus(fromDay: 9, label: 'En ligne'),
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
