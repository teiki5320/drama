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

## Conventions linguistiques (à respecter partout)

- **`Maman`** toujours majuscule (prénom de cœur). Jamais `maman`.
- **`Traitement de Maman`** : label unique pour la deadline J45.
- **Étages / arrondissements** : `8e`, `47e` (jamais `8ème`, `47ème`).
- **Montants** : `2 384 €` avec espace insécable avant le symbole. Jamais `2 384€`.
- **Jours** : `J1`, `J45`, `J112` (pas `45ème jour`, ni `45e jour`).
- **Indicateurs bourse** : `Plus-value latente` (jamais `PnL`). `PRU` reste OK comme abréviation pour le prix de revient unitaire.
- **Personnages** :
  - `Madame Heng` (jamais `Mme Heng`, jamais `Madame HENG`)
  - `Tante Mei` (toujours majuscule au titre)
  - `Tristan Heng`, `Vincent Heng`, `Camille Roux`
- **Tickers** : majuscules en prose (`HENG`, jamais `Heng` quand c'est l'action).
- **Citations dans dialogue** : point INTÉRIEUR aux guillemets pour une phrase complète : `« Oui. »` (pas `« Oui ».`).
- **Apostrophes** : droites (`'`), jamais typographiques (`’`).
- **Voix de Shen** : "je" majoritaire, ironie sèche, pas de superlatifs littéraires forcés. Jeune, 24 ans, qui écrit dans son carnet.
- **Voix Camille** : machine à vannes, croissants, légèreté piquante.
- **Voix Tristan** : sec, peu de mots, pas de superlatifs.
- **Voix Madame Heng** : sentencieuse, formelle, références chinoises.
- **Voix Vincent** : commercial, anglicismes (`closing`, `deal`).
- **Voix Hélène/Maman** : douce, lettrée (Duras, Ernaux), s'excuse.

## Workflow photos

- Tampon : `refs/tampon/` (zone d'arrivée)
- Archive : `refs/archive/` (non utilisées, autres dramas, variantes)
- Bundle final : `assets/photos/{characters,scenes,posts}/`
- Status : `refs/SCENES_STATUS.md` (tableau de bord)
- Prompts portraits : `refs/PROMPTS.md`
- Prompts scènes J1-J14 : `refs/PROMPTS_SCENES.md`
