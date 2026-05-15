/// Bascule architecturale : le scénario n'est plus calé sur 112 jours
/// rigides mais sur 6 épisodes qui suivent les 6 actes de la roadmap.
/// Chaque épisode contient une liste de Beats — moments narratifs
/// précis horodatés dans le gameworld (jour/heure/minute).
///
/// Le joueur progresse en passant d'un beat au suivant :
/// - soit en répondant au SMS-clé du beat (auto-progression) ;
/// - soit en tapant le widget « Prochain moment » sur le home.

class Episode {
  /// Identifiant stable (`collision`, `contrat`, …).
  final String id;

  /// Numéro d'épisode 1..6.
  final int number;

  /// Titre court affiché à l'écran.
  final String title;

  /// Sous-titre / pitch en une phrase.
  final String subtitle;

  /// Liste ordonnée des beats de cet épisode.
  final List<Beat> beats;

  const Episode({
    required this.id,
    required this.number,
    required this.title,
    required this.subtitle,
    required this.beats,
  });
}

class Beat {
  /// Position du beat dans son épisode (0-indexed).
  final int idx;

  /// Jour gameworld où le beat se déclenche.
  final int day;

  /// Heure (0-23) et minute (0-59) du déclenchement.
  final int hour;
  final int minute;

  /// Label humain pour le debug et un éventuel HUD plus tard.
  final String label;

  /// Si non-null, le beat ne se débloque vers le suivant qu'une fois
  /// le joueur a répondu à ce choix SMS (clé dans `kSmsChoices`).
  /// Null = pas de gate, le joueur passe quand il veut via le widget.
  final String? requiresChoice;

  const Beat({
    required this.idx,
    required this.day,
    required this.hour,
    required this.minute,
    required this.label,
    this.requiresChoice,
  });

  int get totalMinutes => day * 24 * 60 + hour * 60 + minute;
}
