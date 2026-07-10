import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/notes_data.dart';
import '../../../providers/phone_state_provider.dart';
import '../../../providers/relationships_provider.dart';

/// Mode Carnet — extraction des notes en une vue paysage panoramique
/// façon vrai carnet écrit à la main : papier crème, marge gauche,
/// trait vertical rouge, écriture serif italique avec dates en marge.
///
/// Accessible depuis l'app Notes via bouton « Mode Carnet ». Quand
/// le jeu sera fini (Ep 5 terminé), cette vue contiendra les 112 jours
/// d'écriture de Shen, à lire d'une traite — récompense diégétique.
class CarnetView extends ConsumerStatefulWidget {
  const CarnetView({super.key});

  @override
  ConsumerState<CarnetView> createState() => _CarnetViewState();
}

class _CarnetViewState extends ConsumerState<CarnetView> {
  @override
  void initState() {
    super.initState();
    // On force le paysage le temps de la vue.
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    // Même filtre que l'app Notes : les notes gatées par la suspicion de
    // Maman ne doivent pas fuir par le Mode Carnet.
    final suspicion =
        ref.watch(relationshipsProvider)['maman']?.suspicion ?? 0;
    final notes = kNotes
        .where((n) =>
            n.day <= day &&
            !n.draft &&
            (n.requiresSuspicionMaman == null ||
                suspicion >= n.requiresSuspicionMaman!))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFFFAF4E6),
      body: SafeArea(
        child: Stack(
          children: [
            // Bouton retour
            Positioned(
              top: 4,
              left: 4,
              child: IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF3DA85F)),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  Navigator.of(context).pop();
                },
              ),
            ),
            // Trait vertical rouge à 80 px de la marge gauche
            Positioned(
              top: 40,
              bottom: 40,
              left: 92,
              child: Container(
                width: 1.2,
                color: const Color(0xFFD97757).withValues(alpha: 0.5),
              ),
            ),
            // Lignes horizontales fines style cahier
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(painter: _RuledPaperPainter()),
              ),
            ),
            // Contenu — PageView avec courbure 3D légère pour donner
            // la sensation de tourner les pages d'un cahier.
            Padding(
              padding: const EdgeInsets.fromLTRB(110, 50, 50, 30),
              child: _PageCurlView(notes: notes),
            ),
            // Indication de geste
            Positioned(
              bottom: 6,
              right: 18,
              child: Text(
                'Glisse pour tourner les pages →',
                style: GoogleFonts.crimsonPro(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFF8B8480),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RuledPaperPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFC9BFA8).withValues(alpha: 0.30)
      ..strokeWidth = 0.5;
    const lineGap = 26.0;
    for (var y = 40.0; y < size.height - 30; y += lineGap) {
      canvas.drawLine(Offset(50, y), Offset(size.width - 30, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// PageView avec courbure 3D légère — chaque page « se tourne »
/// avec un Transform.rotateY proportionnel à sa distance de la page
/// active. Donne la sensation tactile d'un vrai cahier.
class _PageCurlView extends StatefulWidget {
  const _PageCurlView({required this.notes});
  final List<NoteEntry> notes;

  @override
  State<_PageCurlView> createState() => _PageCurlViewState();
}

class _PageCurlViewState extends State<_PageCurlView> {
  final _ctrl = PageController(viewportFraction: 0.92);
  double _page = 0;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(() {
      setState(() => _page = _ctrl.page ?? 0);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _ctrl,
      itemCount: widget.notes.length,
      onPageChanged: (_) => HapticFeedback.lightImpact(),
      itemBuilder: (context, i) {
        final delta = (i - _page).clamp(-1.0, 1.0);
        final angle = delta * 0.35; // radians
        final n = widget.notes[i];
        return Transform(
          alignment: delta < 0 ? Alignment.centerRight : Alignment.centerLeft,
          transform: Matrix4.identity()
            ..setEntry(3, 2, 0.001)
            ..rotateY(angle),
          child: Container(
            margin: const EdgeInsets.only(right: 40),
            padding: const EdgeInsets.symmetric(horizontal: 4),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.06),
                  blurRadius: 12,
                  offset: Offset(delta < 0 ? -4 : 4, 0),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'J${n.day}',
                      style: GoogleFonts.crimsonPro(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFD97757),
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      n.time,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: const Color(0xFF6B6B6B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  n.title,
                  style: GoogleFonts.crimsonPro(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF1A1A1A),
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      n.body,
                      style: GoogleFonts.crimsonPro(
                        fontSize: 15,
                        color: const Color(0xFF2C2A26),
                        fontStyle: FontStyle.italic,
                        height: 1.7,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 6),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      '— ${i + 1} —',
                      style: GoogleFonts.crimsonPro(
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                        color: const Color(0xFF8B8480),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
