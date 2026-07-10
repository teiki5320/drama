import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../data/sms_choices.dart';
import '../../../../providers/phone_state_provider.dart';
import '../../../../providers/relationships_provider.dart';
import '../../../../providers/sent_replies_provider.dart';

/// Panneau de 3 boutons de réponse, en bas de la conversation, quand un
/// message reçu attend un choix de Shen. Au tap : ajoute le reply, met
/// à jour les jauges relationnelles, ferme le panneau.
class ChoicePanel extends ConsumerStatefulWidget {
  const ChoicePanel({
    super.key,
    required this.beatId,
    required this.lastMessageTime,
    required this.lastMessageDay,
    this.promptText,
  });

  final String beatId;
  final String lastMessageTime;
  final int lastMessageDay;

  /// Extrait du message auquel Shen répond — le panneau peut viser un
  /// message plus haut dans le fil, on le cite pour lever l'ambiguïté.
  final String? promptText;

  @override
  ConsumerState<ChoicePanel> createState() => _ChoicePanelState();
}

class _ChoicePanelState extends ConsumerState<ChoicePanel> {
  /// Anti double-tap : deux taps rapides appliquaient deux deltas et
  /// écrasaient la réponse.
  bool _sent = false;

  String get beatId => widget.beatId;
  String get lastMessageTime => widget.lastMessageTime;
  int get lastMessageDay => widget.lastMessageDay;

  @override
  Widget build(BuildContext context) {
    final choice = choiceForBeat(beatId);
    if (choice == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFAFAFA),
        border: Border(top: BorderSide(color: Color(0xFFE5E5E5), width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.promptText != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6, left: 4, right: 4),
              child: Text(
                '\u00AB ${widget.promptText!.length > 80 ? '${widget.promptText!.substring(0, 80)}\u2026' : widget.promptText!} \u00BB',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey.shade500,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 4),
            child: Text(
              'Tu réponds quoi ?',
              style: GoogleFonts.inter(
                fontSize: 11,
                color: Colors.grey.shade600,
                letterSpacing: 0.4,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          for (final option in choice.options)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: _OptionButton(
                option: option,
                onTap: () {
                  if (_sent) return;
                  setState(() => _sent = true);
                  HapticFeedback.selectionClick();
                  // 1) Mémorise la réponse pour la rendre dans la conversation
                  ref.read(sentRepliesProvider.notifier).send(SentReply(
                        contactId: choice.contactId,
                        beatId: beatId,
                        text: option.reply,
                        time: lastMessageTime,
                        day: lastMessageDay,
                      ));
                  // 2) Applique le delta sur la jauge du contact
                  ref
                      .read(relationshipsProvider.notifier)
                      .apply(choice.contactId, option.delta);
                  // 3) Petite consommation batterie
                  ref.read(phoneStateProvider.notifier).consumeBattery(1);
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _OptionButton extends StatelessWidget {
  const _OptionButton({required this.option, required this.onTap});
  final SmsChoiceOption option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E5E5), width: 0.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (option.label != null)
              Text(
                option.label!.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF007AFF),
                  letterSpacing: 1.0,
                ),
              ),
            const SizedBox(height: 2),
            Text(
              option.reply,
              style: GoogleFonts.inter(
                fontSize: 14,
                color: const Color(0xFF1A1A1A),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
