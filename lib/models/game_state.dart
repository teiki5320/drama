import 'dart:convert';

import 'insta_post.dart';

class GameState {
  final int currentDay;
  final int argent;
  final int mood;
  final int reputation;
  final int followers;
  final Map<String, int> stockHoldings;
  final Map<String, double> stockAvgCost;
  final Map<String, double> stockCurrentPrices;
  final List<String> ownedItems;
  final Map<int, int> choicesMade;
  final int lowMoodStreak;
  final bool isMomTreatmentPaid;
  final List<String> unlockedConversations;
  final List<String> seenInstaPosts;
  final List<InstaPost> generatedInstaPosts;
  final String? ending;

  const GameState({
    this.currentDay = 1,
    this.argent = 2384,
    this.mood = 5,
    this.reputation = 0,
    this.followers = 712,
    this.stockHoldings = const {},
    this.stockAvgCost = const {},
    this.stockCurrentPrices = const {},
    this.ownedItems = const [],
    this.choicesMade = const {},
    this.lowMoodStreak = 0,
    this.isMomTreatmentPaid = false,
    this.unlockedConversations = const ['maman', 'camille'],
    this.seenInstaPosts = const [],
    this.generatedInstaPosts = const [],
    this.ending,
  });

  GameState copyWith({
    int? currentDay,
    int? argent,
    int? mood,
    int? reputation,
    int? followers,
    Map<String, int>? stockHoldings,
    Map<String, double>? stockAvgCost,
    Map<String, double>? stockCurrentPrices,
    List<String>? ownedItems,
    Map<int, int>? choicesMade,
    int? lowMoodStreak,
    bool? isMomTreatmentPaid,
    List<String>? unlockedConversations,
    List<String>? seenInstaPosts,
    List<InstaPost>? generatedInstaPosts,
    String? ending,
  }) {
    return GameState(
      currentDay: currentDay ?? this.currentDay,
      argent: argent ?? this.argent,
      mood: mood ?? this.mood,
      reputation: reputation ?? this.reputation,
      followers: followers ?? this.followers,
      stockHoldings: stockHoldings ?? this.stockHoldings,
      stockAvgCost: stockAvgCost ?? this.stockAvgCost,
      stockCurrentPrices: stockCurrentPrices ?? this.stockCurrentPrices,
      ownedItems: ownedItems ?? this.ownedItems,
      choicesMade: choicesMade ?? this.choicesMade,
      lowMoodStreak: lowMoodStreak ?? this.lowMoodStreak,
      isMomTreatmentPaid: isMomTreatmentPaid ?? this.isMomTreatmentPaid,
      unlockedConversations:
          unlockedConversations ?? this.unlockedConversations,
      seenInstaPosts: seenInstaPosts ?? this.seenInstaPosts,
      generatedInstaPosts: generatedInstaPosts ?? this.generatedInstaPosts,
      ending: ending ?? this.ending,
    );
  }

  Map<String, dynamic> toJson() => {
        'currentDay': currentDay,
        'argent': argent,
        'mood': mood,
        'reputation': reputation,
        'followers': followers,
        'stockHoldings': stockHoldings,
        'stockAvgCost': stockAvgCost,
        'stockCurrentPrices': stockCurrentPrices,
        'ownedItems': ownedItems,
        'choicesMade':
            choicesMade.map((k, v) => MapEntry(k.toString(), v)),
        'lowMoodStreak': lowMoodStreak,
        'isMomTreatmentPaid': isMomTreatmentPaid,
        'unlockedConversations': unlockedConversations,
        'seenInstaPosts': seenInstaPosts,
        'generatedInstaPosts':
            generatedInstaPosts.map((e) => e.toJson()).toList(),
        'ending': ending,
      };

  factory GameState.fromJson(Map<String, dynamic> json) => GameState(
        currentDay: (json['currentDay'] as num?)?.toInt() ?? 1,
        argent: (json['argent'] as num?)?.toInt() ?? 2384,
        mood: (json['mood'] as num?)?.toInt() ?? 5,
        reputation: (json['reputation'] as num?)?.toInt() ?? 0,
        followers: (json['followers'] as num?)?.toInt() ?? 712,
        stockHoldings: ((json['stockHoldings'] as Map?) ?? const {})
            .map((k, v) => MapEntry(k.toString(), (v as num).toInt())),
        stockAvgCost: ((json['stockAvgCost'] as Map?) ?? const {})
            .map((k, v) => MapEntry(k.toString(), (v as num).toDouble())),
        stockCurrentPrices: ((json['stockCurrentPrices'] as Map?) ?? const {})
            .map((k, v) => MapEntry(k.toString(), (v as num).toDouble())),
        ownedItems: ((json['ownedItems'] as List?) ?? const [])
            .map((e) => e.toString())
            .toList(growable: false),
        choicesMade: ((json['choicesMade'] as Map?) ?? const {}).map(
          (k, v) => MapEntry(int.parse(k.toString()), (v as num).toInt()),
        ),
        lowMoodStreak: (json['lowMoodStreak'] as num?)?.toInt() ?? 0,
        isMomTreatmentPaid: (json['isMomTreatmentPaid'] as bool?) ?? false,
        unlockedConversations:
            ((json['unlockedConversations'] as List?) ?? const [])
                .map((e) => e.toString())
                .toList(growable: false),
        seenInstaPosts: ((json['seenInstaPosts'] as List?) ?? const [])
            .map((e) => e.toString())
            .toList(growable: false),
        generatedInstaPosts:
            ((json['generatedInstaPosts'] as List?) ?? const [])
                .map((e) => InstaPost.fromJson(e as Map<String, dynamic>))
                .toList(growable: false),
        ending: json['ending'] as String?,
      );

  String encode() => jsonEncode(toJson());
  static GameState decode(String s) =>
      GameState.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
