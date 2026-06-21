# Audit Drama — rapport (juin 2026)

Généré dans le cadre d'un audit autonome. Outil : `python3 tools/audit.py`
(aucune dépendance, ne nécessite pas Flutter). État au moment du rapport :
**17 checks OK, 0 FAIL, 0 WARN, 5 items EDITORIAL** (décisions d'auteur).

## 1. Corrigé automatiquement (sûr, mécanique)

| # | Problème | Correctif |
|---|----------|-----------|
| 1 | `Mme Heng` dans 3 chaînes affichées (interdit par CLAUDE.md) | → `Madame Heng` (`banque_data.dart` ×2, `instagram_app.dart` ×1) |
| 2 | **Bug réel** : 13 items du shop dans 4 catégories (`bouffe`, `art`, `immobilier`, `mecenat`) absentes de `kShopCategories` → jamais filtrables, sans libellé | 4 catégories ajoutées dans `lib/models/shop_item.dart` |
| 3 | `CLAUDE.md` « État actuel » périmé (décrivait un placeholder ; l'app téléphone est construite) + compteurs faux (shop 27→40, invest 5→9, insta 8→42) | Section « État actuel (juin 2026) », « Architecture actuelle » et compteurs mis à jour |
| 4 | Aucun garde-fou automatisé dans le repo | Ajout de `tools/audit.py` (17 checks) |

## 2. Décisions d'auteur requises (EDITORIAL — non corrigé exprès)

Ces points touchent la **voix / le canon narratif** : ils ne sont pas
réparables mécaniquement sans trancher à ta place.

### 2.1 — `scenario.json` : doublon J8–J14
Le fichier contient **21 entrées pour 14 jours** : deux versions rédigées de
J8 à J14 coexistent (introduites ensemble par la PR #110).
- **LOT 1** (riche : SMS, beats, sticky notes ; ~1300–1800 car/jour) — adresses
  « Appartement Heng, 8e », « Cuisine Heng ».
- **LOT 2** (concis ; ~640–1040 car/jour) — adresses « 8 rue de Berri ».
- **Impact runtime : nul** — `scenario.json` n'est **pas chargé** par l'app
  (référence narrative seulement ; le jeu lit `lib/data/*.dart`).
- **À décider** : quelle version est canonique ? L'autre peut être retirée.

### 2.2 — Adresse de l'appartement de Tristan : 8e vs 16e
Contradiction d'arrondissement :
- `ROADMAP.md` + `scenario.json` → **« rue de Berri / 8e »** (8e arr.).
- Le code de l'app → **« avenue Foch »** (~43 réfs ; or avenue Foch est au **16e**).
- **À décider** : soit l'app a délibérément upgradé l'adresse (alors ROADMAP +
  scenario sont à aligner sur Foch), soit c'est une dérive (alors corriger
  l'app vers le 8e). Ne pas réécrire 43 chaînes de la voix de Shen sans ton aval.

### 2.3 — Contenu Ep 2→5 à écrire
9 beats d'épisode déclarent un `requiresChoice` sans `SmsChoice` correspondant
(donc la progression ne peut pas dépasser ces beats tant que le choix n'est pas
écrit) : `maman_long_jing_j23`, `camille_distance_j26`, `mei_decouvre_j35`,
`maman_decouvre_j39`, `maman_confrontation_j42`, `tristan_fin_contrat_j52`,
`mei_invitation_j78`, `tristan_revient_j95`, `epilogue_j112`.
Cohérent avec le fait qu'Ep 1 (J1–J14) est dense et qu'Ep 2→5 sont scaffoldés.

### 2.4 — Couverture narrative
**49/112 jours** ont au moins une trace narrative ; 63 jours restent vides
(toutes apps confondues). Ep 1 est complet, le reste est squelette.

### 2.5 — Feature « achat → post Instagram » non câblée
Les items du shop portent `generatesInstaPost`, `instaPostCaption`,
`instaPostEmoji`, mais `generatesInstaPost` est **parsé sans jamais être
consommé** : acheter un item ne crée pas de post. Feature à implémenter (le
contenu — légendes — est déjà écrit dans `shop_catalog.json`).

## 3. Vérifié sain (aucune action)

- JSON tous valides ; `shop_catalog.json` compatible avec `ShopItem.fromJson`.
- 51 références d'assets résolues sur disque ; déclarations pubspec OK.
- Contrat runtime des choix SMS cohérent (tout message `beatId` a son choix).
- Catalogues romance (27) et arcs (9) : aucun import cassé, aucun orphelin.
- 8 threads Messages → contacts tous définis ; aucun id dupliqué.
- Beats d'épisode monotones en temps ; day-events ordonnés.
- Montants : aucun « collé au € » dans les chaînes affichées (la règle
  « espace insécable » du CLAUDE.md reste aspirationnelle — même les fichiers
  de l'auteur utilisent un espace normal ; non touché par cohérence).
