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
# 0. Se placer à la racine du repo cloné (dossier qui contient pubspec.yaml)
cd ~/path/vers/drama

# 1. Régénérer les dossiers de plateformes dans ce dossier (le "." final = ici)
flutter create --org com.contrejour --project-name contre_jour --platforms=android,ios .

# 2. Installer les dépendances
flutter pub get

# 3. Lancer (sélectionne un device : simulateur iOS, device Android, etc.)
flutter run
```

Le `.` final de `flutter create` cible le dossier courant : il faut donc impérativement avoir fait le `cd` au préalable. `flutter create` ne touchera pas aux fichiers existants (`lib/`, `assets/`, `pubspec.yaml`, `test/`, `ROADMAP.md`). Il ne créera que les dossiers de plateforme manquants.

## Tests

```bash
flutter test
```

## Icône d'app

L'icône source est `assets/icon/icon.png` (1024×1024, sans alpha). C'est un placeholder typographique (caractère 逆 en orange chaud sur papier crème). Pour la remplacer par un design final : exporter un PNG 1024×1024 sans transparence et écraser ce fichier.

Pour régénérer l'icône placeholder à partir du script Python (utile si on veut bidouiller la couleur ou le caractère) :

```bash
python3 tools/generate_icon.py
```

Pour propager l'icône vers toutes les tailles iOS + Android (à refaire à chaque modification du fichier source) :

```bash
flutter pub run flutter_launcher_icons
```

Cette commande lit la config `flutter_launcher_icons` du `pubspec.yaml` et écrit dans `ios/Runner/Assets.xcassets/AppIcon.appiconset/` et `android/app/src/main/res/mipmap-*/`.

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
