import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class _LockNotif {
  const _LockNotif(this.icon, this.app, this.time, this.title, this.text);

  final String icon;
  final String app;
  final String time;
  final String title;
  final String text;
}

const List<_LockNotif> _notifs = [
  _LockNotif('📅', 'Agenda', 'il y a 8 min', 'Demain 08:30 — Hôpital Tenon',
      'Accompagner Maman · niveau 2, couloir K'),
  _LockNotif('🏦', 'BNP Paribas', '07:02', 'Solde : 86,44 €',
      'Votre découvert autorisé sera bientôt atteint.'),
  _LockNotif('🛵', 'Livraisons Pro', 'hier', 'Paiement hebdomadaire : 214,60 €',
      'Bonne semaine ! Objectif : gardez votre priorité A.'),
  _LockNotif('🥐', 'Messages · Camille', 'hier', '',
      'regarde ce meme, c’est TOI 😭 — dors un peu, promis ?'),
];

/// L'écran verrouillé du téléphone de Shen : tout le contexte du jeu
/// tient dans quatre notifications.
class LockScreen extends StatelessWidget {
  const LockScreen({super.key, required this.onUnlock});

  final VoidCallback onUnlock;

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onUnlock,
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF24304E), Color(0xFF141A2E), Color(0xFF0B0E1A)],
            ),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 14),
              child: Column(
                children: [
                  const Text('🔒', style: TextStyle(fontSize: 15)),
                  const SizedBox(height: 6),
                  const Text(
                    '07:46',
                    style: TextStyle(
                      color: Color(0xFFF4F5FA),
                      fontSize: 74,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -2,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Mercredi 15 juillet',
                    style: TextStyle(
                      color: Color(0xDDF4F5FA),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  for (final n in _notifs) _NotifCard(n),
                  const SizedBox(height: 14),
                  const Text(
                    'Touche pour déverrouiller le téléphone de Shen',
                    style: TextStyle(
                      color: Color(0xCCF4F5FA),
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 134,
                    height: 5,
                    decoration: BoxDecoration(
                      color: const Color(0xD9FFFFFF),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotifCard extends StatelessWidget {
  const _NotifCard(this.notif);

  final _LockNotif notif;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0x29FAFAFC),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xEBFFFFFF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(notif.icon, style: const TextStyle(fontSize: 17)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        notif.app.toUpperCase(),
                        style: const TextStyle(
                          color: Color(0xBFF4F5FA),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.6,
                        ),
                      ),
                    ),
                    Text(
                      notif.time,
                      style: const TextStyle(
                        color: Color(0x99F4F5FA),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
                if (notif.title.isNotEmpty)
                  Text(
                    notif.title,
                    style: const TextStyle(
                      color: Color(0xFFF4F5FA),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                Text(
                  notif.text,
                  style: const TextStyle(
                    color: Color(0xEBF4F5FA),
                    fontSize: 13.5,
                    height: 1.3,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
