# `refs/` — photos de référence (production)

Dossier **hors app** : ces images n'entrent pas dans le bundle Flutter.
Elles servent uniquement de matériel de référence pour générer / shooter les
photos finales qui iront, elles, dans `assets/photos/`.

Workflow :
1. Tu déposes ici tes refs (casting, ambiance, lieux).
2. À partir de chaque ref, on produit la version finale (IA générative ou
   shoot) dans le bon ratio / la bonne ambiance.
3. La version finale atterrit dans `assets/photos/<categorie>/` selon la
   convention décrite dans `assets/photos/README.md`.

Si le dossier devient lourd, ajouter `refs/` à `.gitignore` est OK — c'est
de la matière de pré-production, pas du code.

## Sous-dossiers

```
refs/
├── characters/    portraits casting (visage, silhouette, attitude)
├── locations/     lieux récurrents (studio Belleville, Tour Heng, hôpital…)
├── scenes/        moments précis du scénario (J1 studio matin, J7 vue Tour…)
└── moodboards/    palette + lumière + grain par acte
```

## Convention de nommage

Pour t'y retrouver vite quand le dossier grossit :

- `characters/<handle>_<numero>.jpg` — ex. `shen_y_01.jpg`, `t_heng_03.jpg`.
  Le `<handle>` correspond au handle Insta dans `lib/models/character.dart`
  sans le `@`.
- `locations/<lieu>_<numero>.jpg` — ex. `studio_belleville_01.jpg`,
  `tour_heng_47e_02.jpg`.
- `scenes/J<NN>_<key>_<numero>.jpg` — ex. `J01_studio_matin_01.jpg`,
  `J07_tour_heng_vue_01.jpg`. Doit matcher la clé `<key>` qui sera utilisée
  pour le fichier final dans `assets/photos/scenes/`.
- `moodboards/acte<N>_<theme>.jpg` — ex. `acte1_belleville_pluie.jpg`.

## Palette globale du drama (rappel)

- **Belleville / Shen** : crème, beige chaud, terracotta usé, vert bouteille
  du carnet, gris-bleu pluie.
- **Heng (luxe parisien)** : noir laqué, blanc cassé, dorure froide,
  champagne, gris ardoise.
- **Hôpital Tenon** : bleu pâle clinique, beige institutionnel, lumière nord
  froide.
- **Fujian (acte 5)** : ocre, terre, vert olive, ciel blanc d'humidité,
  brasero rouge sombre.

À garder cohérent dans toutes les refs.
