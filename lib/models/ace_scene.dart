/// Modèle de données pour le mode ACE (BD animée à la Ace Attorney).
///
/// Une scène ACE = liste ordonnée de `AceBeat`. Chaque beat est un
/// "panneau" de BD : un fond + un (ou deux) sprite(s) + un cartouche
/// texte en bas. Le joueur tape pour avancer.
library;

enum SpritePosition { left, right, center }

class AceSprite {
  /// Asset statique (PNG transparent). Toujours requis — sert de
  /// fallback si l'asset animé n'est pas disponible / ne se charge pas.
  final String asset;

  /// Asset animé optionnel : WebP animé à fond transparent (boucle
  /// 2 s à 12 fps). Si renseigné, c'est lui qui est affiché à la place
  /// du PNG statique.
  final String? animatedAsset;

  final SpritePosition position;
  final double scale;

  const AceSprite({
    required this.asset,
    this.animatedAsset,
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

  /// Title card du prologue : texte serif centré plein écran, pas de
  /// cartouche, fond ultra sombre. Utilisé pour planter les
  /// personnages et le contexte avant J1.
  titleCard,
}

/// SFX joué à l'apparition du beat (en plus du tick du typewriter).
/// Null = aucun SFX d'apparition.
enum BeatSfx { impact, ring }

/// Ambiance sonore en boucle pendant le beat. Hérite du beat précédent
/// si null.
enum BeatAmbient { none, rain }

class AceBeat {
  /// Image de fond (recouvre tout l'écran, légèrement floue). Si
  /// `backgroundVideo` est renseigné, cette image sert de fallback.
  final String background;

  /// Vidéo de fond optionnelle (MP4 plein écran). Sert pour les beats
  /// où la scène entière est animée (ex. Shen au feu rouge sous la
  /// pluie). Remplace l'image floue + sprite par une vidéo unique.
  final String? backgroundVideo;

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
    this.backgroundVideo,
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
