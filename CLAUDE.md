# CLAUDE.md — consignes projet

## État actuel (juin 2026)

La refonte du 14 mai 2026 (retrait de l'app carnet + ACE + 4 onglets) a été
suivie de la **reconstruction en version téléphone** : l'app est désormais un
**faux iPhone** (`lib/main.dart` → `PhoneShell` : lock → home → apps), avec
onboarding, persistance `shared_preferences`, game loop fin de journée, et
~17 apps (Messages, Notes, Photos, Téléphone, Banque, Instagram, UberEats,
Tinder, WhatsApp, Spotify, Plans, Caméra, Calendrier, Cloud, Réglages,
App Store…). `lib/main.dart` n'est **plus** un placeholder.

- **Histoire pure** dans `ROADMAP.md` (pitch, bible narrative, structure
  16 semaines, scènes non-négociables, scénario J1→J112, 5 épilogues).
- **Contenu jouable** : Ep 1 (J1→J14) est dense ; Ep 2→5 sont **scaffoldés**
  (beats posés dans `lib/data/episodes.dart`, prose/choix encore à écrire).
- **Données du jeu** : le contenu vit majoritairement dans `lib/data/*.dart`.
  Les JSON `assets/data/` sont surtout de la **référence narrative** :
  - `scenario.json` (J1-J14 ; ⚠ doublon J8-J14, deux versions — **non chargé**
    par l'app, c'est une référence)
  - `shop_catalog.json` (**40 items** — **seul JSON réellement chargé**, via
    `shopCatalogProvider`)
  - `investments.json` (9 actions — **non chargé** ; la bourse jouable vit
    dans `lib/data/banque_data.dart`)
  - `insta_seed.json` (42 posts — **non chargé** ; le feed vit dans
    `lib/data/`)
- **Outillage** : `tools/audit.py` valide données, références d'assets,
  câblage des choix et conventions (voir « Audit & garde-fous » plus bas).

L'ancien code (ancienne UI ACE/CARNET, `lib/engine/`, refs/) reste
**récupérable via git history**.

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

## Architecture actuelle

**Version téléphone** (faux iPhone), désormais en place. Home screen + apps,
plus de tabs ACE/CARNET. La narration est distribuée dans les apps au fil des
jours (moteur de beats `episodes.dart` + événements `day_events.dart` qui
poussent SMS/photos/badges aux bonnes heures). Le gros du reste-à-faire est
l'**écriture du contenu Ep 2→5** et le **câblage des mécaniques de simulation**
(argent/mood/réputation, bourse, achat→post Instagram, sélection d'épilogue).
Toucher à la structure de navigation reste à valider avec l'utilisateur.

## Audit & garde-fous

`python3 tools/audit.py` (aucune dépendance ; pas besoin de Flutter) vérifie
sans compiler :

- validité + schéma des JSON `assets/data/` ;
- `shop_catalog.json` compatible avec le modèle `ShopItem` + catégories
  toutes déclarées dans `kShopCategories` ;
- chaque chemin `assets/...` référencé dans `lib/` existe sur disque ;
- contrat runtime des choix SMS (tout message `beatId` a son `SmsChoice`) ;
- conventions linguistiques (ci-dessous) sur les **chaînes affichées** ;
- dérive de documentation (compteurs annoncés ici vs réalité des fichiers) ;
- couverture narrative J1→J112 par app.

Code retour ≠ 0 si un **FAIL** (défaut réparable). Les items **EDITORIAL**
(décision d'auteur : doublon scénario, contenu Ep2+ à écrire) sont signalés
mais **non bloquants**. `--strict` rend les WARN bloquants aussi. Lancer
l'audit avant d'ouvrir une PR.

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
