import 'package:flutter/material.dart';

import '../palette.dart';
import '../rewards.dart';
import '../sudoku.dart';

/// L'app Sudoku — le jeu anti-stress de Shen. Chaque grille terminée
/// débloque un souvenir dans la Galerie.
class SudokuScreen extends StatefulWidget {
  const SudokuScreen({super.key, required this.onBack, required this.onGallery});

  final VoidCallback onBack;
  final VoidCallback onGallery;

  @override
  State<SudokuScreen> createState() => _SudokuScreenState();
}

/// La partie en cours survit aux allers-retours entre apps (le temps
/// d'une session).
SudokuGame? _session;

class _SudokuScreenState extends State<SudokuScreen> {
  int? _selRow;
  int? _selCol;
  bool _won = false;

  void _newGame(int givens) {
    setState(() {
      _session = SudokuGame.generate(givens);
      _selRow = null;
      _selCol = null;
      _won = false;
    });
  }

  void _tapCell(int r, int c) {
    if (_won) return;
    setState(() {
      _selRow = r;
      _selCol = c;
    });
  }

  Future<void> _enter(int value) async {
    final g = _session;
    final r = _selRow, c = _selCol;
    if (g == null || r == null || c == null || g.isGiven(r, c) || _won) return;
    setState(() => g.cells[r][c] = value);
    if (value != 0 && g.complete) {
      _won = true;
      await Rewards.instance.addWin();
      if (!mounted) return;
      _showWinDialog();
    }
  }

  void _showWinDialog() {
    final pal = Palette.of(context);
    final souvenir = Rewards.instance.dernierSouvenir;
    final wins = Rewards.instance.wins;
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: pal.threadBg,
        title: Text(
          souvenir != null ? 'Souvenir débloqué' : 'Grille terminée !',
          style: TextStyle(color: pal.headText, fontWeight: FontWeight.w800),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (souvenir != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(souvenir.asset, height: 170,
                    fit: BoxFit.cover),
              ),
              const SizedBox(height: 10),
              Text(
                '« ${souvenir.titre} »',
                textAlign: TextAlign.center,
                style: TextStyle(color: pal.headText, fontSize: 14.5),
              ),
            ] else
              Text(
                'Toute la galerie est déjà à toi.',
                style: TextStyle(color: pal.preview, fontSize: 14),
              ),
            const SizedBox(height: 6),
            Text(
              '$wins grille${wins > 1 ? 's' : ''} terminée${wins > 1 ? 's' : ''}',
              style: TextStyle(color: pal.meta, fontSize: 12),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              widget.onGallery();
            },
            child: const Text('Voir la galerie'),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Continuer'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    final g = _session;
    return Container(
      color: pal.threadBg,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: widget.onBack,
                  icon: Icon(Icons.arrow_back_ios_new,
                      color: pal.chev, size: 22),
                  tooltip: 'Accueil',
                ),
                Expanded(
                  child: Text(
                    'Sudoku',
                    style: TextStyle(
                      color: pal.headText,
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
                if (g != null)
                  IconButton(
                    onPressed: () => setState(() => _session = null),
                    icon: Icon(Icons.refresh, color: pal.meta, size: 22),
                    tooltip: 'Nouvelle grille',
                  ),
              ],
            ),
            if (g == null)
              Expanded(child: _DifficultyPicker(onPick: _newGame))
            else ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: _Grid(
                  game: g,
                  selRow: _selRow,
                  selCol: _selCol,
                  onTap: _tapCell,
                ),
              ),
              const Spacer(),
              _NumberPad(onEnter: _enter),
              const SizedBox(height: 14),
            ],
          ],
        ),
      ),
    );
  }
}

class _DifficultyPicker extends StatelessWidget {
  const _DifficultyPicker({required this.onPick});

  final ValueChanged<int> onPick;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    Widget bouton(String label, String sub, int givens) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 8),
          child: OutlinedButton(
            onPressed: () => onPick(givens),
            style: OutlinedButton.styleFrom(
              foregroundColor: pal.headText,
              side: BorderSide(color: pal.chev, width: 1.4),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
              padding: const EdgeInsets.symmetric(vertical: 13),
            ),
            child: Column(
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
                Text(sub,
                    style: TextStyle(color: pal.meta, fontSize: 12)),
              ],
            ),
          ),
        );
    final wins = Rewards.instance.wins;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Le jeu anti-stress de Shen.\nChaque grille terminée débloque un souvenir.',
          textAlign: TextAlign.center,
          style: TextStyle(color: pal.preview, fontSize: 13.5, height: 1.5),
        ),
        const SizedBox(height: 18),
        bouton('Facile', '36 cases révélées', 36),
        bouton('Moyen', '30 cases révélées', 30),
        bouton('Difficile', '25 cases révélées', 25),
        const SizedBox(height: 14),
        Text(
          '$wins grille${wins > 1 ? 's' : ''} terminée${wins > 1 ? 's' : ''} · '
          '${Rewards.instance.souvenirsDebloques}/${kSouvenirs.length} souvenirs',
          textAlign: TextAlign.center,
          style: TextStyle(color: pal.meta, fontSize: 12),
        ),
      ],
    );
  }
}

class _Grid extends StatelessWidget {
  const _Grid({
    required this.game,
    required this.selRow,
    required this.selCol,
    required this.onTap,
  });

  final SudokuGame game;
  final int? selRow;
  final int? selCol;
  final void Function(int r, int c) onTap;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    return AspectRatio(
      aspectRatio: 1,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: pal.headText, width: 1.6),
        ),
        child: Column(
          children: [
            for (var r = 0; r < 9; r++)
              Expanded(
                child: Row(
                  children: [
                    for (var c = 0; c < 9; c++)
                      Expanded(child: _cell(context, pal, r, c)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _cell(BuildContext context, Palette pal, int r, int c) {
    final v = game.cells[r][c];
    final given = game.isGiven(r, c);
    final selected = r == selRow && c == selCol;
    final conflict = !given && game.conflict(r, c);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => onTap(r, c),
      child: Container(
        decoration: BoxDecoration(
          color: selected
              ? pal.brand.withValues(alpha: 0.22)
              : (given ? pal.inBubble.withValues(alpha: 0.45) : null),
          border: Border(
            right: BorderSide(
              color: (c + 1) % 3 == 0 ? pal.headText : pal.rowBorder,
              width: (c + 1) % 3 == 0 ? 1.2 : 0.5,
            ),
            bottom: BorderSide(
              color: (r + 1) % 3 == 0 ? pal.headText : pal.rowBorder,
              width: (r + 1) % 3 == 0 ? 1.2 : 0.5,
            ),
          ),
        ),
        alignment: Alignment.center,
        child: v == 0
            ? null
            : Text(
                '$v',
                style: TextStyle(
                  color: conflict
                      ? const Color(0xFFE53935)
                      : (given ? pal.headText : pal.brand),
                  fontSize: 19,
                  fontWeight: given ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

class _NumberPad extends StatelessWidget {
  const _NumberPad({required this.onEnter});

  final ValueChanged<int> onEnter;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    Widget key(String label, int value) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
            child: Material(
              color: pal.inBubble,
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () => onEnter(value),
                child: Container(
                  height: 46,
                  alignment: Alignment.center,
                  child: Text(
                    label,
                    style: TextStyle(
                      color: pal.headText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          Row(children: [for (var i = 1; i <= 5; i++) key('$i', i)]),
          const SizedBox(height: 6),
          Row(children: [
            for (var i = 6; i <= 9; i++) key('$i', i),
            key('⌫', 0),
          ]),
        ],
      ),
    );
  }
}
