# `refs/` — index complet

Vue d'ensemble de l'arborescence après tri.

```
.
├── assets/photos/                 ← bundlé dans l'app (Flutter)
│   ├── characters/                ← 7 portraits Insta (1 par perso)
│   │   ├── shen_y.jpeg
│   │   ├── camille_rx.png
│   │   ├── t_heng.png
│   │   ├── vincent_h.png
│   │   ├── heng_lihua.png
│   │   ├── mei_fujian.png
│   │   └── helene_marchand.png
│   ├── posts/                     ← (vide) photos de posts Insta narratifs
│   └── scenes/                    ← (vide) photos pour NarrativeBlock image
│
└── refs/                          ← hors bundle, pré-prod
    ├── README.md                  ← convention de nommage globale
    ├── PROMPTS.md                 ← prompts de génération par perso
    ├── BRIEF_J01_J07.md           ← brief photo semaine 1
    │
    ├── characters/                ← (vide) candidats portraits
    ├── locations/                 ← (vide) lieux récurrents
    ├── moodboards/                ← (vide) palette par acte
    │
    ├── scenes/                    ← refs de scènes narratives, classées
    │   ├── wenbo/                 ← 3 âges du père bio
    │   │   ├── seul_jeune_30ans.png
    │   │   ├── avec_shen_enfant.png
    │   │   └── age_2017_45ans.png
    │   ├── shen_voyage/           ← Shen en voyage (Hong Kong, Fujian)
    │   │   ├── gare_departure_boards.png
    │   │   ├── paris_aeroport.png
    │   │   └── village_fujian_selfie.png
    │   └── personnages_secondaires/
    │       └── J02_dr_aubin.png   ← pour la scène diagnostic J2
    │
    └── tampon/                    ← réservoir (autres dramas, ambigus)
        └── ...
```

## Promotion d'une scène vers l'app

Quand on veut afficher une image dans le carnet d'un jour donné :

1. Copier la photo de `refs/scenes/<sous_dossier>/<nom>.png` vers
   `assets/photos/scenes/J<NN>_<key>.png`.
2. Ajouter un `NarrativeBlock` type `image` dans `assets/data/scenario.json` :
   ```json
   {
     "type": "image",
     "imageAsset": "assets/photos/scenes/J<NN>_<key>.png",
     "content": "Légende italique en dessous."
   }
   ```

## Conventions

- `assets/photos/characters/<handle>.{png,jpeg}` — ext exacte selon le
  fichier réel ; `lib/models/character.dart` doit pointer dessus.
- `refs/scenes/<sous_dossier>/<nom_descriptif>.png` — nom sans préfixe de
  jour (sauf si scène très spécifique type `J02_dr_aubin.png`), sous-
  dossier par perso ou par thème.
- Pour les scènes datées, préfixe `J<NN>_` est OK quand l'usage est
  certain.
