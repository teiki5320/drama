import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// App Uber Eats Livreur — l'app pro de Shen. Liste des courses du jour
/// avec montants, distances, pénalités.
class UberEatsApp extends ConsumerWidget {
  const UberEatsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final courses = _coursesForDay(day);
    final earnings = courses.fold<double>(0, (a, c) => a + c.payout - c.penalty);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Colors.white),
          // Header noir Uber
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
                  'Uber Eats Pro',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          // Gains du jour
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF06C167).withOpacity(0.15),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: const Color(0xFF06C167).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.account_balance_wallet,
                    color: Color(0xFF06C167)),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Gains du jour',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: Colors.white70,
                        letterSpacing: 0.4,
                      ),
                    ),
                    Text(
                      '${earnings.toStringAsFixed(2)} €',
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: earnings < 0
                            ? const Color(0xFFE53935)
                            : Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: courses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) => _CourseCard(course: courses[i]),
            ),
          ),
        ],
      ),
    );
  }

  List<_Course> _coursesForDay(int day) {
    if (day < 1) return [];
    return [
      const _Course(
        time: '07:15',
        from: 'Boulangerie Wong',
        to: 'Bureau 8ᵉ',
        distance: '3.2 km',
        payout: 8.40,
        penalty: 0,
        status: 'Livré',
      ),
      const _Course(
        time: '08:12',
        from: 'Açaí Bowl Co.',
        to: 'Avenue Montaigne',
        distance: '4.1 km',
        payout: 8.40,
        penalty: 38,
        status: 'Non livré · pénalité',
      ),
    ];
  }
}

class _Course {
  final String time;
  final String from;
  final String to;
  final String distance;
  final double payout;
  final double penalty;
  final String status;
  const _Course({
    required this.time,
    required this.from,
    required this.to,
    required this.distance,
    required this.payout,
    required this.penalty,
    required this.status,
  });
}

class _CourseCard extends StatelessWidget {
  const _CourseCard({required this.course});
  final _Course course;

  @override
  Widget build(BuildContext context) {
    final failed = course.penalty > 0;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(12),
        border: failed
            ? Border.all(
                color: const Color(0xFFE53935).withOpacity(0.5))
            : null,
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
              const Spacer(),
              Text(
                course.status,
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: failed
                      ? const Color(0xFFE53935)
                      : const Color(0xFF06C167),
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
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 7, top: 2, bottom: 2),
            child: Container(
              width: 2,
              height: 12,
              color: Colors.grey.shade700,
            ),
          ),
          Row(
            children: [
              const Icon(Icons.location_on, color: Colors.white70, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  course.to,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    color: Colors.white,
                  ),
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
                  '+ ${course.payout.toStringAsFixed(2)} €',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF06C167),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
