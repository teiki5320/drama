import 'sms_choices.dart';

/// Les 5 épilogues canoniques de Drama. Sélectionnés à J112 selon
/// l'état final (suspicion Maman, balance Banque, choix Shen sur les
/// beats-clés Ep 2-5).
///
/// Chaque épilogue = un titre, un texte long (3-5 paragraphes) en
/// voix Shen, et une coda finale.

class Epilogue {
  final String id;
  final String title;
  final String subtitle;
  final String body;
  final String coda;
  /// Identifiant de la teinte dominante (palette).
  final int colorHex;
  final String emoji;

  const Epilogue({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.body,
    required this.coda,
    required this.colorHex,
    required this.emoji,
  });
}

const kEpilogues = <Epilogue>[
  // ── ÉPILOGUE 1 : Le parc, ma fille ──────────────────────────
  Epilogue(
    id: 'parc_ma_fille',
    title: 'Le parc, ma fille',
    subtitle: 'Fujian, J112 · 17h',
    body:
        'Le bus pour Xiamen passe à 11h, l\'avion pour Paris décolle à 17h.\n\n'
        'Je laisse passer les deux.\n\n'
        'Maman est assise sur le banc qu\'elle me montre depuis trois jours. '
        'Elle me dit : « C\'est ici que ton père m\'a dit qu\'il partait. '
        'Il pensait revenir. »\n\n'
        'Je n\'ai pas besoin de répondre. Tante Mei marche cent mètres devant '
        'nous avec un panier d\'oranges. Elle se retourne et me dit '
        '« ma fille » sans hausser la voix.\n\n'
        'Je reste. Je sais que je reste pour le temps qu\'il faut. Pas plus. '
        'Je n\'ai pas tout choisi. J\'ai choisi cet endroit aujourd\'hui.',
    coda: '(Le téléphone vibre dans ma poche. Je ne regarde pas.)',
    colorHex: 0xFF8AA070,
    emoji: '🍃',
  ),

  // ── ÉPILOGUE 2 : Rue de Berri, encore ───────────────────────
  Epilogue(
    id: 'berri_encore',
    title: 'Rue de Berri, encore',
    subtitle: 'Paris, J112 · 22h',
    body:
        'L\'avion atterrit à 17h. Tristan vient me chercher en personne.\n\n'
        'Il ne dit rien. Il me prend le sac. Dans la voiture il me dit : '
        '« J\'ai prolongé. Le contrat. Trois mois encore. Ma mère a insisté. »\n\n'
        'Je dis oui sans réfléchir. C\'est devenu un réflexe.\n\n'
        'Maman dort à Belleville. Le traitement marche. Je suis riche. Je suis '
        'à la fenêtre du 7e étage, rue de Berri. Je regarde la rue. '
        'Je ne sens plus rien.\n\n'
        'Camille m\'a envoyé un message : « Tu rentres ou tu rentres ? » '
        'Je n\'ai pas répondu.',
    coda: '(Le piano se tait. La femme à droite de Madame Heng est devenue elle.)',
    colorHex: 0xFF1F2937,
    emoji: '🪞',
  ),

  // ── ÉPILOGUE 3 : Belleville, en deuil ───────────────────────
  Epilogue(
    id: 'belleville_deuil',
    title: 'Belleville, en deuil',
    subtitle: 'Paris, J112 · 14h',
    body:
        'Le traitement n\'a pas suffi. L\'argent n\'était pas là à temps, le corps n\'a pas tenu.\n\n'
        'L\'enterrement était hier au Père-Lachaise. Tante Mei a fait le voyage. '
        'Camille a porté le voile noir comme une sœur. Tristan n\'est pas venu — '
        'je ne lui ai pas écrit pour le prévenir.\n\n'
        'Je suis revenue dans le studio de Belleville. Le frigo est encore plein '
        'des choses qu\'elle préparait pour le jour où je passerais.\n\n'
        'J\'ai jeté la carte de Tristan. Pour la deuxième fois. Cette fois je n\'ai '
        'pas recollé.\n\n'
        'Je vais reprendre les livraisons. Lundi. Pour le compteur, qui ne s\'arrête pas.',
    coda: '(« Maman a toussé cette nuit. » C\'était ma première phrase. Aujourd\'hui je l\'écris pour la dernière.)',
    colorHex: 0xFFFCE6D8,
    emoji: '🌧️',
  ),

  // ── ÉPILOGUE 4 : Hong Kong, la promesse ─────────────────────
  Epilogue(
    id: 'hk_promesse',
    title: 'Hong Kong, la promesse',
    subtitle: 'Repulse Bay, J112 · 19h',
    body:
        'Je ne suis pas rentrée à Paris. Je n\'ai pas non plus suivi Maman à Fujian.\n\n'
        'Je vis dans un appartement de Repulse Bay. Tristan vient '
        'le week-end. Vincent a accepté de gérer le family office sans moi.\n\n'
        'Maman m\'a écrit hier : « Ton père aurait été fier de toi. Ou furieux. '
        'C\'est la même chose chez nous. »\n\n'
        'J\'apprends le cantonais. Mal. J\'apprends les Heng. Mieux. Madame Heng '
        'm\'écrit deux fois par mois. Elle ne dit plus « ma fille ». Elle dit '
        '« ma belle-fille ». C\'est plus formel et c\'est mieux.\n\n'
        'Camille refuse de venir me voir. « Ta place n\'est pas là. » Je sais.',
    coda: '(La baie. Le silence. Pas le mien.)',
    colorHex: 0xFFD7DEE5,
    emoji: '🏙️',
  ),

  // ── ÉPILOGUE 5 : Camille, la troisième voie ─────────────────
  Epilogue(
    id: 'camille_troisieme',
    title: 'Camille, la troisième voie',
    subtitle: 'Paris, J112 · 11h',
    body:
        'J\'ai quitté la rue de Berri à J52. Tristan ne m\'a pas retenue.\n\n'
        'Je vis chez Camille depuis deux mois. Maman est en stabilisation à '
        'Tenon, elle vient déjeuner les dimanches. Elle ne me demande plus rien.\n\n'
        'J\'ai repris le master archi à distance, je passe mon HMONP en juin. '
        'Sarah m\'a transmis trois missions freelance qui paient le loyer. '
        'Pas plus.\n\n'
        'Je n\'ai pas remboursé les Heng. Vincent dit que le contrat couvrait — '
        'que l\'argent était à moi. Je ne suis pas sûre. Je garde l\'enveloppe '
        'au cas où.\n\n'
        'Mathieu B. m\'a écrit la semaine dernière. Il rentre de Tokyo pour de bon.',
    coda: '(Camille a dit « je le savais ». Elle ne savait rien. C\'est ce qui m\'a sauvée.)',
    colorHex: 0xFFFCE6D8,
    emoji: '🥐',
  ),
];

/// Sélectionne l'épilogue selon l'état final.
/// Heuristique :
///  - balance < 18000 ou Maman morte → belleville_deuil
///  - balance >= 18000 et reste avec Tristan (berri_choice) → berri_encore
///  - choix HK J95+ → hk_promesse
///  - choix Fujian J88+ → parc_ma_fille
///  - choix Camille J52 → camille_troisieme
/// Par défaut : parc_ma_fille (ouverture neutre).
Epilogue selectEpilogue({
  required int finalBalance,
  required bool stayedWithTristan,
  required bool wentToHK,
  required bool wentToFujian,
  required bool atCamille,
}) {
  if (finalBalance < 18000) return kEpilogues[2]; // deuil
  if (atCamille) return kEpilogues[4]; // camille
  if (wentToHK) return kEpilogues[3]; // hk
  if (wentToFujian) return kEpilogues[0]; // parc
  if (stayedWithTristan) return kEpilogues[1]; // berri
  return kEpilogues[0]; // par défaut
}

/// Dérive les drapeaux d'épilogue depuis les réponses réellement envoyées
/// (beatId → texte de la réponse), puis délègue à [selectEpilogue].
///
/// Règles :
///  - le solde final < 18 000 € écrase tout (deuil) — géré par selectEpilogue ;
///  - `epilogue_j112` (SMS final de Camille) porte la destination :
///    rester au Fujian / rentrer à Paris / partir à Hong Kong ;
///  - rentrer à Paris mène chez Camille si Shen a quitté la rue de Berri à
///    J52 (`tristan_fin_contrat_j52`), sinon chez Tristan (berri_encore) ;
///  - sans réponse à J112 (sécurité), la réponse de J95 à Tristan sert de
///    repli pour Hong Kong ; à défaut le `mood` final départage : un mood
///    bas retombe dans l'inertie de la cage dorée (berri_encore), un mood
///    correct laisse l'ouverture du parc (parc_ma_fille).
Epilogue resolveEpilogue({
  required int finalBalance,
  required Map<String, String> repliesByBeat,
  int mood = 5,
}) {
  final j52 = repliesByBeat['tristan_fin_contrat_j52'] ?? '';
  final j95 = repliesByBeat['tristan_revient_j95'] ?? '';
  final j112 = repliesByBeat['epilogue_j112'] ?? '';

  final leftAtJ52 = j52 == kReplyJ52LeaveToCamille;
  final choseParis = j112 == kReplyJ112Paris;
  final choseHK = j112 == kReplyJ112HongKong ||
      (j112.isEmpty && j95 == kReplyJ95HongKong);
  final choseFujian = j112 == kReplyJ112Fujian;
  // Aucun choix explicite (save incomplète) : le mood tranche.
  final noExplicit = !choseParis && !choseHK && !choseFujian;
  final inertie = noExplicit && mood < 5 && !leftAtJ52;

  return selectEpilogue(
    finalBalance: finalBalance,
    stayedWithTristan: (choseParis && !leftAtJ52) || inertie,
    wentToHK: choseHK,
    wentToFujian: choseFujian,
    atCamille: choseParis && leftAtJ52,
  );
}
