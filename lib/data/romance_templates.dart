/// Catalogue des templates d'archétypes de romance Tinder.
///
/// Chaque archétype vit dans son propre fichier dans `lib/data/romance/`,
/// importé ici et exposé via `kRomanceTemplates`. Le scheduler pioche
/// un archétype éligible (cooldown, mood, jour) et lance une instance.
library;

import '../models/romance.dart';
import 'romance/breadcrumber.dart';
import 'romance/catfish.dart';
import 'romance/lovebomber.dart';
import 'romance/mansplainer.dart';
import 'romance/passion_fougueuse.dart';
import 'romance/predator.dart';
import 'romance/queer_douce.dart';
import 'romance/refuge_sain.dart';
import 'romance/slow_burn.dart';

/// Catalogue complet — l'ordre n'a pas d'importance (le tirage est
/// pondéré par `spawnWeight`).
const kRomanceTemplates = <RomanceTemplate>[
  slowBurnTemplate,
  lovebombTemplate,
  breadcrumberTemplate,
  refugeTemplate,
  predatorTemplate,
  catfishTemplate,
  mansplainerTemplate,
  passionTemplate,
  queerDouceTemplate,
];
