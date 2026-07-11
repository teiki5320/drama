import '../providers/sent_replies_provider.dart';
import 'messages_data.dart';
import 'sms_choices.dart';

/// Résultat du calcul d'affichage d'un fil : messages visibles (déjà
/// tronqués au choix en attente) + le beat/message en attente s'il y en a un.
class ThreadRender {
  final List<Msg> messages;
  final String? pendingBeatId;
  final Msg? pendingMsg;
  const ThreadRender(this.messages, this.pendingBeatId, this.pendingMsg);
}

/// Logique PURE de rendu d'un fil (testable, partagée par la vue conversation,
/// la liste Messages et le widget home Maman) :
/// - filtre par jour courant et seuil de suspicion ;
/// - intercale les réponses déjà envoyées de Shen après leur beat ;
/// - détecte le PREMIER choix non répondu et TRONQUE tout ce qui suit, pour
///   que la conversation se fige sur la décision au lieu de dérouler la
///   journée entière d'un bloc. Le dernier message visible sert aussi
///   d'aperçu (liste + widget), au lieu du dernier message du JOUR.
ThreadRender computeThreadRender({
  required List<Msg> thread,
  required Map<String, SentReply> sentReplies,
  required int day,
  required int suspicion,
}) {
  final canonMsgs = thread
      .where((m) =>
          m.day <= day &&
          (m.requiresSuspicionAtLeast == null ||
              suspicion >= m.requiresSuspicionAtLeast!))
      .toList();
  final msgs = <Msg>[];
  for (final m in canonMsgs) {
    msgs.add(m);
    if (m.beatId != null && sentReplies.containsKey(m.beatId!)) {
      msgs.add(sentReplies[m.beatId!]!.toMsg());
    }
  }
  Msg? pendingMsg;
  var pendingIdx = -1;
  for (var i = 0; i < msgs.length; i++) {
    final m = msgs[i];
    if (m.sender != 'moi' &&
        m.beatId != null &&
        choiceForBeat(m.beatId!) != null &&
        !sentReplies.containsKey(m.beatId!)) {
      pendingMsg = m;
      pendingIdx = i;
      break;
    }
  }
  if (pendingIdx >= 0) {
    msgs.removeRange(pendingIdx + 1, msgs.length);
  }
  return ThreadRender(msgs, pendingMsg?.beatId, pendingMsg);
}
