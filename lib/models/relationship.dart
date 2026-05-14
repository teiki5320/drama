/// Jauges invisibles par contact qui influencent le ton et le contenu
/// des messages reçus. Le joueur ne voit JAMAIS ces nombres — il les
/// ressent à travers la façon dont les PNJ lui parlent.
///
/// Échelle : 0-100. Évolution lente — chaque action modifie ±1 à ±6.
class Relationship {
  /// Confiance qu'a le contact en Shen. ↓ avec mensonges, ↑ avec
  /// transparence et fiabilité.
  final int trust;

  /// Attirance / proximité affective. ↑ avec gestes de tendresse, vu
  /// rapidement, attention portée. ↓ avec ignorance prolongée.
  final int attraction;

  /// Jalousie. ↑ quand le contact perçoit Shen avec quelqu'un d'autre.
  final int jealousy;

  /// Dépendance affective. ↑ quand Shen répond très vite, partage
  /// beaucoup. ↓ quand elle prend du recul.
  final int dependency;

  /// Méfiance / suspicion. ↑ avec incohérences, retards, mensonges
  /// détectés. ↓ avec naturel sur le temps.
  final int suspicion;

  /// Loyauté / fidélité (réciproque). ↑ avec gestes loyaux dans les
  /// deux sens. ↓ avec trahisons.
  final int loyalty;

  const Relationship({
    this.trust = 50,
    this.attraction = 0,
    this.jealousy = 0,
    this.dependency = 0,
    this.suspicion = 0,
    this.loyalty = 50,
  });

  Relationship copyWith({
    int? trust,
    int? attraction,
    int? jealousy,
    int? dependency,
    int? suspicion,
    int? loyalty,
  }) =>
      Relationship(
        trust: (trust ?? this.trust).clamp(0, 100),
        attraction: (attraction ?? this.attraction).clamp(0, 100),
        jealousy: (jealousy ?? this.jealousy).clamp(0, 100),
        dependency: (dependency ?? this.dependency).clamp(0, 100),
        suspicion: (suspicion ?? this.suspicion).clamp(0, 100),
        loyalty: (loyalty ?? this.loyalty).clamp(0, 100),
      );

  /// Applique des deltas (positifs ou négatifs) à toutes les jauges.
  Relationship apply(RelationshipDelta d) => copyWith(
        trust: trust + d.trust,
        attraction: attraction + d.attraction,
        jealousy: jealousy + d.jealousy,
        dependency: dependency + d.dependency,
        suspicion: suspicion + d.suspicion,
        loyalty: loyalty + d.loyalty,
      );
}

/// Delta à appliquer sur une relation à l'issue d'un choix narratif.
class RelationshipDelta {
  final int trust;
  final int attraction;
  final int jealousy;
  final int dependency;
  final int suspicion;
  final int loyalty;

  const RelationshipDelta({
    this.trust = 0,
    this.attraction = 0,
    this.jealousy = 0,
    this.dependency = 0,
    this.suspicion = 0,
    this.loyalty = 0,
  });
}

/// État de départ — Maman et Camille ont déjà une relation forte avec
/// Shen au J1, Tristan n'existe pas encore (jauges à 0).
const Map<String, Relationship> kInitialRelationships = {
  'maman': Relationship(
      trust: 85, attraction: 0, dependency: 70, loyalty: 95, suspicion: 25),
  'camille': Relationship(
      trust: 90, attraction: 10, dependency: 60, loyalty: 90, suspicion: 0),
  'tristan': Relationship(
      trust: 0, attraction: 0, dependency: 0, suspicion: 70, loyalty: 0),
};
