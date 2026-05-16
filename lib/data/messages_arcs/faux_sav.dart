import '../../models/messages_arc.dart';

/// FAUX SAV APPLE — arnaque
/// Numéro "+33 1 84..." se faisant passer pour Apple, prétend iCloud
/// compromis, demande infos. Arc 2 jours, possibilité Shen de tomber
/// dans le piège (impact bancaire) ou bloque.

const fauxSavContact = MessagesArcContact(
  id: 'arc_faux_sav',
  displayName: '+33 1 84 88 23 41',
  emoji: '⚠️',
  avatarTint: '#E5E5E5',
  subtitle: 'Numéro inconnu',
  gradient: [0xFF707080, 0xFF2E2E36],
  isUnknown: true,
);

const fauxSavBeats = <MessagesArcBeat>[
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 4,
    type: MessagesArcBeatType.text,
    textVariants: [
      'APPLE INFO — Votre compte iCloud a été identifié comme '
          'compromis. Connectez-vous à appleid-secure.fr pour '
          'régulariser sous 24h. STOP au 38242.',
      'APPLE SAV — Tentative d\'accès non autorisée à votre Apple ID. '
          'Vérifiez maintenant : apple-id.fr/securite',
      'INFO SECURITE APPLE — 3 connexions suspectes depuis Hong Kong. '
          'Sécurisez votre compte : apple-secure-fr.com',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 6,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    choices: [
      MessagesArcChoice(
        label: 'Bloquer + signaler',
        reply: '',
        moodDelta: 1,
        endsArc: 'shen_block_sav',
      ),
      MessagesArcChoice(
        label: 'Curieuse',
        reply: 'Quel numéro de compte concerné ?',
        setBranch: 'shen_curieuse_sav',
      ),
      MessagesArcChoice(
        label: 'Cliquer',
        reply: '(elle ouvre le lien)',
        moodDelta: -2,
        setBranch: 'shen_clique_sav',
      ),
    ],
  ),
  // ── J+0 : Si curieuse, ils escaladent
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_curieuse_sav',
    textVariants: [
      'Compte ID Apple terminant par les 4 derniers chiffres de votre '
          'numéro de téléphone. Confirmez en cliquant : apple-id.fr/X',
      'Apple ID enregistré au nom de "marchand". Veuillez fournir le code '
          'à 6 chiffres reçu par SMS pour confirmer.',
      'Votre compte sera désactivé dans 47 minutes. Sécurisez : appleid-x.com',
    ],
  ),
  MessagesArcBeat(
    dayOffset: 0,
    atHour: 0,
    atMinute: 18,
    type: MessagesArcBeatType.choice,
    fromThem: false,
    requireBranch: 'shen_curieuse_sav',
    choices: [
      MessagesArcChoice(
        label: 'Bloquer + signaler',
        reply: '',
        moodDelta: 1,
        endsArc: 'shen_block_sav_late',
      ),
      MessagesArcChoice(
        label: 'Donner code',
        reply: '(Shen envoie un code à 6 chiffres)',
        moodDelta: -2,
        setBranch: 'shen_donne_code',
      ),
    ],
  ),
  // ── J+1 : Si Shen a donné code = catastrophe
  MessagesArcBeat(
    dayOffset: 1,
    atHour: 6,
    atMinute: 24,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_donne_code',
    textVariants: [
      'Merci. Votre compte est sécurisé.\n\n'
          '— BANQUE INFO : Prélèvement Apple Services 287.50 € — '
          'compte clôturé pour insuffisance.',
      'Compte vérifié. Bonne journée.\n\n'
          '— ALERTE BNP : tentative de paiement à 320 € sur AliExpress '
          'refusée. Vérifiez votre application.',
    ],
    endsArc: 'shen_arnaquee',
  ),
  // ── J+1 : Si Shen a cliqué sans donner code, l'arnaque s'éteint
  MessagesArcBeat(
    dayOffset: 1,
    atHour: 9,
    atMinute: 14,
    type: MessagesArcBeatType.text,
    requireBranch: 'shen_clique_sav',
    textVariants: [
      'Votre session a expiré. Reconnectez-vous : appleid-secure.fr',
      'Tentative d\'accès non autorisée toujours active. Sécurisez sous 12h.',
    ],
    endsArc: 'shen_sauve_de_justesse',
  ),
];

const fauxSavTemplate = MessagesArcTemplate(
  id: 'faux_sav_apple',
  label: 'Faux SAV Apple',
  category: MessagesArcCategory.arnaque,
  contact: fauxSavContact,
  beats: fauxSavBeats,
  minStartDay: 1,
  spawnWeight: 0.5,
  cooldownDays: 35,
  description: 'Arnaque SMS Apple. Bloquer / cliquer / donner code. '
      'Si Shen donne le code = catastrophe bancaire.',
);
