import 'models.dart';
import 'engine.dart';

/// Jour 1 — mercredi 15 juillet : l'accident, la carte déchirée,
/// et le premier message de Tristan.
Future<void> runDay1(GameEngine e) async {
  e.setDate('Mercredi 15 juillet');
  await e.sleep(1000);

  // — 07:48, Maman —
  e.setClock('07:48');
  e.separator('maman', 'Mercredi 15 juillet · 07:48');
  await e.incoming('maman', 'Tu pars livrer dans combien de temps ?',
      typing: 1500);
  await e.incoming('maman', 'Il pleut sur tout Paris. Couvre-toi.',
      typing: 1400);
  await e.incoming('maman',
      'Le fleuriste sortait les pivoines sous la pluie. Je n’ai pas résisté.',
      typing: 1400);
  var c = await e.choice('maman', const [
    ChoiceOption('Dix minutes. Capuche promise.',
        reply: 'Bien. Fais-toi un thermos de thé, la pluie tient toute la journée.'),
    ChoiceOption('Maman. J’ai 24 ans.',
        reply: 'Et moi 51 ans de pluie. Couvre-toi.'),
    ChoiceOption('Déjà sur le vélo.',
        reply: 'Alors ne réponds pas en pédalant.'),
  ]);
  await e.sleep(700);
  e.markRead('maman');
  await e.incoming('maman', c.reply!, typing: 1300);
  await e.incoming('maman', 'Tu as mangé quelque chose ?', typing: 1300);
  c = await e.choice('maman', const [
    ChoiceOption('Le pain au chocolat d’hier, trempé dans le thé.',
        reply: 'Ce soir je te fais des nouilles. Des vraies.'),
    ChoiceOption('Un truc équilibré, t’inquiète.',
        reply: '« Un truc équilibré. » Je note.'),
    ChoiceOption('Pas le temps. Midi, promis.',
        reply: 'C’est ce que tu dis tous les matins.'),
  ]);
  await e.sleep(700);
  e.markRead('maman');
  await e.incoming('maman', c.reply!, typing: 1400);
  await e.incoming(
      'maman', 'N’oublie pas. Demain, 8h30, Tenon. Je préfère que tu sois là.',
      typing: 1900);
  c = await e.choice('maman', const [
    ChoiceOption('Je serai là.', reply: 'Je sais.'),
    ChoiceOption('C’est juste un contrôle, Maman.',
        reply: 'Oui. Juste un contrôle.'),
    ChoiceOption('Tu veux que je pose ma matinée ?',
        reply: 'Non. Juste toi, à 8h30.'),
  ]);
  await e.sleep(800);
  e.markRead('maman');
  await e.incoming('maman', c.reply!, typing: 1300);
  await e.sleep(1400);

  // — 08:04, la plateforme —
  e.setClock('08:04');
  e.separator('plateforme', 'Mercredi 15 juillet · 08:04');
  await e.incoming(
      'plateforme',
      'Course #14872 — Bowl Açaï → 8 avenue Montaigne. '
      'Rémunération : 8,40 €. Acceptez sous 30 s.',
      typing: 1200);
  c = await e.choice('plateforme', const [
    ChoiceOption('Accepter la course', key: 'ok'),
    ChoiceOption('Laisser passer', key: 'non'),
  ]);
  if (c.key == 'ok') {
    await e.incoming('plateforme',
        'Course #14872 acceptée. Retrait : Wild Berry, rue de Ponthieu. Bonne route.',
        typing: 1100);
  } else {
    await e.incoming('plateforme',
        'Course réattribuée. Rappel : votre taux d’acceptation impacte votre priorité.',
        typing: 1100);
    await e.incoming(
        'plateforme',
        'Course #14891 — Bowl Açaï → 8 avenue Montaigne. '
        'Rémunération : 8,40 €. Acceptez sous 30 s.',
        typing: 1400);
    await e.choice('plateforme', const [
      ChoiceOption('Accepter la course'),
    ]);
    await e.incoming('plateforme',
        'Course #14891 acceptée. Retrait : Wild Berry, rue de Ponthieu. Bonne route.',
        typing: 1100);
  }
  await e.sleep(1800);

  // — 08:31, l'incident (l'accident a lieu hors écran) —
  e.setClock('08:31');
  await e.incoming(
      'plateforme',
      '⚠️ INCIDENT — Course signalée NON LIVRÉE par le client. '
      'Pénalité : 38,00 € sur votre prochaine paie. '
      'Conseil : reprenez une course dès maintenant pour préserver vos statistiques.',
      typing: 1600);
  await e.sleep(2200);

  // — 11:42, Camille —
  e.setClock('11:42');
  e.separator('camille', 'Mercredi 15 juillet · 11:42');
  await e.incoming('camille', 'Alors, la tournée sous la flotte ? T’as survécu ?',
      typing: 1500);
  c = await e.choice('camille', const [
    ChoiceOption('Je me suis fait renverser.', key: 'direct'),
    ChoiceOption('Devine. Pénalité de 38 balles.', key: 'oblique'),
    ChoiceOption('Journée parfaite. Si on aime l’asphalte.', key: 'vanne'),
  ]);
  await e.sleep(600);
  e.markRead('camille');
  if (c.key == 'direct') {
    await e.incoming('camille', 'Attends. QUOI.', typing: 900);
  } else if (c.key == 'oblique') {
    await e.incoming('camille', '38 balles ?? Ils t’ont fait quoi encore ?',
        typing: 1300);
    e.outgoing('camille', 'C’est pas eux. Je me suis fait renverser.');
    await e.sleep(700);
    await e.incoming('camille', 'PARDON ??', typing: 800);
  } else {
    await e.incoming('camille', 'L’asphalte. Shen. Développe. TOUT DE SUITE.',
        typing: 1300);
    e.outgoing('camille', 'Une voiture m’a renversée avenue Montaigne.');
    await e.sleep(700);
  }
  await e.incoming('camille', 'Renversée genre RENVERSÉE ?? T’es où, t’as mal où ??',
      typing: 1400);
  c = await e.choice('camille', const [
    ChoiceOption('Ça va. Le vélo est mort, pas moi.',
        reply: 'OK. OK. Je respire.'),
    ChoiceOption('Une bagnole noire. Le genre qui vaut ton loyer annuel en options.',
        reply: 'Bien sûr. Ils roulent, on tombe.'),
    ChoiceOption('Mal nulle part. J’ai juste la rage.',
        reply: 'La rage c’est bon signe. Ça veut dire vivante.'),
  ]);
  await e.sleep(700);
  e.markRead('camille');
  await e.incoming('camille', c.reply!, typing: 1300);
  await e.sleep(600);
  e.outgoingImage('camille', 'assets/photos/ep1/pr_accident_velo_homme_costume.webp');
  await e.sleep(900);
  e.markRead('camille');
  await e.incoming('camille',
      'Oh non. Il a donné sa vie pour toi, ce vélo. Paix à sa chaîne.',
      typing: 1600);
  await e.incoming('camille',
      'Attends. C’est LUI, là ?? Debout à côté de sa bagnole comme si de rien n’était ??',
      typing: 1800);
  await e.incoming('camille',
      'Constat ? Assurance ? Dis-moi que t’as ses infos.',
      typing: 1500);
  c = await e.choice('camille', const [
    ChoiceOption('Il m’a tendu sa carte comme un pourboire. Je l’ai déchirée devant lui.'),
    ChoiceOption('J’ai sa carte. En quatre morceaux. Dans une flaque.'),
    ChoiceOption('Il a proposé sa carte. J’ai refusé. Fière ou conne, choisis.'),
  ]);
  await e.sleep(900);
  e.markRead('camille');
  await e.incoming('camille', 'T’ES PAS SÉRIEUSE.', typing: 1000);
  await e.incoming('camille', 'Il s’appelait comment ?', typing: 1100);
  c = await e.choice('camille', const [
    ChoiceOption('T. Heng, je crois.'),
    ChoiceOption('Tristan quelque chose. Heng ?'),
  ]);
  await e.sleep(1100);
  e.markRead('camille');
  await e.incoming('camille', 'Shen.', typing: 1600);
  await e.incoming(
      'camille',
      'T comme TRISTAN Heng ?? Heng International ? '
      'La tour en verre avec leur nom en lettres d’un mètre ??',
      typing: 2100);
  c = await e.choice('camille', const [
    ChoiceOption('…la tour de la Défense ?', reply: 'LA TOUR, OUI.'),
    ChoiceOption('Riche ou pas, il conduit comme un pied.',
        reply: 'Je t’adore. T’es un désastre.'),
    ChoiceOption('Tant mieux. Sa carte meurt riche.',
        reply: 'Tu me tues. Sérieusement.'),
  ]);
  await e.sleep(800);
  e.markRead('camille');
  await e.incoming('camille', c.reply!, typing: 1200);
  await e.incoming(
      'camille',
      'Bon. Écoute-moi : retourne chercher les morceaux. '
      'Un type pareil, son assurance te rachète dix vélos.',
      typing: 2000);
  await e.incoming('camille', 'Et passe me voir après. Bisous mon canard cabossé.',
      typing: 1400);
  await e.incomingImage(
      'camille', 'assets/photos/ep1/pr_croissant_partage_cafe.webp',
      typing: 1900);
  await e.incoming('camille', 'Motivation pour samedi. Je dis ça, je dis rien.',
      typing: 1300);
  await e.sleep(1800);

  // — 18:42, Maman, le soir —
  e.setClock('18:42');
  e.separator('maman', '18:42');
  await e.incoming('maman', 'Le riz est dans le rice cooker.', typing: 1400);
  await e.incomingImage('maman', 'assets/photos/ep1/pr_repas_poisson_riz_legumes.webp',
      typing: 2100);
  await e.incoming('maman', 'Ta part. Tu passes ce soir ?', typing: 1200);
  c = await e.choice('maman', const [
    ChoiceOption('J’arrive.', reply: 'Je réchauffe.'),
    ChoiceOption('Tard. M’attends pas pour manger.',
        reply: 'Je mets ta part de côté. Avec un mot dessus.'),
    ChoiceOption('Je dors chez moi ce soir.',
        reply: 'D’accord. Couvre-toi cette nuit.'),
  ]);
  await e.sleep(800);
  e.markRead('maman');
  await e.incoming('maman', c.reply!, typing: 1400);
  await e.sleep(1600);

  e.setClock('22:12');
  await e.incoming('maman', 'Bonne nuit ma fille. À demain. 8h30.',
      typing: 1500);
  c = await e.choice('maman', const [
    ChoiceOption('Bonne nuit Maman ❤️', reply: '❤️'),
    ChoiceOption('À demain.', reply: 'Dors bien.'),
    ChoiceOption('(ne pas répondre)',
        silent: true, reply: 'Dors bien, même quand tu ne réponds pas.'),
  ]);
  await e.sleep(1000);
  if (!c.silent) e.markRead('maman');
  await e.incoming('maman', c.reply!, typing: 1200);
  await e.sleep(2000);

  // — 22:47, le numéro inconnu —
  e.setClock('22:47');
  e.separator('inconnu', 'Mercredi 15 juillet · 22:47');
  await e.incoming('inconnu', 'Mademoiselle Marchand. Tristan Heng.',
      typing: 1900);
  await e.incoming('inconnu',
      'Vous êtes partie sans constat, sans un mot. On ne se quitte pas comme ça.',
      typing: 2100);
  c = await e.choice('inconnu', const [
    ChoiceOption('Comment vous avez eu ce numéro ?', key: 'q'),
    ChoiceOption('Il est presque 23h. On dort, chez les riches ?', key: 'q'),
    ChoiceOption('(bloquer le numéro)', silent: true, key: 'block'),
  ]);
  if (c.key == 'block') {
    e.sysline('inconnu', 'Numéro bloqué.');
    await e.sleep(1600);
    e.sysline('inconnu', 'Nouveau message — autre numéro inconnu');
    await e.incoming('inconnu',
        'Bloquer mon numéro ne bloque pas ma mémoire, Mademoiselle Marchand. '
        'Je ne suis pas pressé.',
        typing: 2000);
  } else {
    await e.sleep(800);
    e.markRead('inconnu');
    await e.typingThenNothing('inconnu');
    e.sysline('inconnu', 'Tristan Heng a commencé à écrire… puis s’est arrêté.');
  }
  await e.sleep(1200);
}
