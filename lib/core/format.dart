/// Helpers de formatage à la française (convention projet).
///
/// `toStringAsFixed` de Dart produit un POINT décimal (« 4.20 »), ce qui
/// jure sur un faux iPhone français. On centralise ici la virgule décimale
/// pour prix, notes, durées, distances, stockage.
library;

/// Nombre à `decimals` décimales, séparateur décimal virgule.
/// Ex. `frDec(4.2, 2)` → « 4,20 », `frDec(9.2, 1)` → « 9,2 ».
String frDec(num v, int decimals) =>
    v.toStringAsFixed(decimals).replaceAll('.', ',');
