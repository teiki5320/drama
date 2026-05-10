# assets/photos/ — convention de nommage

Le code attend des images aux chemins exacts ci-dessous. Toutes sont **optionnelles** :
si un fichier manque, l'app retombe automatiquement sur le placeholder
(emoji XL sur dégradé pastel teinté). Inutile de tout fournir d'un coup.

Format conseillé : `.jpg`, ratio carré pour les portraits, ratio 16:10 environ
pour les posts/scènes. Compresser ≤ 200 ko.

---

## 1. Portraits perso (`assets/photos/characters/`)

Fichier exact attendu pour chaque perso (chemin codé en dur dans
`lib/models/character.dart`) :

| Perso | Chemin |
|---|---|
| Shen Marchand | `characters/shen_y.jpg` |
| Camille Roux | `characters/camille_rx.jpg` |
| Tristan Heng | `characters/t_heng.jpg` |
| Vincent Heng | `characters/vincent_h.jpg` |
| Madame Heng | `characters/heng_lihua.jpg` |
| Tante Mei | `characters/mei_fujian.jpg` |
| Hélène (Maman) | `characters/helene_marchand.jpg` |

Utilisé pour : avatars dans le feed Insta, ronds des stories, hero des
fiches profil, avatars dans Messages.

---

## 2. Posts Insta (`assets/photos/posts/`)

Convention : `posts/<id_du_post>.jpg` où `<id_du_post>` est l'`id` exact
dans `assets/data/insta_seed.json` (ex. `posts/tristan_j20.jpg`).

Si tu ajoutes un fichier `imageAsset` à un post du JSON
(`"imageAsset":"assets/photos/posts/tristan_j20.jpg"`), il s'affiche.
Sinon → fallback emoji + dégradé.

Pour les posts générés par les achats (Tesla, sac Chanel, etc.), le
fallback emoji est suffisant pour la v1 — on pourra y revenir.

---

## 3. Scènes narratives (`assets/photos/scenes/`)

Convention : `scenes/J<NN>_<key>.jpg` (ex. `scenes/J07_tour_heng.jpg`).

Embarqué dans le scénario via un nouveau `NarrativeBlock` de type
`image`. À ajouter dans `assets/data/scenario.json` quand on veut
illustrer un moment :

```json
{
  "type": "image",
  "imageAsset": "assets/photos/scenes/J07_tour_heng.jpg",
  "content": "Tour Heng, 47e étage. La vue mange le ciel."
}
```

Le `content` devient une légende italique sous la photo.

**Suggestions de scènes à illustrer en priorité** (pour s'attacher à
Shen) :
- J1 — Belleville, le studio à 7h42
- J2 — Hélène à l'hôpital
- J7 — Tour Heng, vue depuis le bureau
- J18 — Shen à l'hôpital, les pivoines
- J23 — La cuisine Heng, les fraises (scène canonique)
- J46 — Le thé Long Jing chez Madame Heng
- J86 — Le potager du Fujian, Tante Mei
- J102 — La 312ème lettre dans le brasero
- J109 — Le parc, le banc côté est
