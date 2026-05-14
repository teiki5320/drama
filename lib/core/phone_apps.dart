import 'package:flutter/material.dart';

/// Métadonnées d'une app affichable sur le home screen.
class AppMeta {
  final String id;
  final String label;
  final IconData icon;
  final Color color;       // teinte de fond de l'icône
  final Color fgColor;     // teinte de l'icône
  final bool inDock;       // visible en permanence dans le dock du bas

  const AppMeta({
    required this.id,
    required this.label,
    required this.icon,
    required this.color,
    this.fgColor = Colors.white,
    this.inDock = false,
  });
}

/// Catalogue complet des apps du téléphone (PR 1 → coquilles, les PR
/// suivantes remplissent chaque app).
const List<AppMeta> kAllApps = [
  // ─── Dock (4 apps permanentes) ──────────────────────────────────
  AppMeta(
    id: 'telephone',
    label: 'Téléphone',
    icon: Icons.phone,
    color: Color(0xFF4CD964),
    inDock: true,
  ),
  AppMeta(
    id: 'messages',
    label: 'Messages',
    icon: Icons.chat_bubble,
    color: Color(0xFF34C759),
    inDock: true,
  ),
  AppMeta(
    id: 'photos',
    label: 'Photos',
    icon: Icons.photo_library,
    color: Color(0xFFFF6B6B),
    inDock: true,
  ),
  AppMeta(
    id: 'banque',
    label: 'Banque',
    icon: Icons.account_balance,
    color: Color(0xFF1F2937),
    inDock: true,
  ),
  // ─── Page 1 du home (6 apps) ────────────────────────────────────
  AppMeta(
    id: 'notes',
    label: 'Notes',
    icon: Icons.sticky_note_2,
    color: Color(0xFFFDDB6E),
    fgColor: Color(0xFF1A1A1A),
  ),
  AppMeta(
    id: 'calendrier',
    label: 'Calendrier',
    icon: Icons.calendar_today,
    color: Color(0xFFFFFFFF),
    fgColor: Color(0xFFE53935),
  ),
  AppMeta(
    id: 'instagram',
    label: 'Instagram',
    icon: Icons.camera_alt_outlined,
    color: Color(0xFFE1306C),
  ),
  AppMeta(
    id: 'whatsapp',
    label: 'WhatsApp',
    icon: Icons.message,
    color: Color(0xFF25D366),
  ),
  AppMeta(
    id: 'ubereats',
    label: 'Uber Eats',
    icon: Icons.delivery_dining,
    color: Color(0xFF06C167),
  ),
  AppMeta(
    id: 'tinder',
    label: 'Tinder',
    icon: Icons.local_fire_department,
    color: Color(0xFFFD297B),
  ),
];

AppMeta appById(String id) => kAllApps.firstWhere((a) => a.id == id);
