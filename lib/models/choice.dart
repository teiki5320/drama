class Choice {
  final String prompt;
  final List<ChoiceOption> options;

  /// Délai en secondes au-delà duquel le choix est forcé (option par
  /// défaut sélectionnée automatiquement). `null` = pas de timer. Réservé
  /// aux jours climactiques où l'hésitation a un poids dramatique.
  final int? timeLimitSeconds;

  /// Index de l'option choisie par défaut quand le timer expire. Par
  /// défaut la dernière option (généralement "ne pas répondre" /
  /// "passivité"), qui correspond à un échec narratif explicite.
  final int? defaultOptionIndex;

  const Choice({
    required this.prompt,
    required this.options,
    this.timeLimitSeconds,
    this.defaultOptionIndex,
  });

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        prompt: json['prompt'] as String,
        options: (json['options'] as List<dynamic>)
            .map((e) => ChoiceOption.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
        timeLimitSeconds: (json['timeLimitSeconds'] as num?)?.toInt(),
        defaultOptionIndex: (json['defaultOptionIndex'] as num?)?.toInt(),
      );

  Map<String, dynamic> toJson() => {
        'prompt': prompt,
        'options': options.map((e) => e.toJson()).toList(),
        if (timeLimitSeconds != null) 'timeLimitSeconds': timeLimitSeconds,
        if (defaultOptionIndex != null)
          'defaultOptionIndex': defaultOptionIndex,
      };
}

class ChoiceOption {
  final String text;
  final int argent;
  final int mood;
  final int reputation;
  final List<String>? unlocks;
  final List<String>? setsFlags;
  final String? triggersScene;
  final String? ledgerLabel;

  const ChoiceOption({
    required this.text,
    required this.argent,
    required this.mood,
    required this.reputation,
    this.unlocks,
    this.setsFlags,
    this.triggersScene,
    this.ledgerLabel,
  });

  factory ChoiceOption.fromJson(Map<String, dynamic> json) => ChoiceOption(
        text: json['text'] as String,
        argent: (json['argent'] as num?)?.toInt() ?? 0,
        mood: (json['mood'] as num?)?.toInt() ?? 0,
        reputation: (json['reputation'] as num?)?.toInt() ?? 0,
        unlocks: (json['unlocks'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(growable: false),
        setsFlags: (json['setsFlags'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(growable: false),
        triggersScene: json['triggersScene'] as String?,
        ledgerLabel: json['ledgerLabel'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'argent': argent,
        'mood': mood,
        'reputation': reputation,
        if (unlocks != null) 'unlocks': unlocks,
        if (setsFlags != null) 'setsFlags': setsFlags,
        if (triggersScene != null) 'triggersScene': triggersScene,
        if (ledgerLabel != null) 'ledgerLabel': ledgerLabel,
      };
}
