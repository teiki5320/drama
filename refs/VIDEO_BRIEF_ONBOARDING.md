# Brief vidéo — onboarding "Bienvenue dans À Contre-Jour"

Tu m'as demandé de remplacer les 3 pages d'onboarding actuelles (texte
+ emoji) par une vidéo. Voici le brief pour la produire (génération IA
type Sora / Runway / Veo, ou compositing image+voix).

## Format livré

- **Durée** : 35-45 secondes max. C'est un cold open de drama, pas une
  bande-annonce.
- **Ratio** : vertical 9:16 (l'app est portrait sur iPhone).
- **Résolution** : 1080×1920 minimum.
- **Audio** : narration française voix off **Shen** (jeune femme,
  ton sec mais lumineux, ironie maîtrisée, pas glamour). Musique
  d'ambiance piano discret en sous-couche, niveau bas.
- **Sortie** : `assets/video/intro.mp4` (à câbler avec `video_player`
  package côté Flutter — patch à faire ensemble quand le fichier
  arrive).

## Découpage shot par shot

### Plan 1 (0-6s) — Belleville matin
**Image** : plan large d'une rue de Belleville, début juin, pluie
légère, lumière grise. Un vélo de livraison filant en bas du cadre.
Caractères chinois sur une enseigne de restaurant. Pavés mouillés
brillants.
**Voix off Shen** :
> *"Je m'appelle Shen Marchand. Belleville, 24 ans, livreuse à vélo."*

### Plan 2 (6-12s) — Hôpital Tenon
**Image** : couloir d'hôpital nord-froid, banc en bois, lumière
clinique, une silhouette assise dos courbé (Shen). Au fond, hors de
focus, une infirmière passe.
**Voix off** :
> *"Ma mère est à Tenon. Le traitement coûte 18 000 €. Il me reste
> quarante-cinq jours pour les trouver."*

### Plan 3 (12-19s) — Collision avenue Montaigne
**Image** : vue plongeante d'un vélo couché sur le bitume mouillé,
bowl de petit-déj éclaté, smoothie au sol. Au-dessus : ourlet d'un
costume noir trois pièces et chaussures cuir. Tension.
**Voix off** :
> *"Ce matin-là, j'ai humilié l'héritier du groupe Heng. Le soir
> même, je lui ai recollé sa carte de visite."*

### Plan 4 (19-26s) — Tour Heng 47e étage
**Image** : intérieur de bureau de standing, baie vitrée donnant sur
Paris brumeux, contre-jour. Une silhouette d'homme en costume
sombre dos à la caméra. La moquette absorbe les pas.
**Voix off** :
> *"Il m'a proposé 30 000 €. Trois mois. Fausse fiancée. Pas de
> baisers, pas de mensonges sur ma mère. J'avais une seule
> condition : le droit aux fraises."*

### Plan 5 (26-32s) — Carnet vert + tasse de thé
**Image** : carnet vert ouvert sur une table en bois, stylo bic
vert, la main de Shen écrit (on ne voit pas son visage), à côté
une tasse fumante. La lumière dorée du soir.
**Voix off** :
> *"Tout ce que tu vas lire — ce sont mes mots. Tout ce que tu
> vas choisir, c'est moi qui le vivrai."*

### Plan 6 (32-40s) — Titre carte
**Image** : fade to cream paper (palette du jeu), logo / titre se
forme en serif Crimson Pro :

> **À Contre-Jour**
> *逆光*
>
> _Drama romantique mobile · 112 jours · 5 fins_

Musique se résout sur une note de piano.

### Skip / Commencer (UI overlay)

Sur toute la vidéo, en haut à droite : un bouton discret **`Passer`**
qui appelle `_finish()` du onboarding. À la fin de la vidéo, le
bouton **`Commencer le drama`** apparaît centré sur le titre.

## Direction artistique

- **Palette** : cream paper #FBF7EF (palette du jeu), orange terracotta
  #D97757 pour l'accent. Tout le reste en désaturation contrôlée.
- **Aucun visage frontal de Shen** — uniquement silhouette, dos,
  fragments (main qui écrit, profil flou). La protagoniste reste un
  espace où le joueur se projette.
- **Caméra** : statique ou très lent mouvement. Pas de zoom DSLR
  agressif. Drama littéraire, pas trailer Netflix.
- **Grain film** léger, comme tournée en 35 mm Kodak Portra. Le jeu a
  cette texture.

## Prompts shots individuels (en anglais pour gen IA)

Si tu génères chaque plan via Veo / Runway / Sora :

### Plan 1
```
Slow dolly shot down a wet narrow Belleville Paris street at dawn,
early June, light rain, grey overcast morning light, cobblestones
reflecting amber street lamps. A bicycle delivery rider in dark
clothing passes at the bottom of the frame from right to left, motion
blur. Chinese restaurant signage with red characters glowing on a
storefront. Cinematic 35mm film grain, Kodak Portra 400, 9:16 vertical
aspect ratio, no people in frame in foreground.
```

### Plan 2
```
Static wide shot of an empty Paris hospital corridor at 6:30 AM, cold
north light through tall windows, polished linoleum floor, beige
institutional walls. A young woman sits hunched on a wooden bench at
the far end of the corridor, her back to the camera, dark hair falling
forward. A nurse walks past heavily out of focus. Slow ambient camera
breath, no movement. Cinematic, Kodak Portra 400, 9:16 vertical.
```

### Plan 3
```
Overhead handheld shot tilting down onto wet Paris asphalt avenue
Montaigne morning. A delivery bicycle lying on its side, yellow
delivery backpack burst open, stainless-steel breakfast bowl tipped
over with acai spilled in a streak, broken smoothie cup. Slow zoom out
to reveal the lower part of a man's charcoal grey three-piece bespoke
suit and polished black Oxford shoes standing beside a sleek German
luxury black sedan. Light drizzle, amber reflections. Cinematic, Kodak
Portra 400, 9:16 vertical.
```

### Plan 4
```
Slow static shot inside a 47th floor corner executive office in a
Paris glass tower, cream wool carpet, dark walnut paneling, late
morning hazy light through floor-to-ceiling windows showing Trocadero
and Eiffel Tower silhouette. A man in a charcoal three-piece suit
stands silhouetted against the windows, back to camera, dead still.
The light turns him into a dark cutout. Silence is the subject.
Cinematic, Kodak Portra 400 medium format, 9:16 vertical.
```

### Plan 5
```
Slow static overhead shot of a green spiral notebook open on a warm
wooden table at dusk, a young woman's hand visible (no face) writing
in blue ballpoint pen in French cursive, a steaming tea cup beside the
notebook, evening golden light slanting from a left window. Pages
slightly yellowed, ink fresh. Mood : intimate, literary. Cinematic,
Kodak Portra 400, 9:16 vertical.
```

### Plan 6 (motion graphics, pas IA)
```
Static title card on cream paper background #FBF7EF. Centered text
fades in : "À Contre-Jour" in serif Crimson Pro 110pt, then below
"逆光" in serif Chinese characters 60pt orange #D97757, then below a
horizontal hairline, then "Drama romantique mobile · 112 jours · 5
fins" in sans Inter 18pt grey #6B6B6B. Fade in at 200ms intervals.
Hold 3s.
```

## Workflow

1. Tu génères / commandes la vidéo (Sora / Runway / Veo / shooting
   réel + montage).
2. Tu déposes le fichier dans `assets/video/intro.mp4`.
3. Je crée la branche qui ajoute `video_player` au `pubspec.yaml`,
   déclare l'asset, et remplace les 3 PageView de
   `lib/ui/onboarding_screen.dart` par un `VideoPlayer` plein écran
   avec contrôles minimaux (Skip top-right, Commencer big bottom).
4. Toi tu fais `flutter pub get` sur ton Mac (je ne peux pas), je
   merge la PR, build TestFlight, c'est en prod.

## Note coûts / poids

- `intro.mp4` h.264 720p ~3-5 MB en 40s. Acceptable dans le bundle iOS.
- Si trop lourd : passer en h.265 ou héberger sur ton domaine + jouer
  via URL (mais l'app perd l'offline pour l'onboarding, peu grave).
