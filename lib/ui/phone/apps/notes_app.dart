import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/notes_data.dart';
import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// App Notes — journal intime de Shen, fond papier crème, serif Crimson
/// Pro, bic vert. Liste de notes triées du plus récent au plus ancien
/// (filtre par jour courant).
class NotesApp extends ConsumerWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final mood = ref.watch(phoneStateProvider.select((s) => s.mood));
    final notes = kNotes.where((n) => n.day <= day).toList().reversed.toList();
    // Fond papier crème en mood neutre+ ; refroidit / grisaille en bas mood.
    final bg = mood >= 5
        ? const Color(0xFFFBF7EF)
        : Color.lerp(const Color(0xFFFBF7EF), const Color(0xFFE6E2DC),
            ((5 - mood) / 5).clamp(0.0, 1.0))!;

    return Scaffold(
      backgroundColor: bg,
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Color(0xFF1A1A1A)),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
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
                const SizedBox(width: 4),
                Text(
                  'Notes',
                  style: GoogleFonts.crimsonPro(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                Icon(Icons.create, color: const Color(0xFFD97757), size: 22),
              ],
            ),
          ),
          // Compteur
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 16, 12),
            child: Text(
              '${notes.length} note${notes.length > 1 ? "s" : ""}',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: const Color(0xFF6B6B6B),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: notes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, i) => _NoteCard(note: notes[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  const _NoteCard({required this.note});
  final NoteEntry note;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => _NoteDetailView(note: note)),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E0D5), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (note.starred)
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF3DA85F), // bic vert
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                Expanded(
                  child: Text(
                    note.title,
                    style: GoogleFonts.crimsonPro(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: note.draft
                          ? const Color(0xFFB0A89A)
                          : const Color(0xFF1A1A1A),
                      decoration: note.draft
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      decorationColor: const Color(0xFFB0A89A),
                    ),
                  ),
                ),
                if (note.draft)
                  Container(
                    margin: const EdgeInsets.only(right: 6),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5E0D5),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'brouillon',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        color: const Color(0xFF8B8480),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                Text(
                  'J${note.day} · ${note.time}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: const Color(0xFF6B6B6B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              note.draft ? '${note.body}…' : note.body,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.crimsonPro(
                fontSize: 14,
                color: note.draft
                    ? const Color(0xFF9A938A)
                    : const Color(0xFF3A3A3A),
                fontStyle:
                    note.draft ? FontStyle.italic : FontStyle.normal,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NoteDetailView extends StatelessWidget {
  const _NoteDetailView({required this.note});
  final NoteEntry note;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBF7EF),
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Color(0xFF1A1A1A)),
          SafeArea(
            bottom: false,
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new,
                        color: Color(0xFFD97757), size: 20),
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      Navigator.of(context).pop();
                    },
                  ),
                  Text(
                    'Notes',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      color: const Color(0xFFD97757),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'J${note.day} · ${note.time}',
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: const Color(0xFF6B6B6B),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    note.title,
                    style: GoogleFonts.crimsonPro(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1A1A1A),
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    note.body,
                    style: GoogleFonts.crimsonPro(
                      fontSize: 17,
                      color: const Color(0xFF1A1A1A),
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
