import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/day_events.dart';
import '../data/episodes.dart';
import '../models/episode.dart';
import '../models/phone_state.dart';
import 'messages_arcs_provider.dart';
import 'romance_threads_provider.dart';
import 'transition_provider.dart';

/// Singleton Riverpod du PhoneState.
final phoneStateProvider =
    StateNotifierProvider<PhoneStateNotifier, PhoneState>(
  PhoneStateNotifier.new,
);

/// Provider qui expose le dernier événement déclenché — l'UI peut
/// l'observer pour afficher un banner notification quand il change.
final lastTriggeredEventProvider = StateProvider<DayEvent?>((ref) => null);

class PhoneStateNotifier extends StateNotifier<PhoneState> {
  PhoneStateNotifier(this._ref) : super(const PhoneState());

  /// Ref injectable pour permettre de déclencher des side-effects
  /// (notifs, badges).
  final Ref _ref;

  /// Recharge l'état depuis shared_preferences au démarrage.
  void hydrate(PhoneState s) => state = s;

  /// Force la valeur de mood (clampée 0-10). Utilisé par les arcs de
  /// romance Tinder pour appliquer un delta après un choix Shen.
  void setMood(int newMood) {
    state = state.copyWith(mood: newMood.clamp(0, 10));
  }

  /// Avance l'heure de `minutes`. Roule sur 24h. Déclenche les
  /// événements DayEvent qui tombent dans l'intervalle franchi.
  void advanceTime(int minutes) {
    final from = state;
    var total = from.hour * 60 + from.minute + minutes;
    final newDay = from.currentDay + (total ~/ (24 * 60));
    total %= 24 * 60;
    final h = total ~/ 60;
    final m = total % 60;
    state = state.copyWith(
      currentDay: newDay,
      hour: h,
      minute: m,
      dndEnabled: h >= 23 || h < 7,
    );
    _fireEventsBetween(
      fromDay: from.currentDay,
      fromHour: from.hour,
      fromMinute: from.minute,
      toDay: newDay,
      toHour: h,
      toMinute: m,
    );
    _tickRomances();
  }

  /// Passe au beat suivant — c'est ainsi qu'on progresse dans le scénario.
  /// Saute le temps du beat courant à celui d'après, déclenche les events
  /// éventuels et reverrouille l'écran si on passe une nuit.
  void advanceToNextBeat() {
    final from = state;
    final next = nextBeat(
      episodeId: from.currentEpisodeId,
      beatIdx: from.currentBeatIdx,
    );
    final beat = beatAt(episodeId: next.episodeId, beatIdx: next.beatIdx);
    if (beat == null) return; // fin de l'histoire
    final crossesNight = beat.day > from.currentDay;
    state = state.copyWith(
      currentEpisodeId: next.episodeId,
      currentBeatIdx: next.beatIdx,
      currentDay: beat.day,
      hour: beat.hour,
      minute: beat.minute,
      isLocked: crossesNight ? true : from.isLocked,
      dndEnabled: beat.hour >= 23 || beat.hour < 7,
      battery: crossesNight
          ? (from.battery - 15).clamp(0, 100)
          : (from.battery - 1).clamp(0, 100),
    );
    // Si le beat a une scène de transition, on l'affiche en overlay.
    // L'écran de transition se fermera tout seul (4.5 s) ou au tap.
    if (beat.transition != null) {
      _ref.read(beatTransitionProvider.notifier).state = beat.transition;
    }
    _fireEventsBetween(
      fromDay: from.currentDay,
      fromHour: from.hour,
      fromMinute: from.minute,
      toDay: beat.day,
      toHour: beat.hour,
      toMinute: beat.minute,
    );
    _tickRomances();
  }

  /// Avance les arcs romance Tinder + Messages arcs au temps courant.
  /// Appelé chaque fois que l'heure ou le beat change pour que tout
  /// vive en background sans qu'il faille ouvrir les apps.
  void _tickRomances() {
    try {
      _ref.read(romanceThreadsProvider.notifier).tickAll(
            day: state.currentDay,
            hour: state.hour,
            minute: state.minute,
          );
    } catch (_) {}
    try {
      _ref.read(messagesArcsProvider.notifier).tickAll(
            day: state.currentDay,
            hour: state.hour,
            minute: state.minute,
          );
      // Spawn aléatoire — petit % à chaque tick pour démarrer un arc
      _maybeSpawnMessagesArc();
    } catch (_) {}
  }

  /// Tente un spawn d'arc Messages quand l'heure tourne. Petit % par tick
  /// pour ne pas inonder le joueur.
  void _maybeSpawnMessagesArc() {
    // ~5 % de chance par tick
    if (DateTime.now().millisecondsSinceEpoch % 20 != 0) return;
    _ref.read(messagesArcsProvider.notifier).spawnRandom(
          day: state.currentDay,
          hour: state.hour,
          minute: state.minute,
        );
  }

  /// Si le beat courant attend une réponse SMS et que cette réponse
  /// vient d'arriver, on passe automatiquement au beat suivant. Appelé
  /// par PhoneShell quand `sentRepliesProvider` change.
  void maybeAdvanceAfterReply(String repliedBeatId) {
    final current = beatAt(
      episodeId: state.currentEpisodeId,
      beatIdx: state.currentBeatIdx,
    );
    if (current == null) return;
    if (current.requiresChoice != repliedBeatId) return;
    advanceToNextBeat();
  }

  /// Beat actuellement actif (utile pour le HUD plus tard).
  Beat? get currentBeat => beatAt(
        episodeId: state.currentEpisodeId,
        beatIdx: state.currentBeatIdx,
      );

  void _fireEventsBetween({
    required int fromDay,
    required int fromHour,
    required int fromMinute,
    required int toDay,
    required int toHour,
    required int toMinute,
  }) {
    final events = eventsBetween(
      fromDay: fromDay,
      fromHour: fromHour,
      fromMinute: fromMinute,
      toDay: toDay,
      toHour: toHour,
      toMinute: toMinute,
    );
    for (final e in events) {
      _fireEvent(e);
    }
  }

  void _fireEvent(DayEvent e) {
    // Pousse les badges
    final newBadges = Map<String, int>.from(state.badges);
    for (final appId in e.apps) {
      newBadges[appId] = (newBadges[appId] ?? 0) + 1;
    }
    state = state.copyWith(badges: newBadges);
    // Expose l'event pour que l'UI affiche un banner
    _ref.read(lastTriggeredEventProvider.notifier).state = e;
  }

  /// Passe au lendemain matin (réveil à 6h30 par défaut), reverrouille
  /// l'écran (= chaque jour commence sur le lock screen).
  void advanceDay() {
    state = state.copyWith(
      currentDay: state.currentDay + 1,
      hour: 6,
      minute: 30,
      isLocked: true,
      dndEnabled: false,
      clearOpenApp: true,
      battery: (state.battery - 15).clamp(0, 100),
    );
  }

  /// Recharge la batterie (geste diégétique, déclenché via Control Center
  /// quand on « branche » le téléphone).
  void plugCharger() =>
      state = state.copyWith(battery: 100);

  /// Toggle manuel du Ne Pas Déranger (Control Center).
  void toggleDnd() =>
      state = state.copyWith(dndEnabled: !state.dndEnabled);

  /// Déverrouille l'écran (swipe up depuis le lock screen).
  void unlock() => state = state.copyWith(isLocked: false);

  /// Reverrouille (bouton power, ou auto-lock après inactivité).
  void lock() => state = state.copyWith(isLocked: true, clearOpenApp: true);

  /// Ouvre une app (depuis le home screen).
  void openApp(String id) => state = state.copyWith(openAppId: id);

  /// Ferme l'app courante (retour home).
  void closeApp() => state = state.copyWith(clearOpenApp: true);

  /// Modifie le signal (Wi-Fi chez Heng, 5G livraison, none dans le métro).
  void setSignal(SignalType s) => state = state.copyWith(signal: s);

  /// Petite consommation batterie sur action (1-3% par action significative).
  void consumeBattery(int amount) =>
      state = state.copyWith(battery: (state.battery - amount).clamp(0, 100));

  /// Augmente le badge d'une app (nouvelle notif).
  void addBadge(String appId, [int n = 1]) {
    final badges = Map<String, int>.from(state.badges);
    badges[appId] = (badges[appId] ?? 0) + n;
    state = state.copyWith(badges: badges);
  }

  /// Vide le badge d'une app (l'utilisateur a vu).
  void clearBadge(String appId) {
    final badges = Map<String, int>.from(state.badges)..remove(appId);
    state = state.copyWith(badges: badges);
  }

  /// Débloque une app jusqu'ici cachée.
  void unlockApp(String appId) {
    final apps = {...state.unlockedApps, appId};
    state = state.copyWith(unlockedApps: apps);
  }

  /// Désinstalle une app (la cache du home, peut être réinstallée).
  void removeApp(String appId) {
    final apps = {...state.unlockedApps}..remove(appId);
    state = state.copyWith(unlockedApps: apps);
  }

  /// Pool d'images réelles assignées selon contexte mood/heure.
  /// Quand le joueur prend une photo via la Caméra, on choisit dans
  /// ce pool plutôt que de juste générer un placeholder gradient.
  static const _kPhotoPool = <String, List<String>>{
    'night_low': [
      'assets/photos/camera_pool/night_low_1.webp',
      'assets/photos/camera_pool/night_low_2.webp',
    ],
    'night_high': [
      'assets/photos/camera_pool/night_high_1.webp',
    ],
    'day_low': [
      'assets/photos/camera_pool/day_low_1.webp',
      'assets/photos/camera_pool/day_low_2.webp',
    ],
    'day_high': [
      'assets/photos/camera_pool/day_high_1.webp',
      'assets/photos/camera_pool/day_high_2.webp',
    ],
    'day_mid': [
      'assets/photos/camera_pool/day_mid_1.webp',
      'assets/photos/camera_pool/day_mid_2.webp',
    ],
  };

  /// Le joueur prend une photo via la Caméra. Sélectionne une image
  /// réelle depuis le pool selon (mood, heure), avec emoji + caption
  /// fallback narratif si aucune image disponible.
  UserPhoto takePhoto() {
    final hour = state.hour;
    final mood = state.mood;
    final isNight = hour >= 20 || hour < 6;
    final String key;
    if (isNight) {
      key = mood <= 4 ? 'night_low' : 'night_high';
    } else if (mood <= 4) {
      key = 'day_low';
    } else if (mood >= 8) {
      key = 'day_high';
    } else {
      key = 'day_mid';
    }
    final pool = _kPhotoPool[key] ?? [];
    final imagePath = pool.isEmpty
        ? null
        : pool[state.userPhotos.length % pool.length];
    // Emoji + gradient fallback
    final String emoji;
    if (mood <= 3) {
      emoji = isNight ? '🌑' : '🌫️';
    } else if (mood >= 8) {
      emoji = isNight ? '✨' : '☀️';
    } else {
      emoji = isNight ? '🌃' : '📷';
    }
    final gradient = mood <= 4
        ? [0xFF1F2937, 0xFF374151]
        : (isNight
            ? [0xFF1E2A4A, 0xFF4A3A55]
            : [0xFFE89B7F, 0xFFFCC9A1]);
    final captions = [
      'Le silence du téléphone, capturé par erreur.',
      'Je ne sais pas pourquoi j\'ai pris ça.',
      'Pour plus tard. Pour me souvenir.',
      'La lumière était bizarre ce moment-là.',
      'Je voulais le garder. Sans savoir quoi.',
    ];
    final caption = captions[(state.userPhotos.length) % captions.length];
    final photo = UserPhoto(
      day: state.currentDay,
      hour: hour,
      minute: state.minute,
      emoji: emoji,
      gradient: gradient,
      caption: caption,
      imagePath: imagePath,
    );
    state = state.copyWith(
      userPhotos: [...state.userPhotos, photo],
      battery: (state.battery - 1).clamp(0, 100),
    );
    return photo;
  }

  /// Achat d'un item du catalogue. Vérifie solde et seuils mood/réputation.
  /// Renvoie true si l'achat est passé.
  bool buyItem({
    required String id,
    required String name,
    required String emoji,
    required int price,
    required int moodGain,
    required int reputationGain,
  }) {
    final mvt = DynamicMovement(
      label: name,
      amount: -price,
      day: state.currentDay,
      time: state.timeLabel,
      emoji: emoji,
    );
    state = state.copyWith(
      ownedItems: {...state.ownedItems, id},
      dynamicMovements: [...state.dynamicMovements, mvt],
      mood: state.mood + moodGain,
      reputation: state.reputation + reputationGain,
      battery: (state.battery - 1).clamp(0, 100),
    );
    return true;
  }
}
