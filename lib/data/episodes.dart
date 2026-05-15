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
        transition: BeatTransition(
          timestamp: '08:17',
          body:
              'Je n\'ai pas vu la voiture noire.\n'
              'J\'ai vu le bowl en l\'air.\n'
              'Quand j\'ai relevé la tête, l\'homme du costume\n'
              'était déjà parti.',
          coda: '(Une carte. Quatre morceaux. Dans la flaque.)',
        ),
      ),
      Beat(
        idx: 2,
        day: 1,
        hour: 23,
        minute: 42,
        label: 'Carte recollée — première erreur',
        transition: BeatTransition(
          timestamp: '23:42',
          body:
              'Le scotch transparent ne tient pas.\n'
              'Je recommence. Quatre morceaux.\n'
              'Le « T » de Tristan refuse de se réaligner.',
          coda: '(Dehors, le chien du voisin hurle.)',
        ),
      ),
      Beat(
        idx: 3,
        day: 2,
        hour: 6,
        minute: 30,
        label: 'Tenon — bureau du Dr Aubin',
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
        hour: 23,
        minute: 55,
        label: 'Numéro masqué — T. appelle',
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
        idx: 6,
        day: 4,
        hour: 14,
        minute: 2,
        label: 'Camille pousse à rappeler',
        requiresChoice: 'camille_carte_j4',
      ),
      Beat(
        idx: 7,
        day: 6,
        hour: 14,
        minute: 12,
        label: 'Heng International — Mlle Marchand',
        requiresChoice: 'tristan_rdv_j6',
      ),
      Beat(
        idx: 8,
        day: 6,
        hour: 17,
        minute: 42,
        label: 'Camille apporte le tailleur',
        requiresChoice: 'camille_tailleur_j6',
      ),
      Beat(
        idx: 9,
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
        idx: 10,
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
        idx: 11,
        day: 9,
        hour: 17,
        minute: 22,
        label: 'Emménagement — Avenue Foch',
      ),
      // — Acte C : Vie commune (J11 → J14, cliffhanger Long Jing)
      Beat(
        idx: 12,
        day: 11,
        hour: 21,
        minute: 8,
        label: 'Premier mensonge — Lao Chen, paysagiste',
        requiresChoice: 'maman_stage_j11',
      ),
      Beat(
        idx: 13,
        day: 13,
        hour: 15,
        minute: 8,
        label: 'Camille — « QUEL THÉ ? »',
        requiresChoice: 'camille_quel_the_j13',
      ),
      Beat(
        idx: 14,
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

  // ── Épisodes 2-5 — PAYANTS, scaffolds à écrire ───────────────────
  Episode(
    id: 'routine_du_mensonge',
    number: 2,
    title: 'La routine du mensonge',
    subtitle: 'J15 → J30. Shen tient deux vies. Maman commence à douter.',
    beats: [],
  ),
  Episode(
    id: 'hong_kong',
    number: 3,
    title: 'Hong Kong',
    subtitle: 'J30 → J50. Le voyage. Le secret remonte à la surface.',
    beats: [],
  ),
  Episode(
    id: 'retour',
    number: 4,
    title: 'Retour',
    subtitle: 'J50 → J80. Paris, Maman en crise, Camille à distance.',
    beats: [],
  ),
  Episode(
    id: 'fujian',
    number: 5,
    title: 'Fujian',
    subtitle: 'J80 → J112. Le parc. L\'épilogue.',
    beats: [],
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
