/// Article achetable dans l'app Banque > Achats.
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

  const ShopItem({
    required this.id,
    required this.category,
    required this.emoji,
    required this.name,
    required this.description,
    required this.price,
    required this.moodGain,
    required this.reputationGain,
    this.requiredReputation = 0,
    this.requiredMood = 0,
    this.generatesInstaPost = false,
  });

  factory ShopItem.fromJson(Map<String, dynamic> j) => ShopItem(
        id: j['id'] as String,
        category: j['category'] as String,
        emoji: j['emoji'] as String,
        name: j['name'] as String,
        description: j['description'] as String,
        price: (j['price'] as num).toInt(),
        moodGain: (j['moodGain'] as num?)?.toInt() ?? 0,
        reputationGain: (j['reputationGain'] as num?)?.toInt() ?? 0,
        requiredReputation: (j['requiredReputation'] as num?)?.toInt() ?? 0,
        requiredMood: (j['requiredMood'] as num?)?.toInt() ?? 0,
        generatesInstaPost: j['generatesInstaPost'] as bool? ?? false,
      );
}

const kShopCategories = <String, String>{
  'vehicule': '🛵 Véhicule',
  'mode': '👗 Mode',
  'bijoux': '💎 Bijoux',
  'voyage': '✈️ Voyage',
  'tech': '📱 Tech',
  'deco': '🌿 Déco',
  'beaute': '🌸 Beauté',
  'bouffe': '🍽️ Gastronomie',
  'art': '🎨 Art',
  'immobilier': '🏠 Immobilier',
  'mecenat': '🎗️ Mécénat',
};
