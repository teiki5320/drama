import 'choice.dart';
import 'sms_message.dart';

enum NarrativeBlockType {
  prose,
  sms,
  sectionTitle,
  image,
  quote,
  beat,
  sceneBreak,
  innerThought,
  stickyNote,
  list,
  marginalia,
  dayFooter,
  inlineQuote,
  sceneDialogue,
}

NarrativeBlockType _blockTypeFromString(String s) {
  switch (s) {
    case 'prose':
      return NarrativeBlockType.prose;
    case 'sms':
      return NarrativeBlockType.sms;
    case 'sectionTitle':
      return NarrativeBlockType.sectionTitle;
    case 'image':
      return NarrativeBlockType.image;
    case 'quote':
      return NarrativeBlockType.quote;
    case 'beat':
      return NarrativeBlockType.beat;
    case 'sceneBreak':
      return NarrativeBlockType.sceneBreak;
    case 'innerThought':
      return NarrativeBlockType.innerThought;
    case 'stickyNote':
      return NarrativeBlockType.stickyNote;
    case 'list':
      return NarrativeBlockType.list;
    case 'marginalia':
      return NarrativeBlockType.marginalia;
    case 'dayFooter':
      return NarrativeBlockType.dayFooter;
    case 'inlineQuote':
      return NarrativeBlockType.inlineQuote;
    case 'sceneDialogue':
      return NarrativeBlockType.sceneDialogue;
    default:
      throw FormatException('Unknown NarrativeBlockType: $s');
  }
}

String _blockTypeToString(NarrativeBlockType t) {
  switch (t) {
    case NarrativeBlockType.prose:
      return 'prose';
    case NarrativeBlockType.sms:
      return 'sms';
    case NarrativeBlockType.sectionTitle:
      return 'sectionTitle';
    case NarrativeBlockType.image:
      return 'image';
    case NarrativeBlockType.quote:
      return 'quote';
    case NarrativeBlockType.beat:
      return 'beat';
    case NarrativeBlockType.sceneBreak:
      return 'sceneBreak';
    case NarrativeBlockType.innerThought:
      return 'innerThought';
    case NarrativeBlockType.stickyNote:
      return 'stickyNote';
    case NarrativeBlockType.list:
      return 'list';
    case NarrativeBlockType.marginalia:
      return 'marginalia';
    case NarrativeBlockType.dayFooter:
      return 'dayFooter';
    case NarrativeBlockType.inlineQuote:
      return 'inlineQuote';
    case NarrativeBlockType.sceneDialogue:
      return 'sceneDialogue';
  }
}

class DialogueLine {
  final String speaker;
  final String label;
  final String text;

  const DialogueLine({
    required this.speaker,
    required this.label,
    required this.text,
  });

  factory DialogueLine.fromJson(Map<String, dynamic> json) => DialogueLine(
        speaker: json['speaker'] as String,
        label: json['label'] as String,
        text: json['text'] as String,
      );

  Map<String, dynamic> toJson() => {
        'speaker': speaker,
        'label': label,
        'text': text,
      };
}

class NarrativeBlock {
  final NarrativeBlockType type;
  final String? content;
  final String? conversation;
  final List<SmsMessage>? messages;
  final String? imageAsset;

  /// Identifiant du personnage qui parle dans ce bloc (pour les
  /// blocs prose contenant un dialogue). Affiche un mini avatar à
  /// gauche du paragraphe quand renseigné. Valeurs : ids déclarés
  /// dans `Character` (tristan, maman, camille, vincent, madame_heng,
  /// dr_aubin, etc.).
  final String? speaker;

  /// En-tête horodaté du bloc `sceneDialogue` (ex. "06:30 — Bureau
  /// du Dr Aubin"). Affiché en petit au-dessus de la scène.
  final String? location;

  /// Photo de scène utilisée en arrière-plan flou du `sceneDialogue`.
  /// Si null, fond noir uni.
  final String? backgroundImageAsset;

  /// Liste de répliques pour `sceneDialogue`. Chaque ligne identifie
  /// son speaker (clé de portrait), son label affiché en small caps,
  /// et son texte (qui supporte les emphases `**rouge**` / `*italique*`).
  final List<DialogueLine>? lines;

  const NarrativeBlock({
    required this.type,
    this.content,
    this.conversation,
    this.messages,
    this.imageAsset,
    this.speaker,
    this.location,
    this.backgroundImageAsset,
    this.lines,
  });

  factory NarrativeBlock.fromJson(Map<String, dynamic> json) => NarrativeBlock(
        type: _blockTypeFromString(json['type'] as String),
        content: json['content'] as String?,
        conversation: json['conversation'] as String?,
        messages: (json['messages'] as List<dynamic>?)
            ?.map((e) => SmsMessage.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
        imageAsset: json['imageAsset'] as String?,
        speaker: json['speaker'] as String?,
        location: json['location'] as String?,
        backgroundImageAsset: json['backgroundImageAsset'] as String?,
        lines: (json['lines'] as List<dynamic>?)
            ?.map((e) => DialogueLine.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
      );

  Map<String, dynamic> toJson() => {
        'type': _blockTypeToString(type),
        if (content != null) 'content': content,
        if (conversation != null) 'conversation': conversation,
        if (messages != null)
          'messages': messages!.map((e) => e.toJson()).toList(),
        if (imageAsset != null) 'imageAsset': imageAsset,
        if (speaker != null) 'speaker': speaker,
        if (location != null) 'location': location,
        if (backgroundImageAsset != null)
          'backgroundImageAsset': backgroundImageAsset,
        if (lines != null) 'lines': lines!.map((e) => e.toJson()).toList(),
      };
}

class Trigger {
  final String type;
  final Map<String, String> payload;

  const Trigger({required this.type, required this.payload});

  factory Trigger.fromJson(Map<String, dynamic> json) => Trigger(
        type: json['type'] as String,
        payload: ((json['payload'] as Map<String, dynamic>?) ?? const {})
            .map((k, v) => MapEntry(k, v.toString())),
      );

  Map<String, dynamic> toJson() => {
        'type': type,
        'payload': payload,
      };
}

class DayEntry {
  final int id;
  final String date;
  final String location;
  final String time;
  final List<NarrativeBlock> narrative;
  final Choice choice;
  final List<Trigger>? triggers;

  /// Identifiant de branche narrative. `null` = voie principale
  /// (chemin canonique J1→J14 via le contrat Heng). Une autre valeur
  /// (ex. "voie2") sélectionne une variante de ce numéro de jour. À
  /// `currentDay+1`, le moteur charge l'entry dont l'`id` et le
  /// `branch` correspondent à la branche courante du joueur.
  final String? branch;

  const DayEntry({
    required this.id,
    required this.date,
    required this.location,
    required this.time,
    required this.narrative,
    required this.choice,
    this.triggers,
    this.branch,
  });

  factory DayEntry.fromJson(Map<String, dynamic> json) => DayEntry(
        id: (json['id'] as num).toInt(),
        date: json['date'] as String,
        location: json['location'] as String,
        time: json['time'] as String,
        narrative: (json['narrative'] as List<dynamic>)
            .map((e) => NarrativeBlock.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
        choice: Choice.fromJson(json['choice'] as Map<String, dynamic>),
        triggers: (json['triggers'] as List<dynamic>?)
            ?.map((e) => Trigger.fromJson(e as Map<String, dynamic>))
            .toList(growable: false),
        branch: json['branch'] as String?,
      );
}
