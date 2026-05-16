/// Catalogue des arcs de conversations Messages — secondaires (par
/// opposition aux contacts canoniques Maman/Camille/Tristan/Madame Heng).
///
/// Chaque arc vit dans son fichier dans lib/data/messages_arcs/, importé
/// ici et exposé via `kMessagesArcs`. Le scheduler pioche un arc éligible
/// (cooldown, jour) et lance une instance.
library;

import '../models/messages_arc.dart';
import 'messages_arcs/dr_aubin.dart';
import 'messages_arcs/faux_sav.dart';
import 'messages_arcs/karim_wrong.dart';
import 'messages_arcs/mathieu_tokyo.dart';
import 'messages_arcs/nadia_ex_coloc.dart';
import 'messages_arcs/notaire.dart';
import 'messages_arcs/sarah_collegue.dart';
import 'messages_arcs/stephane_patron.dart';
import 'messages_arcs/voisine.dart';

const kMessagesArcs = <MessagesArcTemplate>[
  voisineTemplate,
  drAubinTemplate,
  karimTemplate,
  fauxSavTemplate,
  sarahTemplate,
  mathieuTemplate,
  nadiaTemplate,
  notaireTemplate,
  stephaneTemplate,
];
