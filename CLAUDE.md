# CLAUDE.md — consignes projet

## Cible TestFlight = `main`

Xcode Cloud est branché sur le repo via App Store Connect ("iOS Build &
TestFlight"), workflow déclenché sur **chaque push vers `main`**. Référentiel
principal `https://github.com/teiki5320/drama.git`, projet
`ios/Runner.xcworkspace`, "Latest Release" Xcode + macOS, build nettoyé.

**Conséquence pratique pour Claude :**

- Continuer à développer sur la branche injectée par le harness (par défaut,
  `claude/...`). Pas de commit direct sur `main` depuis la session.
- En **fin de tâche**, ouvrir la PR vers `main` puis la merger (méthode
  "merge" pour conserver le style des PR précédentes, type `Merge PR #X : ...`)
  sans demander à chaque fois — c'est ce qui livre la build sur TestFlight.
- Pas besoin d'attendre le retour explicite "tu peux pousser sur main", c'est
  acquis pour ce projet.
- Exception : s'arrêter avant le merge si la PR contient quelque chose de
  destructif (suppression de données, migration risquée) ou si les tests
  flottent — dans ces cas, demander confirmation.

## Structure du repo

- Flutter app (iOS + Android), Riverpod, persistance via `shared_preferences`.
- Données dans `assets/data/` (scenario, shop, investments, insta_seed) +
  `assets/photos/` (placeholders avec fallback automatique si manquant).
- Logique pure dans `lib/engine/economy_engine.dart` — facile à tester.
- ROADMAP éditoriale + technique dans `ROADMAP.md` à la racine.

## Conventions

- Tous les textes UI en français (drama francophone).
- Garder l'engine pur (pas de `BuildContext`, pas de Riverpod) pour pouvoir
  écrire des tests unitaires sans Flutter.
- Avant de toucher au scénario (`assets/data/scenario.json`), confirmer avec
  l'utilisateur — la voix de Shen est sensible.
