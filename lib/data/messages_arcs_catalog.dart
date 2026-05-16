/// Catalogue des arcs de conversations Messages — secondaires (par
/// opposition aux contacts canoniques Maman/Camille/Tristan/Madame Heng).
///
/// Chaque arc vit dans son fichier dans lib/data/messages_arcs/, importé
/// ici et exposé via `kMessagesArcs`. Le scheduler pioche un arc éligible
/// (cooldown, jour) et lance une instance.
library;

import '../models/messages_arc.dart';
import 'messages_arcs/voisine.dart';

const kMessagesArcs = <MessagesArcTemplate>[
  voisineTemplate,
];
