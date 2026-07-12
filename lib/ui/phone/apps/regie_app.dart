import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/day_events.dart';
import '../../../data/episodes.dart';
import '../../../data/messages_data.dart';
import '../../../models/episode.dart';
import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// RÉGIE — outil d'AUTEUR (pas du contenu joueur). Permet de suivre TOUT :
///  • Récit : la narration (transitions = voix de Shen), beat par beat.
///  • Événements : tout ce que le moteur pousse (notifs, appels), à l'heure.
///  • Messages : tous les fils SMS, message par message.
class RegieApp extends ConsumerStatefulWidget {
  const RegieApp({super.key});
  @override
  ConsumerState<RegieApp> createState() => _RegieAppState();
}

class _RegieAppState extends ConsumerState<RegieApp> {
  int _tab = 0; // 0 récit · 1 événements · 2 messages

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0E0E12),
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Colors.white),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 6),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Color(0xFFD97757), size: 20),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ref.read(phoneStateProvider.notifier).closeApp();
                  },
                ),
                Text('Régie',
                    style: GoogleFonts.inter(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
              ],
            ),
          ),
          _tabs(),
          const SizedBox(height: 6),
          Expanded(
            child: IndexedStack(
              index: _tab,
              children: [_recit(), _evenements(), _messages()],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs() {
    const labels = ['Récit', 'Événements', 'Messages'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          for (var i = 0; i < labels.length; i++)
            Expanded(
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  setState(() => _tab = i);
                },
                child: Container(
                  margin: EdgeInsets.only(right: i < 2 ? 6 : 0),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: _tab == i
                        ? const Color(0xFFD97757)
                        : Colors.white.withValues(alpha: 0.06),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    labels[i],
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: _tab == i ? Colors.white : Colors.white60,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Onglet RÉCIT ──────────────────────────────────────────────
  Widget _recit() {
    var total = 0, withNar = 0;
    for (final e in kEpisodes) {
      for (final b in e.beats) {
        total++;
        if (b.transition != null) withNar++;
      }
    }
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 48),
      children: [
        _count('$total beats · $withNar avec narration · ${total - withNar} sans'),
        for (final e in kEpisodes) ..._episode(e),
      ],
    );
  }

  List<Widget> _episode(Episode e) => [
        const SizedBox(height: 18),
        Text('ÉPISODE ${e.number} · ${e.title}',
            style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFD97757),
                letterSpacing: 0.4)),
        const SizedBox(height: 2),
        Text(e.subtitle,
            style: GoogleFonts.inter(fontSize: 11, color: Colors.white38)),
        const SizedBox(height: 10),
        for (final b in e.beats) _beat(b),
      ];

  Widget _beat(Beat b) {
    final t = b.transition;
    return _card(
      borderRed: t == null,
      children: [
        _row('J${b.day} · ${_hm(b.hour, b.minute)}', b.label),
        if (b.requiresChoice != null)
          _mono('↩ attend : ${b.requiresChoice}', const Color(0xFF6EC1E4)),
        if (b.unlocksApps.isNotEmpty)
          _mono('🔓 débloque : ${b.unlocksApps.join(", ")}', Colors.white38),
        const SizedBox(height: 8),
        if (t != null) ...[
          _mono(t.timestamp, Colors.white38),
          const SizedBox(height: 4),
          _narr(t.body),
          if (t.coda != null) ...[
            const SizedBox(height: 6),
            _narr(t.coda!, faded: true),
          ],
        ] else
          Text('— pas de narration sur ce beat —',
              style: GoogleFonts.inter(
                  fontSize: 12,
                  color: const Color(0xFFCB7A7A),
                  fontStyle: FontStyle.italic)),
      ],
    );
  }

  // ── Onglet ÉVÉNEMENTS ─────────────────────────────────────────
  Widget _evenements() {
    final ev = [...kDayEvents]
      ..sort((a, b) => (a.day * 1440 + a.hour * 60 + a.minute)
          .compareTo(b.day * 1440 + b.hour * 60 + b.minute));
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 48),
      children: [
        _count('${ev.length} événements poussés (notifs, appels)'),
        const SizedBox(height: 8),
        for (final e in ev)
          _card(children: [
            _row('J${e.day} · ${_hm(e.hour, e.minute)}',
                '${e.isIncomingCall ? "📞 " : ""}${e.notifTitle}'),
            _mono('app : ${e.notifAppId}', Colors.white38),
            const SizedBox(height: 6),
            Text(e.notifBody,
                style: GoogleFonts.inter(
                    fontSize: 13, color: Colors.white, height: 1.3)),
            if (e.summary.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text('« ${e.summary} »',
                  style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white38,
                      fontStyle: FontStyle.italic)),
            ],
            if (e.isIncomingCall && e.callTranscript.isNotEmpty) ...[
              const SizedBox(height: 6),
              for (final line in e.callTranscript)
                Text('› $line',
                    style: GoogleFonts.crimsonPro(
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                        color: Colors.white70)),
            ],
          ]),
      ],
    );
  }

  // ── Onglet MESSAGES ───────────────────────────────────────────
  Widget _messages() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(14, 0, 14, 48),
      children: [
        _count('${kThreads.length} fils · '
            '${kThreads.values.fold<int>(0, (s, l) => s + l.length)} messages'),
        for (final entry in kThreads.entries) ..._thread(entry.key, entry.value),
      ],
    );
  }

  List<Widget> _thread(String cid, List<Msg> msgs) {
    if (msgs.isEmpty) return const [];
    final c = kContacts.where((k) => k.id == cid).toList();
    final name = c.isNotEmpty ? c.first.displayName : cid;
    final emoji = c.isNotEmpty ? c.first.emoji : '';
    return [
      const SizedBox(height: 18),
      Text('$emoji $name  ·  ${msgs.length} msg',
          style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: const Color(0xFFD97757))),
      const SizedBox(height: 8),
      _card(children: [
        for (final m in msgs) _sms(name, m),
      ]),
    ];
  }

  Widget _sms(String contactName, Msg m) {
    final me = m.sender == 'moi';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Column(
        crossAxisAlignment:
            me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            'J${m.day} · ${m.time} · ${me ? "Shen" : contactName}'
            '${m.beatId != null ? "  ·  beat ${m.beatId}" : ""}',
            style: GoogleFonts.inter(fontSize: 9, color: Colors.white38),
          ),
          Text(
            m.text,
            textAlign: me ? TextAlign.right : TextAlign.left,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: me ? const Color(0xFF6EC1E4) : Colors.white,
              height: 1.25,
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers de rendu ──────────────────────────────────────────
  static String _hm(int h, int m) =>
      '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';

  Widget _count(String s) => Padding(
        padding: const EdgeInsets.only(top: 2, bottom: 2),
        child: Text(s,
            style: GoogleFonts.inter(fontSize: 11, color: Colors.white54)),
      );

  Widget _card({required List<Widget> children, bool borderRed = false}) =>
      Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.04),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: borderRed ? const Color(0xFF6B3A3A) : Colors.white12,
              width: 1),
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, children: children),
      );

  Widget _row(String chip, String title) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
            decoration: BoxDecoration(
                color: const Color(0xFF4A3F6E),
                borderRadius: BorderRadius.circular(6)),
            child: Text(chip,
                style: GoogleFonts.inter(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.w700)),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(title,
                style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
        ],
      );

  Widget _mono(String s, Color c) => Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(s, style: GoogleFonts.inter(fontSize: 10, color: c)),
      );

  Widget _narr(String s, {bool faded = false}) => Text(
        s,
        style: GoogleFonts.crimsonPro(
          fontSize: faded ? 13 : 15,
          fontStyle: FontStyle.italic,
          color: faded ? Colors.white54 : Colors.white,
          height: 1.35,
        ),
      );
}
