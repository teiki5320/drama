import 'package:flutter/material.dart';

/// Voile coloré qui se superpose au wallpaper pour traduire l'état
/// émotionnel de Shen — plus le mood est bas, plus le voile est sombre
/// et bleuté ; plus il est haut, plus c'est chaud-doré.
///
/// Échelle mood 0-10. Neutre = 5 (aucun voile).
Color moodOverlay(int mood) {
  if (mood >= 5) {
    // 5 → transparent ; 10 → voile chaud doré (8% alpha)
    final pct = ((mood - 5) / 5).clamp(0.0, 1.0);
    final alpha = (0x14 * pct).round();
    return Color(0xFFE8AC65).withAlpha(alpha);
  } else {
    // 4 → léger ; 0 → voile bleu nuit profond (40% alpha)
    final pct = ((5 - mood) / 5).clamp(0.0, 1.0);
    final alpha = (0x66 * pct).round();
    return Color(0xFF0A1530).withAlpha(alpha);
  }
}

/// Tier réputation pour affichage (« Anonyme » / « Vue » / « Remarquée »
/// / « Mondaine »). Le label apparaît discrètement sur le lock screen.
String reputationTier(int rep) {
  if (rep < 5) return 'Anonyme';
  if (rep < 15) return 'Vue';
  if (rep < 30) return 'Remarquée';
  return 'Mondaine';
}
