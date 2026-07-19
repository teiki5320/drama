# Charte photo — Drama

> **La référence absolue : `assets/photos/avatars/pr_shen.webp`.**
> Toute image du jeu doit pouvoir passer pour une vraie photo prise ou reçue
> sur le téléphone de Shen.

## Convention de nommage

- **`pr_`** = photo réaliste (style canon) · **`ill_`** = illustration
  (interdite dans le jeu tant qu'elle n'est pas régénérée en réaliste).
- Le nom décrit le sujet ; les identités incertaines sont décrites
  (« homme 50aine… ») en attendant qu'on les fixe ensemble.
- Suffixe `_2` = doublon/variante du même sujet.
- L'inventaire complet ancien nom → nouveau nom : `docs/PHOTOS_INDEX.md`.

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
| `avatars/dr_aubin.webp` | Portrait du Dr Aubin — **homme**, oncologue à Tenon, **blouse blanche, derrière son bureau** | *« French hospital oncologist, man in his 50s, short greying hair, white coat, sitting behind his desk, warm direct gaze, hospital office softly blurred »* + bloc de style. (L'auteur possède déjà cette image hors dépôt — à déposer sous ce nom.) |
| remplace `ep1/ill_rue_paris_brouillard` | La vue de la fenêtre de Maman, matin de pluie | *« View from Parisian apartment window, Belleville rooftops in morning fog and rain, zinc roofs, soft grey light, shot on smartphone from inside, window frame edge visible »* + bloc de style |
| remplace `ep1/ill_rue_montmartre_pluie_nuit` | Le trajet vers Tenon (quai du métro Couronnes) | *« Paris métro platform Couronnes, rainy morning, wet floor reflections, few commuters, warm artificial light, candid smartphone shot »* + bloc de style |
| remplace `ep1/ill_bureau_calculs_calculatrice` | Le carnet de comptes de Shen | *« Open notebook on small kitchen table, handwritten three columns of numbers in blue pen, calculator, cold tea, harsh honest daylight, shot from above with smartphone »* + bloc de style |

## À unifier plus tard 🔶

- `ep1/pr_selfie_ascenseur_chemise_blanche` : réaliste, mais le visage ne
  correspond pas exactement à `pr_shen.webp`. À régénérer avec le portrait
  de Shen en référence.
- `_tampon/pr_essayage_tailleur_noir_miroir` : bon candidat pour remplacer
  le selfie d'ascenseur au jour 4 (vrai essayage devant miroir).
- `camera_pool/pr_femme_30aine_pull_beige` : portrait d'une inconnue —
  réserver à un futur personnage.
- `camera_pool/pr_feu_artifice_*` : garder pour Hong Kong (épisode 3+).

## Règle d'or

Une nouvelle photo n'entre dans le jeu que si :
1. elle est photoréaliste (style `pr_shen.webp`) — préfixe `pr_` ;
2. son contenu colle au message qui l'accompagne ;
3. les visages correspondent aux portraits canon des personnages.
