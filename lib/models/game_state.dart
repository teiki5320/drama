import 'dart:convert';

import 'insta_post.dart';
import 'ledger_entry.dart';

class GameState {
  final int currentDay;
  final int argent;
  final int mood;
  final int reputation;
  final int followers;
  final Map<String, int> stockHoldings;
  final Map<String, double> stockAvgCost;
  final Map<String, double> stockCurrentPrices;
  final Map<String, List<double>> stockPriceHistory;
  final List<int> wealthHistory;
  final List<String> ownedItems;
  final Map<int, int> choicesMade;
  final bool isMomTreatmentPaid;
  final List<String> unlockedConversations;
  final List<InstaPost> generatedInstaPosts;
  final List<LedgerEntry> ledger;
  final List<String> seenMessageThreads;
  final int followersDeltaToday;
  final String? ending;

  /// Branche narrative active. `null` = voie principale (canonique).
  /// Bascule via `ChoiceOption.setsBranch` au moment d'un choix
  /// déterminant (ex. J7B refuse l'argent + accepte l'hospitalité).
  /// Lit ensuite les `DayEntry` dont le champ `branch` correspond.
  final String? currentBranch;

  const GameState({
    this.currentDay = 1,
    this.argent = 2384,
    this.mood = 5,
    this.reputation = 0,
    this.followers = 712,
    this.stockHoldings = const {},
    this.stockAvgCost = const {},
    this.stockCurrentPrices = const {},
    this.stockPriceHistory = const {},
    this.wealthHistory = const [],
    this.ownedItems = const [],
    this.choicesMade = const {},
    this.isMomTreatmentPaid = false,
    this.unlockedConversations = const ['maman', 'camille'],
    this.generatedInstaPosts = const [],
    this.ledger = const [],
    this.seenMessageThreads = const [],
    this.followersDeltaToday = 0,
    this.ending,
    this.currentBranch,
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
    Map<String, List<double>>? stockPriceHistory,
    List<int>? wealthHistory,
    List<String>? ownedItems,
    Map<int, int>? choicesMade,
    bool? isMomTreatmentPaid,
    List<String>? unlockedConversations,
    List<InstaPost>? generatedInstaPosts,
    List<LedgerEntry>? ledger,
    List<String>? seenMessageThreads,
    int? followersDeltaToday,
    String? ending,
    String? currentBranch,
    bool clearCurrentBranch = false,
  }) {
    return GameState(
      currentBranch: clearCurrentBranch
          ? null
          : (currentBranch ?? this.currentBranch),
      currentDay: currentDay ?? this.currentDay,
      argent: argent ?? this.argent,
      mood: mood ?? this.mood,
      reputation: reputation ?? this.reputation,
      followers: followers ?? this.followers,
      stockHoldings: stockHoldings ?? this.stockHoldings,
      stockAvgCost: stockAvgCost ?? this.stockAvgCost,
      stockCurrentPrices: stockCurrentPrices ?? this.stockCurrentPrices,
      stockPriceHistory: stockPriceHistory ?? this.stockPriceHistory,
      wealthHistory: wealthHistory ?? this.wealthHistory,
      ownedItems: ownedItems ?? this.ownedItems,
      choicesMade: choicesMade ?? this.choicesMade,
      isMomTreatmentPaid: isMomTreatmentPaid ?? this.isMomTreatmentPaid,
      unlockedConversations:
          unlockedConversations ?? this.unlockedConversations,
      generatedInstaPosts: generatedInstaPosts ?? this.generatedInstaPosts,
      ledger: ledger ?? this.ledger,
      seenMessageThreads: seenMessageThreads ?? this.seenMessageThreads,
      followersDeltaToday:
          followersDeltaToday ?? this.followersDeltaToday,
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
        'stockPriceHistory': stockPriceHistory,
        'wealthHistory': wealthHistory,
        'ownedItems': ownedItems,
        'choicesMade':
            choicesMade.map((k, v) => MapEntry(k.toString(), v)),
        'isMomTreatmentPaid': isMomTreatmentPaid,
        'unlockedConversations': unlockedConversations,
        'generatedInstaPosts':
            generatedInstaPosts.map((e) => e.toJson()).toList(),
        'ledger': ledger.map((e) => e.toJson()).toList(),
        'seenMessageThreads': seenMessageThreads,
        'followersDeltaToday': followersDeltaToday,
        'ending': ending,
        if (currentBranch != null) 'currentBranch': currentBranch,
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
        stockPriceHistory: ((json['stockPriceHistory'] as Map?) ?? const {}).map(
          (k, v) => MapEntry(
            k.toString(),
            (v as List).map((e) => (e as num).toDouble()).toList(growable: false),
          ),
        ),
        wealthHistory: ((json['wealthHistory'] as List?) ?? const [])
            .map((e) => (e as num).toInt())
            .toList(growable: false),
        ownedItems: ((json['ownedItems'] as List?) ?? const [])
            .map((e) => e.toString())
            .toList(growable: false),
        choicesMade: ((json['choicesMade'] as Map?) ?? const {}).map(
          (k, v) => MapEntry(int.parse(k.toString()), (v as num).toInt()),
        ),
        isMomTreatmentPaid: (json['isMomTreatmentPaid'] as bool?) ?? false,
        unlockedConversations:
            ((json['unlockedConversations'] as List?) ?? const [])
                .map((e) => e.toString())
                .toList(growable: false),
        generatedInstaPosts:
            ((json['generatedInstaPosts'] as List?) ?? const [])
                .map((e) => InstaPost.fromJson(e as Map<String, dynamic>))
                .toList(growable: false),
        ledger: ((json['ledger'] as List?) ?? const [])
            .map((e) => LedgerEntry.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
        seenMessageThreads: ((json['seenMessageThreads'] as List?) ?? const [])
            .map((e) => e.toString())
            .toList(growable: false),
        followersDeltaToday:
            (json['followersDeltaToday'] as num?)?.toInt() ?? 0,
        ending: json['ending'] as String?,
        currentBranch: json['currentBranch'] as String?,
      );

  String encode() => jsonEncode(toJson());
  static GameState decode(String s) =>
      GameState.fromJson(jsonDecode(s) as Map<String, dynamic>);
}
