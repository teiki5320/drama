class Choice {
  final String prompt;
  final List<ChoiceOption> options;

  const Choice({required this.prompt, required this.options});

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        prompt: json['prompt'] as String,
        options: (json['options'] as List<dynamic>)
            .map((e) => ChoiceOption.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
      );

  Map<String, dynamic> toJson() => {
        'prompt': prompt,
        'options': options.map((e) => e.toJson()).toList(),
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

  const ChoiceOption({
    required this.text,
    required this.argent,
    required this.mood,
    required this.reputation,
    this.unlocks,
    this.setsFlags,
    this.triggersScene,
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
      );

  Map<String, dynamic> toJson() => {
        'text': text,
        'argent': argent,
        'mood': mood,
        'reputation': reputation,
        if (unlocks != null) 'unlocks': unlocks,
        if (setsFlags != null) 'setsFlags': setsFlags,
        if (triggersScene != null) 'triggersScene': triggersScene,
      };
}
