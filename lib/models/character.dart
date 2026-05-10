import 'package:flutter/material.dart';

class Character {
  final String id;
  final String handle;
  final String displayName;
  final String emoji;
  final String? photoAsset;
  final Color tint;
  final String role;
  final String bio;
  final int? appearsAtDay;

  const Character({
    required this.id,
    required this.handle,
    required this.displayName,
    required this.emoji,
    required this.tint,
    required this.role,
    required this.bio,
    this.photoAsset,
    this.appearsAtDay,
  });
}

const kCharacters = <Character>[
  Character(
    id: 'shen',
    handle: '@shen_y',
    displayName: 'Shen Marchand',
    emoji: '🌿',
    photoAsset: 'assets/photos/characters/shen_y.png',
    tint: Color(0xFFFAE0CC),
    role: 'Toi',
    bio:
        'Étudiante en archi à mi-temps · livreuse à vélo · bilingue français-mandarin. Prend soin de Maman. Carnet vert, stylo bic.',
  ),
  Character(
    id: 'camille',
    handle: '@camille_rx',
    displayName: 'Camille Roux',
    emoji: '🥐',
    photoAsset: 'assets/photos/characters/camille_rx.jpg',
    tint: Color(0xFFFCE6D8),
    role: 'Meilleure amie',
    bio:
        'Étudiante en droit, 24 ans. Belleville depuis toujours. Croissants, vérité, loyauté. Le miroir de Shen.',
  ),
  Character(
    id: 'tristan',
    handle: '@t_heng',
    displayName: 'Tristan Heng',
    emoji: '🧊',
    photoAsset: 'assets/photos/characters/t_heng.png',
    tint: Color(0xFFD7DEE5),
    role: 'Lui',
    bio:
        'Heng International, 29 ans. Costume coupé, montre signée, regard ailleurs. Glaçon, jusqu\'au moment où il fond.',
    appearsAtDay: 1,
  ),
  Character(
    id: 'vincent',
    handle: '@vincent.h',
    displayName: 'Vincent Heng',
    emoji: '🥂',
    photoAsset: 'assets/photos/characters/vincent_h.jpg',
    tint: Color(0xFFEBD8E0),
    role: 'Le frère',
    bio:
        'Frère aîné de Tristan, 31 ans. Tout-sourire, costume sur-mesure, double agenda. Ne jamais le sous-estimer.',
    appearsAtDay: 14,
  ),
  Character(
    id: 'heng_lihua',
    handle: '@heng_lihua',
    displayName: 'Madame Heng',
    emoji: '🍵',
    photoAsset: 'assets/photos/characters/heng_lihua.jpg',
    tint: Color(0xFFE7E1D2),
    role: 'La mère de Tristan',
    bio:
        'Heng Lihua, 58 ans. Thé Long Jing, regard sans complaisance, mémoire longue. Sait des choses qu\'elle ne dit pas.',
  ),
  Character(
    id: 'mei_fujian',
    handle: '@mei_fujian',
    displayName: 'Tante Mei',
    emoji: '🌿',
    photoAsset: 'assets/photos/characters/mei_fujian.png',
    tint: Color(0xFFE0E7D7),
    role: 'Cousine du père',
    bio:
        'Mei, 60 ans, village du Fujian. Potager, brasero, lettres précieusement gardées. Le lien vers Shen Wenbo.',
  ),
  Character(
    id: 'maman',
    handle: '@helene_marchand',
    displayName: 'Hélène Marchand',
    emoji: '👩',
    photoAsset: 'assets/photos/characters/helene_marchand.png',
    tint: Color(0xFFFCE6D8),
    role: 'Maman',
    bio:
        '50 ans. Hôpital Tenon, traitement long. Chante encore en cuisinant. S\'excuse de tomber malade — c\'est insupportable.',
  ),
];

Character? characterByHandle(String handle) {
  for (final c in kCharacters) {
    if (c.handle == handle) return c;
  }
  return null;
}

Character? characterById(String id) {
  for (final c in kCharacters) {
    if (c.id == id) return c;
  }
  return null;
}
