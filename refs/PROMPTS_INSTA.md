# Prompts photos — posts Instagram

42 posts dans `assets/data/insta_seed.json`, aucun n'a encore d'image
(tous tombent sur le fallback gradient + emoji XL). Ce fichier liste
les prompts pour générer chacune.

## Workflow

1. Tu génères une image pour un post.
2. Tu déposes le fichier dans `refs/tampon/`.
3. Je le promeus vers `assets/photos/posts/<post_id>.jpeg` et j'ajoute
   `"imageAsset": "assets/photos/posts/<id>.jpeg"` au post dans
   `insta_seed.json`.

## Format final

- **Ratio** : carré 1:1 (Instagram natif).
- **Résolution** : 1024×1024 minimum.
- **Style commun** : photographique réaliste, grain léger 35mm Kodak
  Portra 400, palette cohérente avec le perso (cf. ci-dessous).

## Suffixe à coller après chaque prompt

```
Instagram square 1:1, photographic, Kodak Portra 400, slight film
grain, natural lighting, no text overlays, lifestyle aesthetic.
```

---

# Phase 1 — Posts visibles dans l'épisode 1 (jours -30 à +14)

> **À générer en priorité** — ce sont les seuls posts que le joueur
> voit avant la fin de l'épisode 1.

## SHEN (@shen_y)
*Pas de posts seed — uniquement les posts générés à l'achat d'items
shop. Pour l'instant on les laisse en fallback emoji.*

## HÉLÈNE / MAMAN (@helene_marchand)

**Refs perso** : `refs/characters/helene_marchand.png`
**Palette** : cream, beige doux, lumière naturelle, intérieur modeste

### `helene_jm30` (29 mai) — Cinq pivoines blanches chez le syrien
```
Close-up of five white peonies wrapped in brown kraft paper, held in
an aging woman's hand (no face visible), simple street florist
background heavily blurred, golden hour soft light, small Belleville
neighborhood vibe.
```

### `helene_jm16` (15 mai) — Photo prise par Shen
```
Side profile of a 50-year-old French woman in soft cardigan, half
smile, looking at something off camera, warm window light, in a
small Belleville apartment kitchen, slightly grainy intimate shot.
```

### `helene_jm3` (28 mai) — Soupe au potiron de la voisine
```
Overhead shot of a steaming bowl of pumpkin soup on an old wooden
table, a heel of bread next to it, simple homemade comfort,
afternoon kitchen light.
```

### `helene_j30` (2 juillet) — Pivoines depuis la chambre
```
Hospital room window in soft afternoon light, a small vase of pink
peonies on the windowsill, Paris rooftops blurred outside, intimate
and quiet, slight melancholy.
```

## CAMILLE (@camille_rx)

**Refs perso** : `refs/characters/camille_rx.png`
**Palette** : café parisien chaud, lumière de fenêtre, croissants

### `camille_jm28` (31 mai) — Code des contrats
```
Open law textbook on a café table next to a chocolate eclair, coffee
mug, a young woman's chestnut-haired silhouette out of focus reading,
warm café bokeh background.
```

### `camille_jm20` (8 juin… avant) — Belleville samedi 11h
```
Café terrace in Belleville, croissant on a white plate, espresso
cup, autumn-yellow sunlight on the table, a chestnut-haired woman's
hand reaching for the cup.
```

### `camille_jm12` (16 juin… retro) — Pâtes coloc
```
Steaming bowl of simple pasta on a small shared kitchen table,
mismatched plates, simple Belleville student flat, warm evening
light, two pairs of hands suggested at the edges.
```

### `camille_jm7` (21 mai retro) — Croissant lundi
```
Close-up of a flaky croissant being torn in two over a small white
plate, a brass coffee carafe in soft focus, café au lait cup, warm
parisian café interior.
```

### `camille_jm2` (1 juin) — Exam blanc demain
```
Selfie point-of-view of a young French chestnut-haired woman, fake-
anxious expression with a half-smile, three croissants on the desk
next to her open law books, evening lamp.
```

### `camille_j1` (3 juin) — Code civil 14h
```
Wide shot of a young French chestnut-haired woman lying dramatically
on a pile of law textbooks, mock-dying pose, half a croissant in
hand, sunny library window light.
```

### `camille_j5` (7 juin) — Belleville pause
```
Belleville street corner at golden hour, a wrought iron café table,
small espresso cup, the silhouette of a young woman from behind
looking up the street.
```

## TRISTAN (@t_heng)

**Refs perso** : `refs/characters/t_heng.png`
**Palette** : noir laqué, vue Paris, costume sombre, peu de lumière

### `tristan_jm26` (8 mai retro) — Tour Heng 47e étage
```
A man in a dark charcoal three-piece suit standing in front of a
floor-to-ceiling window in a luxury Paris office tower, back to the
camera, looking at a hazy Paris skyline including the Eiffel Tower
silhouette, late afternoon light, dramatic minimal aesthetic.
```

### `tristan_jm10` (24 mai retro) — Réunion stratégique
```
Close-up overhead of a sleek black walnut conference table, a single
crystal glass of water reflecting a green banker's lamp, leather
folder, expensive pen, dramatic lighting, executive boardroom mood.
```

### `tristan_j0` (2 juin) — Demain Paris reprend
```
Night view of Paris from a high office window, city lights blurred
through rain-streaked glass, the silhouette of a man's shoulder in
suit holding a tumbler glass, melancholic isolation.
```

## VINCENT (@vincent.h)

**Refs perso** : `refs/characters/vincent_h.png`
**Palette** : luxe ostentatoire, sourires, dorure, bars

### `vincent_jm24` (10 mai retro) — Cigare cubain
```
Close-up of a lit Cuban cigar resting on a dark walnut bar, low-key
warm lighting, a glass of dark amber liquor, leather chair detail,
masculine luxury aesthetic.
```

### `vincent_jm14` (20 mai retro) — Phuket dernier matin
```
Beachside breakfast on a private terrace overlooking the Andaman Sea
at sunrise, a single black espresso cup, white linen table, palm
shadows, luxury resort vibe.
```

### `vincent_jm5` (29 mai retro) — Costume Cifonelli
```
A 31-year-old Asian-French man in a sharply tailored midnight-blue
three-piece suit, half-smile that doesn't reach the eyes, standing
in a luxury Parisian tailor showroom, walnut paneling background.
```

## MADAME HENG (@heng_lihua)

**Refs perso** : `refs/characters/heng_lihua.png`
**Palette** : soie cream, jade, bois sombre, thé, sagesse codée

### `madame_heng_jm22` (12 mai retro) — Le matin chinois
```
Overhead close-up of a traditional Chinese tea setup at dawn:
porcelain gaiwan, two small teacups, steaming Long Jing tea, dark
walnut tea tray, slim ray of morning light cutting across the scene.
```

### `madame_heng_jm8` (26 mai retro) — Héritage des silences
```
Overhead intimate shot of a hand wearing a jade bracelet resting on
an old leather-bound family photo album, sepia portraits visible,
soft amber lamp light, generational mood.
```

### `madame_heng_jm1` (2 juin) — Visite annoncée pour samedi
```
A delicate white porcelain teacup of Long Jing green tea on a dark
walnut tea table, single fresh tea leaf floating, soft side light
from a curtained window, anticipatory mood.
```

### `madame_heng_j9` (11 juin) — Patience amertume
```
Close-up of a hand pouring tea from a gaiwan into a small cup,
elegant low-key lighting, dark Chinese hardwood background, single
peony bloom out of focus.
```

### `madame_heng_j13` (15 juin) — Thé Long Jing première récolte
```
A vintage Chinese tea tin of Long Jing first harvest, the lid open
to reveal the dried green tea leaves, on a dark walnut surface,
soft warm light, ceremonial care.
```

## TANTE MEI (@mei_fujian)

**Refs perso** : `refs/characters/mei_fujian.png`
**Palette** : ocre, terre, village Fujian, simple dignité paysanne

### `mei_fujian_jm18` (16 mai retro) — Premiers iris dans la cour
```
A small earthen pot of blooming purple irises on an old stone
courtyard wall, rural Fujian village setting, late afternoon warm
light, hand-rolled atmosphere.
```

---

# Phase 2 — Posts à venir (J15 et au-delà)

> **À générer plus tard** — invisibles à l'épisode 1.

Format compact pour ces 20 posts (1 ligne par concept).

## CAMILLE — `camille_j18` (J18, hôpital pivoines)
Bouquet de pivoines sur table de chevet d'hôpital, lumière nord froide, intimité.

## VINCENT — `vincent_j16` (J16, Apicius)
Verre de whisky sur nappe blanche, tablecloth Apicius restaurant chic Paris.

## TRISTAN — `tristan_j20` (J20, Hong Kong la semaine prochaine)
Vue nuit Hong Kong skyline depuis hôtel suite, silhouette homme costume près de la fenêtre.

## VINCENT — `vincent_j25` (J25, voiture)
Voiture sportive noire sur route de campagne au crépuscule.

## HÉLÈNE — *(rien d'autre prévu)*

## TRISTAN — `tristan_j32` (J32, Hong Kong mardi)
Boarding pass en première classe sur table, vue lounge aéroport.

## CAMILLE — `camille_j35` (J35, 24 ans)
Petit gâteau d'anniversaire avec une bougie unique, studio belleville, lumière soir.

## VINCENT — `vincent_j40` (J40, deal closed)
Coupe de champagne en main, vue Paris depuis bureau de luxe.

## MADAME HENG — `madame_heng_j43` (J43, gala)
Robe qipao bleu nuit sur fauteuil, perles, jade, soirée pluvieuse derrière une fenêtre.

## TRISTAN — `tristan_j50` (J50, trois cafés une décision)
Trois tasses à expresso vides sur une table de réunion, vue Paris brumeuse.

## TANTE MEI — `mei_fujian_j54` (J54, brasero)
Brasero traditionnel chinois rougeoyant la nuit, mains âgées tendues vers le feu.

## VINCENT — `vincent_j60` (J60, Phuket weekend)
Cocktail tropical au bord d'une piscine à débordement, mer en arrière-plan.

## CAMILLE — `camille_j64` (J64, Belleville samedi)
Vue terrasse café Belleville un matin de samedi, croissants + journal.

## MADAME HENG — `madame_heng_j72` (J72, trois générations)
Vieil album photo ouvert avec trois portraits sépia côte à côte.

## CAMILLE — `camille_j78` (J78, asso droit)
Bureau jonché de dossiers, lampe de bureau, nuit, intensité étudiante.

## TANTE MEI — `mei_fujian_j86` (J86, visiteurs de France)
Petit potager rural Fujian sous soleil de fin d'été, paniers en osier.

## TRISTAN — `tristan_j92` (J92, parc Monceau)
Banc en bois au parc Monceau côté est, lumière de samedi matin, automne précoce.

## MADAME HENG — `madame_heng_j95` (J95, pardon)
Mains tenant un chapelet ou perles de prière, contre une fenêtre voilée.

## TANTE MEI — `mei_fujian_j99` (J99, 312e lettre)
Vieux papier à lettres rurale chinoise sur table en bois, encre noire, enveloppe.

## CAMILLE — `camille_j105` (J105, retrouvailles)
Deux mains tenant des croissants côte à côte sur une table de café, retrouvailles d'amitié.
