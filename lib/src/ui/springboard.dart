import 'package:flutter/material.dart';

import '../engine.dart';

/// L'écran d'accueil du téléphone de Shen : fond d'écran, horloge,
/// et les applications (Messages, Ma Banque…).
class Springboard extends StatelessWidget {
  const Springboard({
    super.key,
    required this.engine,
    required this.onOpenApp,
  });

  final GameEngine engine;
  final ValueChanged<String> onOpenApp;

  @override
  Widget build(BuildContext context) {
    final unread =
        engine.visibleThreads.fold<int>(0, (s, t) => s + t.unread);
    final pending =
        engine.visibleThreads.any((t) => t.pending != null);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF141A33), Color(0xFF2C2347), Color(0xFF3B2B52)],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 34),
            Text(
              engine.gameClock,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 64,
                fontWeight: FontWeight.w300,
                letterSpacing: -1.5,
                fontFeatures: [FontFeature.tabularFigures()],
              ),
            ),
            Text(
              engine.gameDate,
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.85),
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 44),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Row(
                children: [
                  _AppIcon(
                    label: 'Messages',
                    badge: unread > 0
                        ? '$unread'
                        : (pending ? '!' : null),
                    gradient: const [Color(0xFF43C252), Color(0xFF2C9440)],
                    icon: Icons.chat_bubble,
                    onTap: () => onOpenApp('messages'),
                  ),
                  const SizedBox(width: 22),
                  _AppIcon(
                    label: 'Ma Banque',
                    gradient: const [Color(0xFF2E8C74), Color(0xFF175A49)],
                    icon: Icons.account_balance,
                    onTap: () => onOpenApp('banque'),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Text(
              'DRAMA',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.22),
                fontSize: 11,
                fontWeight: FontWeight.w800,
                letterSpacing: 4,
              ),
            ),
            const SizedBox(height: 14),
          ],
        ),
      ),
    );
  }
}

class _AppIcon extends StatelessWidget {
  const _AppIcon({
    required this.label,
    required this.gradient,
    required this.icon,
    required this.onTap,
    this.badge,
  });

  final String label;
  final List<Color> gradient;
  final IconData icon;
  final VoidCallback onTap;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: gradient,
                  ),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black38,
                      blurRadius: 8,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 32),
              ),
              if (badge != null)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: const BoxDecoration(
                      color: Color(0xFFE53935),
                      shape: BoxShape.circle,
                    ),
                    constraints:
                        const BoxConstraints(minWidth: 21, minHeight: 21),
                    alignment: Alignment.center,
                    child: Text(
                      badge!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
