import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

import 'package:drama/src/rewards.dart';
import 'package:drama/src/sudoku.dart';

bool _valide(List<List<int>> g) {
  for (var i = 0; i < 9; i++) {
    final row = <int>{}, col = <int>{};
    for (var j = 0; j < 9; j++) {
      if (g[i][j] < 1 || g[i][j] > 9) return false;
      if (!row.add(g[i][j]) || !col.add(g[j][i])) return false;
    }
  }
  for (var br = 0; br < 9; br += 3) {
    for (var bc = 0; bc < 9; bc += 3) {
      final box = <int>{};
      for (var i = 0; i < 3; i++) {
        for (var j = 0; j < 3; j++) {
          if (!box.add(g[br + i][bc + j])) return false;
        }
      }
    }
  }
  return true;
}

void main() {
  test('la grille générée est valide, partielle et résoluble', () {
    final game = SudokuGame.generate(36, rng: Random(42));
    expect(_valide(game.solution), isTrue);
    var givens = 0;
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        final v = game.puzzle[r][c];
        if (v != 0) {
          givens++;
          expect(v, game.solution[r][c],
              reason: 'une case révélée doit venir de la solution');
        }
      }
    }
    expect(givens, greaterThanOrEqualTo(36));
    expect(givens, lessThan(81));
  });

  test('remplir la solution gagne, un conflit se détecte', () {
    final game = SudokuGame.generate(36, rng: Random(7));
    expect(game.complete, isFalse);
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        game.cells[r][c] = game.solution[r][c];
      }
    }
    expect(game.complete, isTrue);
    // Introduit un doublon dans la première ligne.
    game.cells[0][0] = game.cells[0][1];
    expect(game.conflict(0, 0), isTrue);
    expect(game.complete, isFalse);
  });

  test('les récompenses suivent les victoires', () async {
    final r = Rewards.instance;
    final base = r.wins;
    expect(r.wallpaperDebloque(0), base >= 3);
    await r.addWin();
    expect(r.souvenirsDebloques,
        (base + 1).clamp(0, kSouvenirs.length));
    expect(kSouvenirs.length, 8);
    expect(kWallpapers.length, 3);
  });
}
