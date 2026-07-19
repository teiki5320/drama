# Charte photo — Drama

> **La référence absolue : `assets/photos/avatars/shen.webp`.**
> Toute image du jeu doit pouvoir passer pour une vraie photo prise ou reçue
> sur le téléphone de Shen.

## Le style

- **Photoréalisme argentique** : lumière naturelle, palette douce/muted,
  léger grain de film, flou d'arrière-plan optique.
- **Jamais** d'illustration, de rendu peint, d'anime, de matte painting.
- Les photos « envoyées » par un personnage doivent ressembler à des photos
  de smartphone : cadrage imparfait, spontané.
- Bloc de style à inclure dans chaque prompt (hérité de l'ancienne charte) :
  `cinematic photography, natural lighting, paris setting, melancholic mood,
  muted color palette, film grain, slight haze --style raw
  --no text, watermark, signature, illustration, anime, painting`
- Pour les visages : fournir le portrait de référence
  (`assets/photos/avatars/*.webp`) comme image de conditionnement.

## Inventaire (juillet 2026)

### Conformes ✅
Tous les avatars (`shen`, `maman`, `camille`, `tristan`, `vincent`,
`madame_heng`, `tante_mei`) · `j01_08h17_velo_casse_montaigne` ·
`j01_23h42_carte_recollee` · `post_shen_camille_croissants` ·
`post_camille_cafe` · `post_maman_plat` · `pj_maman_plat` ·
`j07_11h00_tour_heng_exterieur` · `j08_11h30_contrat_14_pages` ·
`j06_22h31_tailleur_miroir` (réaliste ; visage à unifier, voir plus bas) ·
`camera_pool/day_low_1` (pivoines).

### Écartées du jeu ❌ (style illustration — à régénérer)
| Fichier | Usage prévu | Prompt de régénération |
|---|---|---|
| `j02_belleville_matin_brouillard` | La vue de la fenêtre de Maman, matin de pluie | *« View from Parisian apartment window, Belleville rooftops in morning fog and rain, zinc roofs, soft grey light, shot on smartphone from inside, window frame edge visible »* + bloc de style |
| `j02_metro_couronnes_pluie` | Le trajet vers Tenon (quai du métro Couronnes) | *« Paris métro platform Couronnes, rainy morning, wet floor reflections, few commuters, warm artificial light, candid smartphone shot »* + bloc de style |
| `j03_15h48_trois_colonnes` | Le carnet de comptes de Shen (3 colonnes chiffrées) | *« Open notebook on small kitchen table, handwritten three columns of numbers in blue pen, calculator, cold tea, harsh honest daylight, shot from above with smartphone »* + bloc de style |

En attendant leur régénération, ces trois moments passent par le texte seul
(ou une image de remplacement conforme). Dès qu'une version réaliste est
déposée dans `assets/photos/ep1/`, on rebranche la photo dans le récit.

### À unifier plus tard 🔶
- `j06_22h31_tailleur_miroir` : réaliste, mais le visage ne correspond pas
  exactement à `shen.webp`. À régénérer avec le portrait de Shen en référence
  (selfie miroir d'ascenseur, chemisier blanc — le cadrage actuel est bon).
- `camera_pool/day_mid_1` : portrait d'une inconnue — réserver à un futur
  personnage ou régénérer.
- `camera_pool/night_low_1` : feu d'artifice derrière une fenêtre — garder
  pour Hong Kong (épisode 3+).

## Règle d'or pour la suite

Une nouvelle photo n'entre dans le jeu que si :
1. elle est photoréaliste (style `shen.webp`) ;
2. son contenu colle au message qui l'accompagne ;
3. les visages correspondent aux portraits canon des personnages.
