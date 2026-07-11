import 'package:flutter_test/flutter_test.dart';

import 'package:contre_jour/data/messages_data.dart';
import 'package:contre_jour/providers/sent_replies_provider.dart';
import 'package:contre_jour/ui/phone/apps/messages/thread_view.dart';
import 'package:contre_jour/ui/phone/widgets/home_widgets.dart';

/// Tests de régression sur les deux bugs d'ouverture signalés en jouant :
///  1. la bannière « Traitement Maman · 18 000 € » qui spoilait dès J1 ;
///  2. le fil de Maman qui déroulait toute la journée d'un bloc au lieu de
///     se figer sur le choix en attente.
/// On teste la LOGIQUE PURE (extraite des widgets) sur les vraies données.
void main() {
  group('deadlineBannerVisible — pas de spoiler 18 000 € avant J2', () {
    test('masquée à J1 (rien n\'est encore révélé)',
        () => expect(deadlineBannerVisible(1), isFalse));
    test('visible à J2 (révélation Dr Aubin)',
        () => expect(deadlineBannerVisible(2), isTrue));
    test('visible en approche (J44)',
        () => expect(deadlineBannerVisible(44), isTrue));
    test('masquée bien après la deadline (J51)',
        () => expect(deadlineBannerVisible(51), isFalse));
  });

  group('computeThreadRender — le fil se fige sur le choix (données réelles)', () {
    final maman = kThreads['maman']!;

    test('J1 sans réponse : choix petit-déj en attente, la suite est masquée',
        () {
      final r = computeThreadRender(
          thread: maman, sentReplies: const {}, day: 1, suspicion: 0);
      expect(r.pendingBeatId, 'maman_petit_dej_j1');
      // Le dernier message visible EST le message-clé du choix.
      expect(r.messages.last.text, contains('Donne-moi un détail'));
      // Rien de ce qui vient plus tard dans la journée n'apparaît.
      final texts = r.messages.map((m) => m.text).join(' | ');
      expect(texts, isNot(contains('Bonne nuit')));
      expect(texts, isNot(contains('Tu rentres ce soir')));
      expect(texts, isNot(contains('déjeuné')));
    });

    test('après réponse au petit-déj : la réponse s\'intercale, le fil avance',
        () {
      const replies = {
        'maman_petit_dej_j1': SentReply(
          contactId: 'maman',
          beatId: 'maman_petit_dej_j1',
          text: 'Pain au chocolat de la veille.',
          time: '08:16',
          day: 1,
        ),
      };
      final r = computeThreadRender(
          thread: maman, sentReplies: replies, day: 1, suspicion: 0);
      // La réponse de Shen apparaît bien dans le fil.
      expect(
          r.messages.any(
              (m) => m.sender == 'moi' && m.text.contains('Pain au chocolat')),
          isTrue);
      // Le choix suivant (couvre-toi) devient le nouveau point d'arrêt.
      expect(r.pendingBeatId, 'maman_couvre_toi_j1');
      // La fin de journée reste masquée.
      expect(r.messages.map((m) => m.text).join(' '),
          isNot(contains('Bonne nuit')));
    });
  });

  group('computeThreadRender — cas synthétiques (logique isolée)', () {
    test('filtre de suspicion : un message parano reste caché sous le seuil',
        () {
      const thread = [
        Msg(sender: 'maman', text: 'Bonjour', time: '08:00', day: 1),
        Msg(
          sender: 'maman',
          text: 'PARANO',
          time: '09:00',
          day: 1,
          requiresSuspicionAtLeast: 30,
        ),
      ];
      final low = computeThreadRender(
          thread: thread, sentReplies: const {}, day: 1, suspicion: 10);
      final high = computeThreadRender(
          thread: thread, sentReplies: const {}, day: 1, suspicion: 40);
      expect(low.messages.map((m) => m.text), isNot(contains('PARANO')));
      expect(high.messages.map((m) => m.text), contains('PARANO'));
    });

    test('filtre par jour : les messages futurs ne sont pas visibles', () {
      const thread = [
        Msg(sender: 'maman', text: 'Aujourd\'hui', time: '08:00', day: 1),
        Msg(sender: 'maman', text: 'Demain', time: '08:00', day: 2),
      ];
      final r = computeThreadRender(
          thread: thread, sentReplies: const {}, day: 1, suspicion: 0);
      expect(r.messages.map((m) => m.text), contains('Aujourd\'hui'));
      expect(r.messages.map((m) => m.text), isNot(contains('Demain')));
    });

    test('sans choix en attente : aucune troncature', () {
      const thread = [
        Msg(sender: 'maman', text: 'A', time: '08:00', day: 1),
        Msg(sender: 'maman', text: 'B', time: '09:00', day: 1),
        Msg(sender: 'maman', text: 'C', time: '10:00', day: 1),
      ];
      final r = computeThreadRender(
          thread: thread, sentReplies: const {}, day: 1, suspicion: 0);
      expect(r.pendingBeatId, isNull);
      expect(r.messages.length, 3);
    });
  });
}
