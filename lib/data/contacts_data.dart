import 'package:flutter/material.dart';

/// Une fiche personnage consultable dans l'app Contacts. Chaque fiche
/// s'enrichit au fil des rencontres : on ne voit Tristan qu'à partir
/// du beat où il appelle pour la première fois, etc.
class Contact {
  final String id;
  final String name;
  final String role;
  final String avatarPath;
  final String epigraph;
  final String attribution;
  final List<Color> accent;

  /// Index global de beat (cf. PhoneState.currentBeatIdx) à partir
  /// duquel la fiche apparaît dans Contacts. `-1` = visible dès le
  /// premier lancement (perso déjà présentés dans l'onboarding).
  final int unlockBeatIdx;

  const Contact({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarPath,
    required this.epigraph,
    required this.attribution,
    required this.accent,
    this.unlockBeatIdx = -1,
  });
}

/// Liste canonique des fiches. Les épigraphes Shen/Maman/Camille sont
/// repris à l'identique de l'onboarding — ne pas réécrire sans
/// validation explicite (voir CLAUDE.md).
const List<Contact> kAllContacts = [
  Contact(
    id: 'shen',
    name: 'Shen Marchand',
    role: 'Vingt-quatre ans · Livreuse à vélo · Belleville',
    avatarPath: 'assets/photos/avatars/shen.webp',
    epigraph:
        'Je n\'écris pas pour me souvenir.\n'
        'J\'écris pour ne pas pleurer.',
    attribution: 'Carnet, premier jour',
    accent: [Color(0xFF14213D), Color(0xFF1F2937)],
  ),
  Contact(
    id: 'maman',
    name: 'Hélène, dite Maman',
    role: 'Cinquante ans · Toux depuis trois nuits',
    avatarPath: 'assets/photos/avatars/maman.webp',
    epigraph:
        'Tu as mis ton écharpe ?\n'
        'Tes vingt-quatre ans ne tiendront pas la pluie\n'
        'aussi longtemps que tu le crois.',
    attribution: 'SMS, 7 h 30',
    accent: [Color(0xFF1F2937), Color(0xFF3A2E3F)],
  ),
  Contact(
    id: 'camille',
    name: 'Camille Roux',
    role: 'Étudiante en droit · Croissants · Fidèle',
    avatarPath: 'assets/photos/avatars/camille.webp',
    epigraph:
        'Tu n\'es pas un héros,\n'
        't\'es une fille avec un téléphone.',
    attribution: 'Vocal, après-midi',
    accent: [Color(0xFF2A2E3F), Color(0xFF3F2A35)],
  ),
];
