import '../models/ace_scene.dart';

/// Scénario J1 → J3 en mode BD-animée, version cinéma.
///
/// **Style** :
/// - Narration en 3e personne, présent narratif, sensorielle. Descriptions
///   filmiques ("Le bitume monte autant qu'il tombe", "Le sac s'éventre
///   comme un fruit trop mûr"). Phrases pleines, plus longues que le
///   carnet — c'est le contrat de l'ACE.
/// - Pensées en 1re personne, rares et percutantes. "Quelqu'un a appuyé
///   sur pause à l'intérieur de moi." Voix de Shen préservée pour les
///   pics émotionnels.
/// - Quelques voix off omniscientes ("Plus tard, elle ne saurait pas
///   dire quand elle a ramassé les morceaux.") pour le suspense.
/// - Dialogues longs, frontaux, drama coréen.

const String _bgStudioMatin = 'assets/photos/ace/bg_j1_studio_matin.jpeg';
const String _bgStudioNuit = 'assets/photos/ace/bg_j1_studio_nuit.jpeg';
const String _bgRueBelleville = 'assets/photos/ace/bg_j1_rue_belleville.png';
const String _bgCollision = 'assets/photos/ace/bg_j1_avenue_collision.jpeg';
const String _bgAvenuePropre = 'assets/photos/ace/bg_j1_avenue_propre.png';
const String _bgBureauAubin = 'assets/photos/ace/bg_j2_bureau_aubin.png';
const String _bgCalculs = 'assets/photos/ace/bg_j3_calculs.png';

// Sprites Shen livreuse
const String _shenPretePartir =
    'assets/photos/ace/shen_livreuse_01_prete_a_partir.png';
const String _shenFeuRouge =
    'assets/photos/ace/shen_livreuse_02_au_feu_rouge.png';
const String _shenDouleur =
    'assets/photos/ace/shen_livreuse_03_douleur_collision.png';
const String _shenRelevee =
    'assets/photos/ace/shen_livreuse_04_releve_la_tete.png';
const String _shenDechireCarte =
    'assets/photos/ace/shen_livreuse_05_dechire_la_carte.png';
const String _shenMarcheMouillee =
    'assets/photos/ace/shen_livreuse_06_marche_mouillee.png';

// Sprites Shen studio
const String _shenEcrit = 'assets/photos/ace/shen_studio_01_ecrit_carnet.png';
const String _shenRecolle =
    'assets/photos/ace/shen_studio_02_recolle_la_carte.png';
const String _shenCalcule =
    'assets/photos/ace/shen_studio_03_calcule_prostree.png';
const String _shenTelAide =
    'assets/photos/ace/shen_studio_04_telephone_aide_sociale.png';
const String _shenTete =
    'assets/photos/ace/shen_studio_06_se_tient_la_tete.png';

// Sprites Tristan anonyme
const String _tJambes = 'assets/photos/ace/tristan_01_jambes_chaussures.png';
const String _tMainCarte = 'assets/photos/ace/tristan_02_main_carte.png';
const String _tDosSeloigne = 'assets/photos/ace/tristan_05_dos_seloigne.png';

final AceScene aceJ1 = AceScene(
  day: 1,
  title: 'La carte qui ne dit pas son nom',
  location: 'J1 → J3 · Belleville · 8ᵉ · Tenon',
  time: '03 → 05 juin 2026',
  beats: [
    // ═══════════════════════════════════════════════════════════════════
    // PROLOGUE : « Avant »
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
          'Belleville, 20ᵉ arrondissement.\n'
          'Pluie de juin.\n'
          'Sept heures du matin.',
    ),
    AceBeat(
      background: _bgStudioMatin,
      kind: BeatKind.titleCard,
      ambient: BeatAmbient.none,
      text:
          'SHEN MARCHAND, 24 ans.\n'
          'Études d\'architecture à mi-temps.\n'
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
          'Trois jours. Trois portes qui se ferment.\n'
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
      sprites: [AceSprite(asset: _shenEcrit, position: SpritePosition.left)],
      kind: BeatKind.narration,
      text:
          'La pluie tape la fenêtre du studio comme un visiteur insistant. '
          'Shen écrit. Bic vert — elle n\'a pas trouvé le noir.',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [AceSprite(asset: _shenEcrit, position: SpritePosition.left)],
      kind: BeatKind.thought,
      text:
          'Camille m\'a dit que si je n\'écris pas, je vais oublier de '
          'vivre. Je n\'écris pas pour me souvenir. J\'écris pour ne pas '
          'pleurer.',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [AceSprite(asset: _shenEcrit, position: SpritePosition.left)],
      kind: BeatKind.narration,
      text:
          'Sur l\'étagère, une lettre du Fujian dort. Tante Mei écrit en '
          'chinois ; Shen lira ce soir. Si la journée laisse le soir.',
    ),

    // ─── SMS Maman avant départ ────────────────────────────────────
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenPretePartir, position: SpritePosition.center)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Maman',
      text: '« Tu pars livrer dans combien ? »',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenPretePartir, position: SpritePosition.center)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Shen',
      text: '« Dix minutes. Vélo, pluie, le 8ᵉ. »',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenPretePartir, position: SpritePosition.center)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Maman',
      text:
          '« Tes 24 ans tiendront pas la pluie aussi longtemps que tu le '
          'crois. Couvre-toi. Et mange un truc avant de monter sur ce '
          'vélo. »',
    ),

    // ─── Rue Belleville sous la pluie ──────────────────────────────
    AceBeat(
      background: _bgRueBelleville,
      sprites: [
        AceSprite(asset: _shenFeuRouge, position: SpritePosition.left)
      ],
      kind: BeatKind.narration,
      ambient: BeatAmbient.rain,
      text:
          'Belleville se réveille au pas. Le sac fluo de Shen charge trois '
          'bowls vegan et un loyer. Au feu rouge, elle relit le dernier '
          'SMS de Maman.',
    ),
    AceBeat(
      background: _bgRueBelleville,
      sprites: [
        AceSprite(asset: _shenFeuRouge, position: SpritePosition.left)
      ],
      kind: BeatKind.thought,
      text:
          '« Couvre-toi. » Trois syllabes qui essaient de tenir la pluie. '
          'Comme si on pouvait faire passer une chimio avec un châle.',
    ),
    AceBeat(
      background: _bgRueBelleville,
      sprites: [
        AceSprite(asset: _shenFeuRouge, position: SpritePosition.left)
      ],
      kind: BeatKind.narration,
      text:
          'Ce matin-là, Shen pensait que la pluie était son pire ennemi. '
          'Elle se trompait.',
    ),

    // ─── LA COLLISION — Avenue Montaigne 8h17 ──────────────────────
    AceBeat(
      background: _bgCollision,
      kind: BeatKind.narration,
      sfx: BeatSfx.impact,
      text:
          'Avenue Montaigne. 8h17. Le bruit arrive en deux temps. D\'abord '
          'la mécanique d\'un freinage trop tard — un crissement aigu qui '
          'n\'a pas le temps de finir. Puis le métal qui touche le métal, '
          'sourd, qui se cogne dans la poitrine de Shen avant même que '
          'son vélo soit touché.',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenDouleur, position: SpritePosition.left)
      ],
      kind: BeatKind.thought,
      text: 'Quelqu\'un a appuyé sur pause à l\'intérieur de moi.',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenDouleur, position: SpritePosition.left)
      ],
      kind: BeatKind.narration,
      text:
          'Le bitume est plus rapide que la pensée. L\'épaule droite touche '
          'en premier, puis le casque, puis le genou. Le casque tient. Le '
          'genou non. La peau se déchire avec le bruit du papier qu\'on '
          'déchire — un son qu\'on n\'oublie pas.',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenDouleur, position: SpritePosition.left)
      ],
      kind: BeatKind.narration,
      text:
          'Le sac de livraison s\'éventre comme un fruit trop mûr. Le bowl '
          'se renverse en direct ; l\'açaí trace une traînée violette sur '
          'le bitume mouillé. Trente-huit euros que la plateforme va '
          'retenir sur la prochaine paie.',
    ),

    // ─── Le costume sans yeux ──────────────────────────────────────
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenDouleur, position: SpritePosition.left),
        AceSprite(asset: _tJambes, position: SpritePosition.right),
      ],
      kind: BeatKind.narration,
      text:
          'Quand Shen rouvre les yeux, des chaussures cuir. L\'homme qui '
          'sort de la berline porte un costume qui coûte plus que son '
          'loyer annuel. Il regarde sa montre. Il regarde la rue. Il '
          'regarde son rétroviseur. Il regarde tout sauf elle.',
    ),
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenRelevee, position: SpritePosition.left),
        AceSprite(asset: _tJambes, position: SpritePosition.right),
      ],
      kind: BeatKind.narration,
      text:
          'Quand il baisse enfin les yeux, c\'est avec l\'expression de '
          'quelqu\'un qui calcule combien ça va lui coûter.',
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
          '« Ça va aller. Pour le vélo et la consultation. »\n'
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
          '« Votre assurance va payer correctement, comme tout le monde. '
          'Je ne suis pas un pourboire. »',
    ),

    // ─── La carte ──────────────────────────────────────────────────
    AceBeat(
      background: _bgCollision,
      sprites: [
        AceSprite(asset: _shenRelevee, position: SpritePosition.left),
        AceSprite(asset: _tMainCarte, position: SpritePosition.right),
      ],
      kind: BeatKind.narration,
      text:
          'Il lui tend une carte de visite, deux doigts en pince, comme '
          'on tend l\'addition. Bristol crème. Lettrage discret. Trois '
          'lignes que Shen va retenir malgré elle :',
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
          'Shen prend la carte. La regarde. La déchire devant lui — un '
          'coup, deux coups, quatre morceaux. Les bouts tombent dans la '
          'flaque d\'açaí. La pluie s\'en occupe.',
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
            asset: _shenMarcheMouillee, position: SpritePosition.center)
      ],
      kind: BeatKind.thought,
      text:
          '« Heng International — Directeur Europe. » Trois mots que je '
          'ne devrais pas avoir retenus.',
    ),
    AceBeat(
      background: _bgAvenuePropre,
      sprites: [
        AceSprite(
            asset: _shenMarcheMouillee, position: SpritePosition.center)
      ],
      kind: BeatKind.narration,
      text:
          'Shen passe par le 8ᵉ exprès en rentrant. Plus longtemps. Pas '
          'pour y aller. Pour pouvoir y penser. Camille l\'attend ce soir. '
          'Elle va vouloir tout savoir. Shen va devoir choisir ce qu\'elle '
          'raconte.',
    ),

    // ─── Endcap J1 — la carte recollée ─────────────────────────────
    AceBeat(
      background: _bgStudioNuit,
      sprites: [
        AceSprite(asset: _shenRecolle, position: SpritePosition.center)
      ],
      kind: BeatKind.narration,
      ambient: BeatAmbient.rain,
      text:
          '23h42. Studio. La carte est recollée sur l\'étagère — quatre '
          'morceaux, ruban adhésif transparent. Personne — pas même Shen — '
          'ne saurait dire à quel moment elle a ramassé les bouts dans la '
          'flaque.',
    ),
    AceBeat(
      background: _bgStudioNuit,
      sprites: [
        AceSprite(asset: _shenRecolle, position: SpritePosition.center)
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
        AceSprite(asset: _shenCalcule, position: SpritePosition.left)
      ],
      kind: BeatKind.narration,
      text:
          'Le Dr Aubin a un visage que Shen aime bien. Lunettes en écaille. '
          'Le temps qu\'il faut. Il pose son stylo avant de parler. Il ne '
          'lit pas une fiche. Il réfléchit.',
    ),
    AceBeat(
      background: _bgBureauAubin,
      sprites: [
        AceSprite(asset: _shenCalcule, position: SpritePosition.left)
      ],
      kind: BeatKind.thought,
      text:
          'Quand un médecin veut te parler en privé à 6h30 du matin, c\'est '
          'jamais pour te dire que ça va.',
    ),
    AceBeat(
      background: _bgBureauAubin,
      sprites: [
        AceSprite(asset: _shenCalcule, position: SpritePosition.left)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Dr Aubin',
      text:
          '« Mademoiselle Marchand. Votre mère a besoin d\'un traitement '
          'de seconde ligne. Un protocole hors AMM. Donc non remboursé. »',
    ),
    AceBeat(
      background: _bgBureauAubin,
      sprites: [
        AceSprite(asset: _shenCalcule, position: SpritePosition.left)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Shen',
      text: '« Combien ? »',
    ),
    AceBeat(
      background: _bgBureauAubin,
      sprites: [
        AceSprite(asset: _shenCalcule, position: SpritePosition.left)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Dr Aubin',
      text:
          '« Dix-huit mille euros sur six mois. Et je dois insister sur '
          'un point — il faut commencer dans les six semaines, pas plus. '
          'Au-delà, la fenêtre se ferme. »',
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
        AceSprite(asset: _shenCalcule, position: SpritePosition.center)
      ],
      kind: BeatKind.narration,
      text:
          'Hall d\'accueil, 6h48. Eau de Javel et café froid. Shen s\'assoit '
          'sur un banc et calcule. Trois fois. Trois fois la même réponse.',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenCalcule, position: SpritePosition.center)
      ],
      kind: BeatKind.thought,
      text:
          'Sur mon compte courant : 2 384 €. C\'est déjà un miracle de fin '
          'de mois.',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenTete, position: SpritePosition.right)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'L\'infirmière',
      text: '« Vous êtes la fille de Madame Marchand. »',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenTete, position: SpritePosition.right)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'L\'infirmière',
      text:
          '« Elle est ici depuis trois ans. Je la connais bien. Elle ne dit '
          'jamais ce qu\'elle a vraiment, vous savez. Pas même au médecin. '
          'Faites attention à ce qu\'elle vous dit. »',
    ),
    AceBeat(
      background: _bgStudioMatin,
      sprites: [
        AceSprite(asset: _shenTete, position: SpritePosition.center)
      ],
      kind: BeatKind.thought,
      text: 'Maman ne dit pas tout. Maman ne dit pas tout.',
    ),
    AceBeat(
      background: _bgRueBelleville,
      kind: BeatKind.narration,
      ambient: BeatAmbient.rain,
      text:
          '07h24. Métro Couronnes. Shen rentre. Compteur : J42. '
          'Quarante-deux jours pour trouver dix-huit mille euros que '
          'personne ne va lui prêter.',
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
        AceSprite(asset: _shenCalcule, position: SpritePosition.left)
      ],
      kind: BeatKind.narration,
      text:
          'Sur la table de la cuisine, trois feuilles. Trois colonnes : '
          'argent disponible, manque, temps restant. Shen écrit, raye, '
          'recompte. Le chiffre du manque refuse de tenir dans la case ; '
          'elle l\'écrit deux fois, plus petit, pour voir s\'il rétrécit.',
    ),
    AceBeat(
      background: _bgCalculs,
      sprites: [
        AceSprite(asset: _shenCalcule, position: SpritePosition.left)
      ],
      kind: BeatKind.narration,
      text:
          'Doubler les livraisons : +400 € par mois. Troisième service de '
          'nuit : +600 €, mais elle ne dormirait plus. Vendre le piano de '
          'Maman : hors de question.',
    ),
    AceBeat(
      background: _bgCalculs,
      sprites: [
        AceSprite(asset: _shenTete, position: SpritePosition.right)
      ],
      kind: BeatKind.thought,
      text: 'Total potentiel sur six mois : 6 000 €. Manque : 12 000 €.',
    ),

    // ─── La banque ─────────────────────────────────────────────────
    AceBeat(
      background: _bgCalculs,
      sprites: [
        AceSprite(asset: _shenCalcule, position: SpritePosition.left)
      ],
      kind: BeatKind.narration,
      sfx: BeatSfx.ring,
      text: 'Un SMS vibre. La banque a répondu.',
    ),
    AceBeat(
      background: _bgCalculs,
      sprites: [
        AceSprite(asset: _shenCalcule, position: SpritePosition.left)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'La banque',
      text:
          '« Mademoiselle Marchand, suite à l\'étude de votre dossier, '
          'votre demande de crédit personnel est refusée. Vous n\'avez '
          'pas de garant éligible et vos revenus sont jugés insuffisants. '
          'Cordialement. »',
    ),

    // ─── L'aide sociale ────────────────────────────────────────────
    AceBeat(
      background: _bgCalculs,
      sprites: [
        AceSprite(asset: _shenTelAide, position: SpritePosition.right)
      ],
      kind: BeatKind.narration,
      text:
          'Aide sociale, deuxième tentative. Musique d\'attente. Vivaldi '
          'en sourdine — toujours Vivaldi. Comme si l\'État voulait te '
          'rappeler qu\'il est vieux.',
    ),
    AceBeat(
      background: _bgCalculs,
      sprites: [
        AceSprite(asset: _shenTelAide, position: SpritePosition.right)
      ],
      kind: BeatKind.dialogue,
      speakerLabel: 'Aide sociale',
      text:
          '« Six mois minimum pour un dossier, mademoiselle. Vous pouvez '
          'prendre rendez-vous. »',
    ),
    AceBeat(
      background: _bgCalculs,
      sprites: [
        AceSprite(asset: _shenTete, position: SpritePosition.center)
      ],
      kind: BeatKind.thought,
      text: 'Six mois.\nMaman a six semaines.',
    ),

    // ─── La carte revient ──────────────────────────────────────────
    AceBeat(
      background: _bgStudioNuit,
      sprites: [
        AceSprite(asset: _shenRecolle, position: SpritePosition.center)
      ],
      kind: BeatKind.narration,
      ambient: BeatAmbient.rain,
      text:
          'La pluie n\'arrête pas. Shen ouvre le tiroir de la table. La '
          'carte de Tristan Heng est là — en quatre morceaux, ramenée de '
          'la flaque avant-hier soir. Le scotch transparent attend, posé '
          'à côté.',
    ),
    AceBeat(
      background: _bgStudioNuit,
      sprites: [
        AceSprite(asset: _shenRecolle, position: SpritePosition.center)
      ],
      kind: BeatKind.narration,
      text:
          'Plus tard, Shen ne saura pas dire à quel moment elle a décidé. '
          'Le scotch a légèrement jauni le bristol. Le « T » de Tristan a '
          'refusé de se réaligner ; elle a recommencé deux fois.',
    ),
    AceBeat(
      background: _bgStudioNuit,
      sprites: [
        AceSprite(asset: _shenRecolle, position: SpritePosition.center)
      ],
      kind: BeatKind.thought,
      text:
          'Le numéro est lisible. C\'est ridicule. Le numéro est lisible.',
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
