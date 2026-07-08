/// Bascule architecturale : le scénario n'est plus calé sur 112 jours
/// rigides mais sur 5 épisodes (kEpisodes) qui condensent les 6 actes
/// de la roadmap.
/// Chaque épisode contient une liste de Beats — moments narratifs
/// précis horodatés dans le gameworld (jour/heure/minute).
///
/// Le joueur progresse en passant d'un beat au suivant :
/// - soit en répondant au SMS-clé du beat (auto-progression) ;
/// - soit en tapant le widget « Prochain moment » sur le home.

class Episode {
  /// Identifiant stable (`collision`, `contrat`, …).
  final String id;

  /// Numéro d'épisode 1..5.
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

  /// Si non-null, scène textuelle à afficher en plein écran quand on
  /// arrive sur ce beat (4-6 s, fond noir, serif italique blanc).
  /// Sert à montrer ce qui se passe ENTRE deux beats (collision, etc.).
  final BeatTransition? transition;

  /// Liste d'app ids à débloquer (`unlockApp`) à l'arrivée sur ce beat.
  /// Sert à révéler progressivement les apps au fil du scénario
  /// (notes au premier carnet, telephone au premier appel, etc.).
  final List<String> unlocksApps;

  const Beat({
    required this.idx,
    required this.day,
    required this.hour,
    required this.minute,
    required this.label,
    this.requiresChoice,
    this.transition,
    this.unlocksApps = const [],
  });

  int get totalMinutes => day * 24 * 60 + hour * 60 + minute;
}

/// Scène textuelle plein écran qui s'affiche brièvement entre deux
/// beats. Permet de raconter ce que vit Shen pendant le saut de temps.
class BeatTransition {
  /// Heure affichée en haut (ex: « 08:17 »).
  final String timestamp;

  /// Corps principal : 3-5 lignes en serif italique blanc. Voix Shen.
  final String body;

  /// Parenthèse finale optionnelle, plus petite (ex: « (Une carte... »).
  final String? coda;

  const BeatTransition({
    required this.timestamp,
    required this.body,
    this.coda,
  });
}
