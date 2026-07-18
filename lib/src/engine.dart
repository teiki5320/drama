import 'dart:async';

import 'package:flutter/material.dart';

import 'models.dart';
import 'prologue.dart';

/// Les contacts du prologue.
const List<ThreadDef> kThreadDefs = [
  ThreadDef(
    id: 'maman',
    name: 'Maman ❤️',
    headerName: 'Maman',
    initials: 'M',
    gradientTop: Color(0xFFE8637C),
    gradientBottom: Color(0xFFD14A66),
  ),
  ThreadDef(
    id: 'camille',
    name: 'Camille',
    headerName: 'Camille',
    initials: 'C',
    gradientTop: Color(0xFFF0A24A),
    gradientBottom: Color(0xFFE0832C),
  ),
  ThreadDef(
    id: 'plateforme',
    name: 'Livraisons Pro',
    headerName: 'Livraisons Pro',
    initials: 'LP',
    gradientTop: Color(0xFF37B24D),
    gradientBottom: Color(0xFF2C9440),
  ),
  ThreadDef(
    id: 'inconnu',
    name: 'Numéro inconnu',
    headerName: 'Numéro inconnu',
    initials: '?',
    gradientTop: Color(0xFF9BA0AB),
    gradientBottom: Color(0xFF7A8090),
    hiddenAtStart: true,
  ),
];

/// Le moteur du jeu : l'état des fils, la bannière, l'horloge du récit,
/// et les primitives que le script du prologue utilise.
class GameEngine extends ChangeNotifier {
  GameEngine({this.delayScale = 1.0}) {
    for (final def in kThreadDefs) {
      threads[def.id] = ThreadState(def);
    }
    threads['camille']!
      ..preview = 'regarde ce meme, c’est TOI 😭 — dors un peu, promis ?'
      ..previewTime = 'Hier';
    threads['plateforme']!
      ..preview = 'Paiement hebdomadaire : 214,60 €.'
      ..previewTime = 'Hier';
  }

  /// Facteur sur toutes les attentes (0 dans les tests).
  final double delayScale;

  final Map<String, ThreadState> threads = {};

  String? currentThreadId;
  bool locked = true;
  bool ended = false;
  String gameClock = '07:46';
  BannerData? banner;

  int _bannerSeq = 0;
  bool _started = false;
  Future<void>? prologueFuture;

  ThreadState thread(String id) => threads[id]!;

  List<ThreadState> get visibleThreads =>
      kThreadDefs.map((d) => threads[d.id]!).where((t) => !t.hidden).toList();

  // ---------------------------------------------------------------- cycle

  /// Déverrouille le téléphone et lance le prologue (une seule fois).
  void unlock() {
    locked = false;
    notifyListeners();
    if (!_started) {
      _started = true;
      prologueFuture = runPrologue(this);
    }
  }

  /// Lance le prologue sans passer par l'écran verrouillé (tests).
  Future<void> playForTest() {
    locked = false;
    _started = true;
    prologueFuture = runPrologue(this);
    return prologueFuture!;
  }

  // ------------------------------------------------------------ navigation

  void openThread(String id) {
    currentThreadId = id;
    final t = thread(id);
    t.unread = 0;
    if (banner != null && banner!.threadId == id) banner = null;
    notifyListeners();
  }

  void goHome() {
    currentThreadId = null;
    notifyListeners();
  }

  // ------------------------------------------------------------ primitives

  Future<void> sleep(int ms) =>
      Future.delayed(Duration(milliseconds: (ms * delayScale).round()));

  void setClock(String value) {
    gameClock = value;
    notifyListeners();
  }

  void separator(String tid, String label) {
    thread(tid).messages.add(Msg.separator(label));
    notifyListeners();
  }

  void sysline(String tid, String text) {
    thread(tid).messages.add(Msg.sysline(text));
    notifyListeners();
  }

  /// Message entrant : indicateur d'écriture si le fil est ouvert,
  /// sinon livraison silencieuse + badge non lu + bannière.
  Future<void> incoming(String tid, String text, {int typing = 1600}) async {
    final t = thread(tid);
    t.hidden = false;
    if (currentThreadId == tid) {
      final m = Msg.incoming('', typing: true);
      t.messages.add(m);
      notifyListeners();
      await sleep(typing);
      m.typing = false;
      m.text = text;
    } else {
      await sleep(typing);
      t.messages.add(Msg.incoming(text));
      t.unread++;
      _showBanner(t, text);
    }
    t.preview = text;
    t.previewTime = gameClock;
    notifyListeners();
  }

  /// Fait apparaître « en train d'écrire… » sans jamais envoyer de message.
  Future<void> typingThenNothing(String tid, {int ms = 2600}) async {
    final t = thread(tid);
    if (currentThreadId == tid) {
      final m = Msg.incoming('', typing: true);
      t.messages.add(m);
      notifyListeners();
      await sleep(ms);
      t.messages.remove(m);
      notifyListeners();
      await sleep(1200);
    } else {
      await sleep(ms);
    }
  }

  Msg outgoing(String tid, String text) {
    final t = thread(tid);
    final m = Msg.outgoing(text)..receipt = 'Distribué';
    t.messages.add(m);
    t.lastOutgoing = m;
    t.preview = text;
    t.previewTime = gameClock;
    notifyListeners();
    return m;
  }

  /// Passe le dernier message envoyé du fil en « Lu ».
  void markRead(String tid) {
    final m = thread(tid).lastOutgoing;
    if (m != null) {
      m.receipt = 'Lu';
      notifyListeners();
    }
  }

  /// Propose des réponses au joueur et attend son choix.
  Future<ChoiceOption> choice(String tid, List<ChoiceOption> options) {
    final t = thread(tid);
    final pending = PendingChoice(options);
    t.pending = pending;
    if (currentThreadId != tid) {
      _showBanner(t, 'En attente de ta réponse…');
    }
    notifyListeners();
    return pending.completer.future;
  }

  /// Appelé par l'interface quand le joueur touche une réponse.
  void resolveChoice(String tid, ChoiceOption option) {
    final t = thread(tid);
    final pending = t.pending;
    if (pending == null) return;
    t.pending = null;
    if (!option.silent) {
      outgoing(tid, option.label);
    } else {
      notifyListeners();
    }
    pending.completer.complete(option);
  }

  void endPrologue() {
    ended = true;
    thread('inconnu').messages.add(Msg.endCard());
    notifyListeners();
  }

  // -------------------------------------------------------------- bannière

  void _showBanner(ThreadState t, String text) {
    if (currentThreadId == t.def.id) return;
    final seq = ++_bannerSeq;
    banner = BannerData(threadId: t.def.id, text: text, seq: seq);
    notifyListeners();
    Timer(Duration(milliseconds: (4200 * delayScale).round()), () {
      if (banner?.seq == seq) {
        banner = null;
        notifyListeners();
      }
    });
  }
}
