import '../models/episode.dart';

/// Catalogue des 5 épisodes — découpage validé pour le funnel gratuit /
/// payant : Ep 1 gratuit (J1 → J14, deux premières semaines complètes
/// avec collision, contrat, vie commune, premier dîner Madame Heng).
/// Le paywall tombe sur le cliffhanger « ma fille » de Long Jing
/// deuxième récolte. Les 4 épisodes suivants sont payants.

const kEpisodes = <Episode>[
  // ── Épisode 1 ── GRATUIT — J1 → J14 ──────────────────────────────
  Episode(
    id: 'avant_la_lumiere',
    number: 1,
    title: 'Avant la lumière',
    subtitle:
        'Deux semaines. La collision, le contrat, le premier thé chez Madame Heng.',
    beats: [
      // — Acte A : Collision (J1 → J3)
      Beat(
        idx: 0,
        day: 1,
        hour: 7,
        minute: 30,
        transition: BeatTransition(
          timestamp: '07:30',
          body: 'Sept heures et demie. Belleville sent le pain et la pluie.\nLe vélo est en bas, la sacoche vide, la journée à faire.\nMaman écrit avant que j\'aie les yeux ouverts. Elle écrit toujours avant.\nVingt-quatre ans, livreuse, et une mère qui croit que je mange.',
          coda: '(Je réponds « oui ». C\'est plus court que la vérité.)',
        ),
        label: 'Réveil — premier SMS de Maman',
        requiresChoice: 'maman_petit_dej_j1',
      ),
      Beat(
        idx: 1,
        day: 1,
        hour: 8,
        minute: 17,
        label: 'Avenue Montaigne, collision',
        // Le choc révèle le carnet (notes) et la réalité financière
        // (banque). Les deux apps apparaissent sur le home après ce beat.
        unlocksApps: ['notes', 'banque', 'photos'],
        transition: BeatTransition(
          timestamp: '08:17',
          body:
              'Je n\'ai pas vu la voiture noire.\n'
              'J\'ai vu mon bol d\'açaï en l\'air.\n'
              'L\'homme du costume est descendu.\n'
              'Il m\'a tendu une carte.\n'
              'J\'ai pris la carte. J\'ai dit non pour le reste.',
        ),
      ),
      Beat(
        idx: 2,
        day: 1,
        hour: 23,
        minute: 42,
        label: 'Carte déchirée — première erreur',
        transition: BeatTransition(
          timestamp: '23:42',
          body:
              'La carte tient sur ma paume.\n'
              '« Tristan Heng ». Trois mots, un numéro.\n'
              'Je déchire en deux. Puis en quatre.\n'
              'Les morceaux tombent dans l\'évier.',
          coda: '(Dehors, le chien du voisin hurle.)',
        ),
      ),
      Beat(
        idx: 3,
        day: 2,
        hour: 6,
        minute: 30,
        label: 'Tenon — bureau du Dr Aubin',
        // Aubin dit le montant. Il faut gagner — Shen démarre les
        // courses Uber Eats l'après-midi même.
        transition: BeatTransition(
          timestamp: '06:30',
          body: 'Le bureau du Dr Aubin sent le désinfectant et le café froid.\n'
              'Il parle doucement, comme on pose un objet fragile.\n'
              'Un traitement existe. Il coûte dix-huit mille euros.\n'
              'Six semaines. Après, la porte se ferme.\n'
              'Maman regarde ses mains. Moi je regarde le chiffre.',
          coda: '(Dix-huit mille. Je gagne quatre euros la course.)',
        ),
        unlocksApps: ['ubereats'],
      ),
      Beat(
        idx: 4,
        day: 3,
        hour: 14,
        minute: 23,
        transition: BeatTransition(
          timestamp: '14:23',
          body: 'La conseillère clique son stylo sans s\'en rendre compte.\n« Sans CDI, sans garant, je ne peux rien. »\nElle est désolée. Les gens sont souvent désolés.\nJe ressors avec un dépliant que je jette au coin de la rue.',
          coda: '(Le dépliant montre une famille qui sourit devant une maison.)',
        ),
        label: 'BNP — crédit refusé',
      ),
      Beat(
        idx: 5,
        day: 3,
        hour: 17,
        minute: 8,
        label: 'Camille — « rappelle-le »',
        transition: BeatTransition(
          timestamp: '17:08',
          body:
              'Vocal de Camille, trente-deux secondes.\n'
              '« T\'as quoi à perdre, là ?\n'
              'Tu rappelles, tu dis oui une fois,\n'
              'tu ressors avec ce qu\'il faut pour ta mère. »',
        ),
      ),
      Beat(
        idx: 6,
        day: 3,
        hour: 23,
        minute: 30,
        label: 'Carte recollée — quatre morceaux',
        transition: BeatTransition(
          timestamp: '23:30',
          body:
              'Le scotch transparent ne tient pas.\n'
              'Je recommence. Quatre morceaux.\n'
              'Le « T » de Tristan refuse de se réaligner.',
          coda: '(Mais le numéro, lui, est lisible.)',
        ),
      ),
      Beat(
        idx: 7,
        day: 3,
        hour: 23,
        minute: 55,
        label: 'Numéro masqué — T. rappelle',
        // Premier appel entrant → l'app Téléphone apparaît.
        unlocksApps: ['telephone'],
        transition: BeatTransition(
          timestamp: '23:55',
          body:
              'Le téléphone vibre sur la table de nuit.\n'
              'Numéro masqué.\n'
              'Tu sais qui c\'est avant qu\'il parle.',
        ),
      ),
      // — Acte B : Le contrat (J4 → J9)
      Beat(
        idx: 8,
        day: 4,
        hour: 14,
        minute: 2,
        transition: BeatTransition(
          timestamp: '14:02',
          body: 'Camille pose son café sans le boire.\n« Tu as gardé sa carte, hein. »\nCe n\'est pas une question. Camille ne pose jamais de questions.\nJe ne réponds pas. Elle sourit, ce qui est pire.',
          coda: '(La carte est recollée dans ma poche intérieure. Contre le cœur, comme une blague.)',
        ),
        label: 'Camille — « tu as gardé sa carte, hein »',
        requiresChoice: 'camille_carte_j4',
      ),
      Beat(
        idx: 9,
        day: 6,
        hour: 14,
        minute: 12,
        transition: BeatTransition(
          timestamp: '14:12',
          body: 'Tour de verre, avenue de Friedland. On m\'appelle « Mademoiselle Marchand ».\nPersonne ici ne m\'a jamais vue sur un vélo.\nTristan Heng ne dit pas bonjour. Il dit le montant.\nTrois mois. Un rôle. De l\'argent qui sauve Maman.\nJe pense « non ». Je dis « on peut en parler ».',
          coda: '(« On peut en parler », c\'est déjà « oui ». Je le sais en le disant.)',
        ),
        label: 'Heng International — Mlle Marchand',
        requiresChoice: 'tristan_rdv_j6',
      ),
      Beat(
        idx: 10,
        day: 6,
        hour: 17,
        minute: 42,
        transition: BeatTransition(
          timestamp: '17:42',
          body: 'Camille arrive avec une housse et deux croissants.\n« Si tu joues la fille riche, joue-la bien. »\nLe tailleur est trop beau pour Belleville.\nJe l\'essaie devant le miroir de la salle de bain. Ce n\'est pas moi.',
          coda: '(Camille dit que je suis parfaite. Camille ment mieux que moi.)',
        ),
        label: 'Camille apporte le tailleur',
        requiresChoice: 'camille_tailleur_j6',
      ),
      Beat(
        idx: 11,
        day: 7,
        hour: 11,
        minute: 0,
        label: 'Tour Heng — proposition trois mois',
        transition: BeatTransition(
          timestamp: '11:00',
          body:
              'L\'ascenseur monte au 47ᵉ.\n'
              'Quand les portes s\'ouvrent,\n'
              'il y a déjà un dossier à mon nom\n'
              'posé sur la table en verre.',
          coda: '(Donc il savait que je viendrais.)',
        ),
      ),
      Beat(
        idx: 12,
        day: 8,
        hour: 11,
        minute: 30,
        label: 'Cabinet notarial — 14 pages',
        transition: BeatTransition(
          timestamp: '11:30',
          body:
              'Quatorze pages. Une plume Mont-Blanc.\n'
              'Le notaire ne lève pas les yeux.\n'
              'À la page 14, mon stylo tremble\n'
              'sur le « M » de Marchand.',
          coda: '(Personne ne le voit.)',
        ),
      ),
      Beat(
        idx: 13,
        day: 9,
        hour: 17,
        minute: 22,
        transition: BeatTransition(
          timestamp: '17:22',
          body: 'Rue de Berri, huitième. L\'ascenseur monte sans bruit.\nUn carton. C\'est tout ce que j\'ai.\nTristan me montre une chambre plus grande que l\'appartement de Maman.\nJe pose le carton au milieu, comme une bouée.',
          coda: '(Je garde la clé de Belleville dans ma poche. Au cas où.)',
        ),
        label: 'Emménagement — rue de Berri',
      ),
      // — Acte C : Vie commune (J11 → J14, cliffhanger Long Jing)
      Beat(
        idx: 14,
        day: 11,
        hour: 21,
        minute: 8,
        transition: BeatTransition(
          timestamp: '21:08',
          body: 'Maman demande ce que je fais de mes journées.\nJ\'invente un stage. Un paysagiste. Lao Chen.\nLe nom sort tout seul, comme s\'il attendait depuis longtemps.\nElle est contente. Elle dit qu\'elle savait que je m\'en sortirais.',
          coda: '(Le premier mensonge est le plus facile. C\'est ça, le piège.)',
        ),
        label: 'Premier mensonge — Lao Chen, paysagiste',
        requiresChoice: 'maman_stage_j11',
      ),
      Beat(
        idx: 15,
        day: 13,
        hour: 15,
        minute: 8,
        transition: BeatTransition(
          timestamp: '15:08',
          body: 'Camille m\'appelle en majuscules.\n« Tu as parlé de deuxième récolte à une femme que tu détestes ? QUEL THÉ ? »\nJ\'ai appris le nom d\'un thé pour plaire aux Heng.\nJe m\'entends défendre ça. Ma propre voix me gêne.',
          coda: '(Camille raccroche en riant. Son rire, quand il s\'arrête net, ça fait mal.)',
        ),
        label: 'Camille — « QUEL THÉ ? »',
        requiresChoice: 'camille_quel_the_j13',
      ),
      Beat(
        idx: 16,
        day: 14,
        hour: 20,
        minute: 30,
        label: 'Dîner Madame Heng — Long Jing deuxième récolte',
        transition: BeatTransition(
          timestamp: '20:30',
          body:
              'La table est dressée pour six.\n'
              'Une pivoine blanche au centre.\n'
              'Madame Heng te regarde t\'asseoir,\n'
              'puis elle pose une question avec un sourire.',
          coda: '(Tu sais qu\'elle connaît déjà la réponse.)',
        ),
      ),
    ],
  ),

  // ── Épisode 2 — La routine du mensonge — J15 → J30 ─────────────
  Episode(
    id: 'routine_du_mensonge',
    number: 2,
    title: 'La routine du mensonge',
    subtitle: 'J15 → J30. Shen tient deux vies. Maman commence à douter.',
    beats: [
      Beat(
        idx: 0,
        day: 15,
        hour: 8,
        minute: 12,
        label: 'Lendemain Long Jing — message Madame Heng',
        transition: BeatTransition(
          timestamp: '08:12',
          body:
              'Le téléphone vibre.\n'
              'Madame Heng. Huit heures douze.\n'
              '« Vous avez identifié la deuxième récolte. »',
          coda: '(« Ma fille » n\'était pas une erreur.)',
        ),
      ),
      Beat(
        idx: 1,
        day: 16,
        hour: 9,
        minute: 30,
        transition: BeatTransition(
          timestamp: '09:30',
          body: 'On rentre de la dialyse. Maman regarde par la vitre.\nElle ne parle pas. Moi non plus.\nLe silence entre nous n\'a jamais été vide. Aujourd\'hui il l\'est un peu.\nJe conduis une voiture qui n\'est pas à moi vers un appartement qui n\'est pas le mien.',
          coda: '(Elle sent un parfum qu\'elle ne connaît pas. Elle ne dit rien. C\'est pire.)',
        ),
        label: 'Dialyse Maman — silence dans la voiture',
      ),
      Beat(
        idx: 2,
        day: 17,
        hour: 12,
        minute: 40,
        transition: BeatTransition(
          timestamp: '12:40',
          body: 'Je continue les livraisons. Trois jours. Mes règles.\nLe vélo me rappelle qui je suis quand le tailleur l\'oublie.\nLa pluie n\'a pas changé. Moi peut-être.\nUn client me tend deux euros de pourboire comme une aumône. Je les prends.',
          coda: '(La double vie tient sur un porte-bagages.)',
        ),
        label: 'Livraisons sous la pluie — trois jours par semaine, mes règles',
      ),
      Beat(
        idx: 3,
        day: 18,
        hour: 21,
        minute: 14,
        label: 'Vincent débarque sans prévenir',
        transition: BeatTransition(
          timestamp: '21:14',
          body:
              'Il ouvre la porte avec sa clé.\n'
              'Il rit. Il sent le whisky.\n'
              'Il te demande si tu sais tenir un secret.',
        ),
      ),
      Beat(
        idx: 4,
        day: 19,
        hour: 21,
        minute: 4,
        transition: BeatTransition(
          timestamp: '21:04',
          body: 'Madame Heng écrit le soir, jamais avant.\n« Nous avons déjeuné, juste nous deux. Mon fils m\'a dit que vous lisiez Duras. »\nElle teste. Chaque phrase est un test.\nJe réponds en pesant chaque mot, comme elle.',
          coda: '(Elle ne dit jamais « ma fille ». Pas encore.)',
        ),
        label: 'Madame Heng écrit après le déjeuner « juste nous deux »',
        requiresChoice: 'heng_duras_j19',
      ),
      Beat(
        idx: 5,
        day: 20,
        hour: 20,
        minute: 0,
        label: 'Soirée mère Tristan — Cercle Interallié',
        transition: BeatTransition(
          timestamp: '20:00',
          body:
              'Trente personnes. Trente noms à retenir.\n'
              'Madame Heng te présente comme « la jeune Marchand ».\n'
              'Pas « ma fille ». Pas devant ces gens.',
        ),
      ),
      Beat(
        idx: 6,
        day: 21,
        hour: 19,
        minute: 45,
        transition: BeatTransition(
          timestamp: '19:45',
          body: 'Camille m\'emmène au cinéma. Une salle presque vide.\nDeux heures dans le noir où je n\'ai à jouer personne.\nJe ne me souviens pas du film. Je me souviens d\'avoir respiré.\nCamille partage son paquet de bonbons sans compter.',
          coda: '(Deux heures sans mentir. C\'est le luxe, maintenant.)',
        ),
        label: 'Cinéma avec Camille — deux heures sans mentir',
      ),
      Beat(
        idx: 7,
        day: 22,
        hour: 10,
        minute: 0,
        label: '2e acompte Heng — 10 000 €',
        transition: BeatTransition(
          timestamp: '10:00',
          body:
              'Notification Banque : virement +10 000 €.\n'
              'C\'est la moitié.\n'
              'Tu n\'as plus besoin de mentir longtemps.',
          coda: '(Sauf que tu mens à toi-même.)',
        ),
      ),
      Beat(
        idx: 8,
        day: 23,
        hour: 19,
        minute: 32,
        transition: BeatTransition(
          timestamp: '19:32',
          body: 'Maman ouvre mon sac pour y ranger un pull.\nElle en sort une boîte de thé. Du Long Jing. Le vrai, le cher.\n« Depuis quand tu bois ça, toi ? »\nLe mensonge cherche une sortie. Il n\'en trouve pas tout de suite.',
          coda: '(Une boîte de thé. C\'est par là que ça craque.)',
        ),
        label: 'Maman trouve une boîte de Long Jing chez Shen',
        requiresChoice: 'maman_long_jing_j23',
      ),
      Beat(
        idx: 9,
        day: 24,
        hour: 21,
        minute: 12,
        transition: BeatTransition(
          timestamp: '21:12',
          body: 'Belleville, la petite cuisine. Maman me regarde trop longtemps.\n« Tu as le visage de quelqu\'un qui ment à quelqu\'un qu\'elle aime. »\nElle a toujours su lire les visages. Le mien surtout.\nJe débarrasse la table pour ne pas avoir à répondre.',
          coda: '(Elle ne demande pas quoi. Elle attend que je le dise.)',
        ),
        label: 'Belleville — « le visage d\'une fille amoureuse »',
        requiresChoice: 'maman_devine_j24',
      ),
      Beat(
        idx: 10,
        day: 25,
        hour: 9,
        minute: 30,
        transition: BeatTransition(
          timestamp: '09:30',
          body: 'Dr Aubin m\'attire dans le couloir, loin de Maman.\n« Ce que vous faites tient. Continuez. »\nIl ne demande pas comment je trouve l\'argent. Les médecins ne demandent pas.\nJe hoche la tête. Je retourne sourire à Maman.',
          coda: '(« Ça tient. » Deux mots pour six semaines de corde raide.)',
        ),
        label: 'Dialyse Maman — Dr Aubin attire Shen à part',
      ),
      Beat(
        idx: 11,
        day: 25,
        hour: 23,
        minute: 5,
        label: 'Long Jing silencieux — quelque chose se règle',
        transition: BeatTransition(
          timestamp: '23:05',
          body:
              'Il sort de son bureau vers 23h.\n'
              '— Vous voulez du thé ?\n'
              'On boit en silence. Personne ne parle du mot d\'avant-hier.',
          coda: '(Affective. Il avait dit affective.)',
        ),
      ),
      Beat(
        idx: 12,
        day: 26,
        hour: 22,
        minute: 14,
        transition: BeatTransition(
          timestamp: '22:14',
          body: 'Treize jours sans écrire à Camille. Elle compte. Elle a toujours compté.\n« Tu me manques. Et je déteste ça, parce que c\'est toi qui pars. »\nJe lis le message trois fois.\nJe tape une réponse, je l\'efface, j\'en tape une autre.',
          coda: '(La seule personne à qui je ne mens pas, c\'est la seule que je néglige.)',
        ),
        label: 'Camille — « tu m\'as pas appelée depuis 8 jours »',
        requiresChoice: 'camille_distance_j26',
      ),
      Beat(
        idx: 13,
        day: 27,
        hour: 18,
        minute: 20,
        label: 'Le genou — Tristan sort le kit de premiers secours',
        transition: BeatTransition(
          timestamp: '18:20',
          body:
              'Il s\'agenouille avec un kit de premiers secours impeccable.\n'
              'Il nettoie. Il colle un pansement. Ses mains ne tremblent pas.\n'
              'Tout dure quatre minutes.',
          coda: '(Je ne respire pas pendant les quatre minutes.)',
        ),
      ),
      Beat(
        idx: 14,
        day: 28,
        hour: 15,
        minute: 0,
        label: 'Dr Aubin — bilan mi-parcours',
        transition: BeatTransition(
          timestamp: '15:00',
          body:
              'Le bilan est meilleur que prévu.\n'
              'Le Dr Aubin dit : « grâce à ce que vous faites. »\n'
              'Il ne sait pas quoi exactement.',
        ),
      ),
      Beat(
        idx: 15,
        day: 29,
        hour: 10,
        minute: 30,
        transition: BeatTransition(
          timestamp: '10:30',
          body: 'Une boîte à chaussures sous le lit de Maman.\nDedans : mon ancien passeport, une photo de Papa, une lettre en chinois.\nUn prénom que je n\'utilise plus. Shen Miao.\nCamille me demande pourquoi je pleure pour un carton. Je ne sais pas mentir à Camille.',
          coda: '(On garde ses vies dans des boîtes à chaussures. Toutes.)',
        ),
        label: 'Le passeport — la boîte à chaussures',
        requiresChoice: 'camille_passeport_j29',
      ),
      Beat(
        idx: 16,
        day: 30,
        hour: 19,
        minute: 30,
        label: 'Gala Heng International — Tristan annonce HK',
        transition: BeatTransition(
          timestamp: '19:30',
          body:
              'Hôtel particulier. Cent invités. Champagne.\n'
              'Tristan se penche à ton oreille :\n'
              '« Tu pars avec moi à Hong Kong jeudi. »',
          coda: '(Tu n\'as pas le passeport sur toi.)',
        ),
      ),
    ],
  ),
  // ── Épisode 3 — Hong Kong — J30 → J50 ─────────────────────────
  Episode(
    id: 'hong_kong',
    number: 3,
    title: 'Hong Kong',
    subtitle: 'J30 → J50. Le voyage. Le secret remonte à la surface.',
    beats: [
      Beat(
        idx: 0,
        day: 32,
        hour: 14,
        minute: 0,
        label: 'Vol Paris → Hong Kong',
        transition: BeatTransition(
          timestamp: '14:00',
          body:
              'Business class. Tu n\'as jamais vu autant d\'espace dans un avion.\n'
              'Tristan dort tout le vol. Tu regardes par le hublot.\n'
              'Tu envoies un SMS à Maman : « Stage à Lyon. Pas de réseau. »',
          coda: '(Ton premier vol vers le pays de ton père.)',
        ),
      ),
      Beat(
        idx: 1,
        day: 33,
        hour: 8,
        minute: 30,
        transition: BeatTransition(
          timestamp: '08:30',
          body: 'Hong Kong à l\'aube. L\'air est épais, il colle.\nUn chauffeur Heng tient une pancarte : « Mlle Marchand ».\nEncore ce nom. Encore ce rôle, mais plus loin de Maman.\nLa ville monte tout droit, comme si elle voulait fuir la mer.',
          coda: '(Onze mille kilomètres. Le mensonge a pris l\'avion avec moi.)',
        ),
        label: 'Atterrissage HK — chauffeur Heng',
      ),
      Beat(
        idx: 2,
        day: 33,
        hour: 20,
        minute: 0,
        label: 'Dîner Heng Causeway Bay — oncle Vincent senior',
        transition: BeatTransition(
          timestamp: '20:00',
          body:
              'Vingt étages au-dessus de la baie.\n'
              'L\'oncle te regarde : « Tu parles mandarin ? »\n'
              'Tu réponds en mandarin. Silence à table.',
        ),
      ),
      Beat(
        idx: 3,
        day: 34,
        hour: 10,
        minute: 0,
        label: 'Mong Kok seule — « la bouche du Fujian »',
        transition: BeatTransition(
          timestamp: '10:00',
          body:
              'Le marché. L\'humidité, le jasmin, la friture, l\'encens.\n'
              'Le vendeur d\'éventails me parle en cantonais, je réponds en mandarin.\n'
              '— Le visage de la France et la bouche du Fujian.',
          coda: '(Madame Heng a dit la même chose.)',
        ),
      ),
      Beat(
        idx: 4,
        day: 35,
        hour: 11,
        minute: 0,
        transition: BeatTransition(
          timestamp: '11:00',
          body: 'Un cercle Heng sur WhatsApp. Une photo de groupe où je souris mal.\nTante Mei, à Fujian, la voit. Tante Mei voit tout.\n« 你是他的女儿吗 ? (Es-tu sa fille ?) »\nLe passé remonte par une application. Je ne l\'avais pas vu venir.',
          coda: '(Le monde est petit. Surtout quand on se cache.)',
        ),
        label: 'Tante Mei te repère via WhatsApp Heng',
        requiresChoice: 'mei_decouvre_j35',
        // Premier contact Tante Mei → WhatsApp apparaît.
        unlocksApps: ['whatsapp'],
      ),
      Beat(
        idx: 5,
        day: 36,
        hour: 10,
        minute: 0,
        transition: BeatTransition(
          timestamp: '10:00',
          body: 'Un virement tombe. Dix mille euros. Le troisième.\nSur l\'écran, le compte de Maman remonte, ligne après ligne.\nChaque chiffre me rapproche du traitement et m\'éloigne de moi.\nJe regarde le solde comme un thermomètre.',
          coda: '(Je compte en vies, maintenant, pas en euros.)',
        ),
        label: '3e acompte Heng — 10 000 €',
      ),
      Beat(
        idx: 6,
        day: 36,
        hour: 23,
        minute: 0,
        transition: BeatTransition(
          timestamp: '23:00',
          body: 'Le balcon donne sur la baie. Deux verres. Tristan ne parle pas beaucoup.\nLes lumières de Kowloon tremblent sur l\'eau.\nIl pose sa main à côté de la mienne, pas dessus.\nJe ne bouge pas la mienne. Ça compte, ne pas bouger.',
          coda: '(Le contrat ne dit rien sur les silences à deux verres.)',
        ),
        label: 'Balcon sur la baie — deux verres d\'eau',
      ),
      Beat(
        idx: 7,
        day: 37,
        hour: 21,
        minute: 14,
        label: 'Repulse Bay — Tristan parle de son grand-père',
        transition: BeatTransition(
          timestamp: '21:14',
          body:
              'Tu marches sur la plage. Lui n\'a jamais marché ici à pied.\n'
              'Il dit : « Mon grand-père a été enterré ici. »\n'
              'Tu dis : « Mon père aussi est de Fujian. »',
          coda: '(C\'est la première fois que tu lui parles de Papa.)',
        ),
      ),
      Beat(
        idx: 8,
        day: 38,
        hour: 19,
        minute: 0,
        transition: BeatTransition(
          timestamp: '19:00',
          body: 'Une robe bleu nuit dans une penderie qui n\'est pas la mienne.\nJe l\'enfile. Dans le miroir, quelqu\'un que Camille ne reconnaîtrait pas.\nJ\'envoie une photo. Camille met trois secondes à répondre.\nTrois secondes, chez Camille, c\'est un roman.',
          coda: '(« Elle est belle », écrit-elle. Pas « tu es belle ». Elle a vu, elle aussi.)',
        ),
        label: 'La robe bleu nuit — trois secondes de silence',
        requiresChoice: 'camille_robe_j38',
      ),
      Beat(
        idx: 9,
        day: 38,
        hour: 23,
        minute: 32,
        transition: BeatTransition(
          timestamp: '23:32',
          body: 'Lan Kwai Fong, la nuit qui déborde. Tristan a trop bu.\nIl se penche et dit « Shen ». Pas « Marchand ». Shen.\nMon vrai prénom dans une bouche qui l\'a payé.\nJe le ramène. Il s\'endort dans le taxi comme un enfant riche.',
          coda: '(Il a dit mon prénom. Je ne sais pas si c\'est un cadeau ou une prise.)',
        ),
        label: 'Lan Kwai Fong — Tristan ivre dit ton vrai prénom',
      ),
      Beat(
        idx: 10,
        day: 39,
        hour: 7,
        minute: 14,
        transition: BeatTransition(
          timestamp: '07:14',
          body: 'Quatre heures du matin à Paris. Maman appelle. Maman n\'appelle jamais la nuit.\nTante Mei a parlé. Bien sûr que Tante Mei a parlé.\n« Où es-tu vraiment ? » Sa voix ne tremble pas, et c\'est ça qui tremble en moi.\nJe regarde la baie par la fenêtre. Je cherche une phrase qui ne blesse pas.',
          coda: '(Il n\'y en a pas.)',
        ),
        label: 'Maman appelle 4h du matin Paris — Tante Mei a parlé',
        requiresChoice: 'maman_decouvre_j39',
      ),
      Beat(
        idx: 11,
        day: 39,
        hour: 21,
        minute: 40,
        transition: BeatTransition(
          timestamp: '21:40',
          body: 'Vincent m\'attend au bar de l\'hôtel. Il commande pour deux sans demander.\n« Ma mère t\'apprécie. C\'est rare. Ne gâche pas ça. »\nSous le sourire commercial, une menace polie.\nIl parle de « la famille » comme d\'une entreprise. C\'en est une.',
          coda: '(Le verre qu\'il me tend, je le laisse plein.)',
        ),
        label: 'Vincent au bar de l\'hôtel — « la quatrième »',
        requiresChoice: 'vincent_quatrieme_j39',
      ),
      Beat(
        idx: 12,
        day: 40,
        hour: 8,
        minute: 0,
        transition: BeatTransition(
          timestamp: '08:00',
          body: 'Vol de retour. Tristan dort, la tête contre le hublot.\nMoi je regarde la nuit qu\'on traverse à l\'envers.\nEn bas, Maman m\'attend avec une question que je n\'ai pas fini de fuir.\nOnze heures pour préparer une vérité. Ce n\'est pas assez.',
          coda: '(On rentre toujours plus vite qu\'on est parti.)',
        ),
        label: 'Vol HKG → Paris — Tristan dort, toi non',
      ),
    ],
  ),
  // ── Épisode 4 — Retour — J40 → J80 ─────────────────────────────
  Episode(
    id: 'retour',
    number: 4,
    title: 'Retour',
    subtitle: 'J40 → J80. Paris, Maman en crise, Camille à distance.',
    beats: [
      Beat(
        idx: 0,
        day: 41,
        hour: 9,
        minute: 14,
        label: 'CDG arrivée — Maman l\'attend',
        transition: BeatTransition(
          timestamp: '09:14',
          body:
              'Elle est là, dans le hall des arrivées.\n'
              'Elle ne dit pas un mot. Elle te tend une enveloppe.\n'
              'Le nom de Tristan dessus.',
          coda: '(Tante Mei a tout dit.)',
        ),
      ),
      Beat(
        idx: 1,
        day: 42,
        hour: 11,
        minute: 14,
        transition: BeatTransition(
          timestamp: '11:14',
          body: 'Belleville. Je dis tout. Le contrat, l\'argent, Tristan, le rôle.\nMaman écoute sans m\'interrompre. Puis elle se tait. Quatre heures.\nLe silence de Maman, je le connais depuis toujours. Celui-là est neuf.\nJe reste dans la cuisine, à attendre un verdict qui ne vient pas.',
          coda: '(À la fin elle dit : « Tu as fait ça pour moi. » Ce n\'est pas un pardon. C\'est pire.)',
        ),
        label: 'Confrontation Maman — silence pendant 4h',
        requiresChoice: 'maman_confrontation_j42',
      ),
      Beat(
        idx: 2,
        day: 43,
        hour: 14,
        minute: 0,
        transition: BeatTransition(
          timestamp: '14:00',
          body: 'Rue de Berri. Les cartons attendent, vides, contre le mur.\nJe ne sais pas encore si je pars ou si je reste.\nChaque objet ici appartient à quelqu\'un d\'autre. Moi comprise.\nJe m\'assois par terre au milieu de la grande pièce.',
          coda: '(Un carton plié, c\'est une décision qu\'on n\'a pas encore prise.)',
        ),
        label: 'Rue de Berri — les cartons pas encore faits',
      ),
      Beat(
        idx: 3,
        day: 44,
        hour: 20,
        minute: 0,
        transition: BeatTransition(
          timestamp: '20:00',
          body: 'Camille monte avec un thermos et rien à dire.\nElle ne juge pas. Elle verse le café, elle s\'assoit.\n« Je reste jusqu\'à ce que tu aies décidé. Ou pas. »\nPour la première fois depuis des semaines, je n\'ai personne à jouer.',
          coda: '(Une amie, c\'est quelqu\'un qui reste dans une pièce qui n\'est pas la sienne.)',
        ),
        label: 'Camille apporte du café — pas de jugement',
      ),
      Beat(
        idx: 4,
        day: 45,
        hour: 10,
        minute: 0,
        label: 'J45 — Dr Aubin décision finale',
        transition: BeatTransition(
          timestamp: '10:00',
          body:
              'Le traitement commence aujourd\'hui.\n'
              'L\'argent est là. Le compte est plein.\n'
              'Personne dans cette salle ne sait comment.',
          coda: '(Tu as gagné. Tu n\'as rien gagné.)',
        ),
      ),
      Beat(
        idx: 5,
        day: 46,
        hour: 17,
        minute: 30,
        transition: BeatTransition(
          timestamp: '17:30',
          body: 'Madame Heng me croise dans le couloir, s\'arrête.\n« Tu as les yeux de ta mère, mais tu as la bouche de quelqu\'un d\'autre. »\nElle me tutoie pour la première fois. Une seule fois.\nPuis elle repart, droite, comme si elle n\'avait rien dit.',
          coda: '(Un tutoiement chez Madame Heng, c\'est un aveu. Le seul qu\'elle se permettra.)',
        ),
        label: 'La phrase de Madame Heng, dans le couloir',
        requiresChoice: 'heng_phrase_j46',
      ),
      Beat(
        idx: 6,
        day: 47,
        hour: 11,
        minute: 0,
        label: 'Bureau de Madame Heng — « pas mon histoire à raconter »',
        transition: BeatTransition(
          timestamp: '11:00',
          body:
              '— De qui je tiens cette bouche, Madame ?\n'
              '— Mademoiselle Marchand. Ce n\'est pas mon histoire à raconter.\n'
              'Elle me ressert du thé. Ses mains sont parfaitement calmes.',
        ),
      ),
      Beat(
        idx: 7,
        day: 49,
        hour: 12,
        minute: 10,
        transition: BeatTransition(
          timestamp: '12:10',
          body: 'Vincent propose un déjeuner « entre nous ». Je décline.\nIl insiste avec la douceur des gens habitués à obtenir.\n« Tu montes vite, pour une fille de Belleville. »\nCe n\'est pas un compliment. Je réponds que je descends aussi bien.',
          coda: '(Il rit. Les Heng rient toujours une seconde trop tard.)',
        ),
        label: 'Vincent tâte le terrain — déjeuner décliné',
      ),
      Beat(
        idx: 8,
        day: 52,
        hour: 18,
        minute: 8,
        transition: BeatTransition(
          timestamp: '18:08',
          body: 'Tristan me convoque comme on clôt un dossier.\n« Le contrat arrive à son terme. Tu es libre. »\n« Libre » dans sa bouche sonne comme un congé.\nMaman est sauvée. Le rôle est fini. Il reste moi, et je ne sais plus où je vis.',
          coda: '(Il me tend une enveloppe. Je ne l\'ouvre pas devant lui.)',
        ),
        label: 'Tristan annonce la fin du contrat',
        requiresChoice: 'tristan_fin_contrat_j52',
      ),
      Beat(
        idx: 9,
        day: 53,
        hour: 9,
        minute: 40,
        transition: BeatTransition(
          timestamp: '09:40',
          body: 'Un dossier sur le bureau de Tristan. « Shanghai — relocalisation ».\nIl part. Il ne me l\'a pas dit. Je l\'apprends par une chemise cartonnée.\nCamille dit que c\'est normal, qu\'on ne me devait rien.\nElle a raison. Ça n\'aide pas.',
          coda: '(On range les gens comme des dossiers. J\'étais dans le bon tiroir.)',
        ),
        label: 'Le dossier de Shanghai est sur son bureau',
        requiresChoice: 'camille_dossier_j53',
      ),
      Beat(
        idx: 10,
        day: 55,
        hour: 20,
        minute: 0,
        label: 'Six heures de vérité',
        transition: BeatTransition(
          timestamp: '20:00',
          body:
              'Arrêté deux jours avant l\'arrivée de Maman. Cinq ans de prison.\n'
              'Les lettres interceptées par sa famille. Mort en 2018, Fuzhou.\n'
              'Et une lettre de 2017 : « à ma fille que je n\'ai pas connue ».',
          coda: '(Je n\'ai pas pleuré. Trop sidérée pour pleurer.)',
        ),
      ),
      Beat(
        idx: 11,
        day: 58,
        hour: 21,
        minute: 30,
        transition: BeatTransition(
          timestamp: '21:30',
          body: 'Rue de Berri, deux étages, deux silences.\nOn se croise dans l\'ascenseur avec la politesse des inconnus.\nCe qu\'on a été tient dans un bonsoir poli.\nJe monte, il descend. C\'est peut-être plus honnête comme ça.',
          coda: '(La distance, ce n\'est pas l\'absence. C\'est pire : la présence sans rien.)',
        ),
        label: 'La distance — chacun son étage',
      ),
      Beat(
        idx: 12,
        day: 60,
        hour: 20,
        minute: 0,
        transition: BeatTransition(
          timestamp: '20:00',
          body: 'C\'est l\'anniversaire de Camille. Je ne suis pas là.\nJe regarde les photos arriver une par une sur l\'écran.\nElle a mis la robe que je lui ai offerte il y a deux ans.\nJe tape « joyeux anniversaire ». Je trouve ça maigre.',
          coda: '(On peut être seule dans trois cents mètres carrés. Surtout là.)',
        ),
        label: 'Anniversaire Camille — Shen est seule',
      ),
      Beat(
        idx: 13,
        day: 64,
        hour: 11,
        minute: 0,
        transition: BeatTransition(
          timestamp: '11:00',
          body: 'Le marché de Belleville, un dimanche. Les mêmes cageots, les mêmes cris.\nMaman marchande un kilo d\'oranges comme si de rien n\'était.\nElle va mieux. Le traitement tient. C\'est pour ça que j\'ai tout fait.\nJe porte les sacs. C\'est la seule chose simple de ma journée.',
          coda: '(Elle me glisse une orange dans la poche, comme quand j\'avais dix ans.)',
        ),
        label: 'Belleville, encore — le marché du dimanche',
      ),
      Beat(
        idx: 14,
        day: 69,
        hour: 21,
        minute: 0,
        transition: BeatTransition(
          timestamp: '21:00',
          body: 'Maman lit une lettre à la table de la cuisine.\nUne écriture chinoise que je ne sais plus déchiffrer.\nSes lèvres bougent sans bruit. Elle sourit, puis non.\nElle ne me dit pas ce qu\'il y a dedans. Pas encore.',
          coda: '(Certaines lettres mettent trente ans à arriver.)',
        ),
        label: 'Hélène lit la lettre',
        requiresChoice: 'maman_lettre_j69',
      ),
      Beat(
        idx: 15,
        day: 70,
        hour: 22,
        minute: 14,
        transition: BeatTransition(
          timestamp: '22:14',
          body: 'Résultats. Dr Aubin emploie le mot « stabilisé ».\nIl le dit prudemment, comme on prête quelque chose de fragile.\nMaman serre ma main sous la table, une seconde.\nJ\'ai gagné du temps. Le temps, c\'est tout ce que je voulais acheter.',
          coda: '(« Stabilisé. » J\'écris le mot dans mon carnet pour y croire.)',
        ),
        label: 'Bilan Maman — meilleur que prévu',
      ),
      Beat(
        idx: 16,
        day: 75,
        hour: 9,
        minute: 30,
        transition: BeatTransition(
          timestamp: '09:30',
          body: 'Tante Mei envoie des photos d\'une cour à Fujian.\nUn kaki qui perd ses feuilles. Un banc. Un mur ocre.\nMaman regarde longtemps l\'écran, sans parler.\n« C\'est là que ton père a dit qu\'il partait », dit-elle enfin.',
          coda: '(Un arbre à onze mille kilomètres, et soudain toute la maison le regarde.)',
        ),
        label: 'Des photos de la cour — le kaki de Tante Mei',
      ),
      Beat(
        idx: 17,
        day: 78,
        hour: 19,
        minute: 32,
        transition: BeatTransition(
          timestamp: '19:32',
          body: 'Tante Mei rappelle. Sa voix a l\'accent de l\'enfance de Maman.\n« Venez. Toi et ta mère. Avant l\'hiver. 家里等你们。 (La maison vous attend.) »\nElle ne demande pas si c\'est possible. Elle dit que c\'est l\'heure.\nMaman, à côté, fait semblant de ne pas espérer.',
          coda: '(Une invitation qui ressemble à une convocation du sang.)',
        ),
        label: 'Tante Mei rappelle — invitation Fujian',
        requiresChoice: 'mei_invitation_j78',
      ),
    ],
  ),
  // ── Épisode 5 — Fujian — J80 → J112 ────────────────────────────
  Episode(
    id: 'fujian',
    number: 5,
    title: 'Fujian',
    subtitle: 'J80 → J112. Le parc. L\'épilogue.',
    beats: [
      Beat(
        idx: 0,
        day: 80,
        hour: 8,
        minute: 0,
        label: 'Vol Paris → Xiamen avec Maman',
        transition: BeatTransition(
          timestamp: '08:00',
          body:
              'Première fois que Maman remonte dans un avion.\n'
              'Première fois qu\'elle revient depuis 1998.\n'
              'Elle te tient la main au décollage.',
        ),
      ),
      Beat(
        idx: 1,
        day: 81,
        hour: 19,
        minute: 0,
        label: 'La route rouge — Fuzhou vers le village',
        transition: BeatTransition(
          timestamp: '19:00',
          body:
              'Trois heures de route. La terre devient rouge.\n'
              'Maman regarde par la fenêtre sans rien dire.\n'
              'Elle reconnaît des choses qu\'elle n\'a jamais vues.',
        ),
      ),
      Beat(
        idx: 2,
        day: 82,
        hour: 14,
        minute: 0,
        transition: BeatTransition(
          timestamp: '14:00',
          body: 'Le village au bout de la route rouge. Tante Mei a soixante-treize ans\net les mains de Maman en plus vieux.\nElle nous serre sans un mot, longtemps.\nLa maison sent le bois, le thé, et quelque chose que je reconnais sans savoir quoi.',
          coda: '(On revient toujours dans un endroit qu\'on n\'a jamais vu.)',
        ),
        label: 'Village ancestral — Tante Mei a 73 ans',
      ),
      Beat(
        idx: 3,
        day: 84,
        hour: 9,
        minute: 0,
        label: 'La tombe de Wenbo — trois bâtons d\'encens',
        transition: BeatTransition(
          timestamp: '09:00',
          body:
              'La fumée monte droit. C\'est bon signe, dit Tante Mei.\n'
              'Maman parle à la pierre en français, comme toujours.\n'
              'Je n\'entends pas ce qu\'elle dit. Je n\'ai pas besoin.',
        ),
      ),
      Beat(
        idx: 4,
        day: 86,
        hour: 16,
        minute: 0,
        transition: BeatTransition(
          timestamp: '16:00',
          body: 'Ma chambre, ici, n\'a jamais existé et pourtant elle m\'attendait.\nLe lit est étroit, la fenêtre donne sur la cour.\nSur une étagère, une photo de Papa jeune, avant la France, avant tout.\nJe m\'assois sur le lit. Il ne grince pas. Rien ici ne me juge.',
          coda: '(Pour la première fois depuis des mois, je n\'ai personne à devenir.)',
        ),
        label: 'La chambre d\'enfant — 心 gravé sur le chambranle',
      ),
      Beat(
        idx: 5,
        day: 88,
        hour: 17,
        minute: 0,
        label: 'Le parc — la promesse de Papa',
        transition: BeatTransition(
          timestamp: '17:00',
          body:
              'Maman te montre le parc.\n'
              'C\'est là que ton père lui a dit qu\'il partait à Paris.\n'
              'Tu n\'as jamais entendu cette histoire.',
        ),
      ),
      Beat(
        idx: 6,
        day: 91,
        hour: 20,
        minute: 30,
        transition: BeatTransition(
          timestamp: '20:30',
          body: 'Tante Mei sort une lettre de 2017. Papa l\'avait écrite, jamais envoyée.\nElle est pour moi. Mon prénom en haut, en chinois. Shen Miao.\nJe ne lis pas le chinois. Tante Mei traduit, ligne à ligne, sans se presser.\nPapa savait qu\'il partait. Il pensait revenir. Ils pensent tous revenir.',
          coda: '(Une lettre de mon père, huit ans après, dans une langue que j\'ai laissée filer.)',
        ),
        label: 'La lettre de 2017 — elle t\'attend',
        requiresChoice: 'mei_lettre_j91',
      ),
      Beat(
        idx: 7,
        day: 95,
        hour: 11,
        minute: 0,
        transition: BeatTransition(
          timestamp: '11:00',
          body: 'Un SMS de Tristan, depuis Shanghai. « Tu reviens ? »\nDeux mots. De lui, deux mots, c\'est presque un discours.\nLe kaki de la cour perd une feuille pendant que je lis.\nJe pose le téléphone à l\'envers sur la table. Je le laisse là.',
          coda: '(« Tu reviens ? » Il n\'a pas écrit « reviens ». La différence tient toute ma réponse.)',
        ),
        label: 'Tristan envoie un SMS — « tu reviens ? »',
        requiresChoice: 'tristan_revient_j95',
      ),
      Beat(
        idx: 8,
        day: 98,
        hour: 14,
        minute: 0,
        transition: BeatTransition(
          timestamp: '14:00',
          body: 'Tante Mei me donne le pinceau de calligraphie de mon père.\nLe manche est usé à l\'endroit exact où on tient.\n« Il écrivait mieux qu\'il ne parlait », dit-elle. Comme moi, je pense.\nJe ne sais pas m\'en servir. Je le garde quand même.',
          coda: '(On hérite d\'abord des gestes qu\'on ne sait pas faire.)',
        ),
        label: 'Le pinceau de Wenbo — les cadeaux de Tante Mei',
      ),
      Beat(
        idx: 9,
        day: 102,
        hour: 21,
        minute: 0,
        transition: BeatTransition(
          timestamp: '21:00',
          body: 'La cour, la nuit, un brasero. Maman brûle des lettres, une par une.\n« Trois cent douze », dit-elle. « J\'en ai écrit trois cent douze. »\nÀ Papa, à personne, à qui répond quand on n\'attend plus.\nElle m\'en tend une, la dernière, sans la brûler.',
          coda: '(Elle a écrit toute sa vie à un absent. Moi j\'ai menti une saison à une présente. On se ressemble.)',
        ),
        label: 'La 312e lettre — le brasero de la cour',
        requiresChoice: 'maman_312e_j102',
      ),
      Beat(
        idx: 10,
        day: 105,
        hour: 19,
        minute: 32,
        transition: BeatTransition(
          timestamp: '19:32',
          body: 'Camille appelle. Derrière elle, Paris fait du bruit.\n« Ta place est où, au juste ? »\nCe n\'est pas méchant. C\'est la seule vraie question depuis longtemps.\nJe regarde la cour, le kaki, Maman qui range. Je ne réponds pas tout de suite.',
          coda: '(La place, ce n\'est pas un lieu. Je commence seulement à le comprendre.)',
        ),
        label: 'Camille — « ta place est où ? »',
      ),
      Beat(
        idx: 11,
        day: 108,
        hour: 9,
        minute: 0,
        transition: BeatTransition(
          timestamp: '09:00',
          body: 'Deux valises ouvertes sur le lit. Vides.\nLe vol pour Paris est dans quatre jours. Ou dans une vie.\nJe plie une chemise, je la déplie. Je ne décide rien.\nDehors, Tante Mei chante quelque chose sans paroles.',
          coda: '(Une valise vide, c\'est la question posée à plat.)',
        ),
        label: 'Les valises ouvertes — rien dedans encore',
      ),
      Beat(
        idx: 12,
        day: 110,
        hour: 20,
        minute: 0,
        transition: BeatTransition(
          timestamp: '20:00',
          body: 'Vingt minutes au téléphone avec Camille. On ne parle de rien.\nOn rit comme avant, comme si aucun kilomètre.\nElle ne me demande pas de rentrer. C\'est pour ça que je pourrais.\nQuand elle raccroche, la cour est très silencieuse.',
          coda: '(Les gens qui ne te retiennent pas sont les seuls qu\'on veut rejoindre.)',
        ),
        label: 'Camille au téléphone — vingt minutes de rires',
      ),
      Beat(
        idx: 13,
        day: 112,
        hour: 7,
        minute: 14,
        label: 'Épilogue — choix final',
        requiresChoice: 'epilogue_j112',
        transition: BeatTransition(
          timestamp: '07:14',
          body:
              'Le bus passe à 11h pour Xiamen.\n'
              'L\'avion décolle à 17h pour Paris.\n'
              'Tu choisis ce que tu emportes.',
          coda: '(L\'écho dans le parc dit : « ma fille ».)',
        ),
      ),
    ],
  ),
];

/// Renvoie l'épisode par son id, ou null si introuvable.
Episode? episodeById(String id) {
  for (final e in kEpisodes) {
    if (e.id == id) return e;
  }
  return null;
}

/// Renvoie le beat actif (ou null si l'index est hors limites).
Beat? beatAt({required String episodeId, required int beatIdx}) {
  final ep = episodeById(episodeId);
  if (ep == null) return null;
  if (beatIdx < 0 || beatIdx >= ep.beats.length) return null;
  return ep.beats[beatIdx];
}

/// Calcule (episodeId, beatIdx) du beat juste après le couple passé.
/// Si on est sur le dernier beat de l'épisode, on passe à l'épisode
/// suivant (beatIdx = 0). Si on est sur le dernier beat du dernier
/// épisode, on renvoie le même couple (fin de l'histoire).
({String episodeId, int beatIdx}) nextBeat({
  required String episodeId,
  required int beatIdx,
}) {
  final ep = episodeById(episodeId);
  if (ep == null) {
    return (episodeId: kEpisodes.first.id, beatIdx: 0);
  }
  // Beat suivant dans le même épisode ?
  if (beatIdx + 1 < ep.beats.length) {
    return (episodeId: episodeId, beatIdx: beatIdx + 1);
  }
  // Épisode suivant — on saute aussi les épisodes vides (scaffolds).
  final idx = kEpisodes.indexWhere((e) => e.id == episodeId);
  for (var i = idx + 1; i < kEpisodes.length; i++) {
    if (kEpisodes[i].beats.isNotEmpty) {
      return (episodeId: kEpisodes[i].id, beatIdx: 0);
    }
  }
  // Plus rien — on reste sur le dernier beat connu.
  return (episodeId: episodeId, beatIdx: beatIdx);
}
