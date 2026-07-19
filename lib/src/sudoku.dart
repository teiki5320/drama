import 'dart:math';

/// Générateur et vérificateur de sudoku — Dart pur, sans dépendance.
class SudokuGame {
  SudokuGame(this.puzzle, this.solution)
      : cells = [
          for (final row in puzzle) [...row],
        ];

  /// La grille de départ (0 = case vide).
  final List<List<int>> puzzle;

  /// La solution complète.
  final List<List<int>> solution;

  /// L'état courant rempli par le joueur.
  final List<List<int>> cells;

  bool isGiven(int r, int c) => puzzle[r][c] != 0;

  bool get complete {
    for (var r = 0; r < 9; r++) {
      for (var c = 0; c < 9; c++) {
        if (cells[r][c] != solution[r][c]) return false;
      }
    }
    return true;
  }

  /// La valeur en (r,c) entre-t-elle en conflit avec une autre case remplie ?
  bool conflict(int r, int c) {
    final v = cells[r][c];
    if (v == 0) return false;
    for (var i = 0; i < 9; i++) {
      if (i != c && cells[r][i] == v) return true;
      if (i != r && cells[i][c] == v) return true;
    }
    final br = (r ~/ 3) * 3, bc = (c ~/ 3) * 3;
    for (var i = br; i < br + 3; i++) {
      for (var j = bc; j < bc + 3; j++) {
        if ((i != r || j != c) && cells[i][j] == v) return true;
      }
    }
    return false;
  }

  // ------------------------------------------------------------ génération

  /// Génère une grille à solution unique avec [givens] cases révélées
  /// (36 = facile, 30 = moyen, 25 = difficile).
  static SudokuGame generate(int givens, {Random? rng}) {
    final r = rng ?? Random();
    final solution = _solvedGrid(r);
    final puzzle = [
      for (final row in solution) [...row],
    ];
    final positions = [for (var i = 0; i < 81; i++) i]..shuffle(r);
    var filled = 81;
    for (final pos in positions) {
      if (filled <= givens) break;
      final row = pos ~/ 9, col = pos % 9;
      final saved = puzzle[row][col];
      puzzle[row][col] = 0;
      if (_countSolutions(puzzle, cap: 2) == 1) {
        filled--;
      } else {
        puzzle[row][col] = saved;
      }
    }
    return SudokuGame(puzzle, solution);
  }

  static List<List<int>> _solvedGrid(Random r) {
    final grid = List.generate(9, (_) => List.filled(9, 0));
    bool fill(int pos) {
      if (pos == 81) return true;
      final row = pos ~/ 9, col = pos % 9;
      final digits = [1, 2, 3, 4, 5, 6, 7, 8, 9]..shuffle(r);
      for (final d in digits) {
        if (_fits(grid, row, col, d)) {
          grid[row][col] = d;
          if (fill(pos + 1)) return true;
          grid[row][col] = 0;
        }
      }
      return false;
    }

    fill(0);
    return grid;
  }

  static bool _fits(List<List<int>> g, int row, int col, int d) {
    for (var i = 0; i < 9; i++) {
      if (g[row][i] == d || g[i][col] == d) return false;
    }
    final br = (row ~/ 3) * 3, bc = (col ~/ 3) * 3;
    for (var i = br; i < br + 3; i++) {
      for (var j = bc; j < bc + 3; j++) {
        if (g[i][j] == d) return false;
      }
    }
    return true;
  }

  static int _countSolutions(List<List<int>> g, {int cap = 2}) {
    var count = 0;
    bool solve(int pos) {
      if (pos == 81) {
        count++;
        return count >= cap;
      }
      final row = pos ~/ 9, col = pos % 9;
      if (g[row][col] != 0) return solve(pos + 1);
      for (var d = 1; d <= 9; d++) {
        if (_fits(g, row, col, d)) {
          g[row][col] = d;
          final stop = solve(pos + 1);
          g[row][col] = 0;
          if (stop) return true;
        }
      }
      return false;
    }

    solve(0);
    return count;
  }
}
