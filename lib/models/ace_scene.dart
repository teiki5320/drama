/// Modèle de données pour le mode ACE (BD animée à la Ace Attorney).
///
/// Une scène ACE = liste ordonnée de `AceBeat`. Chaque beat est un
/// "panneau" de BD : un fond + un (ou deux) sprite(s) + un cartouche
/// texte en bas. Le joueur tape pour avancer.
library;

enum SpritePosition { left, right, center }

class AceSprite {
  final String asset;
  final SpritePosition position;
  final double scale;

  const AceSprite({
    required this.asset,
    this.position = SpritePosition.left,
    this.scale = 1.0,
  });
}

enum BeatKind {
  /// Narration off, pas de "speaker". Voix de Shen ou neutre.
  narration,

  /// Dialogue d'un personnage (label + texte).
  dialogue,

  /// Pensée intérieure de Shen (italique, sans guillemets).
  thought,
}

/// SFX joué à l'apparition du beat (en plus du tick du typewriter).
/// Null = aucun SFX d'apparition.
enum BeatSfx { impact, ring }

/// Ambiance sonore en boucle pendant le beat. Hérite du beat précédent
/// si null.
enum BeatAmbient { none, rain }

class AceBeat {
  /// Image de fond (recouvre tout l'écran, légèrement floue).
  final String background;

  /// Sprites visibles (0..2). Un seul = positionné selon `position`.
  /// Deux = un à gauche + un à droite.
  final List<AceSprite> sprites;

  /// Type de beat (change le rendu du cartouche).
  final BeatKind kind;

  /// Nom affiché en haut du cartouche (vide pour narration / pensée).
  final String? speakerLabel;

  /// Texte affiché dans le cartouche, avec emphase **gras** / *italique*.
  final String text;

  /// SFX one-shot joué à l'apparition du beat. Null = silence.
  final BeatSfx? sfx;

  /// Ambiance en boucle à activer sur ce beat (ne se relance pas si déjà
  /// active). Null = on garde l'ambiance précédente.
  final BeatAmbient? ambient;

  const AceBeat({
    required this.background,
    required this.text,
    this.sprites = const [],
    this.kind = BeatKind.dialogue,
    this.speakerLabel,
    this.sfx,
    this.ambient,
  });
}

class AceScene {
  final int day;
  final String title;
  final String location;
  final String time;
  final List<AceBeat> beats;

  const AceScene({
    required this.day,
    required this.title,
    required this.location,
    required this.time,
    required this.beats,
  });
}
