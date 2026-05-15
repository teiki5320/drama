import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/phone_apps.dart';
import '../../data/calendar_data.dart';
import '../../data/messages_data.dart';
import '../../data/notes_data.dart';
import '../../data/photos_data.dart';
import '../../providers/phone_state_provider.dart';

/// Spotlight iOS — pull-down sur le home pour fouiller à travers tout
/// le contenu indexé (apps, notes, messages, photos, calendrier).
/// Filtre par `currentDay` pour ne pas spoiler.
class SpotlightSearch extends ConsumerStatefulWidget {
  const SpotlightSearch({super.key});

  @override
  ConsumerState<SpotlightSearch> createState() => _SpotlightSearchState();
}

class _SpotlightSearchState extends ConsumerState<SpotlightSearch> {
  final _ctrl = TextEditingController();
  String _q = '';

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final q = _q.trim().toLowerCase();

    final apps = q.isEmpty
        ? <AppMeta>[]
        : kAllApps
            .where((a) => a.label.toLowerCase().contains(q))
            .toList();
    final notes = q.isEmpty
        ? <NoteEntry>[]
        : kNotes
            .where((n) =>
                n.day <= day &&
                (n.title.toLowerCase().contains(q) ||
                    n.body.toLowerCase().contains(q)))
            .toList();
    final msgs = q.isEmpty
        ? <_MsgHit>[]
        : kThreads.entries
            .expand((e) => e.value.where((m) => m.day <= day).map(
                (m) => _MsgHit(contactId: e.key, msg: m)))
            .where((h) => h.msg.text.toLowerCase().contains(q))
            .toList();
    final photos = q.isEmpty
        ? <PhotoItem>[]
        : kPhotos
            .where((p) =>
                p.day <= day &&
                (p.title.toLowerCase().contains(q) ||
                    p.subtitle.toLowerCase().contains(q)))
            .toList();
    final events = q.isEmpty
        ? <CalendarEvent>[]
        : kEvents
            .where((e) =>
                e.day >= day &&
                (e.title.toLowerCase().contains(q) ||
                    (e.location?.toLowerCase().contains(q) ?? false)))
            .toList();

    return Scaffold(
      backgroundColor: Colors.black.withValues(alpha: 0.88),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.search,
                              color: Colors.white70, size: 18),
                          const SizedBox(width: 6),
                          Expanded(
                            child: TextField(
                              controller: _ctrl,
                              autofocus: true,
                              cursorColor: Colors.white,
                              style: GoogleFonts.inter(
                                  fontSize: 16, color: Colors.white),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Spotlight',
                                hintStyle: GoogleFonts.inter(
                                    fontSize: 16,
                                    color: Colors.white54),
                              ),
                              onChanged: (v) => setState(() => _q = v),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Annuler',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: q.isEmpty
                  ? Center(
                      child: Text(
                        'Cherche dans Notes, Messages, Photos, Calendrier…',
                        style: GoogleFonts.crimsonPro(
                          fontSize: 14,
                          color: Colors.white54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    )
                  : ListView(
                      children: [
                        if (apps.isNotEmpty)
                          _Section(title: 'APPS', children: [
                            for (final a in apps)
                              _Hit(
                                icon: Icon(a.icon, color: a.fgColor),
                                iconBg: a.color,
                                title: a.label,
                                subtitle: 'Application',
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  ref
                                      .read(phoneStateProvider.notifier)
                                      .openApp(a.id);
                                  Navigator.of(context).pop();
                                },
                              ),
                          ]),
                        if (notes.isNotEmpty)
                          _Section(title: 'NOTES', children: [
                            for (final n in notes)
                              _Hit(
                                icon: const Icon(Icons.sticky_note_2,
                                    color: Color(0xFF1A1A1A)),
                                iconBg: const Color(0xFFFDDB6E),
                                title: n.title,
                                subtitle: 'J${n.day} · ${n.time}',
                                onTap: () {
                                  ref
                                      .read(phoneStateProvider.notifier)
                                      .openApp('notes');
                                  Navigator.of(context).pop();
                                },
                              ),
                          ]),
                        if (msgs.isNotEmpty)
                          _Section(title: 'MESSAGES', children: [
                            for (final h in msgs.take(8))
                              _Hit(
                                icon: const Icon(Icons.chat_bubble,
                                    color: Colors.white),
                                iconBg: const Color(0xFF34C759),
                                title: contactById(h.contactId).displayName,
                                subtitle: h.msg.text,
                                onTap: () {
                                  ref
                                      .read(phoneStateProvider.notifier)
                                      .openApp('messages');
                                  Navigator.of(context).pop();
                                },
                              ),
                          ]),
                        if (photos.isNotEmpty)
                          _Section(title: 'PHOTOS', children: [
                            for (final p in photos)
                              _Hit(
                                icon: const Icon(Icons.photo_library,
                                    color: Colors.white),
                                iconBg: const Color(0xFFFF6B6B),
                                title: p.title,
                                subtitle: 'J${p.day} · ${p.subtitle}',
                                onTap: () {
                                  ref
                                      .read(phoneStateProvider.notifier)
                                      .openApp('photos');
                                  Navigator.of(context).pop();
                                },
                              ),
                          ]),
                        if (events.isNotEmpty)
                          _Section(title: 'CALENDRIER', children: [
                            for (final e in events)
                              _Hit(
                                icon: const Icon(Icons.calendar_today,
                                    color: Color(0xFFE53935)),
                                iconBg: Colors.white,
                                title: e.title,
                                subtitle:
                                    'J${e.day} · ${e.startTime} · ${e.location ?? "—"}',
                                onTap: () {
                                  ref
                                      .read(phoneStateProvider.notifier)
                                      .openApp('calendrier');
                                  Navigator.of(context).pop();
                                },
                              ),
                          ]),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MsgHit {
  final String contactId;
  final Msg msg;
  _MsgHit({required this.contactId, required this.msg});
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children});
  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 4),
          child: Text(
            title,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Colors.white70,
              letterSpacing: 1.2,
            ),
          ),
        ),
        ...children,
      ],
    );
  }
}

class _Hit extends StatelessWidget {
  const _Hit({
    required this.icon,
    required this.iconBg,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });
  final Widget icon;
  final Color iconBg;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBg,
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: IconTheme(
                data: const IconThemeData(size: 18),
                child: icon,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: Colors.white70,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
