/// In-game time helpers. Day 1 corresponds to Friday June 3 (per scenario.json
/// J1.date). All dates derive from this anchor.

const _frenchDays = [
  'Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche',
];
const _frenchMonths = [
  'janvier', 'février', 'mars', 'avril', 'mai', 'juin',
  'juillet', 'août', 'septembre', 'octobre', 'novembre', 'décembre',
];

DateTime _gameDate(int day) {
  final base = DateTime(2024, 6, 3); // Vendredi 3 juin
  return base.add(Duration(days: day - 1));
}

String formatGameDate(int day) {
  final d = _gameDate(day);
  return '${_frenchDays[d.weekday - 1]} ${d.day} ${_frenchMonths[d.month - 1]}';
}

/// Short variant: "03 juin", "28 juin".
String formatGameDateShort(int day) {
  final d = _gameDate(day);
  return '${d.day.toString().padLeft(2, '0')} ${_frenchMonths[d.month - 1]}';
}

/// Money with thin spaces as thousands separator: 9950 → "9 950 €".
String formatMoney(int amount) {
  final neg = amount < 0;
  final abs = amount.abs().toString();
  final buf = StringBuffer();
  for (var i = 0; i < abs.length; i++) {
    if (i > 0 && (abs.length - i) % 3 == 0) buf.write(' '); // narrow nbsp
    buf.write(abs[i]);
  }
  return '${neg ? '-' : ''}${buf.toString()} €';
}

/// Money with sign always shown: positive → "+9 950 €", negative → "-9 950 €".
String formatMoneySigned(int amount) {
  if (amount > 0) return '+${formatMoney(amount)}';
  return formatMoney(amount);
}
