import '../models/ace_scene.dart';

/// Scénario J1 en mode BD-animée.
///
/// Structure : background + sprite(s) + cartouche texte. Avance au tap.
///
/// Voix de Shen : "je" majoritaire, ironie sèche, 24 ans, carnet.
/// Voix de Tristan : sec, peu de mots, pas de superlatifs.

const String _bgStudioMatin = 'assets/photos/ace/bg_j1_studio_matin.jpeg';
const String _bgStudioNuit = 'assets/photos/ace/bg_j1_studio_nuit.jpeg';
const String _bgRueBelleville = 'assets/photos/ace/bg_j1_rue_belleville.png';
const String _bgCollision = 'assets/photos/ace/bg_j1_avenue_collision.jpeg';
const String _bgAvenuePropre = 'assets/photos/ace/bg_j1_avenue_propre.png';

// Sprites Shen livreuse
const String _shenPretePartir = 'assets/photos/ace/shen_livreuse_01_prete_a_partir.png';
const String _shenFeuRouge = 'assets/photos/ace/shen_livreuse_02_au_feu_rouge.png';
const String _shenDouleur = 'assets/photos/ace/shen_livreuse_03_douleur_collision.png';
const String _shenRelevee = 'assets/photos/ace/shen_livreuse_04_releve_la_tete.png';
const String _shenDechireCarte = 'assets/photos/ace/shen_livreuse_05_dechire_la_carte.png';
const String _shenMarcheMouillee = 'assets/photos/ace/shen_livreuse_06_marche_mouillee.png';

// Sprites Shen studio
const String _shenEcrit = 'assets/photos/ace/shen_studio_01_ecrit_carnet.png';
const String _shenRecolle = 'assets/photos/ace/shen_studio_02_recolle_la_carte.png';
const String _shenCalcule = 'assets/photos/ace/shen_studio_03_calcule_prostree.png';
const String _shenTelAide = 'assets/photos/ace/shen_studio_04_telephone_aide_sociale.png';
const String _shenTelNuit = 'assets/photos/ace/shen_studio_05_telephone_inconnu_nuit.png';
const String _shenTete = 'assets/photos/ace/shen_studio_06_se_tient_la_tete.png';

// Sprites Tristan anonyme (visage caché par cadrage)
const String _tJambes = 'assets/photos/ace/tristan_01_jambes_chaussures.png';
const String _tMainCarte = 'assets/photos/ace/tristan_02_main_carte.png';
const String _tMainFermee = 'assets/photos/ace/tristan_03_main_fermee.png';
const String _tOuvre = 'assets/photos/ace/tristan_04_ouvre_portiere.png';
const String _tDosSeloigne = 'assets/photos/ace/tristan_05_dos_seloigne.png';

final AceScene aceJ1 = AceScene(
  day: 1,
  title: 'La carte qui ne dit pas son nom',
  location: 'Belleville · Avenue Montaigne',
  time: '06:40 → 23:55',
  beats: [
    // ─── Acte 1 : matin Belleville ───────────────────────────────────
    AceBeat(
      background: _bgStudioMatin,
      sprites: [AceSprite(asset: _shenEcrit, position: SpritePosition.left)],
      kind: BeatKind.narration,
      text:
          '6h40. Je note le matin avant qu\'il ne me note. Bic vert. Carnet. '
          'Maman dort encore — Tenon nous mange à petites cuillerées.',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [AceSprite(asset: _shenEcrit, position: SpritePosition.left)],
      kind: BeatKind.thought,
      text:
          'Trois courses avant midi. Loyer le 5. Traitement de Maman, '
          'toujours.',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenPretePartir, position: SpritePosition.center)
      ],
      kind: BeatKind.narration,
      text:
          'Casque. Veste. Sac. Je sors. Belleville sent le pain et la pluie.',
    ),

    // ─── Acte 2 : trajet et feu rouge ────────────────────────────────
    AceBeat(
      background: _bgRueBelleville,
      sprites: [
        AceSprite(asset: _shenFeuRouge, position: SpritePosition.left)
      ],
      kind: BeatKind.narration,
      ambient: BeatAmbient.rain,
      text:
          'Feu rouge rue Ramponeau. La ville s\'éveille en gris. '
          'Le sac fluo pèse trois croissants et un loyer.',
    ),
    AceBeat(
      background: _bgRueBelleville,
      sprites: [
        AceSprite(asset: _shenFeuRouge, position: SpritePosition.left)
      ],
      kind: BeatKind.thought,
      text: 'Pédaler. Ne pas penser. Pédaler.',
    ),

    // ─── Acte 3 : la collision ───────────────────────────────────────
    AceBeat(
      background: _bgCollision,
      sprites: [],
      kind: BeatKind.narration,
      sfx: BeatSfx.impact,
      text:
          'Avenue Montaigne. 8h12. Une berline noire ouvre sa portière sans regarder.',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenDouleur, position: SpritePosition.left)
      ],
      kind: BeatKind.thought,
      text: 'L\'épaule. La hanche. Le goudron mouillé.',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenDouleur, position: SpritePosition.left),
        AceSprite(asset: _tJambes, position: SpritePosition.right),
      ],
      kind: BeatKind.narration,
      text:
          'Des chaussures cirées descendent du véhicule. Pas de "ça va ?". '
          'Pas un mot.',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenRelevee, position: SpritePosition.left),
        AceSprite(asset: _tMainCarte, position: SpritePosition.right),
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Inconnu',
      text: '« Mes assurances règleront. Appelez ce numéro. »',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenRelevee, position: SpritePosition.left),
        AceSprite(asset: _tMainCarte, position: SpritePosition.right),
      ],
      kind: BeatKind.thought,
      text:
          'Pas de nom. Pas de regard. Une carte blanche, un numéro, '
          'rien d\'autre.',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenRelevee, position: SpritePosition.left),
        AceSprite(asset: _tDosSeloigne, position: SpritePosition.right),
      ],
      kind: BeatKind.narration,
      sfx: BeatSfx.impact,
      text:
          'Il remonte dans la berline. La portière claque. La voiture '
          's\'éloigne. Mon vélo est tordu sur les pavés.',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenDechireCarte, position: SpritePosition.center)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Shen',
      text: '« Très bien. »',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenDechireCarte, position: SpritePosition.center)
      ],
      kind: BeatKind.thought,
      text:
          'Je déchire la carte. Deux morceaux. Quatre. Le vent les prend. '
          'Le goudron les boit.',
    ),

    // ─── Acte 4 : la longue marche ───────────────────────────────────
    AceBeat(
      background: _bgAvenuePropre,
      sprites: [
        AceSprite(asset: _shenMarcheMouillee, position: SpritePosition.center)
      ],
      kind: BeatKind.narration,
      text:
          'Je pousse le vélo cassé. L\'avenue Montaigne est trop propre '
          'pour mes mains sales.',
    ),
    AceBeat(
      background: _bgAvenuePropre,
      sprites: [
        AceSprite(asset: _shenMarcheMouillee, position: SpritePosition.center)
      ],
      kind: BeatKind.thought,
      text:
          'Trois courses annulées. La cliente du 47e ne paiera pas. Le '
          'cadre est foutu. Bonjour la journée.',
    ),

    // ─── Acte 5 : retour studio, le regret ───────────────────────────
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenCalcule, position: SpritePosition.left)
      ],
      kind: BeatKind.narration,
      ambient: BeatAmbient.none,
      text:
          'Studio. 14h. Je compte ce que je n\'ai pas : un vélo, trois '
          'courses, une fierté.',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenCalcule, position: SpritePosition.left)
      ],
      kind: BeatKind.thought,
      text:
          'Et si j\'avais gardé la carte ? Juste pour la facture du vélo. '
          'Juste ça.',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenRecolle, position: SpritePosition.center)
      ],
      kind: BeatKind.narration,
      text:
          'Je retrouve trois fragments dans la poche de ma veste. Pas le '
          'quatrième. Le numéro y serait peut-être.',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenRecolle, position: SpritePosition.center)
      ],
      kind: BeatKind.thought,
      text:
          'Je les pose sur la table. Je ne les recolle pas tout de suite. '
          'On verra ce soir.',
    ),

    // ─── Acte 6 : tentative aide sociale (soir tombant) ──────────────
    AceBeat(
      background: _bgStudioNuit,
      sprites: [
        AceSprite(asset: _shenTelAide, position: SpritePosition.right)
      ],
      kind: BeatKind.narration,
      text:
          '20h. J\'appelle l\'aide sociale pour les frais de Maman. '
          'Musique d\'attente. Vivaldi en sourdine.',
    ),
    AceBeat(
      background: _bgStudioNuit,
      sprites: [
        AceSprite(asset: _shenTelAide, position: SpritePosition.right)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Aide sociale',
      text:
          '« Votre dossier est en cours d\'instruction. Comptez six à huit '
          'semaines. »',
    ),
    AceBeat(
      background: _bgStudioNuit,
      sprites: [
        AceSprite(asset: _shenTete, position: SpritePosition.center)
      ],
      kind: BeatKind.thought,
      text:
          'Huit semaines. Tenon n\'attend pas huit semaines. Maman non plus.',
    ),

    // ─── Acte 7 : le coup de fil de nuit ─────────────────────────────
    AceBeat(
      background: _bgStudioNuit,
      sprites: [
        AceSprite(asset: _shenTelNuit, position: SpritePosition.left)
      ],
      kind: BeatKind.narration,
      sfx: BeatSfx.ring,
      ambient: BeatAmbient.rain,
      text:
          '23h55. Numéro masqué. Je décroche par fatigue.',
    ),
    AceBeat(
      background: _bgStudioNuit,
      sprites: [
        AceSprite(asset: _shenTelNuit, position: SpritePosition.left)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Inconnu',
      text:
          '« Je devine que la carte est en miettes. Demain, 8h, café Le '
          'Rostand. — T. »',
    ),
    AceBeat(
      background: _bgStudioNuit,
      sprites: [
        AceSprite(asset: _shenTelNuit, position: SpritePosition.left)
      ],
      kind: BeatKind.thought,
      text:
          'Comment il sait. Pour la carte. Pour moi. Pour ce numéro.',
    ),
    AceBeat(
      background: _bgStudioNuit,
      sprites: [
        AceSprite(asset: _shenEcrit, position: SpritePosition.right)
      ],
      kind: BeatKind.narration,
      text:
          'Je raccroche. Je note dans le carnet : "T. — Le Rostand — 8h". '
          'Je n\'ai pas dit oui. Je n\'ai pas dit non.',
    ),
  ],
);
