/// Ambiance / météo / palette par jour, affichée comme un badge discret
/// à côté de la date dans le titre du carnet. Permet d'ancrer le ton
/// émotionnel de la journée avant même la lecture.

class DayAmbience {
  final String emoji;
  final String label;
  const DayAmbience({required this.emoji, required this.label});
}

const Map<int, DayAmbience> kDayAmbiences = {
  1: DayAmbience(emoji: '🌧️', label: 'Pluie sur Belleville'),
  2: DayAmbience(emoji: '🏥', label: 'Lumière clinique'),
  3: DayAmbience(emoji: '🌥️', label: 'Dimanche gris'),
  4: DayAmbience(emoji: '☕', label: 'Café chaud, fenêtre humide'),
  5: DayAmbience(emoji: '🌙', label: 'Nuit blanche'),
  6: DayAmbience(emoji: '🪞', label: 'Avant-veille'),
  7: DayAmbience(emoji: '☁️', label: 'Brume sur Paris'),
  8: DayAmbience(emoji: '✒️', label: 'Encre noire, parquet ciré'),
  9: DayAmbience(emoji: '✨', label: 'Doré silencieux'),
  10: DayAmbience(emoji: '🍓', label: 'Matin tendre'),
  11: DayAmbience(emoji: '🌹', label: 'Belleville le soir'),
  12: DayAmbience(emoji: '🍽️', label: 'Treize chaises'),
  13: DayAmbience(emoji: '🍵', label: 'Veille'),
  14: DayAmbience(emoji: '🍷', label: 'Long Jing première récolte'),
};

DayAmbience? ambienceForDay(int day) => kDayAmbiences[day];
