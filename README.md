# À Contre-Jour (逆光)

Drama romantique mobile, 112 jours / 16 semaines / 5 fins. Voir `ROADMAP.md` pour la spec complète.

## Stack

- Flutter (Dart), channel stable
- Cibles Android (minSdk 23) et iOS (iOS 14+)
- State management : Riverpod
- Persistance : `shared_preferences` + assets JSON locaux
- Pas de backend, pas de réseau

## Premier lancement

Le scaffolding `android/` et `ios/` n'est pas commité (à régénérer en local avec Flutter installé). Étapes :

```bash
# 1. Régénérer les dossiers de plateformes
flutter create --org com.contrejour --project-name contre_jour --platforms=android,ios .

# 2. Installer les dépendances
flutter pub get

# 3. Lancer
flutter run
```

`flutter create` ne touchera pas aux fichiers existants (`lib/`, `assets/`, `pubspec.yaml`, `test/`). Il ne créera que les dossiers de plateforme manquants.

## Tests

```bash
flutter test
```

## Structure (extrait)

```
contre_jour/
├── pubspec.yaml
├── ROADMAP.md                  # spec narrative + technique complète
├── assets/data/                # scénario + catalogues JSON
├── lib/
│   ├── main.dart
│   ├── core/                   # theme, couleurs
│   ├── models/                 # GameState, DayEntry, Choice, …
│   ├── data/                   # loaders + repository
│   ├── providers/              # Riverpod
│   ├── engine/                 # economy + ending
│   └── ui/                     # 4 onglets : Carnet, Banque, Insta, Messages
└── test/
```

## Contenu narratif

- `assets/data/scenario.json` : J1 → J7 encodés (à étendre vers J112)
- `assets/data/shop_catalog.json` : 24 articles (5 catégories progression mood + 4 catégories permanentes)
- `assets/data/investments.json` : 5 actions (LUG, NCT, NCB, HENG, HAN)
- `assets/data/insta_seed.json` : 8 posts narratifs des autres personnages

## Distribution

iOS via TestFlight (pipeline déjà en place côté propriétaire). Android : APK / AAB via `flutter build`.
