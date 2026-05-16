/// Modèle de lieu pour l'app Plans — restaurants, clients, lieux
/// canoniques (Tour Heng, Foch, Tenon, Belleville) et lieux narratifs
/// (collision Avenue Montaigne).
///
/// Chaque lieu a des coordonnées approximatives Paris pour la
/// projection sur la carte stylisée. Pas de tuiles réelles — on dessine
/// Paris en CustomPainter (Seine + arrondissements + pins).
library;

/// Catégorie de lieu — affecte la couleur du pin, l'icône, le filtre.
enum PlaceCategory {
  heng,         // Tour Heng, Avenue Foch home, cabinet notaire
  maman,        // Belleville flat, Tenon, marché Belleville
  camille,      // appartement Camille, lieux qu'elle aime
  restaurant,   // UberEats restaurants
  customer,     // UberEats client addresses
  collision,    // lieu narratif J1 collision
  rendezVous,   // RDV ponctuels (Tour Heng J7, etc.)
  banque,       // BNP Champs-Élysées
  medical,      // Tenon, cabinet médecin
  amitie,       // librairie Bastien, lieux liés aux arcs
  travail,      // bureaux livraison, plateforme
  perso,        // appartement Avenue Foch
}

class MapPlace {
  final String id;
  final String name;
  final String address;
  /// Latitude approximative pour la projection sur le canvas Paris.
  final double lat;
  /// Longitude approximative.
  final double lng;
  final PlaceCategory category;
  final String emoji;
  /// Détail / contexte affichable dans le sheet.
  final String detail;
  /// Si true, le lieu est dévoilé d'office (sans qu'on l'ait visité).
  /// Utilisé pour les lieux canoniques connus dès J1.
  final bool revealedAtStart;
  /// Si non-null, le lieu n'apparaît que si Shen est passée par ce
  /// beat narratif (ex: Tour Heng dévoilée seulement après J6 RDV).
  final int? requiresDay;

  const MapPlace({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
    required this.category,
    required this.emoji,
    required this.detail,
    this.revealedAtStart = false,
    this.requiresDay,
  });
}

/// Stats globales calculées sur l'ensemble des visites.
class MapStats {
  final int placesVisited;
  final int placesTotal;
  final double kmTotal;
  final Map<PlaceCategory, int> visitsPerCategory;
  const MapStats({
    required this.placesVisited,
    required this.placesTotal,
    required this.kmTotal,
    required this.visitsPerCategory,
  });
}
