import 'dart:async';

import 'package:flutter_test/flutter_test.dart';

import 'package:drama/src/engine.dart';

/// Joue le prologue entier en résolvant chaque choix automatiquement.
Future<GameEngine> _playThrough({required int optionIndex}) async {
  final engine = GameEngine(delayScale: 0);
  engine.addListener(() {
    for (final t in engine.threads.values) {
      final pending = t.pending;
      if (pending != null) {
        scheduleMicrotask(() {
          if (t.pending == pending) {
            final options = pending.options;
            final i = optionIndex.clamp(0, options.length - 1);
            engine.resolveChoice(t.def.id, options[i]);
          }
        });
      }
    }
  });
  await engine.playForTest();
  return engine;
}

void main() {
  test('l’épisode 1 se joue jusqu’à la fin (premiers choix)', () async {
    final e = await _playThrough(optionIndex: 0);
    expect(e.ended, isTrue);
    final total =
        e.threads.values.fold<int>(0, (s, t) => s + t.messages.length);
    expect(total, greaterThan(90));
    expect(e.thread('inconnu').hidden, isFalse);
    expect(e.thread('aubin').hidden, isFalse);
    expect(e.thread('banque').hidden, isFalse);
    expect(e.gameClock, '22:40');
    // Des photos circulent régulièrement dans les conversations.
    final photos = e.threads.values
        .expand((t) => t.messages)
        .where((m) => m.imageAsset != null)
        .length;
    expect(photos, greaterThanOrEqualTo(10));
    // Premier choix au jour 4 : le contact Tristan est enregistré.
    expect(e.thread('inconnu').effectiveDef.name, 'Tristan H.');
    expect(e.thread('inconnu').contactKey, 'tristan');
  });

  test('l’épisode 1 se joue jusqu’à la fin (derniers choix, blocage inclus)',
      () async {
    final e = await _playThrough(optionIndex: 2);
    expect(e.ended, isTrue);
    // La branche « bloquer le numéro » : Tristan revient d'un autre numéro.
    final inconnu = e.thread('inconnu').messages;
    expect(
      inconnu.any((m) => m.text.contains('ne bloque pas ma mémoire')),
      isTrue,
    );
    // Dernier choix au jour 4 : le contact reste un numéro inconnu.
    expect(e.thread('inconnu').effectiveDef.name, 'Numéro inconnu');
  });

  test('un message reçu dans un fil fermé devient non lu + bannière', () async {
    final engine = GameEngine(delayScale: 0);
    await engine.incoming('camille', 'coucou', typing: 0);
    expect(engine.thread('camille').unread, 1);
    expect(engine.banner, isNotNull);
    engine.openThread('camille');
    expect(engine.thread('camille').unread, 0);
    expect(engine.banner, isNull);
  });
}
