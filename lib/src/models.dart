import 'dart:async';

import 'package:flutter/material.dart';

/// Nature d'un élément affiché dans un fil de discussion.
enum MsgKind { incoming, outgoing, separator, sysline, endCard }

/// Un message (ou séparateur) dans un fil. Mutable : un message entrant
/// commence en « en train d'écrire… » puis reçoit son texte.
class Msg {
  Msg.incoming(this.text, {this.typing = false}) : kind = MsgKind.incoming;
  Msg.incomingImage(this.imageAsset)
      : kind = MsgKind.incoming,
        text = '';
  Msg.outgoing(this.text) : kind = MsgKind.outgoing;
  Msg.outgoingImage(this.imageAsset)
      : kind = MsgKind.outgoing,
        text = '';
  Msg.separator(this.text) : kind = MsgKind.separator;
  Msg.sysline(this.text) : kind = MsgKind.sysline;
  Msg.endCard() : kind = MsgKind.endCard, text = '';

  final MsgKind kind;
  String text;
  bool typing = false;

  /// Photo partagée dans la bulle (message image).
  String? imageAsset;

  /// « Distribué » puis « Lu » — uniquement pour les messages envoyés.
  String? receipt;
}

/// Une réponse proposée au joueur.
class ChoiceOption {
  const ChoiceOption(this.label, {this.reply, this.silent = false, this.key});

  /// Le texte envoyé par Shen (et affiché sur le bouton).
  final String label;

  /// La réplique de l'autre, quand elle dépend directement du choix.
  final String? reply;

  /// Choix silencieux : rien n'est envoyé (« ne pas répondre », bloquer…).
  final bool silent;

  /// Étiquette de branche pour le script.
  final String? key;
}

/// Un choix en attente de réponse dans un fil.
class PendingChoice {
  PendingChoice(this.options) : completer = Completer<ChoiceOption>();

  final List<ChoiceOption> options;
  final Completer<ChoiceOption> completer;
}

/// Définition statique d'un contact.
class ThreadDef {
  const ThreadDef({
    required this.id,
    required this.name,
    required this.headerName,
    required this.initials,
    required this.gradientTop,
    required this.gradientBottom,
    this.avatarAsset,
    this.hiddenAtStart = false,
  });

  final String id;
  final String name;
  final String headerName;
  final String initials;
  final Color gradientTop;
  final Color gradientBottom;

  /// Photo du contact ; à défaut, pastille dégradée avec initiales.
  final String? avatarAsset;

  final bool hiddenAtStart;
}

/// État vivant d'un fil de discussion.
class ThreadState {
  ThreadState(this.def)
      : hidden = def.hiddenAtStart,
        contactKey = def.id;

  final ThreadDef def;
  final List<Msg> messages = [];
  bool hidden;
  int unread = 0;
  String preview = '';
  String previewTime = '';
  PendingChoice? pending;
  Msg? lastOutgoing;

  /// Renommage en cours de partie (ex. « Numéro inconnu » → « Tristan H. »).
  String? nameOverride;
  String? headerOverride;
  String? avatarOverride;

  /// Clé de la fiche contact à afficher (change quand on enregistre le contact).
  String contactKey;

  /// La définition effective, surcharges comprises.
  ThreadDef get effectiveDef => ThreadDef(
        id: def.id,
        name: nameOverride ?? def.name,
        headerName: headerOverride ?? def.headerName,
        initials: def.initials,
        gradientTop: def.gradientTop,
        gradientBottom: def.gradientBottom,
        avatarAsset: avatarOverride ?? def.avatarAsset,
        hiddenAtStart: def.hiddenAtStart,
      );
}

/// Bannière de notification (message reçu dans un fil non ouvert).
class BannerData {
  const BannerData({
    required this.threadId,
    required this.text,
    required this.seq,
  });

  final String threadId;
  final String text;
  final int seq;
}
