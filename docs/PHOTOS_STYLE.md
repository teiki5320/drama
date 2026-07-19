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
| ~~carnet de comptes~~ | ✅ **Fait** (lot du 19/07) : `ep1/pr_carnet_comptes_table_cuisine.webp`, branchée au J3 (« trois colonnes »). | — |
| **contrat vierge** | J6 : le contrat de 14 pages que Tristan annonce (scène en texte seul depuis l'audit du 19/07 — l'ancienne photo montrait un contrat déjà annoté et signé) | *« Thick unsigned legal contract on a notary's leather desk, cover page reading only "CONTRAT", fourteen numbered pages fanned slightly, black fountain pen resting beside, no handwriting, no signatures »* + bloc de style |
| **bouquet sous la pluie** | J1 : les pivoines du fleuriste (photo retirée — l'actuelle est en plein soleil et montre les deux mains de Maman) | *« Peonies bucket outside a Paris florist in the rain, wet kraft paper, water drops, grey morning light, no people, shot quickly from under an umbrella »* + bloc de style |
| **croissant du samedi** | J1 : la « motivation pour samedi » de Camille (photo retirée — l'ancienne montrait deux paires de mains, prise par un tiers) | *« First-person point of view, own hand holding out a golden croissant across a Paris café table, second coffee waiting on the other side, warm morning light »* + bloc de style |
| **écran badge refusé** (optionnel) | Beat « ascenseur A » à ajouter un jour au J6 — l'existante affiche l'ancien nom « SHEN MIAO » et une date 2023 | *« Security desk monitor listing visitor names, one row highlighted red: "MARCHAND S — 47 — accès refusé", modern lobby reflections »* + bloc de style |
| remplace `illustrations/ill_rue_paris_brouillard` | La vue de la fenêtre de Maman, matin de pluie | *« View from Parisian apartment window, Belleville rooftops in morning fog and rain, zinc roofs, soft grey light, shot on smartphone from inside, window frame edge visible »* + bloc de style |
| remplace `illustrations/ill_rue_montmartre_pluie_nuit` | Le trajet vers Tenon (quai du métro Couronnes) | *« Paris métro platform Couronnes, rainy morning, wet floor reflections, few commuters, warm artificial light, candid smartphone shot »* + bloc de style |

## À unifier plus tard 🔶

- `personnages/pr_selfie_ascenseur_chemise_blanche` : sortie du jeu (audit du
  19/07) — visage hors canon et ascenseur de tour de bureaux. Le J4 utilise
  désormais `ep1/pr_essayage_tailleur_noir_miroir` (tailleur sur portant,
  silhouette floue — aucun conflit de visage).
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
2. son contenu colle au message qui l'accompagne (météo, heure, lieu,
   plat annoncé…) ;
3. les visages correspondent aux portraits canon des personnages ;
4. **le point de vue est possible** : une photo envoyée par un personnage ne
   montre jamais ce personnage (sauf selfie), ni une deuxième main ou
   silhouette non identifiée — si Camille « attend », personne d'autre n'est
   attablé sur sa photo ;
5. aucun texte lisible (écran, document, reçu) ne contredit le canon —
   ni ancien nom (« Shen Miao », « Lu Huan »), ni montants ou dates d'une
   autre version de l'histoire.

Et côté récit : quand deux personnages sont **physiquement ensemble**, ils ne
s'écrivent pas. Les lignes système (voir J4 11h30) sont l'outil de **dernier
recours**, validé par l'auteur : on ne s'en sert que quand la messagerie ne
peut vraiment pas porter la scène — sinon on déplace la scène hors écran et
on la fait exister par ses traces (photo, récap, « Rentrée. ») avant que la
conversation reprenne.
