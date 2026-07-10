import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _kAppsOpenedKey = 'apps_opened_v1';

/// Set d'apps déjà ouvertes par le joueur — persisté en
/// shared_preferences. Quand le joueur ouvre une app pour la première
/// fois, on affiche un petit popup d'explication, puis on ajoute son
/// id à ce set pour ne plus le remontrer.
final appsOpenedProvider =
    StateNotifierProvider<AppsOpenedNotifier, Set<String>>(
  (ref) => AppsOpenedNotifier(),
);

class AppsOpenedNotifier extends StateNotifier<Set<String>> {
  AppsOpenedNotifier() : super(const {}) {
    _load();
  }

  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    state = (p.getStringList(_kAppsOpenedKey) ?? const []).toSet();
  }

  Future<void> markOpened(String appId) async {
    if (state.contains(appId)) return;
    state = {...state, appId};
    final p = await SharedPreferences.getInstance();
    await p.setStringList(_kAppsOpenedKey, state.toList());
  }

  /// Réinitialise (utilisé par Réglages > Reset partie).
  Future<void> reset() async {
    state = const {};
    final p = await SharedPreferences.getInstance();
    await p.remove(_kAppsOpenedKey);
  }
}

/// Texte d'explication par app. Court, voix descriptive (pas Shen).
const Map<String, ({String title, String body})> kAppTutorials = {
  'messages': (
    title: 'Messages',
    body:
        'Le centre de gravité du jeu. Quand un SMS arrive avec un choix, '
        'trois boutons s\'affichent en bas de la conversation. Réponds — '
        'le temps avance automatiquement.',
  ),
  'notes': (
    title: 'Notes',
    body:
        'Le journal intime de Shen. Bic vert, papier crème. Tu y trouveras '
        'des notes finalisées et des brouillons abandonnés. Tape l\'icône '
        'livre en haut pour passer en Mode Carnet (vue paysage).',
  ),
  'photos': (
    title: 'Photos',
    body:
        'Galerie de Shen. Pince pour zoomer sur une photo — au-delà de '
        '1.4×, des points blancs pulsent : tape-les pour révéler ce que '
        'Shen voit dedans.',
  ),
  'banque': (
    title: 'Banque',
    body:
        'Trois onglets : Compte (mouvements, solde), Investissement '
        '(cours des actions avec sparkline), Achats (catalogue qui se '
        'débloque selon ton mood et ta réputation).',
  ),
  'telephone': (
    title: 'Téléphone',
    body:
        'Journal des appels. Tape un voicemail pour lire la transcription '
        '— certains contiennent des indices que les SMS ne portent pas.',
  ),
  'whatsapp': (
    title: 'WhatsApp',
    body:
        'Le refuge. Tante Mei écrit en mandarin (traduction entre '
        'parenthèses). Camille a un canal off-record avec disparition '
        'après 7 jours — c\'est là qu\'on parle vraiment.',
  ),
  'calendrier': (
    title: 'Calendrier',
    body:
        'Les rendez-vous fixés dans le scénario. La deadline du traitement '
        'de Maman (J45, 18 000 €) y est marquée en rouge.',
  ),
  'ubereats': (
    title: 'Uber Eats',
    body:
        'L\'app pro de Shen. Mode Livreur jusqu\'à J8 : accepter / refuser '
        'des courses. À partir de J9, le compte est suspendu — mode '
        'Commande uniquement.',
  ),
  'instagram': (
    title: 'Instagram',
    body:
        'Les stories tournent en 24 h. Tape une story pour la voir en '
        'plein écran. Double-tap un post pour aimer. ⋯ permet de masquer '
        'un compte.',
  ),
  'tinder': (
    title: 'Tinder',
    body:
        'Soir de désespoir. Swipe horizontal pour rejeter / aimer, swipe '
        'vers le haut pour ⭐ super-like, appui long pour voir le profil '
        'détaillé. Tu n\'es pas obligée d\'être là ce soir.',
  ),
  'cloud': (
    title: 'Cloud',
    body:
        'Documents, ordonnances, lettres. Onglet « Récemment supprimés » '
        'pour récupérer ce que Shen aurait préféré oublier — c\'est '
        'souvent là qu\'on trouve le plus.',
  ),
  'reglages': (
    title: 'Réglages',
    body:
        'Voir l\'épisode et le beat courants, ton mood et ta réputation, '
        'le total dépensé. Bouton « Réinitialiser la partie » en rouge en '
        'bas.',
  ),
  'appstore': (
    title: 'App Store',
    body:
        'Installe ou désinstalle les apps. Certaines (Spotify, '
        'Plans) ne sont pas là par défaut — à toi de les obtenir.',
  ),
  'camera': (
    title: 'Caméra',
    body:
        'Mode mémoire. Capture l\'instant courant — Shen génère une vraie '
        'image selon son mood et l\'heure, avec une caption automatique. '
        'Les clichés rejoignent Photos sous « Juin · Caméra ».',
  ),
};
