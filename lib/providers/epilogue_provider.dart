import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/epilogues.dart';

/// Épilogue en cours d'affichage (plein écran, par-dessus le téléphone).
/// Null = pas d'épilogue affiché. Posé par PhoneShell quand Shen répond
/// au SMS final de Camille (`epilogue_j112`), remis à null au tap.
final epilogueProvider = StateProvider<Epilogue?>((ref) => null);
