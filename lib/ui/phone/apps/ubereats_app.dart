import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// Uber Eats — l'app a deux modes :
/// - **Pro** (livreuse) : Shen reçoit des courses, accepte ou refuse,
///   gagne € selon succès, batterie -2. Mode par défaut J1-J8.
/// - **Commande** (cliente) : à partir de J9 quand Shen vit Avenue Foch,
///   elle peut commander pour Tristan (sushi 80€, dim sum 35€), pour
///   Camille (long doppio Hanami 4,20€), ou pour Maman (livraison
///   nouilles + soupe d'orge à Belleville).
///
/// J9+ : compte « Livreur » SUSPENDU. L'app passe en mode commande
/// uniquement, écran rouge à l'ouverture.
class UberEatsApp extends ConsumerStatefulWidget {
  const UberEatsApp({super.key});

  @override
  ConsumerState<UberEatsApp> createState() => _UberEatsAppState();
}

class _UberEatsAppState extends ConsumerState<UberEatsApp> {
  bool _proMode = true;
  final Set<String> _acceptedCourseIds = {};
  final Set<String> _orderedItemIds = {};

  @override
  Widget build(BuildContext context) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final isSuspended = day >= 9; // J9 = emménagement, compte suspendu

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Colors.white),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Color(0xFF06C167), size: 20),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ref.read(phoneStateProvider.notifier).closeApp();
                  },
                ),
                Text(
                  'Uber Eats',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          if (isSuspended)
            // ── Mode commande client (J9+) avec bandeau rouge ─────
            Expanded(child: _OrderMode(
              orderedItemIds: _orderedItemIds,
              onOrder: (id) => setState(() => _orderedItemIds.add(id)),
              day: day,
            ))
          else
            // ── Mode Pro (livreuse) avec toggle ───────────────────
            Expanded(
              child: _proMode
                  ? _LivreurMode(
                      day: day,
                      acceptedCourseIds: _acceptedCourseIds,
                      onAccept: (id) => setState(() {
                        _acceptedCourseIds.add(id);
                        HapticFeedback.mediumImpact();
                      }),
                      onRefuse: () => HapticFeedback.lightImpact(),
                      onSwitch: () => setState(() => _proMode = false),
                    )
                  : _OrderMode(
                      orderedItemIds: _orderedItemIds,
                      onOrder: (id) => setState(() => _orderedItemIds.add(id)),
                      day: day,
                    ),
            ),
        ],
      ),
    );
  }
}

// ─── Mode Livreur ────────────────────────────────────────────────
class _LivreurMode extends StatelessWidget {
  const _LivreurMode({
    required this.day,
    required this.acceptedCourseIds,
    required this.onAccept,
    required this.onRefuse,
    required this.onSwitch,
  });
  final int day;
  final Set<String> acceptedCourseIds;
  final void Function(String) onAccept;
  final VoidCallback onRefuse;
  final VoidCallback onSwitch;

  @override
  Widget build(BuildContext context) {
    final courses = _coursesForDay(day);
    final notedRating = 4.2 - (acceptedCourseIds.length < 2 ? 0 : 0.0);
    final accepted =
        courses.where((c) => acceptedCourseIds.contains(c.id)).toList();
    final earnings = accepted.fold<double>(
        0, (a, c) => a + c.payout - c.penalty);

    return Column(
      children: [
        // Stat bar : note + gains
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              Expanded(
                child: _StatCard(
                  label: 'Note livreuse',
                  value: '⭐ ${notedRating.toStringAsFixed(1)}',
                  hint: '${127 - acceptedCourseIds.length} avis',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  label: 'Gains du jour',
                  value: '${earnings.toStringAsFixed(2)} €',
                  hint: '${accepted.length} courses',
                  emphasize: earnings >= 20,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        // Switch mode + bouton « Aller en mode commande »
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: GestureDetector(
            onTap: onSwitch,
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.white24, width: 0.5),
              ),
              child: Row(
                children: [
                  const Icon(Icons.swap_horiz,
                      color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    'Passer en mode Commande',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: courses.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final c = courses[i];
              return _CourseCard(
                course: c,
                accepted: acceptedCourseIds.contains(c.id),
                onAccept: () => onAccept(c.id),
                onRefuse: onRefuse,
              );
            },
          ),
        ),
      ],
    );
  }

  List<_Course> _coursesForDay(int day) {
    if (day < 1) return [];
    final base = <_Course>[
      const _Course(
        id: 'c_j1_07h15',
        time: '07:15',
        from: 'Boulangerie Wong',
        to: 'Bureau 8ᵉ',
        distance: '3.2 km',
        payout: 8.40,
        penalty: 0,
        status: 'Livré',
        surge: 1.0,
      ),
      // Idée 3 — Course « impossible » de la collision (replay narratif)
      const _Course(
        id: 'c_j1_07h52',
        time: '07:52',
        from: 'Açaí Bowl Co.',
        to: 'Avenue Montaigne',
        distance: '4.1 km',
        payout: 8.40,
        penalty: 38,
        status: 'Non livré · pénalité',
        surge: 1.0,
        replayNarrative: true,
      ),
    ];
    if (day >= 2) {
      // Idée 4 — Tarification surge (pluie = +50%)
      base.add(const _Course(
        id: 'c_j2_06h05',
        time: '06:05',
        from: 'Café Hanami',
        to: 'Bureau République',
        distance: '5.4 km',
        payout: 9.10,
        penalty: 0,
        status: 'Proposée',
        surge: 1.5, // pluie
      ));
    }
    if (day >= 3) {
      base.add(const _Course(
        id: 'c_j3_22h30',
        time: '22:30',
        from: 'Sushi Run',
        to: 'Belleville',
        distance: '2.1 km',
        payout: 6.20,
        penalty: 0,
        status: 'Proposée',
        surge: 1.0,
        suspicionWarning: true, // livre la nuit → Maman suspecte
      ));
    }
    return base;
  }
}

// ─── Mode Commande (client) ──────────────────────────────────────
class _OrderMode extends ConsumerWidget {
  const _OrderMode({
    required this.orderedItemIds,
    required this.onOrder,
    required this.day,
  });
  final Set<String> orderedItemIds;
  final void Function(String) onOrder;
  final int day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isSuspended = day >= 9;
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        if (isSuspended)
          // Idée 5 — Bandeau COMPTE SUSPENDU plein écran
          Container(
            padding: const EdgeInsets.all(16),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFE53935).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: const Color(0xFFE53935).withValues(alpha: 0.5)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.error_outline,
                    color: Color(0xFFE53935), size: 24),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COMPTE LIVREUSE SUSPENDU',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFFE53935),
                          letterSpacing: 1.0,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Pénalités cumulées · 412 € à rembourser '
                        'avant réactivation. Mode commande uniquement.',
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          color: Colors.white,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        // Idée 2 — Restaurants commande
        Text(
          'À COMMANDER',
          style: GoogleFonts.inter(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: Colors.white70,
            letterSpacing: 1.2,
          ),
        ),
        const SizedBox(height: 10),
        for (final item in _kOrderItems(day))
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: _OrderRow(
              item: item,
              ordered: orderedItemIds.contains(item.id),
              onOrder: () => onOrder(item.id),
            ),
          ),
      ],
    );
  }

  List<_OrderItem> _kOrderItems(int day) {
    return [
      _OrderItem(
        id: 'long_doppio_camille',
        emoji: '☕',
        restaurant: 'Café Hanami',
        item: 'Long doppio pour Camille',
        price: 4.20,
        note: 'Comme elle aime. Brûlant.',
      ),
      _OrderItem(
        id: 'soupe_maman',
        emoji: '🍲',
        restaurant: 'Maison Wong · Belleville',
        item: 'Nouilles + soupe d\'orge pour Maman',
        price: 12.50,
        note: 'Livré 75019, sans signature à la porte.',
      ),
      if (day >= 9) ...[
        _OrderItem(
          id: 'sushi_tristan',
          emoji: '🍣',
          restaurant: 'Yasu · 8ᵉ',
          item: 'Plateau omakase 12 pièces pour Tristan',
          price: 80.00,
          note: 'Wasabi à part. À la table de bureau.',
          requiresAvenueFoch: true,
        ),
        _OrderItem(
          id: 'dim_sum_madame_heng',
          emoji: '🥟',
          restaurant: 'Lan Garden · Avenue Foch',
          item: 'Dim sum pour la table familiale',
          price: 35.00,
          note: 'Madame Heng préfère le porc.',
          requiresAvenueFoch: true,
        ),
      ],
    ];
  }
}

// ─── Modèles ────────────────────────────────────────────────────
class _Course {
  final String id;
  final String time;
  final String from;
  final String to;
  final String distance;
  final double payout;
  final double penalty;
  final String status;
  final double surge;
  final bool replayNarrative;
  final bool suspicionWarning;
  const _Course({
    required this.id,
    required this.time,
    required this.from,
    required this.to,
    required this.distance,
    required this.payout,
    required this.penalty,
    required this.status,
    this.surge = 1.0,
    this.replayNarrative = false,
    this.suspicionWarning = false,
  });
}

class _OrderItem {
  final String id;
  final String emoji;
  final String restaurant;
  final String item;
  final double price;
  final String note;
  final bool requiresAvenueFoch;
  const _OrderItem({
    required this.id,
    required this.emoji,
    required this.restaurant,
    required this.item,
    required this.price,
    required this.note,
    this.requiresAvenueFoch = false,
  });
}

// ─── UI atoms ────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.hint,
    this.emphasize = false,
  });
  final String label;
  final String value;
  final String hint;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: emphasize
            ? const Color(0xFF06C167).withValues(alpha: 0.15)
            : const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(10),
        border: emphasize
            ? Border.all(
                color: const Color(0xFF06C167).withValues(alpha: 0.5))
            : Border.all(color: Colors.white24, width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: Colors.white70,
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: emphasize ? const Color(0xFF06C167) : Colors.white,
            ),
          ),
          Text(
            hint,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({
    required this.course,
    required this.accepted,
    required this.onAccept,
    required this.onRefuse,
  });
  final _Course course;
  final bool accepted;
  final VoidCallback onAccept;
  final VoidCallback onRefuse;

  @override
  Widget build(BuildContext context) {
    final failed = course.penalty > 0;
    final isPending = !accepted && course.status == 'Proposée';
    final surgeBoost = course.surge > 1.0;
    final effectivePayout = course.payout * course.surge;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: failed
            ? Border.all(
                color: const Color(0xFFE53935).withValues(alpha: 0.5))
            : (course.replayNarrative
                ? Border.all(
                    color: const Color(0xFFD97757).withValues(alpha: 0.5))
                : null),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                course.time,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
              if (surgeBoost) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFCC00),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '×${course.surge.toStringAsFixed(1)} ☔',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
              if (course.suspicionWarning) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE53935),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'NUIT',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
              const Spacer(),
              Text(
                accepted ? 'Acceptée' : course.status,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: failed
                      ? const Color(0xFFE53935)
                      : accepted
                          ? const Color(0xFF06C167)
                          : Colors.white70,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.store, color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  course.from,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          // Mini carte GPS (idée 8 — placeholder CustomPainter)
          if (isPending || accepted)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: SizedBox(
                height: 40,
                child: CustomPaint(
                  painter: _MiniMapPainter(
                    accepted: accepted,
                  ),
                  size: const Size.fromHeight(40),
                ),
              ),
            ),
          Row(
            children: [
              const Icon(Icons.location_on,
                  color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  course.to,
                  style: GoogleFonts.inter(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                course.distance,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.grey.shade400,
                ),
              ),
              const Spacer(),
              if (failed)
                Text(
                  '− ${course.penalty.toStringAsFixed(0)} €',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFE53935),
                  ),
                )
              else
                Text(
                  '+ ${effectivePayout.toStringAsFixed(2)} €',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF06C167),
                  ),
                ),
            ],
          ),
          // Boutons accepter/refuser sur les courses pending
          if (isPending) ...[
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: onRefuse,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white24),
                      foregroundColor: Colors.white70,
                    ),
                    child: const Text('Refuser'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: onAccept,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF06C167),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Accepter'),
                  ),
                ),
              ],
            ),
          ],
          if (course.replayNarrative)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '↺ Course du J1 08:17. Tu te souviens.',
                style: GoogleFonts.crimsonPro(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: const Color(0xFFD97757),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  const _OrderRow({
    required this.item,
    required this.ordered,
    required this.onOrder,
  });
  final _OrderItem item;
  final bool ordered;
  final VoidCallback onOrder;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white24, width: 0.5),
      ),
      child: Row(
        children: [
          Text(item.emoji, style: const TextStyle(fontSize: 32)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.restaurant,
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.white70,
                    letterSpacing: 0.5,
                  ),
                ),
                Text(
                  item.item,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  item.note,
                  style: GoogleFonts.crimsonPro(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                    color: Colors.white54,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${item.price.toStringAsFixed(2)} €',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 4),
              GestureDetector(
                onTap: ordered ? null : () {
                  HapticFeedback.mediumImpact();
                  onOrder();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: ordered
                        ? Colors.white12
                        : const Color(0xFF06C167),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    ordered ? 'Commandé' : 'Commander',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: ordered ? Colors.white54 : Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MiniMapPainter extends CustomPainter {
  _MiniMapPainter({required this.accepted});
  final bool accepted;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF0F0F0F);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          Offset.zero & size, const Radius.circular(6)),
      bg,
    );
    // Faux trait de route en zigzag
    final road = Paint()
      ..color = accepted
          ? const Color(0xFF06C167)
          : Colors.white38
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final path = Path()
      ..moveTo(8, size.height - 8)
      ..lineTo(size.width * 0.25, size.height * 0.7)
      ..lineTo(size.width * 0.4, size.height * 0.45)
      ..lineTo(size.width * 0.6, size.height * 0.55)
      ..lineTo(size.width * 0.8, size.height * 0.3)
      ..lineTo(size.width - 8, 8);
    canvas.drawPath(path, road);
    // Pin départ
    canvas.drawCircle(
        Offset(8, size.height - 8), 3, Paint()..color = Colors.white);
    // Pin arrivée
    canvas.drawCircle(
        Offset(size.width - 8, 8), 4, Paint()..color = const Color(0xFFE53935));
  }

  @override
  bool shouldRepaint(covariant _MiniMapPainter old) =>
      old.accepted != accepted;
}
