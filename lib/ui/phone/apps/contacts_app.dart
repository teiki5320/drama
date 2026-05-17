import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../data/contacts_data.dart';
import '../../../providers/phone_state_provider.dart';
import '../status_bar.dart';

/// App Contacts — liste des personnages rencontrés. Chaque fiche
/// s'ouvre sur un détail plein écran (grande photo + épigraphe).
class ContactsApp extends ConsumerStatefulWidget {
  const ContactsApp({super.key});

  @override
  ConsumerState<ContactsApp> createState() => _ContactsAppState();
}

class _ContactsAppState extends ConsumerState<ContactsApp> {
  Contact? _selected;

  @override
  Widget build(BuildContext context) {
    final beatIdx =
        ref.watch(phoneStateProvider.select((s) => s.currentBeatIdx));
    final visible = kAllContacts
        .where((c) => c.unlockBeatIdx < 0 || beatIdx >= c.unlockBeatIdx)
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      backgroundColor: Colors.white,
      body: _selected == null
          ? _List(
              contacts: visible,
              onTap: (c) => setState(() => _selected = c),
            )
          : _Detail(
              contact: _selected!,
              onBack: () => setState(() => _selected = null),
            ),
    );
  }
}

class _List extends ConsumerWidget {
  const _List({required this.contacts, required this.onTap});
  final List<Contact> contacts;
  final ValueChanged<Contact> onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const PhoneStatusBar(foreground: Color(0xFF1A1A1A)),
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new,
                    color: Color(0xFF007AFF), size: 20),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  ref.read(phoneStateProvider.notifier).closeApp();
                },
              ),
              const SizedBox(width: 4),
              Text(
                'Contacts',
                style: GoogleFonts.crimsonPro(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: contacts.length,
            separatorBuilder: (_, __) => Padding(
              padding: const EdgeInsets.only(left: 64),
              child: Container(height: 0.5, color: Colors.grey.shade300),
            ),
            itemBuilder: (context, i) =>
                _Row(contact: contacts[i], onTap: () => onTap(contacts[i])),
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.contact, required this.onTap});
  final Contact contact;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: AssetImage(contact.avatarPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                contact.name,
                style: GoogleFonts.inter(
                  fontSize: 17,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF1A1A1A),
                ),
              ),
            ),
            Icon(Icons.chevron_right,
                color: Colors.grey.shade400, size: 22),
          ],
        ),
      ),
    );
  }
}

class _Detail extends StatelessWidget {
  const _Detail({required this.contact, required this.onBack});
  final Contact contact;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            contact.accent.first,
            contact.accent.last,
            Colors.black,
          ],
          stops: const [0.0, 0.55, 1.0],
        ),
      ),
      child: Column(
        children: [
          const PhoneStatusBar(foreground: Colors.white),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 16, 8),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new,
                      color: Colors.white, size: 20),
                  onPressed: () {
                    HapticFeedback.selectionClick();
                    onBack();
                  },
                ),
                const SizedBox(width: 4),
                Text(
                  'Contacts',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.85),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: Colors.white.withValues(alpha: 0.45), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.35),
                  blurRadius: 24,
                  spreadRadius: 2,
                ),
              ],
              image: DecorationImage(
                image: AssetImage(contact.avatarPath),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            contact.name,
            textAlign: TextAlign.center,
            style: GoogleFonts.crimsonPro(
              fontSize: 26,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              contact.role,
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.65),
                letterSpacing: 0.5,
                height: 1.4,
              ),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(36, 0, 36, 32),
            child: Column(
              children: [
                Text(
                  contact.epigraph,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.crimsonPro(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    color: Colors.white.withValues(alpha: 0.92),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  '— ${contact.attribution}',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    color: Colors.white.withValues(alpha: 0.55),
                    letterSpacing: 1.2,
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
