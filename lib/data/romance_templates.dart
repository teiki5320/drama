/// Catalogue des templates d'archétypes de romance Tinder.
///
/// Chaque archétype vit dans son propre fichier dans `lib/data/romance/`,
/// importé ici et exposé via `kRomanceTemplates`. Le scheduler pioche
/// un archétype éligible (cooldown, mood, jour) et lance une instance.
library;

import '../models/romance.dart';
import 'romance/avocate_adulte.dart';
import 'romance/breadcrumber.dart';
import 'romance/catfish.dart';
import 'romance/class_divide.dart';
import 'romance/depart_imminent.dart';
import 'romance/drama_yoga.dart';
import 'romance/escort_reveal.dart';
import 'romance/homonyme.dart';
import 'romance/infirmiere_refuge.dart';
import 'romance/journaliste_curieuse.dart';
import 'romance/libraire_potentiel.dart';
import 'romance/lovebomber.dart';
import 'romance/magnetique_vide.dart';
import 'romance/manipulatrice_soft.dart';
import 'romance/mansplainer.dart';
import 'romance/passion_fougueuse.dart';
import 'romance/pere_divorce.dart';
import 'romance/poly_ambigu.dart';
import 'romance/predator.dart';
import 'romance/queer_douce.dart';
import 'romance/refuge_sain.dart';
import 'romance/retour_hk.dart';
import 'romance/slow_burn.dart';
import 'romance/sportive_dispo.dart';
import 'romance/startup_narcissique.dart';
import 'romance/tendre_immature.dart';
import 'romance/vegan_moralisateur.dart';

/// Catalogue complet — 27 archétypes. L'ordre n'a pas d'importance
/// (le tirage est pondéré par `spawnWeight`).
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
  pereTemplate,
  tendreTemplate,
  departTemplate,
  startupTemplate,
  classDivideTemplate,
  polyTemplate,
  magnetiqueTemplate,
  journalisteTemplate,
  infirmiereTemplate,
  manipulatriceTemplate,
  sportiveTemplate,
  avocateTemplate,
  dramaYogaTemplate,
  escortTemplate,
  retourHkTemplate,
  veganTemplate,
  libraireTemplate,
  homonymeTemplate,
];
