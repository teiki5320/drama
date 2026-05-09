class ShopItem {
  final String id;
  final String category;
  final String emoji;
  final String name;
  final String description;
  final int price;
  final int moodGain;
  final int reputationGain;
  final int requiredReputation;
  final int requiredMood;
  final bool generatesInstaPost;
  final String? instaPostCaption;
  final String? instaPostEmoji;

  const ShopItem({
    required this.id,
    required this.category,
    required this.emoji,
    required this.name,
    required this.description,
    required this.price,
    required this.moodGain,
    required this.reputationGain,
    required this.requiredReputation,
    required this.requiredMood,
    required this.generatesInstaPost,
    this.instaPostCaption,
    this.instaPostEmoji,
  });

  factory ShopItem.fromJson(Map<String, dynamic> json) => ShopItem(
        id: json['id'] as String,
        category: json['category'] as String,
        emoji: json['emoji'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        price: (json['price'] as num).toInt(),
        moodGain: (json['moodGain'] as num?)?.toInt() ?? 0,
        reputationGain: (json['reputationGain'] as num?)?.toInt() ?? 0,
        requiredReputation: (json['requiredReputation'] as num?)?.toInt() ?? 0,
        requiredMood: (json['requiredMood'] as num?)?.toInt() ?? 0,
        generatesInstaPost: (json['generatesInstaPost'] as bool?) ?? false,
        instaPostCaption: json['instaPostCaption'] as String?,
        instaPostEmoji: json['instaPostEmoji'] as String?,
      );
}
