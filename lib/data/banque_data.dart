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
