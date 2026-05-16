import 'dart:convert';
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../data/messages_arcs_catalog.dart';
import '../models/messages_arc.dart';
import 'phone_state_provider.dart';

/// État des arcs de conversations Messages — instances actives + archives.
@immutable
class MessagesArcsState {
  final List<MessagesArcInstance> instances;
  /// templateId → jour du dernier spawn (cooldown par archétype).
  final Map<String, int> lastSpawnDay;

  const MessagesArcsState({
    this.instances = const [],
    this.lastSpawnDay = const {},
  });

  MessagesArcsState copyWith({
    List<MessagesArcInstance>? instances,
    Map<String, int>? lastSpawnDay,
  }) =>
      MessagesArcsState(
        instances: instances ?? this.instances,
        lastSpawnDay: lastSpawnDay ?? this.lastSpawnDay,
      );

  List<MessagesArcInstance> get active =>
      instances.where((i) => !i.ended).toList();
  List<MessagesArcInstance> get archived =>
      instances.where((i) => i.ended).toList();
}

const _kPrefsKey = 'messages_arcs_v1';
/// Maximum d'arcs actifs simultanés. Moins que Tinder car Messages est
/// déjà chargé en contacts canoniques.
const _kMaxParallelArcs = 2;

class MessagesArcsNotifier extends StateNotifier<MessagesArcsState> {
  MessagesArcsNotifier() : super(const MessagesArcsState()) {
    _hydrate();
  }

  final _rng = Random();
  final _textPicks = <String, Map<int, int>>{};
  final _photoPicks = <String, Map<int, int>>{};

  Future<void> _hydrate() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_kPrefsKey);
    if (raw == null) return;
    try {
      final j = jsonDecode(raw) as Map<String, dynamic>;
      final list = (j['instances'] as List?) ?? [];
      final spawn = (j['lastSpawnDay'] as Map?)?.map(
            (k, v) => MapEntry(k as String, v as int),
          ) ??
          <String, int>{};
      state = state.copyWith(
        instances: list
            .map((e) => MessagesArcInstance.fromJson(e as Map<String, dynamic>))
            .toList(),
        lastSpawnDay: spawn,
      );
    } catch (_) {}
  }

  Future<void> _persist() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _kPrefsKey,
      jsonEncode({
        'instances': state.instances.map((i) => i.toJson()).toList(),
        'lastSpawnDay': state.lastSpawnDay,
      }),
    );
  }

  // ─── Spawn ───────────────────────────────────────────────────

  /// Tente de spawn un template précis. Retourne l'instance ou null.
  MessagesArcInstance? spawn({
    required String templateId,
    required int day,
    required int hour,
    required int minute,
  }) {
    if (state.active.length >= _kMaxParallelArcs) return null;
    final template = kMessagesArcs.firstWhere(
      (t) => t.id == templateId,
      orElse: () => kMessagesArcs.first,
    );
    final last = state.lastSpawnDay[templateId];
    if (last != null && day - last < template.cooldownDays) return null;
    if (day < template.minStartDay) return null;
    if (template.maxStartDay != null && day > template.maxStartDay!) {
      return null;
    }

    final instance = MessagesArcInstance(
      id: 'msgarc_${DateTime.now().millisecondsSinceEpoch}_'
          '${_rng.nextInt(9999)}',
      templateId: templateId,
      startDay: day,
      startHour: hour,
      startMinute: minute,
    );
    state = state.copyWith(
      instances: [...state.instances, instance],
      lastSpawnDay: {...state.lastSpawnDay, templateId: day},
    );
    _persist();
    return instance;
  }

  /// Spawn aléatoire pondéré parmi les templates éligibles. Appelé par
  /// le scheduler à chaque tick si conditions remplies.
  MessagesArcInstance? spawnRandom({
    required int day,
    required int hour,
    required int minute,
  }) {
    if (state.active.length >= _kMaxParallelArcs) return null;
    final eligible = kMessagesArcs.where((t) {
      if (day < t.minStartDay) return false;
      if (t.maxStartDay != null && day > t.maxStartDay!) return false;
      final last = state.lastSpawnDay[t.id];
      if (last != null && day - last < t.cooldownDays) return false;
      return true;
    }).toList();
    if (eligible.isEmpty) return null;
    final totalW = eligible.fold<double>(0, (s, t) => s + t.spawnWeight);
    var roll = _rng.nextDouble() * totalW;
    for (final t in eligible) {
      roll -= t.spawnWeight;
      if (roll <= 0) {
        return spawn(
            templateId: t.id, day: day, hour: hour, minute: minute);
      }
    }
    return null;
  }

  // ─── Tick : avance toutes les instances ──────────────────────

  void tickAll({
    required int day,
    required int hour,
    required int minute,
  }) {
    var changed = false;
    final newInstances = <MessagesArcInstance>[];
    for (final inst in state.instances) {
      if (inst.ended || inst.pendingChoiceBeatIdx != null) {
        newInstances.add(inst);
        continue;
      }
      final advanced = _advanceInstance(inst, day, hour, minute);
      if (advanced != inst) changed = true;
      newInstances.add(advanced);
    }
    if (changed) {
      state = state.copyWith(instances: newInstances);
      _persist();
    }
  }

  MessagesArcInstance _advanceInstance(
    MessagesArcInstance inst,
    int day,
    int hour,
    int minute,
  ) {
    final template = _templateOf(inst);
    var cur = inst;
    while (cur.nextBeatIdx < template.beats.length) {
      final beat = template.beats[cur.nextBeatIdx];
      if (beat.requireBranch != null &&
          !cur.branches.contains(beat.requireBranch)) {
        cur = cur.copyWith(nextBeatIdx: cur.nextBeatIdx + 1);
        continue;
      }
      if (beat.forbidBranch != null &&
          cur.branches.contains(beat.forbidBranch)) {
        cur = cur.copyWith(nextBeatIdx: cur.nextBeatIdx + 1);
        continue;
      }
      final (bd, bh, bm) = _beatFireTime(inst, beat);
      final beatTotal = bd * 24 * 60 + bh * 60 + bm;
      final nowTotal = day * 24 * 60 + hour * 60 + minute;
      if (beatTotal > nowTotal) break;
      if (beat.type == MessagesArcBeatType.choice) {
        cur = cur.copyWith(pendingChoiceBeatIdx: cur.nextBeatIdx);
        break;
      }
      cur = _playBeat(cur, beat, bd, bh, bm);
      if (beat.setBranch != null) {
        cur = cur.copyWith(branches: {...cur.branches, beat.setBranch!});
      }
      if (beat.endsArc != null) {
        cur = cur.copyWith(ended: true, endingId: beat.endsArc);
        break;
      }
      cur = cur.copyWith(nextBeatIdx: cur.nextBeatIdx + 1);
    }
    return cur;
  }

  MessagesArcInstance _playBeat(
    MessagesArcInstance inst,
    MessagesArcBeat beat,
    int day,
    int hour,
    int minute,
  ) {
    final time =
        '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
    String? text;
    String? photoLabel;
    if (beat.textVariants.isNotEmpty) {
      text = _pickVariant(inst.id, inst.nextBeatIdx, beat.textVariants);
    }
    if (beat.photoLabels.isNotEmpty) {
      photoLabel = _pickPhoto(inst.id, inst.nextBeatIdx, beat.photoLabels);
    }
    return inst.copyWith(
      playedMessages: [
        ...inst.playedMessages,
        MessagesArcPlayedMsg(
          fromThem: beat.fromThem,
          day: day,
          time: time,
          type: beat.type,
          text: text,
          photoLabel: photoLabel,
          voiceDurationS: beat.voiceDurationS,
          callDurationS: beat.callDurationS,
        ),
      ],
    );
  }

  // ─── Choix Shen ─────────────────────────────────────────────

  void respondToChoice({
    required String instanceId,
    required int choiceIdx,
    required int day,
    required int hour,
    required int minute,
  }) {
    final idx = state.instances.indexWhere((i) => i.id == instanceId);
    if (idx < 0) return;
    var inst = state.instances[idx];
    if (inst.pendingChoiceBeatIdx == null || inst.ended) return;
    final template = _templateOf(inst);
    final beat = template.beats[inst.pendingChoiceBeatIdx!];
    if (choiceIdx < 0 || choiceIdx >= beat.choices.length) return;
    final choice = beat.choices[choiceIdx];

    final newMessages =
        List<MessagesArcPlayedMsg>.from(inst.playedMessages);
    if (choice.reply.isNotEmpty) {
      final time =
          '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
      newMessages.add(MessagesArcPlayedMsg(
        fromThem: false,
        day: day,
        time: time,
        type: MessagesArcBeatType.text,
        text: choice.reply,
        chosenIndex: choiceIdx,
      ));
    }

    inst = inst.copyWith(
      playedMessages: newMessages,
      branches: choice.setBranch != null
          ? {...inst.branches, choice.setBranch!}
          : inst.branches,
      nextBeatIdx: inst.pendingChoiceBeatIdx! + 1,
      clearPendingChoice: true,
      ended: choice.endsArc != null,
      endingId: choice.endsArc,
    );

    if (choice.moodDelta != 0) {
      _moodDeltaApply?.call(choice.moodDelta);
    }

    final newInstances = List<MessagesArcInstance>.from(state.instances);
    newInstances[idx] = inst;
    state = state.copyWith(instances: newInstances);
    tickAll(day: day, hour: hour, minute: minute);
    _persist();
  }

  void Function(int delta)? _moodDeltaApply;
  void bindMoodDelta(void Function(int delta) fn) {
    _moodDeltaApply = fn;
  }

  // ─── Helpers ────────────────────────────────────────────────

  MessagesArcTemplate _templateOf(MessagesArcInstance inst) =>
      kMessagesArcs.firstWhere(
        (t) => t.id == inst.templateId,
        orElse: () => kMessagesArcs.first,
      );

  (int, int, int) _beatFireTime(MessagesArcInstance i, MessagesArcBeat b) {
    var day = i.startDay + b.dayOffset;
    var totalMin = b.atHour * 60 + b.atMinute;
    if (b.dayOffset == 0 && b.atHour == 0) {
      totalMin = i.startHour * 60 + i.startMinute + b.atMinute;
    }
    if (totalMin >= 24 * 60) {
      day += totalMin ~/ (24 * 60);
      totalMin = totalMin % (24 * 60);
    }
    return (day, totalMin ~/ 60, totalMin % 60);
  }

  String _pickVariant(String instId, int beatIdx, List<String> variants) {
    final picks = _textPicks.putIfAbsent(instId, () => {});
    final existing = picks[beatIdx];
    if (existing != null && existing < variants.length) {
      return variants[existing];
    }
    final pick = _rng.nextInt(variants.length);
    picks[beatIdx] = pick;
    return variants[pick];
  }

  String _pickPhoto(String instId, int beatIdx, List<String> photos) {
    final picks = _photoPicks.putIfAbsent(instId, () => {});
    final existing = picks[beatIdx];
    if (existing != null && existing < photos.length) {
      return photos[existing];
    }
    final pick = _rng.nextInt(photos.length);
    picks[beatIdx] = pick;
    return photos[pick];
  }

  MessagesArcTemplate templateOf(MessagesArcInstance inst) => _templateOf(inst);

  List<MessagesArcChoice>? pendingChoices(MessagesArcInstance inst) {
    if (inst.pendingChoiceBeatIdx == null) return null;
    return _templateOf(inst).beats[inst.pendingChoiceBeatIdx!].choices;
  }
}

final messagesArcsProvider =
    StateNotifierProvider<MessagesArcsNotifier, MessagesArcsState>(
  (ref) {
    final notifier = MessagesArcsNotifier();
    notifier.bindMoodDelta((delta) {
      final cur = ref.read(phoneStateProvider).mood;
      ref
          .read(phoneStateProvider.notifier)
          .setMood((cur + delta).clamp(0, 10));
    });
    return notifier;
  },
);

/// Provider dérivé : nombre d'arcs Messages en attente de réponse Shen.
/// Utilisé pour le badge unread sur Messages.
final messagesArcsUnreadCountProvider = Provider<int>((ref) {
  final state = ref.watch(messagesArcsProvider);
  return state.active
      .where((i) => i.pendingChoiceBeatIdx != null)
      .length;
});
