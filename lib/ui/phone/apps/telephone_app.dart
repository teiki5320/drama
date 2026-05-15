import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/telephone_data.dart';
import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// App Téléphone — journal d'appels iOS-like, voicemails.
class TelephoneApp extends ConsumerWidget {
  const TelephoneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final day = ref.watch(phoneStateProvider.select((s) => s.currentDay));
    final calls = kCalls.where((c) => c.day <= day).toList().reversed.toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const PhoneStatusBar(foreground: Color(0xFF1A1A1A)),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Color(0xFF4CD964), size: 20),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    ref.read(phoneStateProvider.notifier).closeApp();
                  },
                ),
                const SizedBox(width: 4),
                Text(
                  'Récents',
                  style: GoogleFonts.crimsonPro(
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
                const Spacer(),
                Icon(Icons.add_circle_outline,
                    color: const Color(0xFF4CD964), size: 26),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: calls.length,
              separatorBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(left: 50),
                child: Container(height: 0.5, color: Colors.grey.shade300),
              ),
              itemBuilder: (context, i) => _CallRow(call: calls[i]),
            ),
          ),
        ],
      ),
    );
  }
}

class _CallRow extends StatelessWidget {
  const _CallRow({required this.call});
  final CallEntry call;

  @override
  Widget build(BuildContext context) {
    final missed = call.type == CallType.missed;
    final color = missed ? const Color(0xFFE53935) : const Color(0xFF1A1A1A);
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        if (call.voicemailNote != null) {
          showModalBottomSheet(
            context: context,
            backgroundColor: const Color(0xFFFBF7EF),
            builder: (_) => _VoicemailSheet(call: call),
          );
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            // Avatar contact si dispo, sinon emoji + tinte
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: call.avatarPath == null
                    ? const Color(0xFFEFEFEF)
                    : null,
                image: call.avatarPath != null
                    ? DecorationImage(
                        image: AssetImage(call.avatarPath!),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
              alignment: Alignment.center,
              child: call.avatarPath != null
                  ? null
                  : Text(call.contactEmoji ?? '📞',
                      style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 10),
            Icon(_iconForType(call.type),
                color: call.type == CallType.missed
                    ? const Color(0xFFE53935)
                    : Colors.grey.shade600,
                size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    call.contactLabel,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: color,
                    ),
                  ),
                  Text(
                    _labelForType(call.type),
                    style: GoogleFonts.inter(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'J${call.day} · ${call.time}',
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.info_outline,
                color: Color(0xFF4CD964), size: 18),
          ],
        ),
      ),
    );
  }

  static IconData _iconForType(CallType t) {
    switch (t) {
      case CallType.incoming:
        return Icons.call_received;
      case CallType.outgoing:
        return Icons.call_made;
      case CallType.missed:
        return Icons.call_missed;
      case CallType.voicemail:
        return Icons.voicemail;
    }
  }

  static String _labelForType(CallType t) {
    switch (t) {
      case CallType.incoming:
        return 'Entrant';
      case CallType.outgoing:
        return 'Sortant';
      case CallType.missed:
        return 'Manqué';
      case CallType.voicemail:
        return 'Messagerie';
    }
  }
}

class _VoicemailSheet extends StatelessWidget {
  const _VoicemailSheet({required this.call});
  final CallEntry call;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.voicemail, color: Colors.grey.shade700),
                const SizedBox(width: 8),
                Text(
                  'Transcription',
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              call.contactLabel,
              style: GoogleFonts.crimsonPro(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF1A1A1A),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              call.voicemailNote ?? '',
              style: GoogleFonts.crimsonPro(
                fontSize: 16,
                color: const Color(0xFF1A1A1A),
                height: 1.5,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24),
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CD964),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.play_arrow, color: Colors.white, size: 18),
                    const SizedBox(width: 6),
                    Text(
                      call.duration,
                      style: GoogleFonts.inter(
                          fontSize: 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
