# `refs/archive/` — photos non utilisées

Toutes les photos qui ne sont plus dans le tampon mais qu'on garde au cas
où :

- **Variantes scénarios** (`J03_calculs_variante.png`,
  `J05_carte_recollee_variante.png`) : autres takes de scènes pour
  lesquelles on a déjà choisi une version principale dans
  `assets/photos/scenes/`. À ressortir si on change d'avis.
- **Autres dramas** (`_autre_drama_*.png`) : images générées pour
  d'autres projets (Neocity, Hatsune, Liu Wei, etc.), nettement hors
  univers d'À Contre-Jour. Ne pas remettre dans le tampon sans usage
  spécifique.
- **Mockups UI** (`chat_*.png`, `post_*.png`, `wallpaper_*.png`,
  `map_*.jpg`) : éléments d'interface de projets antérieurs. Peuvent
  servir d'inspi mais pas tels quels.
- **Portraits anonymes non identifiés** (`femme_asia_*`,
  `homme_asia_*`, `homme_blanc_*`) : générations de personnes qui ne
  matchaient aucun perso de notre casting. À ressortir si on ajoute
  un nouveau personnage secondaire (boulangère, voisine, etc.).

## Comment ressortir une photo

```bash
git mv refs/archive/<nom>.png refs/tampon/<nom>.png  # ou directement
git mv refs/archive/<nom>.png assets/photos/<categorie>/<nom_final>.png
```

Si tu veux nettoyer définitivement, on peut `git rm` une fois qu'on
est sûrs de ne plus en avoir besoin (les fichiers existent dans
l'historique git de toute façon).
