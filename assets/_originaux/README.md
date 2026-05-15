# Originaux haute résolution

Ce dossier contient les **PNG originaux non compressés** des photos
qui ont été optimisées en WebP dans `assets/photos/`.

## Règle absolue

**N'AJOUTE JAMAIS** `assets/_originaux/` dans le bloc `flutter:.assets:`
de `pubspec.yaml`. Ces fichiers ne doivent **PAS** être livrés dans
le bundle iOS — ils sont uniquement là pour qu'on puisse re-générer
des variations (re-crop, ré-encoder différemment, etc.) plus tard.

## Sous-dossiers

- `_tampon/` — originaux des photos en triage (87 fichiers, ~151 Mo)
- `ref_characters/` — originaux des refs personnages (18 fichiers, ~27 Mo)

## Si tu veux récupérer un original

Les WebP dans `assets/photos/` ont le même nom (juste extension `.webp` au
lieu de `.png` / `.jpg`). Exemple :

- WebP : `assets/photos/_tampon/IMG_4621.webp`
- Original : `assets/_originaux/_tampon/IMG_4621.png`
