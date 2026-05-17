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
        unlocksApps: ['notes', 'banque'],
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
        unlocksApps: ['ubereats'],
      ),
      Beat(
        idx: 4,
        day: 3,
        hour: 14,
        minute: 23,
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
        label: 'Camille — « tu as gardé sa carte, hein »',
        requiresChoice: 'camille_carte_j4',
      ),
      Beat(
        idx: 9,
        day: 6,
        hour: 14,
        minute: 12,
        label: 'Heng International — Mlle Marchand',
        requiresChoice: 'tristan_rdv_j6',
      ),
      Beat(
        idx: 10,
        day: 6,
        hour: 17,
        minute: 42,
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
        label: 'Emménagement — Avenue Foch',
      ),
      // — Acte C : Vie commune (J11 → J14, cliffhanger Long Jing)
      Beat(
        idx: 14,
        day: 11,
        hour: 21,
        minute: 8,
        label: 'Premier mensonge — Lao Chen, paysagiste',
        requiresChoice: 'maman_stage_j11',
      ),
      Beat(
        idx: 15,
        day: 13,
        hour: 15,
        minute: 8,
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
        label: 'Dialyse Maman — silence dans la voiture',
      ),
      Beat(
        idx: 2,
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
        idx: 3,
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
        idx: 4,
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
        idx: 5,
        day: 23,
        hour: 19,
        minute: 32,
        label: 'Maman trouve une boîte de Long Jing chez Shen',
        requiresChoice: 'maman_long_jing_j23',
      ),
      Beat(
        idx: 6,
        day: 25,
        hour: 9,
        minute: 30,
        label: 'Dialyse Maman — Dr Aubin attire Shen à part',
      ),
      Beat(
        idx: 7,
        day: 26,
        hour: 22,
        minute: 14,
        label: 'Camille — « tu m\'as pas appelée depuis 8 jours »',
        requiresChoice: 'camille_distance_j26',
      ),
      Beat(
        idx: 8,
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
        idx: 9,
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
        day: 35,
        hour: 11,
        minute: 0,
        label: 'Tante Mei te repère via WhatsApp Heng',
        requiresChoice: 'mei_decouvre_j35',
        // Premier contact Tante Mei → WhatsApp apparaît.
        unlocksApps: ['whatsapp'],
      ),
      Beat(
        idx: 4,
        day: 36,
        hour: 10,
        minute: 0,
        label: '3e acompte Heng — 10 000 €',
      ),
      Beat(
        idx: 5,
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
        idx: 6,
        day: 38,
        hour: 23,
        minute: 32,
        label: 'Lan Kwai Fong — Tristan ivre dit ton vrai prénom',
      ),
      Beat(
        idx: 7,
        day: 39,
        hour: 7,
        minute: 14,
        label: 'Maman appelle 4h du matin Paris — Tante Mei a parlé',
        requiresChoice: 'maman_decouvre_j39',
      ),
      Beat(
        idx: 8,
        day: 40,
        hour: 8,
        minute: 0,
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
        label: 'Confrontation Maman — silence pendant 4h',
        requiresChoice: 'maman_confrontation_j42',
      ),
      Beat(
        idx: 2,
        day: 44,
        hour: 20,
        minute: 0,
        label: 'Camille apporte du café — pas de jugement',
      ),
      Beat(
        idx: 3,
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
        idx: 4,
        day: 52,
        hour: 18,
        minute: 8,
        label: 'Tristan annonce la fin du contrat',
        requiresChoice: 'tristan_fin_contrat_j52',
      ),
      Beat(
        idx: 5,
        day: 60,
        hour: 20,
        minute: 0,
        label: 'Anniversaire Camille — Shen est seule',
      ),
      Beat(
        idx: 6,
        day: 70,
        hour: 22,
        minute: 14,
        label: 'Bilan Maman — meilleur que prévu',
      ),
      Beat(
        idx: 7,
        day: 78,
        hour: 19,
        minute: 32,
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
        day: 82,
        hour: 14,
        minute: 0,
        label: 'Village ancestral — Tante Mei a 73 ans',
      ),
      Beat(
        idx: 2,
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
        idx: 3,
        day: 95,
        hour: 11,
        minute: 0,
        label: 'Tristan envoie un SMS — « tu reviens ? »',
        requiresChoice: 'tristan_revient_j95',
      ),
      Beat(
        idx: 4,
        day: 105,
        hour: 19,
        minute: 32,
        label: 'Camille — « ta place est où ? »',
      ),
      Beat(
        idx: 5,
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
