import 'package:flutter/material.dart';

import '../contacts.dart';
import '../models.dart';
import '../palette.dart';
import 'widgets.dart';

/// Ouvre la fiche du contact, comme quand on touche le nom en haut
/// d'une conversation dans Messages.
void showContactSheet(BuildContext context, ThreadState thread) {
  final pal = Palette.of(context);
  final def = thread.effectiveDef;
  final contactKey = thread.contactKey;
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: pal.threadBg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => ContactSheet(def: def, contactKey: contactKey),
  );
}

class ContactSheet extends StatelessWidget {
  const ContactSheet({super.key, required this.def, this.contactKey});

  final ThreadDef def;
  final String? contactKey;

  void _messagerieSeulement(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(
          content: Text('Dans Drama, tout passe par les messages.'),
          duration: Duration(seconds: 2),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    final info = kContacts[contactKey ?? def.id] ??
        ContactInfo(displayName: def.name, emptyNote: 'Aucune information.');
    final height = MediaQuery.of(context).size.height * 0.82;
    return SizedBox(
      height: height,
      child: Column(
        children: [
          const SizedBox(height: 8),
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: pal.meta.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 24),
              children: [
                Center(child: GradientAvatar(def: def, size: 96)),
                const SizedBox(height: 12),
                Center(
                  child: Text(
                    info.displayName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: pal.headText,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                    ),
                  ),
                ),
                if (info.subtitle != null) ...[
                  const SizedBox(height: 3),
                  Center(
                    child: Text(
                      info.subtitle!,
                      style: TextStyle(color: pal.meta, fontSize: 14),
                    ),
                  ),
                ],
                const SizedBox(height: 18),
                Row(
                  children: [
                    _ActionButton(
                      icon: Icons.chat_bubble,
                      label: 'message',
                      onTap: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      icon: Icons.phone,
                      label: 'appeler',
                      onTap: () => _messagerieSeulement(context),
                    ),
                    const SizedBox(width: 8),
                    _ActionButton(
                      icon: Icons.videocam,
                      label: 'vidéo',
                      onTap: () => _messagerieSeulement(context),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                if (info.fields.isEmpty && info.emptyNote != null)
                  _Cell(
                    child: Text(
                      info.emptyNote!,
                      style: TextStyle(color: pal.meta, fontSize: 15),
                    ),
                  ),
                for (final field in info.fields) ...[
                  _Cell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          field.label,
                          style: TextStyle(
                            color: pal.meta,
                            fontSize: 12.5,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          field.value,
                          style: TextStyle(
                            color: field.label == 'mobile' ||
                                    field.label == 'assistance'
                                ? pal.chev
                                : pal.headText,
                            fontSize: 16,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                if (info.canBlock) ...[
                  const SizedBox(height: 4),
                  _Cell(
                    onTap: () {
                      ScaffoldMessenger.of(context)
                        ..clearSnackBars()
                        ..showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Dans Drama, certains numéros reviennent toujours.'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                    },
                    child: Text(
                      'Bloquer ce correspondant',
                      style: TextStyle(
                        color: pal.pill,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    return Expanded(
      child: Material(
        color: pal.inBubble,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              children: [
                Icon(icon, color: pal.chev, size: 20),
                const SizedBox(height: 3),
                Text(
                  label,
                  style: TextStyle(color: pal.chev, fontSize: 11.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({required this.child, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final pal = Palette.of(context);
    return Material(
      color: pal.inBubble.withValues(alpha: 0.55),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          child: child,
        ),
      ),
    );
  }
}
