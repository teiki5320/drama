import '../models/ace_scene.dart';

/// Scénario J1 → J3 en mode BD-animée, version drama.
///
/// **Règles de voix (strictes)** :
/// - **Narration** = 3e personne, présent narratif, sensorielle. Phrases
///   pleines, descriptions filmiques. Aucun "je".
/// - **Pensées** = 1re personne. "Je", "moi", "mon". Aucune référence à
///   "Shen" en 3e personne dans une pensée.
/// - **Voix off omnisciente** ponctuelle, en 3e personne narratif :
///   "Plus tard, Shen ne saurait pas dire à quel moment elle a décidé."
/// - **Dialogues** = répliques entre guillemets français « ». Speaker
///   nommé dans le label.
///
/// **Drama** :
/// - Cliffhangers de fin de beat. Chaque beat tire vers le suivant.
/// - Stakes corporels : douleur, faim, sommeil, argent retenu.
/// - Compteur visible : six semaines, dix-huit mille, deux mille trois cent
///   quatre-vingt-quatre.
/// - Dignité de Shen sous tension : elle refuse, elle compte, elle tient.

const String _bgStudioMatin = 'assets/photos/ace/bg_j1_studio_matin.jpeg';
const String _bgStudioNuit = 'assets/photos/ace/bg_j1_studio_nuit.jpeg';
const String _bgRueBelleville = 'assets/photos/ace/bg_j1_rue_belleville.png';
const String _bgCollision = 'assets/photos/ace/bg_j1_avenue_collision.jpeg';
const String _bgAvenuePropre = 'assets/photos/ace/bg_j1_avenue_propre.png';
const String _bgBureauAubin = 'assets/photos/ace/bg_j2_bureau_aubin.png';
const String _bgCalculs = 'assets/photos/ace/bg_j3_calculs.png';

// Sprites Shen livreuse — PNG statiques + WebP animés transparents
const String _shenPretePartir =
    'assets/photos/ace/shen_livreuse_01_prete_a_partir.png';
const String _shenPretePartirAnim =
    'assets/photos/ace/shen_livreuse_01_prete_a_partir.webp';
const String _shenFeuRouge =
    'assets/photos/ace/shen_livreuse_02_au_feu_rouge.png';
const String _shenDouleur =
    'assets/photos/ace/shen_livreuse_03_douleur_collision.png';
const String _shenDouleurAnim =
    'assets/photos/ace/shen_livreuse_03_douleur_collision.webp';
const String _shenRelevee =
    'assets/photos/ace/shen_livreuse_04_releve_la_tete.png';
const String _shenDechireCarte =
    'assets/photos/ace/shen_livreuse_05_dechire_la_carte.png';
const String _shenMarcheMouillee =
    'assets/photos/ace/shen_livreuse_06_marche_mouillee.png';
const String _shenMarcheMouilleeAnim =
    'assets/photos/ace/shen_livreuse_06_marche_mouillee.webp';

// Sprites Shen studio
const String _shenEcrit = 'assets/photos/ace/shen_studio_01_ecrit_carnet.png';
const String _shenEcritAnim =
    'assets/photos/ace/shen_studio_01_ecrit_carnet.webp';
const String _shenRecolle =
    'assets/photos/ace/shen_studio_02_recolle_la_carte.png';
const String _shenRecolleAnim =
    'assets/photos/ace/shen_studio_02_recolle_la_carte.webp';
const String _shenCalcule =
    'assets/photos/ace/shen_studio_03_calcule_prostree.png';
const String _shenCalculeAnim =
    'assets/photos/ace/shen_studio_03_calcule_prostree.webp';
const String _shenTelAide =
    'assets/photos/ace/shen_studio_04_telephone_aide_sociale.png';
const String _shenTelAideAnim =
    'assets/photos/ace/shen_studio_04_telephone_aide_sociale.webp';
const String _shenTete =
    'assets/photos/ace/shen_studio_06_se_tient_la_tete.png';
const String _shenTeteAnim =
    'assets/photos/ace/shen_studio_06_se_tient_la_tete.webp';

// Sprites Tristan anonyme (pas d'anim pour l'instant)
const String _tJambes = 'assets/photos/ace/tristan_01_jambes_chaussures.png';
const String _tMainCarte = 'assets/photos/ace/tristan_02_main_carte.png';
const String _tDosSeloigne = 'assets/photos/ace/tristan_05_dos_seloigne.png';

// Vidéo plein écran (MP4 avec son propre fond)
const String _vidFeuRouge =
    'assets/photos/ace/scene_j1_feu_rouge_belleville.mp4';

final AceScene aceJ1 = AceScene(
  day: 1,
  title: 'La carte qui ne dit pas son nom',
  location: 'J1 → J3 · Belleville · 8ᵉ · Tenon',
  time: '03 → 05 juin 2026',
  beats: [
    // ═══════════════════════════════════════════════════════════════════
    // PROLOGUE — « Avant »
    // ═══════════════════════════════════════════════════════════════════
    AceBeat(
      background: _bgStudioMatin,
      kind: BeatKind.titleCard,
      text: 'À CONTRE-JOUR\n逆光',
    ),
    AceBeat(
      background: _bgRueBelleville,
      kind: BeatKind.titleCard,
      ambient: BeatAmbient.rain,
      text:
          'Belleville, 20ᵉ.\n'
          'Pluie de juin.\n'
          'Six heures du matin.',
    ),
    AceBeat(
      background: _bgStudioMatin,
      kind: BeatKind.titleCard,
      ambient: BeatAmbient.none,
      text:
          'SHEN MARCHAND, 24 ans.\n'
          'Architecture à mi-temps.\n'
          'Livreuse à vélo, le reste du temps.\n'
          'Bilingue français-mandarin.',
    ),
    AceBeat(
      background: _bgStudioMatin,
      kind: BeatKind.titleCard,
      text:
          'Sa mère, Hélène. Cinquante ans.\n'
          'Hôpital Tenon, depuis trois ans.\n'
          'Elle s\'excuse de tomber malade.\n'
          'C\'est insupportable.',
    ),
    AceBeat(
      background: _bgStudioMatin,
      kind: BeatKind.titleCard,
      text:
          'Trois jours pour comprendre.\n'
          'Trois portes pour s\'effondrer.\n'
          'Et un homme qui n\'a pas encore de nom.',
    ),

    // ═══════════════════════════════════════════════════════════════════
    // J1 — Vendredi 3 juin — La carte
    // ═══════════════════════════════════════════════════════════════════
    AceBeat(
      background: _bgStudioMatin,
      kind: BeatKind.titleCard,
      text: 'J1\nVendredi 3 juin · 07h42\nStudio, Belleville',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [AceSprite(asset: _shenEcrit, animatedAsset: _shenEcritAnim, position: SpritePosition.left)],
      kind: BeatKind.narration,
      text:
          'La pluie cogne la fenêtre du studio. Shen écrit, vite, sans '
          'lever la tête. Bic vert : elle n\'a pas trouvé le noir.',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [AceSprite(asset: _shenEcrit, animatedAsset: _shenEcritAnim, position: SpritePosition.left)],
      kind: BeatKind.thought,
      text:
          'Maman a toussé à quatre heures du matin.\n'
          'J\'ai fait semblant de dormir. Si elle sait que je l\'ai '
          'entendue, elle s\'excusera.\n'
          'Maman s\'excuse de tomber malade. Je ne supporte pas.',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [AceSprite(asset: _shenEcrit, animatedAsset: _shenEcritAnim, position: SpritePosition.left)],
      kind: BeatKind.narration,
      text:
          'Sur l\'étagère, une lettre du Fujian patiente, fermée. Tante '
          'Mei écrit en chinois. Shen lira ce soir — si la journée laisse '
          'le soir.',
    ),

    // ─── SMS Maman avant départ ────────────────────────────────────
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenPretePartir, animatedAsset: _shenPretePartirAnim, position: SpritePosition.center)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Maman',
      text: '« Tu pars livrer dans combien ? »',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenPretePartir, animatedAsset: _shenPretePartirAnim, position: SpritePosition.center)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Shen',
      text: '« Dix minutes. Vélo, pluie, le 8ᵉ. »',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenPretePartir, animatedAsset: _shenPretePartirAnim, position: SpritePosition.center)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Maman',
      text:
          '« Tes vingt-quatre ans ne tiendront pas la pluie aussi '
          'longtemps que tu le crois. Couvre-toi. Et mange un truc avant '
          'de monter sur ce vélo. »',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenPretePartir, animatedAsset: _shenPretePartirAnim, position: SpritePosition.center)
      ],
      kind: BeatKind.thought,
      text:
          'Pain au chocolat de la veille trempé dans du thé tiède. Ça me '
          'tient debout. Je ne lui dirai pas.',
    ),

    // ─── Rue Belleville sous la pluie ──────────────────────────────
    // Cette séquence utilise la vidéo plein écran (Shen au feu rouge,
    // pluie qui ruisselle sur le casque, trafic en arrière-plan). Pas
    // de sprite composité : la scène EST la vidéo.
    AceBeat(
      background: _bgRueBelleville,
      backgroundVideo: _vidFeuRouge,
      kind: BeatKind.narration,
      ambient: BeatAmbient.rain,
      text:
          'Belleville s\'éveille à contre-cœur. Le sac fluo charge trois '
          'petits-déjeuners à quatre euros pièce — moins la part de la '
          'plateforme, il restera de quoi acheter du riz.',
    ),
    AceBeat(
      background: _bgRueBelleville,
      backgroundVideo: _vidFeuRouge,
      kind: BeatKind.thought,
      text:
          'Ce soir : payer le loyer, lire la lettre du Fujian, vérifier '
          'que Maman a bien pris ses gélules de seize heures.\n'
          'Pédaler. Ne pas penser. Pédaler.',
    ),
    AceBeat(
      background: _bgRueBelleville,
      backgroundVideo: _vidFeuRouge,
      kind: BeatKind.narration,
      text:
          'Ce matin-là, Shen croyait que la pluie était son pire ennemi. '
          'Elle se trompait.',
    ),

    // ─── LA COLLISION — Avenue Montaigne 8h17 ──────────────────────
    AceBeat(
      background: _bgCollision,
      kind: BeatKind.narration,
      sfx: BeatSfx.impact,
      text:
          'Avenue Montaigne. Huit heures dix-sept. Le bruit arrive en deux '
          'temps. D\'abord la mécanique d\'un freinage trop tard : un '
          'crissement aigu qui n\'a pas le temps de finir. Puis le métal '
          'qui touche le métal — sourd, court — et qui frappe dans la '
          'poitrine de Shen avant même que son vélo soit touché.',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenDouleur, animatedAsset: _shenDouleurAnim, position: SpritePosition.left)
      ],
      kind: BeatKind.thought,
      text: 'Quelqu\'un vient d\'appuyer sur pause à l\'intérieur de moi.',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenDouleur, animatedAsset: _shenDouleurAnim, position: SpritePosition.left)
      ],
      kind: BeatKind.narration,
      text:
          'Le bitume est plus rapide que la pensée. L\'épaule droite touche '
          'en premier, puis le casque, puis le genou. Le casque tient. Le '
          'genou non — la peau s\'ouvre avec le bruit du papier qu\'on '
          'déchire. Un son qu\'on n\'oublie jamais.',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenDouleur, animatedAsset: _shenDouleurAnim, position: SpritePosition.left)
      ],
      kind: BeatKind.narration,
      text:
          'Le sac de livraison s\'éventre comme un fruit trop mûr. Le bowl '
          'se renverse en direct ; l\'açaí trace une coulée violette sur '
          'le bitume mouillé. Trente-huit euros que la plateforme retiendra '
          'sur la prochaine paie.',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenDouleur, animatedAsset: _shenDouleurAnim, position: SpritePosition.left)
      ],
      kind: BeatKind.thought,
      text:
          'Pas pleurer. Pas devant lui. Pas devant la rue.',
    ),

    // ─── Le costume sans yeux ──────────────────────────────────────
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenDouleur, animatedAsset: _shenDouleurAnim, position: SpritePosition.left),
        AceSprite(asset: _tJambes, position: SpritePosition.right),
      ],
      kind: BeatKind.narration,
      text:
          'Quand Shen rouvre les yeux : des chaussures cuir. L\'homme qui '
          'descend de la berline porte un costume qui coûte plus que son '
          'loyer annuel. Il regarde sa montre. Il regarde la rue. Il '
          'regarde son rétroviseur. Il regarde tout — sauf elle.',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenRelevee, position: SpritePosition.left),
        AceSprite(asset: _tJambes, position: SpritePosition.right),
      ],
      kind: BeatKind.narration,
      text:
          'Quand il finit par baisser les yeux, c\'est avec l\'expression '
          'de quelqu\'un qui calcule combien ça va lui coûter.',
    ),

    // ─── Dialogue du mépris ────────────────────────────────────────
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenRelevee, position: SpritePosition.left),
        AceSprite(asset: _tMainCarte, position: SpritePosition.right),
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'L\'inconnu',
      text:
          '« Ça ira. Pour le vélo et la consultation. »\n'
          '(Il sort deux billets de cent euros.)',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenRelevee, position: SpritePosition.left),
        AceSprite(asset: _tMainCarte, position: SpritePosition.right),
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Shen',
      text: '« Gardez votre argent. »',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenRelevee, position: SpritePosition.left),
        AceSprite(asset: _tMainCarte, position: SpritePosition.right),
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'L\'inconnu',
      text: '« Pardon ? »',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenRelevee, position: SpritePosition.left),
        AceSprite(asset: _tMainCarte, position: SpritePosition.right),
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Shen',
      text:
          '« Votre assurance paiera. Comme tout le monde. Je ne suis pas '
          'un pourboire. »',
    ),

    // ─── La carte — révélation ─────────────────────────────────────
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenRelevee, position: SpritePosition.left),
        AceSprite(asset: _tMainCarte, position: SpritePosition.right),
      ],
      kind: BeatKind.narration,
      text:
          'Il lui tend une carte de visite — deux doigts en pince, comme '
          'on tend l\'addition. Bristol crème. Lettrage discret. Trois '
          'lignes que Shen lit malgré elle :',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _tMainCarte, position: SpritePosition.center)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'La carte',
      text: 'TRISTAN HENG\nHeng International\nDirecteur Europe',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenDechireCarte, position: SpritePosition.center)
      ],
      kind: BeatKind.narration,
      sfx: BeatSfx.impact,
      text:
          'Shen prend la carte. Elle la regarde. Elle la déchire devant '
          'lui — un coup, deux coups, quatre morceaux. Les bouts tombent '
          'dans la flaque d\'açaí. La pluie s\'en occupe.',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenDechireCarte, position: SpritePosition.center)
      ],
      kind: BeatKind.thought,
      text:
          'Voilà. Ça, au moins, je l\'aurai fait correctement aujourd\'hui.',
    ),

    // ─── Le retour ─────────────────────────────────────────────────
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenDechireCarte, position: SpritePosition.left),
        AceSprite(asset: _tDosSeloigne, position: SpritePosition.right),
      ],
      kind: BeatKind.narration,
      text:
          'Elle repart en boitant, son vélo cassé sur l\'épaule. Elle ne '
          'se retourne pas. Si elle se retournait, il verrait qu\'elle '
          'tremble.',
    ),
    AceBeat(
      background: _bgAvenuePropre,
      sprites: [
        AceSprite(
            asset: _shenMarcheMouillee, animatedAsset: _shenMarcheMouilleeAnim, position: SpritePosition.center)
      ],
      kind: BeatKind.thought,
      text:
          'Heng International. Directeur Europe.\n'
          'Trois mots que je ne devrais pas avoir retenus.\n'
          'Trois mots que je ne vais pas oublier.',
    ),
    AceBeat(
      background: _bgAvenuePropre,
      sprites: [
        AceSprite(
            asset: _shenMarcheMouillee, animatedAsset: _shenMarcheMouilleeAnim, position: SpritePosition.center)
      ],
      kind: BeatKind.narration,
      text:
          'Shen passe par le 8ᵉ exprès en rentrant. Plus longtemps. Pas '
          'pour y aller — pour pouvoir y penser. Camille l\'attend ce soir. '
          'Elle voudra tout savoir. Shen devra choisir ce qu\'elle raconte.',
    ),

    // ─── Endcap J1 — la carte recollée ─────────────────────────────
    AceBeat(
      background: _bgStudioNuit,
      sprites: [
        AceSprite(asset: _shenRecolle, animatedAsset: _shenRecolleAnim, position: SpritePosition.center)
      ],
      kind: BeatKind.narration,
      ambient: BeatAmbient.rain,
      text:
          'Vingt-trois heures quarante-deux. Studio. Les quatre morceaux '
          'sont posés sur l\'étagère, alignés. Personne — pas même Shen — '
          'ne saurait dire à quel moment elle les a ramassés dans la '
          'flaque.',
    ),
    AceBeat(
      background: _bgStudioNuit,
      sprites: [
        AceSprite(asset: _shenRecolle, animatedAsset: _shenRecolleAnim, position: SpritePosition.center)
      ],
      kind: BeatKind.thought,
      text: 'Première erreur.',
    ),

    // ═══════════════════════════════════════════════════════════════════
    // J2 — Samedi 4 juin — Tenon — Dr Aubin
    // ═══════════════════════════════════════════════════════════════════
    AceBeat(
      background: _bgBureauAubin,
      kind: BeatKind.titleCard,
      ambient: BeatAmbient.none,
      text: 'J2\nSamedi 4 juin · 06h30\nHôpital Tenon — Bureau du Dr Aubin',
    ),
    AceBeat(
      background: _bgBureauAubin,
      sprites: [
        AceSprite(asset: _shenCalcule, animatedAsset: _shenCalculeAnim, position: SpritePosition.left)
      ],
      kind: BeatKind.narration,
      text:
          'Le Dr Aubin a un visage que Shen aime bien. Lunettes en écaille, '
          'cheveux gris coupés trop court. Il pose son stylo avant de '
          'parler. Il ne lit pas une fiche : il réfléchit.',
    ),
    AceBeat(
      background: _bgBureauAubin,
      sprites: [
        AceSprite(asset: _shenCalcule, animatedAsset: _shenCalculeAnim, position: SpritePosition.left)
      ],
      kind: BeatKind.thought,
      text:
          'Quand un médecin demande à me parler en privé à six heures '
          'trente du matin, ce n\'est jamais pour me dire que ça va.',
    ),
    AceBeat(
      background: _bgBureauAubin,
      sprites: [
        AceSprite(asset: _shenCalcule, animatedAsset: _shenCalculeAnim, position: SpritePosition.left)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Dr Aubin',
      text:
          '« Madame Marchand. Votre mère a besoin d\'un traitement de '
          'seconde ligne. Un protocole hors AMM. Donc non remboursé. »',
    ),
    AceBeat(
      background: _bgBureauAubin,
      sprites: [
        AceSprite(asset: _shenCalcule, animatedAsset: _shenCalculeAnim, position: SpritePosition.left)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Shen',
      text: '« Combien ? »',
    ),
    AceBeat(
      background: _bgBureauAubin,
      sprites: [
        AceSprite(asset: _shenCalcule, animatedAsset: _shenCalculeAnim, position: SpritePosition.left)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Dr Aubin',
      text:
          '« Dix-huit mille euros sur six mois. Et il faut commencer sous '
          'six semaines, pas au-delà. Au-delà, il sera trop tard. »',
    ),
    AceBeat(
      background: _bgBureauAubin,
      sprites: [
        AceSprite(asset: _shenCalcule, animatedAsset: _shenCalculeAnim, position: SpritePosition.left)
      ],
      kind: BeatKind.thought,
      text:
          'Dix-huit mille.\n'
          'J\'en ai deux mille trois cent quatre-vingt-quatre.\n'
          'Et c\'est déjà un miracle de fin de mois.',
    ),
    AceBeat(
      background: _bgBureauAubin,
      kind: BeatKind.narration,
      sfx: BeatSfx.impact,
      text:
          'Six semaines. Quarante-deux jours. Le compteur démarre '
          'maintenant.',
    ),

    // ─── Le hall, l'infirmière ─────────────────────────────────────
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenCalcule, animatedAsset: _shenCalculeAnim, position: SpritePosition.center)
      ],
      kind: BeatKind.narration,
      text:
          'Hall d\'accueil, six heures quarante-huit. Eau de Javel et café '
          'froid. Shen s\'assoit sur un banc et reprend ses comptes. Trois '
          'fois. Trois fois la même réponse.',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenCalcule, animatedAsset: _shenCalculeAnim, position: SpritePosition.center)
      ],
      kind: BeatKind.thought,
      text:
          'Manque : quinze mille six cent seize.\n'
          'Temps : quarante-deux jours.\n'
          'Sommeil restant : aucun.',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenTete, animatedAsset: _shenTeteAnim, position: SpritePosition.right)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'L\'infirmière',
      text: '« Vous êtes la fille de Madame Marchand. »',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenTete, animatedAsset: _shenTeteAnim, position: SpritePosition.right)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'L\'infirmière',
      text:
          '« Elle est ici depuis trois ans. Je la connais bien. Elle ne '
          'dit jamais ce qu\'elle a vraiment, vous savez. Pas même au '
          'médecin.\n'
          'Faites attention à ce qu\'elle vous dit. »',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenTete, animatedAsset: _shenTeteAnim, position: SpritePosition.center)
      ],
      kind: BeatKind.thought,
      text: 'Maman ne dit pas tout.\nMaman ne dit pas tout.',
    ),
    AceBeat(
      background: _bgRueBelleville,
      kind: BeatKind.narration,
      ambient: BeatAmbient.rain,
      text:
          'Sept heures vingt-quatre. Métro Couronnes. Shen rentre. Compteur '
          'au front : J42. Quarante-deux jours pour trouver dix-huit mille '
          'euros que personne ne lui prêtera.',
    ),

    // ═══════════════════════════════════════════════════════════════════
    // J3 — Dimanche 5 juin — Calculs, refus, carte
    // ═══════════════════════════════════════════════════════════════════
    AceBeat(
      background: _bgCalculs,
      kind: BeatKind.titleCard,
      ambient: BeatAmbient.none,
      text: 'J3\nDimanche 5 juin · 14h30\nStudio, Belleville',
    ),
    AceBeat(
      background: _bgCalculs,
      sprites: [
        AceSprite(asset: _shenCalcule, animatedAsset: _shenCalculeAnim, position: SpritePosition.left)
      ],
      kind: BeatKind.narration,
      text:
          'Sur la table de la cuisine : trois feuilles. Trois colonnes — '
          'argent disponible, manque, temps restant. Shen écrit, raye, '
          'recompte. Le chiffre du manque refuse de tenir dans la case ; '
          'elle l\'écrit deux fois, plus petit, pour voir s\'il rétrécit. '
          'Il ne rétrécit pas.',
    ),
    AceBeat(
      background: _bgCalculs,
      sprites: [
        AceSprite(asset: _shenCalcule, animatedAsset: _shenCalculeAnim, position: SpritePosition.left)
      ],
      kind: BeatKind.narration,
      text:
          'Doubler les livraisons : quatre cents euros par mois. Troisième '
          'service de nuit : six cents, mais elle ne dormirait plus. Vendre '
          'le piano de Maman : entre mille deux cents et mille huit cents. '
          'Hors de question.',
    ),
    AceBeat(
      background: _bgCalculs,
      sprites: [
        AceSprite(asset: _shenTete, animatedAsset: _shenTeteAnim, position: SpritePosition.right)
      ],
      kind: BeatKind.thought,
      text:
          'Total potentiel sur six mois : six mille.\n'
          'Manque réel : douze mille.\n'
          'Marge d\'erreur : zéro.',
    ),

    // ─── La banque ─────────────────────────────────────────────────
    AceBeat(
      background: _bgCalculs,
      sprites: [
        AceSprite(asset: _shenCalcule, animatedAsset: _shenCalculeAnim, position: SpritePosition.left)
      ],
      kind: BeatKind.narration,
      sfx: BeatSfx.ring,
      text: 'Le téléphone vibre. La banque a répondu.',
    ),
    AceBeat(
      background: _bgCalculs,
      sprites: [
        AceSprite(asset: _shenCalcule, animatedAsset: _shenCalculeAnim, position: SpritePosition.left)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'La banque',
      text:
          '« Mademoiselle Marchand, suite à l\'étude de votre dossier, '
          'votre demande de crédit personnel est refusée. Pas de garant '
          'éligible. Revenus jugés insuffisants. Cordialement. »',
    ),
    AceBeat(
      background: _bgCalculs,
      sprites: [
        AceSprite(asset: _shenCalcule, animatedAsset: _shenCalculeAnim, position: SpritePosition.left)
      ],
      kind: BeatKind.thought,
      text: 'Une porte. Fermée.',
    ),

    // ─── L'aide sociale ────────────────────────────────────────────
    AceBeat(
      background: _bgCalculs,
      sprites: [
        AceSprite(asset: _shenTelAide, animatedAsset: _shenTelAideAnim, position: SpritePosition.right)
      ],
      kind: BeatKind.narration,
      text:
          'Aide sociale, deuxième tentative. Musique d\'attente. Vivaldi, '
          'en sourdine — toujours Vivaldi, comme si l\'État rappelait à '
          'chacun qu\'il est plus vieux que lui.',
    ),
    AceBeat(
      background: _bgCalculs,
      sprites: [
        AceSprite(asset: _shenTelAide, animatedAsset: _shenTelAideAnim, position: SpritePosition.right)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Aide sociale',
      text:
          '« Six mois minimum pour instruire un dossier, mademoiselle. '
          'Vous pouvez prendre rendez-vous. »',
    ),
    AceBeat(
      background: _bgCalculs,
      sprites: [
        AceSprite(asset: _shenTete, animatedAsset: _shenTeteAnim, position: SpritePosition.center)
      ],
      kind: BeatKind.thought,
      text:
          'Six mois.\n'
          'Maman a six semaines.\n'
          'Deux portes. Fermées.',
    ),

    // ─── La carte revient ──────────────────────────────────────────
    AceBeat(
      background: _bgStudioNuit,
      sprites: [
        AceSprite(asset: _shenRecolle, animatedAsset: _shenRecolleAnim, position: SpritePosition.center)
      ],
      kind: BeatKind.narration,
      ambient: BeatAmbient.rain,
      text:
          'La pluie ne s\'arrête pas. Shen ouvre le tiroir de la table. '
          'Les quatre morceaux sont là, alignés depuis avant-hier soir. '
          'À côté, un rouleau de scotch transparent. Il attend.',
    ),
    AceBeat(
      background: _bgStudioNuit,
      sprites: [
        AceSprite(asset: _shenRecolle, animatedAsset: _shenRecolleAnim, position: SpritePosition.center)
      ],
      kind: BeatKind.narration,
      text:
          'Plus tard, Shen ne saura pas dire à quel moment elle a décidé. '
          'Le scotch jaunit légèrement le bristol. Le « T » de Tristan '
          'refuse de se réaligner. Elle recommence deux fois.',
    ),
    AceBeat(
      background: _bgStudioNuit,
      sprites: [
        AceSprite(asset: _shenRecolle, animatedAsset: _shenRecolleAnim, position: SpritePosition.center)
      ],
      kind: BeatKind.thought,
      text:
          'Le numéro est lisible.\n'
          'C\'est ridicule.\n'
          'Le numéro est lisible.',
    ),
    AceBeat(
      background: _bgStudioNuit,
      kind: BeatKind.titleCard,
      text:
          '23h58. Studio.\n'
          'Pas de solution.\n'
          'Pas encore.',
    ),
  ],
);
