class Investment {
  final String ticker;
  final String name;
  final String sector;
  final double price;
  final String description;
  final int? unlockedAtDay;

  const Investment({
    required this.ticker,
    required this.name,
    required this.sector,
    required this.price,
    required this.description,
    this.unlockedAtDay,
  });

  String get id => ticker;

  factory Investment.fromJson(Map<String, dynamic> json) => Investment(
        ticker: json['ticker'] as String,
        name: json['name'] as String,
        sector: json['sector'] as String,
        price: (json['price'] as num).toDouble(),
        description: json['description'] as String,
        unlockedAtDay: (json['unlockedAtDay'] as num?)?.toInt(),
      );

  Investment copyWith({double? price}) => Investment(
        ticker: ticker,
        name: name,
        sector: sector,
        price: price ?? this.price,
        description: description,
        unlockedAtDay: unlockedAtDay,
      );
}
