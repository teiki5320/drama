import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/messages_data.dart';

/// Réponse envoyée par Shen pour un beat précis.
class SentReply {
  final String contactId;
  final String beatId;
  final String text;
  final String time; // "07:48"
  final int day;

  const SentReply({
    required this.contactId,
    required this.beatId,
    required this.text,
    required this.time,
    required this.day,
  });

  Msg toMsg() => Msg(
        sender: 'moi',
        text: text,
        time: time,
        day: day,
      );
}

/// Réponses Shen indexées par beatId (un seul choix possible par beat).
final sentRepliesProvider =
    StateNotifierProvider<SentRepliesNotifier, Map<String, SentReply>>(
  (ref) => SentRepliesNotifier(),
);

class SentRepliesNotifier extends StateNotifier<Map<String, SentReply>> {
  SentRepliesNotifier() : super(const {});

  void send(SentReply reply) {
    state = {...state, reply.beatId: reply};
  }

  bool isReplied(String beatId) => state.containsKey(beatId);

  /// Renvoie les réponses pour un contact donné.
  Iterable<SentReply> forContact(String contactId) =>
      state.values.where((r) => r.contactId == contactId);

  /// Hydrate depuis shared_preferences au démarrage.
  void hydrate(Map<String, SentReply> r) => state = r;

  /// Reset (Réglages > Reset partie).
  void reset() => state = const {};
}
