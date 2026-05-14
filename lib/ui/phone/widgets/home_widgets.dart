import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../providers/phone_state_provider.dart';

/// Widget Météo grand format pour le home screen.
class MeteoWidget extends StatelessWidget {
  const MeteoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Belleville',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '13°',
                style: GoogleFonts.inter(
                  fontSize: 38,
                  fontWeight: FontWeight.w200,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Pluie',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white,
                ),
              ),
              Text(
                'Min : 11°  ·  Max : 15°',
                style: GoogleFonts.inter(
                  fontSize: 10,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.umbrella, color: Colors.white, size: 32),
        ],
      ),
    );
  }
}

/// Widget cadre photo « Maman » qui rotate quotidiennement.
class PhotoMamanWidget extends StatelessWidget {
  const PhotoMamanWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Color(0xFFFCE6D8), Color(0xFFFAE0CC)],
                  ),
                ),
                child: const Icon(Icons.favorite,
                    color: Color(0xFFD97757), size: 16),
              ),
              const SizedBox(width: 8),
              Text(
                'Maman',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            'Couvre-toi.',
            style: GoogleFonts.crimsonPro(
              fontSize: 16,
              fontStyle: FontStyle.italic,
              color: Colors.white,
            ),
          ),
          Text(
            'Hier, 22h08',
            style: GoogleFonts.inter(
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.65),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget Calendrier — prochain rdv (J+1, Tenon).
class CalendarWidget extends StatelessWidget {
  const CalendarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return _GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PROCHAIN',
            style: GoogleFonts.inter(
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFFF6B6B),
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Dialyse Maman',
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Hôpital Tenon',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: Colors.white.withValues(alpha: 0.75),
            ),
          ),
          const Spacer(),
          Row(
            children: [
              const Icon(Icons.access_time, size: 12, color: Colors.white70),
              const SizedBox(width: 4),
              Text(
                'Demain 9h30',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.white.withValues(alpha: 0.85),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Widget « Avancer dans la journée » — c'est ainsi qu'on progresse.
/// Tap court = +1h, tap long = passer au lendemain (animation lock screen
/// qui revient).
class TimeSkipWidget extends ConsumerWidget {
  const TimeSkipWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        ref.read(phoneStateProvider.notifier).advanceTime(60);
        ref.read(phoneStateProvider.notifier).consumeBattery(2);
      },
      onLongPress: () {
        HapticFeedback.mediumImpact();
        ref.read(phoneStateProvider.notifier).advanceDay();
      },
      child: _GlassCard(
        child: Row(
          children: [
            const Icon(Icons.fast_forward, color: Colors.white, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Avancer',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    'Tap : +1h  ·  Long : +1 jour',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Carte glassmorphism semi-transparente commune à tous les widgets.
class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(18),
        border:
            Border.all(color: Colors.white.withValues(alpha: 0.20), width: 1),
      ),
      child: child,
    );
  }
}
