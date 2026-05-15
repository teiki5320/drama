import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Un appel entrant en cours — quand non-null, on superpose un écran
/// plein d'appel iPhone-like par-dessus tout.
class IncomingCall {
  /// Nom affiché (ex. « Maman ❤️ », « Numéro masqué », « Tristan H. »).
  final String displayName;
  /// Sous-titre court sous le nom (ex. « mobile », « Heng International »).
  final String? subtitle;
  /// Emoji avatar fallback quand pas d'image.
  final String emoji;
  /// Couleur d'avatar (hex).
  final int avatarColor;
  /// Si true, l'appel est marqué « masqué » et le nom n'est pas révélé.
  final bool masked;

  const IncomingCall({
    required this.displayName,
    this.subtitle,
    this.emoji = '👤',
    this.avatarColor = 0xFFCCCCCC,
    this.masked = false,
  });
}

/// Provider qui pilote l'écran d'appel entrant — set non-null pour
/// faire sonner, set null quand l'utilisateur décroche ou raccroche.
final incomingCallProvider = StateProvider<IncomingCall?>((ref) => null);
