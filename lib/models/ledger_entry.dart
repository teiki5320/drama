enum LedgerEntryKind {
  passiveIncome,
  shopPurchase,
  stockBuy,
  stockSell,
  momTreatment,
  choiceExpense,
  choiceIncome,
  dailyExpense,
  rent,
}

class LedgerEntry {
  final int day;
  final LedgerEntryKind kind;
  final String label;
  final int amount;

  const LedgerEntry({
    required this.day,
    required this.kind,
    required this.label,
    required this.amount,
  });

  String get emoji {
    switch (kind) {
      case LedgerEntryKind.passiveIncome:
        return '💼';
      case LedgerEntryKind.shopPurchase:
        return '🛍️';
      case LedgerEntryKind.stockBuy:
        return '📈';
      case LedgerEntryKind.stockSell:
        return '📉';
      case LedgerEntryKind.momTreatment:
        return '🏥';
      case LedgerEntryKind.choiceExpense:
        return '🧾';
      case LedgerEntryKind.choiceIncome:
        return '💵';
      case LedgerEntryKind.dailyExpense:
        return '🚇';
      case LedgerEntryKind.rent:
        return '🏠';
    }
  }

  Map<String, dynamic> toJson() => {
        'day': day,
        'kind': kind.name,
        'label': label,
        'amount': amount,
      };

  factory LedgerEntry.fromJson(Map<String, dynamic> json) => LedgerEntry(
        day: (json['day'] as num).toInt(),
        kind: LedgerEntryKind.values.firstWhere(
          (e) => e.name == json['kind'],
          orElse: () => LedgerEntryKind.choiceExpense,
        ),
        label: json['label'] as String,
        amount: (json['amount'] as num).toInt(),
      );
}
