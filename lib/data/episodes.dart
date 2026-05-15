import '../models/episode.dart';

/// Catalogue des 6 épisodes — calque les 6 actes de la roadmap.
///
/// État au commit : les 3 premiers épisodes sont remplis avec les beats
/// qui correspondent au contenu narratif déjà écrit (J1 → J14). Les 3
/// derniers sont des scaffolds : structure prête, beats à compléter
/// quand on étendra le scénario.
const kEpisodes = <Episode>[
  // ── Épisode 1 ── Vendredi 3 juin → dimanche 5 juin ───────────────
  Episode(
    id: 'collision',
    number: 1,
    title: 'Collision',
    subtitle: 'Vendredi 3 juin, Avenue Montaigne. Un acaï renversé.',
    beats: [
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
      ),
      Beat(
        idx: 2,
        day: 1,
        hour: 23,
        minute: 42,
        label: 'Carte recollée — première erreur',
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
      ),
    ],
  ),

  // ── Épisode 2 ── Lundi 6 juin → vendredi 10 juin ─────────────────
  Episode(
    id: 'contrat',
    number: 2,
    title: 'Le contrat',
    subtitle: '47ᵉ étage de la Tour Heng. Trente mille euros, trois mois.',
    beats: [
      Beat(
        idx: 0,
        day: 4,
        hour: 14,
        minute: 2,
        label: 'Camille pousse à rappeler',
        requiresChoice: 'camille_carte_j4',
      ),
      Beat(
        idx: 1,
        day: 6,
        hour: 14,
        minute: 12,
        label: 'Heng International — Mlle Marchand',
        requiresChoice: 'tristan_rdv_j6',
      ),
      Beat(
        idx: 2,
        day: 6,
        hour: 17,
        minute: 42,
        label: 'Camille apporte le tailleur',
        requiresChoice: 'camille_tailleur_j6',
      ),
      Beat(
        idx: 3,
        day: 7,
        hour: 11,
        minute: 0,
        label: 'Tour Heng — proposition trois mois',
      ),
      Beat(
        idx: 4,
        day: 8,
        hour: 11,
        minute: 30,
        label: 'Cabinet notarial — 14 pages',
      ),
      Beat(
        idx: 5,
        day: 9,
        hour: 17,
        minute: 22,
        label: 'Emménagement — Avenue Foch',
      ),
    ],
  ),

  // ── Épisode 3 ── Lundi 13 juin → samedi 18 juin ──────────────────
  Episode(
    id: 'vie_commune',
    number: 3,
    title: 'Vie commune',
    subtitle: 'Long Jing deuxième récolte. Madame Heng dit « ma fille ».',
    beats: [
      Beat(
        idx: 0,
        day: 11,
        hour: 21,
        minute: 8,
        label: 'Premier mensonge — Lao Chen, paysagiste',
        requiresChoice: 'maman_stage_j11',
      ),
      Beat(
        idx: 1,
        day: 13,
        hour: 15,
        minute: 8,
        label: 'Camille — « QUEL THÉ ? »',
        requiresChoice: 'camille_quel_the_j13',
      ),
      Beat(
        idx: 2,
        day: 14,
        hour: 20,
        minute: 30,
        label: 'Dîner Madame Heng — Long Jing',
      ),
    ],
  ),

  // ── Épisodes 4-6 — Scaffolds, beats à écrire ────────────────────
  Episode(
    id: 'hong_kong',
    number: 4,
    title: 'Hong Kong',
    subtitle: 'Le voyage. Le secret remonte à la surface.',
    beats: [],
  ),
  Episode(
    id: 'retour',
    number: 5,
    title: 'Retour',
    subtitle: 'Paris, Maman en crise, Camille à distance.',
    beats: [],
  ),
  Episode(
    id: 'fujian',
    number: 6,
    title: 'Fujian',
    subtitle: 'Le parc. L\'épilogue.',
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
