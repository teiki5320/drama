import 'models.dart';
import 'engine.dart';

/// Jour 2 — jeudi 16 juillet : Tenon. Le diagnostic, le devis, la carte recollée.
Future<void> runDay2(GameEngine e) async {
  // — 06:30, Maman —
  e.setClock('06:30');
  e.separator('maman', 'Jeudi 16 juillet · 06:30');
  await e.incoming('maman', 'Debout ma fille. On dit 8h30, on arrive 8h.',
      typing: 1500);
  await e.incoming('maman',
      'Mets quelque chose de chaud. Les hôpitaux sont des glacières.',
      typing: 1600);
  var c = await e.choice('maman', const [
    ChoiceOption('Je passe te prendre à 7h30.', reply: 'Je serai en bas.'),
    ChoiceOption('Tu as dormi, toi ?', reply: 'Un peu. Assez.'),
    ChoiceOption('On va y arriver, Maman.', reply: 'Bien sûr. On est deux.'),
  ]);
  await e.sleep(700);
  e.markRead('maman');
  await e.incoming('maman', c.reply!, typing: 1300);
  await e.sleep(1500);

  // — 07:15, Camille —
  e.setClock('07:15');
  e.separator('camille', 'Jeudi 16 juillet · 07:15');
  await e.incoming('camille',
      'Pensée pour vous deux. Tu m’écris dès que tu sors. Promis ?',
      typing: 1500);
  c = await e.choice('camille', const [
    ChoiceOption('Promis.'),
    ChoiceOption('C’est juste un contrôle, Camille.'),
  ]);
  await e.sleep(600);
  e.markRead('camille');
  e.outgoing('camille', 'En route. Métro Couronnes, pluie comprise.');
  await e.sleep(800);
  await e.incoming('camille', 'Courage. Je suis là, quoi qu’il sorte de ce rendez-vous.',
      typing: 1500);
  await e.sleep(1800);

  // — 09:58, Dr Aubin —
  e.setClock('09:58');
  e.separator('aubin', 'Jeudi 16 juillet · 09:58');
  await e.incoming(
      'aubin',
      'Bonjour Mademoiselle Marchand. Dr Aubin, oncologie. Vous êtes en salle 2 '
      'avec votre mère — je vous écris ici pour la suite : passez me voir seule '
      'avant de partir. Cabinet 214.',
      typing: 2200);
  c = await e.choice('aubin', const [
    ChoiceOption('J’arrive.', reply: 'Je vous attends.'),
    ChoiceOption('Pourquoi seule, docteur ?',
        reply:
            'Parce que certaines choses se disent d’abord à celles qui portent. '
            'Cabinet 214.'),
  ]);
  await e.sleep(800);
  e.markRead('aubin');
  await e.incoming('aubin', c.reply!, typing: 1500);
  await e.sleep(2200);

  // — 12:40, Camille (le verdict) —
  e.setClock('12:40');
  await e.incoming('camille', 'Alors ?? Dis-moi.', typing: 1200);
  c = await e.choice('camille', const [
    ChoiceOption('C’est une tumeur, Camille. Opérable. Mais il y a un « mais ».',
        key: 'dire'),
    ChoiceOption('Pas par écrit. Ce soir.', key: 'soir'),
  ]);
  await e.sleep(900);
  e.markRead('camille');
  if (c.key == 'dire') {
    await e.incoming('camille', 'Je m’assois. Vas-y.', typing: 1200);
    e.outgoing('camille',
        'Le protocole que recommande Aubin n’est pas remboursé. Dix-huit mille euros.');
    await e.sleep(1000);
    await e.incoming('camille', 'Dix-huit. Mille.', typing: 1400);
    await e.incoming('camille',
        'OK. On respire. On liste. On trouve. Ce soir, chez moi, avec un carnet.',
        typing: 1900);
  } else {
    await e.incoming('camille',
        'OK. Ce soir, chez moi. Je cuisine, tu parles. Et tu ne portes pas ça seule.',
        typing: 1900);
  }
  await e.sleep(1800);

  // — 14:20, Dr Aubin (le devis) —
  e.setClock('14:20');
  await e.incoming(
      'aubin',
      'Comme convenu, par écrit : le protocole recommandé est hors nomenclature. '
      'Devis : 18 240 €. Pour tenir le calendrier, le dossier doit être validé '
      'avant le 30. Je sais que c’est brutal. Écrivez-moi si besoin.',
      typing: 2600);
  c = await e.choice('aubin', const [
    ChoiceOption('Avant le 30. Compris.', reply: 'Chaque jour compte. Bon courage.'),
    ChoiceOption('Et si je n’y arrive pas à temps ?',
        reply:
            'Alors on repousse d’un mois, et un mois n’est pas neutre. '
            'Concentrons-nous sur le calendrier.'),
  ]);
  await e.sleep(900);
  e.markRead('aubin');
  await e.incoming('aubin', c.reply!, typing: 1700);
  await e.sleep(2000);

  // — 21:40, Maman —
  e.setClock('21:40');
  await e.incoming('maman',
      'Merci d’être venue aujourd’hui. Le Dr Aubin dit que je suis solide.',
      typing: 1800);
  c = await e.choice('maman', const [
    ChoiceOption('Tu es la plus solide.', reply: 'Je tiens ça de personne. Ou de toi.'),
    ChoiceOption('On va se battre, toi et moi.', reply: 'On va surtout dormir. Ça commence par là.'),
    ChoiceOption('Dors. Je m’occupe des papiers.', reply: 'Ne porte pas tout seule, ma fille.'),
  ]);
  await e.sleep(800);
  e.markRead('maman');
  await e.incoming('maman', c.reply!, typing: 1500);
  await e.incoming('maman', 'Et pour le traitement… c’est cher ?', typing: 1700);
  c = await e.choice('maman', const [
    ChoiceOption('C’est pris en charge, Maman. T’occupe de rien.', key: 'mensonge',
        reply: 'Tant mieux. Alors je n’ai plus qu’à guérir.'),
    ChoiceOption('On regardera les papiers ensemble.', key: 'verite',
        reply: 'D’accord. Mais pas ce soir. Ce soir on dort.'),
  ]);
  await e.sleep(900);
  e.markRead('maman');
  await e.incoming('maman', c.reply!, typing: 1500);
  await e.sleep(2000);

  // — 23:42, Camille (la carte) —
  e.setClock('23:42');
  e.outgoingImage('camille', 'assets/photos/ep1/j01_23h42_carte_recollee.webp');
  e.outgoing('camille', 'Tu avais raison. Je l’ai recollée. Au cas où.');
  await e.sleep(1200);
  e.markRead('camille');
  await e.incoming('camille',
      'Garde-la. On ne sait jamais quel morceau de fierté on devra avaler.',
      typing: 1800);
  await e.sleep(1500);
}

/// Jour 3 — vendredi 17 juillet : le refus de la banque, les trois colonnes.
Future<void> runDay3(GameEngine e) async {
  // — 09:14, la banque —
  e.setClock('09:14');
  e.separator('banque', 'Vendredi 17 juillet · 09:14');
  await e.incoming(
      'banque',
      'INFO BNP : votre demande de crédit personnel n°7842 a été REFUSÉE. '
      'Motif : garanties insuffisantes, absence de garant éligible. '
      'Détails sur l’application.',
      typing: 1400);
  await e.sleep(1800);

  // — 10:02, Camille —
  e.setClock('10:02');
  e.separator('camille', '10:02');
  await e.incoming('camille', 'La banque a dit quoi ?', typing: 1100);
  var c = await e.choice('camille', const [
    ChoiceOption('Refus. Pas de garant.', reply: 'Évidemment. Aide sociale ?'),
    ChoiceOption('Devine. Comme d’habitude.', reply: 'OK. Aide sociale ?'),
  ]);
  await e.sleep(700);
  e.markRead('camille');
  await e.incoming('camille', c.reply!, typing: 1100);
  e.outgoing('camille',
      'Six mois d’instruction minimum. Aubin me donne jusqu’au 30.');
  await e.sleep(900);
  await e.incoming('camille', 'Donc.', typing: 900);
  await e.incoming('camille', 'La carte.', typing: 900);
  c = await e.choice('camille', const [
    ChoiceOption('Je ne mendie pas chez les Heng.',
        reply: 'C’est pas mendier si tu rends. C’est emprunter.'),
    ChoiceOption('Et je lui dis quoi ? « Bonjour, votre carte marche encore ? »',
        reply: 'Exactement ça. En mieux formulé. Je peux t’aider.'),
    ChoiceOption('J’y pense. C’est ça le pire.',
        reply: 'C’est pas le pire. Le pire c’est le 30 du mois.'),
  ]);
  await e.sleep(900);
  e.markRead('camille');
  await e.incoming('camille', c.reply!, typing: 1500);
  await e.incoming('camille', 'Réfléchis aujourd’hui. Demain on agit.', typing: 1300);
  await e.sleep(1800);

  // — 12:18, Maman (le quotidien continue) —
  e.setClock('12:18');
  e.separator('maman', '12:18');
  await e.incoming('maman', 'Tu manges ?', typing: 900);
  c = await e.choice('maman', const [
    ChoiceOption('Oui. Un bowl.', reply: 'Pas trop de sel.'),
    ChoiceOption('Oui Maman.', reply: '« Oui Maman. » Un détail, la prochaine fois.'),
  ]);
  await e.sleep(700);
  e.markRead('maman');
  await e.incoming('maman', c.reply!, typing: 1100);
  await e.sleep(1600);

  // — 15:48, les trois colonnes —
  e.setClock('15:48');
  e.outgoing('camille',
      'J’ai fait mes comptes. Trois colonnes : ce que j’ai, ce qu’il faut, '
      'ce qui manque.');
  await e.sleep(900);
  e.outgoing('camille', 'La troisième est la plus longue.');
  await e.sleep(1300);
  e.markRead('camille');
  await e.incoming('camille', 'La colonne 3 a un prénom, Shen.', typing: 1600);
  await e.sleep(1800);

  // — 18:30, Dr Aubin —
  e.setClock('18:30');
  await e.incoming(
      'aubin',
      'Point calendrier : le créneau de bloc se réserve dix jours à l’avance. '
      'Où en êtes-vous ?',
      typing: 1900);
  c = await e.choice('aubin', const [
    ChoiceOption('Je réunis la somme. Tenez le créneau.',
        reply: 'Je le tiens. Tenez le rythme.'),
    ChoiceOption('Presque, docteur.',
        reply: '« Presque » ne réserve pas un bloc. Mais je vous fais confiance.'),
  ]);
  await e.sleep(800);
  e.markRead('aubin');
  await e.incoming('aubin', c.reply!, typing: 1500);
  await e.sleep(1500);
}

/// Jour 4 — samedi 18 juillet : Camille pousse, Shen écrit à Tristan.
Future<void> runDay4(GameEngine e) async {
  // — 10:14, Camille —
  e.setClock('10:14');
  e.separator('camille', 'Samedi 18 juillet · 10:14');
  await e.incomingImage('camille', 'assets/photos/ep1/post_camille_cafe.webp',
      typing: 1900);
  await e.incoming('camille',
      'Debout. Café en bas de chez toi dans vingt minutes. On s’habille comme '
      'quelqu’un qui va gagner.',
      typing: 1800);
  var c = await e.choice('camille', const [
    ChoiceOption('J’arrive.', reply: 'Deux sucres, comme les jours de guerre.'),
    ChoiceOption('Il est 10h un samedi, Camille.',
        reply: 'Et le 30 arrive un jeudi. Debout.'),
  ]);
  await e.sleep(800);
  e.markRead('camille');
  await e.incoming('camille', c.reply!, typing: 1300);
  await e.sleep(1900);

  // — 11:30, le moment —
  e.setClock('11:30');
  await e.incoming('camille', 'Bon. Tu as son numéro depuis jeudi soir dans ton fil.',
      typing: 1500);
  await e.incoming('camille', 'Écris-lui. Maintenant. Je te regarde.', typing: 1300);
  c = await e.choice('camille', const [
    ChoiceOption('OK. Je lui écris.', key: 'seule',
        reply: 'Je suis là. Vas-y.'),
    ChoiceOption('Je peux pas, Camille.', key: 'forcee',
        reply: 'Alors donne-moi ce téléphone.'),
  ]);
  await e.sleep(900);
  e.markRead('camille');
  await e.incoming('camille', c.reply!, typing: 1200);
  await e.sleep(1500);

  // — 11:47, le message à Tristan —
  e.setClock('11:47');
  e.separator('inconnu', 'Samedi 18 juillet · 11:47');
  if (c.key == 'forcee') {
    e.sysline('inconnu', 'Camille a pris ton téléphone.');
    await e.sleep(900);
  }
  e.outgoing('inconnu',
      'Bonjour. Shen Marchand — la cycliste de mercredi. Vous disiez qu’on ne se '
      'quitte pas comme ça. Vous vouliez quoi, exactement ?');
  await e.sleep(2400);
  e.markRead('inconnu');
  await e.incoming('inconnu', 'Vous répondez. Enfin.', typing: 2000);
  await e.incoming('inconnu',
      'Pas par écrit. Lundi, 11h, Tour Heng, 47ᵉ étage. Un badge sera à votre nom.',
      typing: 2200);
  c = await e.choice('inconnu', const [
    ChoiceOption('J’y serai.', reply: 'Bien. Pas de retard.'),
    ChoiceOption('Dites-moi au moins de quoi il s’agit.',
        reply: 'D’un arrangement. Le reste en face.'),
  ]);
  await e.sleep(900);
  e.markRead('inconnu');
  await e.incoming('inconnu', c.reply!, typing: 1500);
  c = await e.choice('inconnu', const [
    ChoiceOption('(enregistrer le contact : Tristan H.)', silent: true, key: 'save'),
    ChoiceOption('(le laisser en « Numéro inconnu »)', silent: true, key: 'anon'),
  ]);
  if (c.key == 'save') {
    e.renameThread('inconnu',
        name: 'Tristan H.',
        headerName: 'Tristan H.',
        avatarAsset: 'assets/photos/avatars/tristan.webp',
        contactKey: 'tristan');
    e.sysline('inconnu', 'Contact enregistré : Tristan H.');
  }
  await e.sleep(1800);

  // — 17:40, Camille (le tailleur) —
  e.setClock('17:40');
  await e.incoming('camille',
      'Je passe ce soir : le tailleur noir de ma mère, et son chemisier blanc. '
      '38. Lundi, tu plaides ta propre cause. Habille-toi comme telle.',
      typing: 2100);
  await e.sleep(1600);
  e.setClock('21:10');
  e.outgoingImage('camille', 'assets/photos/ep1/j06_22h31_tailleur_miroir.webp');
  e.outgoing('camille',
      'Le seul miroir en pied de l’immeuble, c’est l’ascenseur. Verdict ?');
  await e.sleep(1300);
  e.markRead('camille');
  await e.incoming('camille',
      'Verdict : lundi, c’est lui qui sera en difficulté.',
      typing: 1700);
  await e.sleep(1500);

  // — 19:42, Maman —
  e.setClock('21:30');
  e.separator('maman', '21:30');
  await e.incoming('maman', 'Tu viens demain ? Je fais les dumplings.', typing: 1400);
  c = await e.choice('maman', const [
    ChoiceOption('Évidemment.', reply: 'Midi. Pas 14h, ma fille. Midi.'),
    ChoiceOption('Je viens, mais je repars tôt.',
        reply: 'Alors on mangera tôt. Viens.'),
  ]);
  await e.sleep(700);
  e.markRead('maman');
  await e.incoming('maman', c.reply!, typing: 1300);
  await e.sleep(1500);
}

/// Jour 5 — dimanche 19 juillet : les dumplings, la veille d'armes.
Future<void> runDay5(GameEngine e) async {
  // — 11:32, Maman —
  e.setClock('11:32');
  e.separator('maman', 'Dimanche 19 juillet · 11:32');
  await e.incomingImage('maman', 'assets/photos/ep1/pj_maman_plat.webp',
      typing: 2000);
  await e.incoming('maman',
      'Le bouillon d’abord. Les dumplings ensuite — la pâte repose. '
      'Viens avant qu’elle ne m’obéisse plus.',
      typing: 1700);
  var c = await e.choice('maman', const [
    ChoiceOption('J’arrive, garde-m’en.', reply: 'Je ne promets rien.'),
    ChoiceOption('Tu es la seule à faire obéir la pâte.',
        reply: 'La pâte, oui. Ma fille, moins.'),
  ]);
  await e.sleep(800);
  e.markRead('maman');
  await e.incoming('maman', c.reply!, typing: 1300);
  await e.sleep(2200);

  // — 16:48, après le déjeuner —
  e.setClock('16:48');
  await e.incoming('maman',
      'C’était bien de t’avoir aujourd’hui. Tu avais l’air ailleurs.',
      typing: 1800);
  c = await e.choice('maman', const [
    ChoiceOption('Le travail, Maman. Rien de grave.', key: 'mensonge',
        reply: 'Le travail. Bon.'),
    ChoiceOption('J’ai un rendez-vous important demain.', key: 'demi',
        reply: 'Alors dors tôt. On gagne les batailles la veille.'),
    ChoiceOption('J’étais là, avec toi. C’est ce qui compte.', key: 'tendre',
        reply: 'Oui. C’est ce qui compte.'),
  ]);
  await e.sleep(900);
  e.markRead('maman');
  await e.incoming('maman', c.reply!, typing: 1400);
  await e.sleep(2000);

  // — 20:15, Camille —
  e.setClock('20:15');
  e.separator('camille', 'Dimanche 19 juillet · 20:15');
  await e.incoming('camille', 'Prête pour demain ?', typing: 1100);
  await e.incoming('camille', 'Règle n°1 : tu ne signes RIEN lundi. Promets-moi.',
      typing: 1500);
  c = await e.choice('camille', const [
    ChoiceOption('Promis.', reply: 'Menteuse. Bonne nuit ma poule.'),
    ChoiceOption('Ça dépendra du chiffre.', reply: 'SHEN.'),
    ChoiceOption('Je promets d’écouter. C’est déjà ça.',
        reply: 'C’est déjà trop. Bonne nuit quand même.'),
  ]);
  await e.sleep(800);
  e.markRead('camille');
  await e.incoming('camille', c.reply!, typing: 1300);
  await e.sleep(2000);

  // — 22:30, Tristan —
  e.setClock('22:30');
  await e.incoming('inconnu', 'Demain. Ne soyez pas en retard. Ascenseur B, pas le A.',
      typing: 2000);
  c = await e.choice('inconnu', const [
    ChoiceOption('Pourquoi le B ?',
        reply: 'Le A s’arrête au 40ᵉ. Les curieux descendent là.'),
    ChoiceOption('Je ne suis jamais en retard.', reply: 'Nous verrons.'),
  ]);
  await e.sleep(900);
  e.markRead('inconnu');
  await e.incoming('inconnu', c.reply!, typing: 1600);
  await e.sleep(1500);
}

/// Jour 6 — lundi 20 juillet : le 47ᵉ étage, la proposition. Fin d'épisode.
Future<void> runDay6(GameEngine e) async {
  // — 08:40, Maman —
  e.setClock('08:40');
  e.separator('maman', 'Lundi 20 juillet · 08:40');
  await e.incoming('maman',
      'Camille m’a dit que tu voyais quelqu’un pour un travail aujourd’hui. '
      'Bonne chance ma fille.',
      typing: 1900);
  var c = await e.choice('maman', const [
    ChoiceOption('Merci Maman.', reply: 'Tiens-toi droite. Ils regardent ça.'),
    ChoiceOption('Je te raconterai.', reply: 'Je n’en doute pas.'),
  ]);
  await e.sleep(700);
  e.markRead('maman');
  await e.incoming('maman', c.reply!, typing: 1300);
  await e.sleep(1800);

  // — 10:12, devant la tour —
  e.setClock('10:12');
  e.separator('camille', 'Lundi 20 juillet · 10:12');
  e.outgoingImage('camille', 'assets/photos/ep1/j07_11h00_tour_heng_exterieur.webp');
  e.outgoing('camille', 'J’y suis.');
  await e.sleep(1200);
  e.markRead('camille');
  await e.incoming('camille', 'Respire. Tu vaux plus que leur tour entière.',
      typing: 1500);
  await e.incoming('camille', 'Et rappelle-toi : tu ne signes rien.', typing: 1200);
  await e.sleep(2400);

  // — 11:52, la sortie (le rendez-vous a eu lieu hors écran) —
  e.setClock('11:52');
  e.outgoing('camille', 'Je sors. Laisse-moi marcher dix minutes.');
  await e.sleep(1400);
  e.markRead('camille');
  await e.incoming('camille', 'J’attends. Mais pas longtemps.', typing: 1200);
  await e.sleep(2600);

  // — 14:30, Tristan récapitule —
  e.setClock('14:30');
  await e.incoming('inconnu',
      'Récapitulatif de notre échange, puisque vous avez demandé du temps :',
      typing: 2000);
  await e.incoming(
      'inconnu',
      'Trois mois. Fiancée officielle, en public et devant ma famille. '
      'Contrat notarié. Discrétion absolue. 30 000 €, dont 10 000 € à la signature.',
      typing: 2600);
  await e.incomingImage('inconnu', 'assets/photos/ep1/j08_11h30_contrat_14_pages.webp',
      typing: 2200);
  await e.incoming('inconnu', 'Le document. Quatorze pages. Lisez tout.',
      typing: 1500);
  c = await e.choice('inconnu', const [
    ChoiceOption('Pourquoi moi ?',
        reply:
            'Parce que vous avez déchiré ma carte au lieu de me sourire. '
            'C’est rare, dans mon monde.'),
    ChoiceOption('Et si je refuse ?',
        reply: 'Alors ce numéro disparaît, et je vous souhaite une belle vie.'),
    ChoiceOption('C’est de la folie.',
        reply:
            'Non. C’est un arrangement. La folie serait de refuser sans compter.'),
  ]);
  await e.sleep(1100);
  e.markRead('inconnu');
  await e.incoming('inconnu', c.reply!, typing: 2000);
  await e.sleep(2000);

  // — 15:10, Camille —
  e.setClock('15:10');
  await e.incoming('camille', 'ALORS ??', typing: 900);
  e.outgoing('camille', 'Trois mois. Trente mille. Fausse fiancée. Quatorze pages.');
  await e.sleep(1200);
  await e.incoming('camille', 'PUTAIN.', typing: 900);
  await e.incoming('camille', 'Tu lis chaque clause. CHAQUE clause.', typing: 1400);
  await e.incoming('camille',
      'Et tu penses à Tenon avant de penser à ta fierté. C’est tout ce que je dis.',
      typing: 1800);
  c = await e.choice('camille', const [
    ChoiceOption('Je sais.', reply: 'Je sais que tu sais. Je le dis quand même.'),
    ChoiceOption('Ma fierté est déjà dans une flaque avenue Montaigne.',
        reply: 'Non. Ta fierté a recollé une carte. C’est différent.'),
  ]);
  await e.sleep(900);
  e.markRead('camille');
  await e.incoming('camille', c.reply!, typing: 1600);
  await e.sleep(2000);

  // — 19:30, Dr Aubin (la pression) —
  e.setClock('19:30');
  await e.incoming(
      'aubin',
      'Sans validation du devis cette semaine, on reporte le protocole d’un mois. '
      'Je préfère vous le dire clairement.',
      typing: 2200);
  c = await e.choice('aubin', const [
    ChoiceOption('Vous l’aurez cette semaine.', reply: 'Je vous crois. Le créneau est gardé.'),
    ChoiceOption('Vous le saurez avant jeudi.', reply: 'Avant jeudi, donc. Je note.'),
  ]);
  await e.sleep(900);
  e.markRead('aubin');
  await e.incoming('aubin', c.reply!, typing: 1500);
  await e.sleep(2000);

  // — 21:00, Maman —
  e.setClock('21:00');
  await e.incoming('maman', 'Tu me sembles loin ce soir. Tout va bien ?',
      typing: 1600);
  c = await e.choice('maman', const [
    ChoiceOption('Tout va bien, Maman.', reply: 'Bon. Alors dors bien.'),
    ChoiceOption('Juste fatiguée. Grosse semaine.',
        reply: 'Les semaines passent. Dors.'),
    ChoiceOption('Bientôt de bonnes nouvelles. Promis.',
        reply: 'Je préfère les bonnes nuits aux bonnes nouvelles. Va dormir.'),
  ]);
  await e.sleep(800);
  e.markRead('maman');
  await e.incoming('maman', c.reply!, typing: 1500);
  await e.sleep(2200);

  // — 22:40, Tristan : la question —
  e.setClock('22:40');
  await e.incoming('inconnu', 'Alors, Mademoiselle Marchand. Votre réponse ?',
      typing: 2200);
  c = await e.choice('inconnu', const [
    ChoiceOption('Oui. J’accepte.',
        reply:
            'Bien. Signature demain, 11h30, étude Vidal, rue de Sèze. '
            'Lisez l’article 14 deux fois.'),
    ChoiceOption('35 000, et j’accepte.',
        reply:
            '33 000. Parce que vous avez négocié sans trembler. '
            'Signature demain, 11h30, étude Vidal.'),
    ChoiceOption('Il me faut la nuit.',
        reply: 'La nuit vous appartient. Ma proposition expire à 9h.'),
  ]);
  await e.sleep(1300);
  e.markRead('inconnu');
  await e.incoming('inconnu', c.reply!, typing: 2400);
  await e.sleep(1600);
}
