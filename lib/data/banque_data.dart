/// Données de l'app Banque — mouvements, soldes, alertes.
/// Les chiffres collent au scénario canonique (2 384 € au démarrage).

class BankMovement {
  final int day;
  final String time;
  final String label;
  final int amount; // négatif = sortie, positif = entrée
  final String category;
  final String emoji;

  const BankMovement({
    required this.day,
    required this.time,
    required this.label,
    required this.amount,
    required this.category,
    required this.emoji,
  });
}

const kMovements = <BankMovement>[
  // Mouvements antérieurs au J1 (le compte ne part pas de zéro)
  BankMovement(
      day: 0,
      time: '15:30',
      label: 'Loyer studio Belleville',
      amount: -680,
      category: 'logement',
      emoji: '🏠'),
  BankMovement(
      day: 0,
      time: '09:12',
      label: 'CAF — prime étudiante',
      amount: 320,
      category: 'aide',
      emoji: '🏛️'),
  BankMovement(
      day: 0,
      time: '11:48',
      label: 'Livraisons (semaine)',
      amount: 240,
      category: 'travail',
      emoji: '🛵'),
  // Idée 4 — Trace que Maman gérait déjà mal son budget
  BankMovement(
      day: 0,
      time: '08:45',
      label: 'Pharmacie Belleville',
      amount: -15,
      category: 'sante',
      emoji: '💊'),
  BankMovement(
      day: 0,
      time: '17:22',
      label: 'Métro · 10 tickets',
      amount: -16,
      category: 'transport',
      emoji: '🚇'),
  BankMovement(
      day: 0,
      time: '19:08',
      label: 'Carrefour Express · pain, lait, riz',
      amount: -8,
      category: 'courses',
      emoji: '🛒'),
  // J1
  BankMovement(
      day: 1,
      time: '07:32',
      label: 'Boulangerie Wong',
      amount: -3,
      category: 'courses',
      emoji: '🥐'),
  BankMovement(
      day: 1,
      time: '08:31',
      label: 'Plateforme — pénalité course #14872',
      amount: -38,
      category: 'travail',
      emoji: '⚠️'),
  // J2
  BankMovement(
      day: 2,
      time: '06:25',
      label: 'Métro Couronnes — Tenon',
      amount: -3,
      category: 'transport',
      emoji: '🚇'),
  // J3
  BankMovement(
      day: 3,
      time: '14:23',
      label: 'BNP — frais dossier crédit refusé',
      amount: -50,
      category: 'banque',
      emoji: '🏦'),
];

class StockPosition {
  final String ticker;
  final String name;
  final String sector;
  final double price;
  final double change24h; // %
  final int? unlockedAtDay;
  final String description;

  const StockPosition({
    required this.ticker,
    required this.name,
    required this.sector,
    required this.price,
    required this.change24h,
    required this.description,
    this.unlockedAtDay,
  });
}

const kStocks = <StockPosition>[
  StockPosition(
    ticker: 'LUG',
    name: 'Lu Group',
    sector: 'Immobilier / Tech',
    price: 139.20,
    change24h: 0.8,
    description:
        'Conglomérat de NeoCity. Action solide, croissance steady.',
  ),
  StockPosition(
    ticker: 'NCT',
    name: 'NeoCity Tower Holdings',
    sector: 'Immobilier',
    price: 88.50,
    change24h: -0.3,
    description:
        'Gestionnaire des tours du quartier financier. Corrélé à Lu Group.',
  ),
  StockPosition(
    ticker: 'NCB',
    name: 'NeoCity Bank',
    sector: 'Banque',
    price: 69.10,
    change24h: 0.1,
    description:
        'Banque commerciale historique. Stable, peu de croissance.',
  ),
  StockPosition(
    ticker: 'HENG',
    name: 'Heng International',
    sector: 'Hôtellerie',
    price: 220.00,
    change24h: 1.4,
    unlockedAtDay: 10,
    description:
        'Le groupe de Tristan. Volatile, dépend des contrats asiatiques.',
  ),
  StockPosition(
    ticker: 'HAN',
    name: 'Hanami Café Co.',
    sector: 'Food & Beverage',
    price: 12.40,
    change24h: 2.1,
    description:
        'Chaîne de cafés artisanaux. Action pas chère. Opportunité ou piège.',
  ),
];

/// Solde de départ canonique J1.
const int kStartingBalance = 2384;

/// Events scénarisés qui poussent / cassent les prix à un jour précis.
/// Format : ticker → { day → multiplicateur appliqué au prix de base }.
/// Exemples canoniques :
///  - HENG vacille J7 (annonce du contrat Tristan), monte +12 % J8.
///  - HAN s'effondre J9 (Hanami est racheté par Lu Group, rumeur).
///  - LUG monte J10 (NeoCity gagne un appel d'offres).
const _kStockEvents = <String, Map<int, double>>{
  'HENG': {7: 0.92, 8: 1.12, 14: 1.18},
  'LUG': {10: 1.06, 13: 1.04},
  'HAN': {9: 0.78, 11: 0.85},
  'NCT': {6: 1.02, 12: 0.97},
  'NCB': {3: 0.96, 10: 1.02},
};

/// Calcule le prix d'un ticker à un jour donné. Combine :
///  - Prix de base (`StockPosition.price`).
///  - Marche aléatoire déterministe : noise pseudo-aléatoire seedé sur
///    (ticker, day) → ±3 % max par jour.
///  - Events scénarisés (cf. `_kStockEvents`) qui ajoutent un kick.
double priceAt(StockPosition s, int day) {
  if (day <= 1) return s.price;
  var price = s.price;
  for (var d = 2; d <= day; d++) {
    // Hash déterministe : ticker + day → noise [-0.03, +0.03]
    final h = (s.ticker.hashCode * 31 + d) & 0x7fffffff;
    final noise = ((h % 1000) / 1000.0 - 0.5) * 0.06; // ±3 %
    price = price * (1 + noise);
    final event = _kStockEvents[s.ticker]?[d];
    if (event != null) price = price * event;
  }
  return double.parse(price.toStringAsFixed(2));
}

/// Variation 24h en pourcent (prix d-1 vs d).
double change24hAt(StockPosition s, int day) {
  if (day <= 1) return s.change24h;
  final today = priceAt(s, day);
  final yesterday = priceAt(s, day - 1);
  if (yesterday <= 0) return 0;
  return double.parse(
      (((today - yesterday) / yesterday) * 100).toStringAsFixed(1));
}

/// Renvoie la liste des prix sur les `n` derniers jours pour un sparkline.
List<double> priceHistory(StockPosition s, int day, {int n = 14}) {
  final start = (day - n + 1).clamp(1, day);
  return [for (var d = start; d <= day; d++) priceAt(s, d)];
}
