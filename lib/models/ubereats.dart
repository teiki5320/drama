/// Modèle de données UberEats — restaurants, clients, courses.
/// Permet de générer un catalogue riche au lieu d'une poignée de
/// courses hardcodées dans ubereats_app.dart.
library;

/// Cuisine du restaurant — affecte le rendu visuel + les commentaires
/// des clients.
enum CuisineType {
  asiatique,
  burger,
  pizza,
  healthy,
  patisserie,
  cafe,
  francais,
  libanais,
  mexicain,
  vegan,
  petitDejeuner,
  sushi,
  ramen,
  thai,
  chinois,
  italien,
  africain,
  indien,
}

/// Zone géographique Paris — pour heatmap + densité de courses.
enum UberZone {
  belleville,    // 19e/20e, populaire, matin
  marais,        // 3e/4e, hipster, soir
  champsLuxe,    // 8e, riche, midi
  saintGermain,  // 6e, intello, après-midi
  montparnasse,  // 14e/15e, mix
  republique,    // 10e/11e, bobo bohème
  bastille,      // 11e/12e, nightlife
  defense,       // bureau, midi
  vincennes,     // famille, dimanche
  pantin,        // banlieue proche, ouvrier
  rueDeBerri,     // 8e, ultra-riche
  goutteDor,     // 18e, vivant
}

/// Libellé affichable d'une zone (l'enum brut « rueDeBerri » ne doit
/// jamais apparaître à l'écran).
String zoneLabel(UberZone z) => switch (z) {
      UberZone.belleville => 'Belleville',
      UberZone.marais => 'Le Marais',
      UberZone.champsLuxe => 'Champs-Élysées',
      UberZone.saintGermain => 'Saint-Germain',
      UberZone.montparnasse => 'Montparnasse',
      UberZone.republique => 'République',
      UberZone.bastille => 'Bastille',
      UberZone.defense => 'La Défense',
      UberZone.vincennes => 'Vincennes',
      UberZone.pantin => 'Pantin',
      UberZone.rueDeBerri => 'Rue de Berri',
      UberZone.goutteDor => 'Goutte d\'Or',
    };

class Restaurant {
  final String id;
  final String name;
  final CuisineType cuisine;
  final UberZone zone;
  final String address;
  final String emoji;
  /// Détail unique qui personnalise le resto.
  final String detail;
  /// Note moyenne 0-5.0.
  final double rating;
  /// Si true, le resto a une histoire avec Shen (alliée potentielle).
  final bool isFavoris;
  /// Si non-null, l'identité du gérant (pour les arcs).
  final String? managerName;
  final List<int> gradient;

  const Restaurant({
    required this.id,
    required this.name,
    required this.cuisine,
    required this.zone,
    required this.address,
    required this.emoji,
    required this.detail,
    this.rating = 4.5,
    this.isFavoris = false,
    this.managerName,
    this.gradient = const [0xFF06C167, 0xFF036B3A],
  });
}

/// Type de client — pondère pourboire et notes.
enum CustomerKind {
  cadrePresse,      // 8e, midi rapide, tip moyen
  etudiant,         // chambre, tip rare, sympa
  meresoloEnfant,   // famille, tip moyen, gentille
  vieuxClassique,   // 6e, formalité, tip généreux
  vieuxIsole,       // tip très généreux, demande à parler
  bobo,             // 11e, tip OK, note artistique
  startupper,       // 8e, anglicismes
  noctambule,       // 4h du matin, ivre, tip variable
  gymGirl,          // healthy, no tip
  generosityMax,    // tip très haut sans raison
  picky,            // se plaint, mauvais rating
  pourboireZero,    // jamais de tip
  flirteur,         // drague le livreur
  pressePolite,     // courtois mais sec
  enfantConfus,     // commande passée par enfant
}

class UberCustomer {
  final String id;
  final String displayName;
  final CustomerKind kind;
  final UberZone zone;
  final String address;  // ex: "12 rue de Berri, 8e"
  final String building; // ex: "Bât. A · 3e étage · code 4297"
  final String emoji;
  /// Bio courte affichée si on tap dessus.
  final String bio;
  /// Pourboire moyen en euros.
  final double avgTip;
  /// Notes possibles laissées au livreur (pioche aléatoire).
  final List<String> notesPool;
  /// Si true, ce client peut déclencher un arc récurrent.
  final bool isRecurring;

  const UberCustomer({
    required this.id,
    required this.displayName,
    required this.kind,
    required this.zone,
    required this.address,
    required this.building,
    required this.emoji,
    required this.bio,
    this.avgTip = 0.0,
    this.notesPool = const [],
    this.isRecurring = false,
  });
}

/// Type de course — affecte la mécanique et le rendu.
enum CourseType {
  standard,        // course classique
  surgePluie,      // pluie, +50 %
  surgeMidi,       // déjeuner, +30 %
  surgeSoir,       // dîner, +30 %
  veryClose,       // < 1 km, payout bas
  longueDistance,  // > 6 km, payout haut
  nuit,            // après 22h, bonus
  weekendBonus,    // samedi-dimanche
  vipPremium,      // VIP Uber, +€5 garantis
  rerouterRequest, // client demande à un autre livreur
  collisionReplay, // J1 collision canonique
}

class UberCourse {
  final String id;
  /// Jour minimum de spawn possible.
  final int minDay;
  /// Heure de début (24h format).
  final int hour;
  final int minute;
  /// Restaurant d'origine.
  final String restaurantId;
  /// Client destinataire.
  final String customerId;
  /// Distance en km (calculée selon zones).
  final double distanceKm;
  /// Payout de base (avant surge).
  final double basePayout;
  /// Type de course.
  final CourseType type;
  /// Si true, course rare/spéciale (Stéphane VIP, etc.).
  final bool isSpecial;
  /// Note narrative attachée (pour les courses canoniques).
  final String? narrativeNote;

  const UberCourse({
    required this.id,
    required this.minDay,
    required this.hour,
    this.minute = 0,
    required this.restaurantId,
    required this.customerId,
    required this.distanceKm,
    required this.basePayout,
    this.type = CourseType.standard,
    this.isSpecial = false,
    this.narrativeNote,
  });

  /// Multiplicateur surge selon type.
  double get surgeMultiplier {
    switch (type) {
      case CourseType.surgePluie:
        return 1.5;
      case CourseType.surgeMidi:
      case CourseType.surgeSoir:
        return 1.3;
      case CourseType.weekendBonus:
        return 1.25;
      case CourseType.nuit:
        return 1.2;
      case CourseType.vipPremium:
        return 1.0; // bonus fixe à la place
      default:
        return 1.0;
    }
  }

  /// Bonus VIP fixe (€).
  double get vipBonus => type == CourseType.vipPremium ? 5.0 : 0.0;

  /// Payout total estimé (avant pourboire client).
  double get totalPayout =>
      (basePayout * surgeMultiplier) + vipBonus;
}
