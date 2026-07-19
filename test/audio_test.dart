import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

import 'package:drama/src/music.dart';

void main() {
  test('chaque morceau marqué disponible existe dans assets/audio', () {
    for (final t in kTracks) {
      final exists = File('assets/audio/${t.file}').existsSync();
      expect(exists, t.dispo,
          reason: '${t.file} : dispo=${t.dispo} mais existe=$exists');
    }
  });

  test('les trois sons de messagerie existent', () {
    for (final f in ['sfx_recu.wav', 'sfx_envoye.wav', 'sfx_banniere.wav']) {
      expect(File('assets/audio/$f').existsSync(), isTrue, reason: f);
    }
  });
}
