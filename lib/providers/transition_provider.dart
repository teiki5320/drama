import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/episode.dart';

/// Provider qui pilote l'affichage de l'écran de transition entre beats.
/// Quand non-null, PhoneShell empile l'écran de transition par-dessus
/// tout le reste pour 4-6 secondes, puis le remet à null.
final beatTransitionProvider =
    StateProvider<BeatTransition?>((ref) => null);
