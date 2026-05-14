# CLAUDE.md — consignes projet

## État actuel (mai 2026)

**Le projet est en pleine refonte.** L'app Flutter complète (carnet + ACE +
4 onglets) a été retirée le 14 mai 2026. Ce qui reste dans le repo :

- **Histoire pure** dans `ROADMAP.md` (pitch, bible narrative, structure
  16 semaines, scènes non-négociables, scénario J1→J112, 5 épilogues).
- **Données canoniques** dans `assets/data/` :
  - `scenario.json` (J1-J14 encodés)
  - `shop_catalog.json` (27 items)
  - `investments.json` (5 actions bourse)
  - `insta_seed.json` (8 posts initiaux)
- **Squelette Flutter minimal** pour ne pas casser le pipeline Xcode Cloud :
  `pubspec.yaml`, `lib/main.dart` (placeholder « Refonte en cours »),
  projets `ios/` et `android/` intacts.

L'ancien code (lib/ui/, lib/engine/, lib/providers/, lib/models/, assets/photos/,
refs/) reste **récupérable via git history** mais n'est plus dans le repo.

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
- Exception : s'arrêter avant le merge si la PR contient quelque chose de
  destructif (suppression de données, migration risquée) ou si les tests
  flottent — dans ces cas, demander confirmation.

## Prochaine architecture

Direction probable : **version téléphone** — l'app devient un faux iPhone
avec un home screen et des apps (Messages, Notes, Photos, Téléphone, Banque,
Insta). Plus de tabs ACE/CARNET. La narration sera distribuée dans les apps
au fil des jours. À valider avec l'utilisateur avant de coder.

## Conventions linguistiques (à respecter partout)

- **`Maman`** toujours majuscule (prénom de cœur). Jamais `maman`.
- **`Traitement de Maman`** : label unique pour la deadline J45.
- **Étages / arrondissements** : `8e`, `47e` (jamais `8ème`, `47ème`).
- **Montants** : `2 384 €` avec espace insécable avant le symbole. Jamais `2 384€`.
- **Jours** : `J1`, `J45`, `J112` (pas `45ème jour`, ni `45e jour`).
- **Indicateurs bourse** : `Plus-value latente` (jamais `PnL`). `PRU` reste OK
  comme abréviation pour le prix de revient unitaire.
- **Personnages** :
  - `Madame Heng` (jamais `Mme Heng`, jamais `Madame HENG`)
  - `Tante Mei` (toujours majuscule au titre)
  - `Tristan Heng`, `Vincent Heng`, `Camille Roux`
- **Tickers** : majuscules en prose (`HENG`, jamais `Heng` quand c'est l'action).
- **Citations dans dialogue** : point INTÉRIEUR aux guillemets pour une phrase
  complète : `« Oui. »` (pas `« Oui ».`).
- **Apostrophes** : droites (`'`), jamais typographiques (`'`).
- **Voix de Shen** : "je" majoritaire, ironie sèche, pas de superlatifs
  littéraires forcés. Jeune, 24 ans, qui écrit dans son carnet.
- **Voix Camille** : machine à vannes, croissants, légèreté piquante.
- **Voix Tristan** : sec, peu de mots, pas de superlatifs.
- **Voix Madame Heng** : sentencieuse, formelle, références chinoises.
- **Voix Vincent** : commercial, anglicismes (`closing`, `deal`).
- **Voix Hélène/Maman** : douce, lettrée (Duras, Ernaux), s'excuse.

## Avant de toucher au contenu narratif

Toucher au scénario (`assets/data/scenario.json`, `ROADMAP.md`) sans
confirmation explicite de l'utilisateur — la voix de Shen est sensible.
