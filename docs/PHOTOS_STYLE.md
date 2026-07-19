# Charte photo — Drama

> **La référence absolue : `assets/photos/avatars/pr_shen.webp`.**
> Toute image du jeu doit pouvoir passer pour une vraie photo prise ou reçue
> sur le téléphone de Shen.

## Convention de nommage

- **`pr_`** = photo réaliste (style canon) · **`ill_`** = illustration
  (interdite dans le jeu tant qu'elle n'est pas régénérée en réaliste).
- Le nom décrit le sujet ; les identités incertaines sont décrites
  (« homme 50aine… ») en attendant qu'on les fixe ensemble.
- Suffixes `_2`/`_3` = variantes du même sujet.
- Arborescence : `assets/photos/{avatars,ep1}` = embarqué dans l'app ;
  `assets/photos/{personnages,lieux,quotidien,documents,planches,illustrations}`
  = banque d'images ; `assets/_originaux/…` = masters png/jpg ;
  `assets/videos/` = clips. Inventaire complet : `docs/PHOTOS_INDEX.md`.

## Le style

- **Photoréalisme argentique** : lumière naturelle, palette douce/muted,
  léger grain de film, flou d'arrière-plan optique.
- **Jamais** d'illustration, de rendu peint, d'anime, de matte painting.
- Les photos « envoyées » par un personnage doivent ressembler à des photos
  de smartphone : cadrage imparfait, spontané.
- Bloc de style à inclure dans chaque prompt :
  `cinematic photography, natural lighting, paris setting, melancholic mood,
  muted color palette, film grain, slight haze --style raw
  --no text, watermark, signature, illustration, anime, painting`
- Pour les visages : fournir le portrait de référence
  (`assets/photos/avatars/pr_*.webp`) comme image de conditionnement.

## À générer / régénérer

| Fichier attendu | Usage | Prompt |
|---|---|---|
| ~~`avatars/dr_aubin.webp`~~ | ✅ **Fait** (lot du 19/07) : `avatars/pr_aubin.webp` — homme 50aine, blouse blanche, derrière son bureau. Branché sur la fiche et le fil du Dr Aubin. | — |
| ~~carnet de comptes~~ | ✅ **Fait** (lot du 19/07) : `quotidien/pr_carnet_comptes_table_cuisine.webp` (vue du dessus) et `pr_carnet_comptes_table_ronde.webp`. Remplacent `illustrations/ill_bureau_calculs_calculatrice` le jour où la scène repasse en photo. | — |
| remplace `illustrations/ill_rue_paris_brouillard` | La vue de la fenêtre de Maman, matin de pluie | *« View from Parisian apartment window, Belleville rooftops in morning fog and rain, zinc roofs, soft grey light, shot on smartphone from inside, window frame edge visible »* + bloc de style |
| remplace `illustrations/ill_rue_montmartre_pluie_nuit` | Le trajet vers Tenon (quai du métro Couronnes) | *« Paris métro platform Couronnes, rainy morning, wet floor reflections, few commuters, warm artificial light, candid smartphone shot »* + bloc de style |

## À unifier plus tard 🔶

- `ep1/pr_selfie_ascenseur_chemise_blanche` : réaliste, mais le visage ne
  correspond pas exactement à `pr_shen.webp`. À régénérer avec le portrait
  de Shen en référence.
- `personnages/pr_essayage_tailleur_noir_miroir` : bon candidat pour remplacer
  le selfie d'ascenseur au jour 4 (vrai essayage devant miroir).
- `personnages/pr_portrait_femme_casque_velo[_2]` et
  `pr_portrait_jeune_femme_cheveux_attaches/laches` : ressemblent fort à Shen
  (casque de livreuse !) mais le visage diffère un peu du canon — identités
  à confirmer ensemble.
- `personnages/pr_femme_60aine_pivoines_fenetre_toits` : probablement Maman
  (pivoines + toits de Paris) — à confirmer.
- `personnages/pr_femme_30aine_pull_beige` : portrait d'une inconnue —
  réserver à un futur personnage.
- `lieux/pr_feu_artifice_*` : garder pour Hong Kong (épisode 3+).
- Plusieurs images du lot du 19/07 citent l'ancien univers « NEOCITY / Lu
  Huan / Liu Wei » (quittance en yuans, reçu de taxi, capture de messagerie,
  dossier scellé, dessin d'enfant…) : très utilisables pour le passé chinois
  de la famille, mais les noms affichés dedans sont à recaler sur le canon.

## Règle d'or

Une nouvelle photo n'entre dans le jeu que si :
1. elle est photoréaliste (style `pr_shen.webp`) — préfixe `pr_` ;
2. son contenu colle au message qui l'accompagne ;
3. les visages correspondent aux portraits canon des personnages.
