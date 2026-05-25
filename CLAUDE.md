# CLAUDE.md — consignes projet

## État actuel (mai 2026)

**Architecture « faux iPhone ».** L'app simule un téléphone avec home screen,
status bar, lock screen et 16+ apps intégrées. La narration est distribuée
dans les apps au fil des jours via un système d'épisodes/beats.

### Structure du code

```
lib/
  core/          phone_apps.dart (catalogue AppMeta, kAllApps)
  data/          episodes.dart, messages_data.dart, sms_choices.dart,
                 telephone_data.dart, contacts_data.dart, …
  models/        phone_state.dart (état global), episode.dart (Beat, Episode)
  providers/     phone_state_provider.dart (Riverpod StateNotifier),
                 transition_provider.dart, messages_arcs_provider.dart, …
  ui/phone/      phone_shell.dart (routeur), home_screen.dart, lock_screen.dart,
                 apps/ (un fichier par app : messages_app.dart, banque_app.dart, …)
                 onboarding_screen.dart (6 slides : 3 pitch + 3 perso)
assets/
  data/          scenario.json, shop_catalog.json, investments.json, insta_seed.json
  photos/        avatars/, ep1/, camera_pool/, …
```

### Apps disponibles

**Dock** (permanent) : Messages, Photos, Banque, Téléphone.
**Page 1** (débloquées au départ) : Calendrier, Instagram, Réglages,
Contacts, Caméra, App Store.
**Débloquées par le scénario** : Notes + Banque (collision J1), Uber Eats
(Tenon J2), Téléphone (T. appelle J3), WhatsApp (Tante Mei J35), Tinder,
Cloud, Spotify, Plans, Strava (via App Store ou beats).

### Narration

- **5 épisodes** dans `lib/data/episodes.dart`. Ep 1 gratuit (J1→J14),
  Ep 2-5 payants (J15→J112).
- Chaque épisode contient des **beats** horodatés (jour + heure). La
  progression auto-avance quand le joueur répond au SMS-clé du beat
  (`requiresChoice`).
- Les beats peuvent porter une `BeatTransition` (écran poétique entre
  deux moments) et des `unlocksApps` (apps débloquées après le beat).
- **Séquence canonique Ep1 Acte A** (PR #159) :
  Collision (Tristan descend, tend carte) → Carte déchirée chez Shen →
  Tenon (montant) → BNP refus → Camille « rappelle-le » → Carte recollée →
  T. rappelle.

### Onboarding

6 slides (PR #158) : 3 slides de pitch (I/II/III) + 3 slides de
présentation personnage (Shen, Maman, Camille) avec avatar + épigraphe.
L'onboarding se joue une seule fois avant le lock screen.

### Histoire

`ROADMAP.md` contient la bible narrative complète : pitch, structure
16 semaines, scènes non-négociables, scénario J1→J112, 5 épilogues.

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

**NE JAMAIS inventer de texte narratif** (quotes, transitions, répliques,
épigraphes) sans confirmation **mot pour mot** de l'utilisateur. La voix de
Shen est sensible — mais toutes les voix le sont.

Fichiers concernés :
- `lib/data/episodes.dart` (transitions, labels de beats)
- `lib/data/messages_data.dart`, `lib/data/sms_choices.dart` (SMS, répliques)
- `lib/ui/phone/onboarding_screen.dart` (slides perso avec épigraphes)
- `lib/data/contacts_data.dart` (fiches personnages avec quotes)
- `assets/data/scenario.json`, `ROADMAP.md`

**Workflow obligatoire** : proposer le texte en clair dans la conversation,
attendre la validation explicite (« ok » / « reformule » / « j'écris
moi-même »), puis seulement écrire dans le fichier. Ne jamais commit + push
du texte inventé sans validation préalable.
