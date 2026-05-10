# Prompts photos — scènes narratives J1 → J14

Compléments à `PROMPTS.md` (portraits). Ici uniquement les scènes
narratives déjà câblées dans `assets/data/scenario.json` via des
`NarrativeBlock` type `image`. Pour chaque scène : un prompt principal
copy-paste, le nom de fichier final attendu, l'emplacement dans le
jour.

**Format** : 16:10 environ, 1600×1000. Style cinéma réaliste, palette
cohérente avec le ton du jour (Belleville pluvieux = froid / gris ;
Tour Heng = laqué noir / dorure ; hôpital = bleu institutionnel ;
village Fujian = ocre).

**Refs perso** : pour chaque scène, la liste des portraits à charger
dans ton outil de génération (OpenArt "character reference",
Midjourney `--cref`, etc.). Quand un perso apparaît même partiellement
(silhouette, main, profil flou), passer sa fiche en référence garantit
la cohérence visuelle d'un scène à l'autre. Si aucun perso n'est
visible (scène d'objet ou d'environnement), c'est précisé.

**Suffixe commun** :
```
Cinematic editorial photograph, natural lighting, slight film grain,
35mm look, shallow depth of field, photo-realistic, no text overlays,
no people in foreground if subject is environmental, 16:10 framing.
```

---

## J1 — La collision (avenue Montaigne, 08:17)

**Refs perso** : aucun — scène d'environnement, on ne voit que des fragments anonymes (vélo + bas de costume).
**Fichier final** : `assets/photos/scenes/J01_collision.png`

```
Cinematic photograph from a low ground-level angle on a wet Paris
avenue Montaigne morning, light drizzle, asphalt reflecting amber
street lights. Foreground close to the ground : a yellow bike-delivery
backpack burst open, a stainless-steel breakfast bowl tipped over with
acai and yogurt spilled in a long streak, a single smoothie cup
shattered, glass on dark wet pavement. A bicycle lying on its side,
front wheel slightly twisted. In the soft-focus background above the
spill : the lower part of a man's charcoal-grey three-piece bespoke
suit and polished black leather Oxford shoes standing beside a black
luxury sedan front bumper (sleek German berline aesthetic). Shallow
depth, focus on the bowl and bike. Mood : urban, abrupt, cold morning,
slight humiliation. Kodak Portra 400, 16:10 aspect.
```

Légende dans le scénario : *Avenue Montaigne, 08:17. Le bowl coûte 38 €.*

---

## J2 — Dr Aubin *(déjà fournie ✅)*

**Refs perso** : Dr Aubin (perso de scène, pas de fiche profil — voir `refs/scenes/personnages_secondaires/J02_dr_aubin.png`).
**Fichier final** : `assets/photos/scenes/J02_dr_aubin.png`

---

## J3 — Calculs (studio Belleville, après-midi)

**Refs perso** : aucun — scène d'objet en plongée.
**Fichier final** : `assets/photos/scenes/J03_calculs.png`

```
Overhead cinematic photograph of a small wooden kitchen table in a
14m² Belleville studio apartment, afternoon overcast daylight from a
single window. On the table : a worn lined notebook open with
handwritten budget calculations in blue ballpoint pen, columns of
numbers crossed out and rewritten, a small mechanical pencil
calculator, a chipped white coffee mug half-empty with cold espresso,
a few crumpled receipts. Soft warm wood tones, slightly out-of-focus
edges. Mood : stuck, methodical, restrained anxiety. Kodak Portra 400,
16:10 aspect.
```

Légende suggérée : *Trois fois la même réponse.*

---

## J4 — Café Hanami (avec Camille, 14:02)

**Refs perso** :
- `refs/characters/camille_rx.png` — Camille (main visible posée sur le casebook, pas de visage frontal)
**Fichier final** : `assets/photos/scenes/J04_cafe_hanami.png`

```
Cinematic photograph inside a small franco-japanese café near a Paris
university campus, mid-afternoon overcast light through wood-framed
window. Foreground table close-up: two flaky golden butter croissants
on small white ceramic plates, two cups of black coffee, an open law
casebook with one hand resting on it, a torn business card half
visible reassembled with transparent tape. Background : warm bokeh of
wood paneling, brass fixtures, hanging cherry-blossom mobile, a couple
of patrons heavily blurred. Mood : intimate conversation, decision
about to be made. Kodak Portra 400, 16:10 aspect.
```

Légende : *Camille pose son croissant. Mauvais signe.*

---

## J5 — La carte recollée + plan (studio, 23:15)

**Refs perso** : aucun — scène d'objet en plongée.
**Fichier final** : `assets/photos/scenes/J05_carte_recollee.png`

```
Overhead cinematic photograph on a wooden table in a small Belleville
studio at night, single warm desk lamp lighting from the side. Close
up: a torn business card "Tristan Heng — Heng International —
Directeur Europe" carefully reassembled with transparent adhesive
tape, slightly yellowed, placed flat under the corner of a small white
ceramic plate to keep it flat. Beside it : an open silver MacBook Air
showing a Numbers spreadsheet with a 10-year repayment plan, columns
of dates and amounts in euros, partial visibility. The corner of a
green spiral notebook. Mood : late-night decision, sober, dignified
preparation. Kodak Portra 800, 16:10 aspect.
```

Légende : *Je serai sa débitrice. Pas sa charité.*

---

## J6 — Tailleur miroir (studio, 19:00)

**Refs perso** :
- `refs/characters/shen_y.jpeg` — Shen (épaule/bras dans le miroir, pas de visage frontal)
**Fichier final** : `assets/photos/scenes/J06_tailleur_miroir.png`

```
Cinematic photograph in a small Belleville studio bedroom, evening
warm tungsten light from a single bedside lamp. On a freestanding
metal coat-rack: a black tailored women's pantsuit jacket hanging
neatly, pressed white silk blouse beside it. Foreground left: a
half-length oval mirror leaning against a wall, in the mirror's
reflection we glimpse only the bare shoulder and partial profile of a
young woman (heavily out of focus, no face), her dark hair pulled back.
Wooden floor, simple gauze curtain catching low light. Mood : armor
about to be worn, sober, controlled. Kodak Portra 400, 16:10 aspect.
```

Légende : *Pas plus belle. Plus coupée.*

---

## J7 — Tour Heng, 47e étage (10:47)

**Refs perso** :
- `refs/characters/t_heng.png` — Tristan (silhouette de dos en contre-jour, costume)
**Fichier final** : `assets/photos/scenes/J07_tour_heng_47e.png`

```
Cinematic interior photograph of a corner executive office on the
47th floor of a Paris glass tower, morning light through floor-to-
ceiling windows showing a hazy panoramic view of Paris with the
Trocadero and Eiffel Tower silhouetted. Thick cream wool carpet,
dark walnut paneled walls, minimal mid-century black-lacquered desk
with a single closed kraft folder. A man in a charcoal three-piece
suit stands silhouetted against the window, his back to the camera,
his form deliberately out of focus, posture rigid. The light from
the windows turns him into a dark cutout. Mood : silence,
intimidation, money, the protagonist about to enter a foreign world.
Kodak Portra 400 medium format, 16:10 aspect.
```

Légende : *47e étage. La moquette absorbe les pas.*

---

## J8 — Le contrat notarié (cabinet, 11:30)

**Refs perso** : aucun visage — scène d'objet en plongée (le stylo Montblanc et la marginalia sont les sujets).
**Fichier final** : `assets/photos/scenes/J08_contrat_notarie.png`

```
Overhead cinematic photograph of a polished mahogany notary's desk,
soft north light through tall windows. Centered on the desk : a
printed legal contract, three pages, the top sheet visible with
typed paragraphs and handwritten marginalia in fountain-pen blue ink
listing peculiar clauses ("Pas de baisers. Pas de mensonges sur
maman. Droit aux fraises."). A heavy black Montblanc fountain pen
lies across the page. Two halves of a torn business card no longer
relevant pushed aside. A small gold-rimmed water glass at the corner.
Mood : official transaction, intimacy negotiated into ink. Kodak
Portra 400, 16:10 aspect.
```

Légende : *Article 7, alinéa b : droit aux fraises.*

---

## J9 — Valise sur grand lit (appartement Heng, 17:20)

**Refs perso** : aucun — scène d'environnement, pas de personnage dans le cadre.
**Fichier final** : `assets/photos/scenes/J09_valise_grand_lit.png`

```
Cinematic wide photograph of a vast white minimalist Parisian luxury
bedroom in a 350m² apartment, 8th arrondissement, late afternoon
golden light filtering through sheer curtains. Centered : a single
small black hard-shell suitcase placed on an immense king-sized bed
with crisp white linen. The suitcase looks comically small, lost in
the bed's expanse. Marble floor with subtle veining, soft cream walls,
a single fresh white peony in a tall glass vase on the nightstand. No
people. The whole room feels too big, too empty, expensive and cold.
Mood : displacement, foreign luxury, Shen's smallness. Kodak Portra
800, 16:10 aspect.
```

Légende : *Une valise au milieu de 350 m².*

---

## J10 — Cuisine Heng, fraises (08:00)

**Refs perso** : aucun — scène d'objet en plongée (les fraises, le clin d'œil au contrat J8).
**Fichier final** : `assets/photos/scenes/J10_cuisine_fraises.png`

```
Close-up cinematic photograph in a sleek minimalist Parisian luxury
kitchen, morning soft north light. On a black quartz countertop : a
small white porcelain bowl with three ripe red strawberries, one
sliced in half showing the pale heart, surrounded by a few green
leaves. To the right : a sleek black ceramic coffee cup, half-empty,
black coffee. The strawberries are placed deliberately, as if
provocatively offered. No people, but the framing implies someone has
just left them there. Mood : a small forbidden pleasure, a private
joke between two people. Kodak Portra 400, 16:10 aspect.
```

Légende : *Trois fraises. Article 7 b, en pratique.*

---

## J11 — Visite à maman, studio Belleville (19:00)

**Refs perso** :
- `refs/characters/helene_marchand.png` — Hélène (silhouette douce, profil flou, demi-sourire)
**Fichier final** : `assets/photos/scenes/J11_visite_maman.png`

```
Cinematic intimate photograph of a small Belleville studio at early
evening, warm tungsten kitchen light. Foreground : a small wooden
dinner table set for two with simple plates, a covered pot, a steaming
bowl of stir-fried green vegetables, a glass of water. The corner of
a folded green notebook beside one of the plates. Background : an
older woman in a beige knit cardigan sitting at the edge of the table
slightly out of focus, her warm grey hair softly lit, a fragile silhouette,
half-smiling at someone off-camera (her daughter). Mood : tenderness,
something Shen is hiding from her mother, warmth that hurts. Kodak
Portra 400, 16:10 aspect.
```

Légende : *Maman lève la tête. Elle ne pose pas la question.*

---

## J12 — Appartement Heng, midi (12:01)

**Refs perso** : aucun — scène d'environnement, les chaises vides suggèrent les présences sans les montrer.
**Fichier final** : `assets/photos/scenes/J12_dejeuner_heng.png`

```
Cinematic wide photograph of a Parisian luxe apartment dining area,
mid-day natural light. Long lacquered dark walnut dining table set
elegantly for two : porcelain plates, a single steam rising from a
soup bowl, a small carafe of water, white linen napkins folded
sharply. A floor-to-ceiling window in the background opens onto a
hazy Paris view. No people in the immediate frame, but two empty
chairs slightly out of place suggest someone just sat down. Mood :
the choreography of forced intimacy, expensive silence. Kodak
Portra 400, 16:10 aspect.
```

Légende : *Treize chaises. Deux occupées.*

---

## J13 — Appartement Heng, soir avec Camille au téléphone (18:30)

**Refs perso** :
- `refs/characters/shen_y.jpeg` — Shen (main + bras visibles, pas de visage)
- `refs/characters/camille_rx.png` — Camille (juste pour le contact "Camille ❤️" affiché à l'écran de l'iPhone)
**Fichier final** : `assets/photos/scenes/J13_camille_telephone.png`

```
Cinematic close-up photograph of a young woman's hand holding an
iPhone in portrait orientation, the screen showing an active call
"Camille ❤️" with a long timer (00:23:41 visible), evening warm
lighting from a Parisian apartment in the background, Place Vendôme
visible heavily out of focus through a window. Beside the hand : a
small glass of red wine half-empty. Mood : confidence between
women, friend on the other side of the line, small relief. Kodak
Portra 400, 16:10 aspect.
```

Légende : *Vingt-trois minutes de respiration.*

---

## J14 — Thé Madame Heng (dîner familial, 20:30)

**Refs perso** :
- `refs/characters/heng_lihua.png` — Madame Heng (mains seulement dans le cadre, bracelet argent)
- `refs/characters/shen_y.jpeg` — Shen (mains seulement)
**Fichier final** : `assets/photos/scenes/J14_the_madame_heng.png`

```
Cinematic close-up cinematic photograph of two pairs of hands
exchanging a small white porcelain teacup over a dark lacquered low
wooden tea table. On the table : a steaming gaiwan teapot, two small
matching cups already poured, the pale green tea Long Jing visible
inside the offered cup. One pair of hands belongs to an older woman
with fine silver bracelet (Madame Heng) and the other to a young
woman with simple unjeweled fingers (Shen). No faces in frame. Behind
them : a warm dark interior, a single soft lamp, walnut bookshelves
heavily out of focus. Mood : a generational handing-over,
unspoken examination, the moment a matriarch decides if she likes
you. Kodak Portra 400 medium format, 16:10 aspect.
```

Légende : *Le thé Long Jing première récolte. « Ma fille. »*

---

## Workflow de promotion

Pour chaque image générée :

1. Tu la déposes (n'importe où, je trie).
2. Je la déplace vers `assets/photos/scenes/J<NN>_<key>.png` (chemins
   exacts ci-dessus).
3. Le `NarrativeBlock` est déjà câblé dans `scenario.json` pour J1, J2,
   J6, J7, J9, J14. Pour J3, J4, J5, J8, J10, J11, J12, J13 il faudra
   ajouter le bloc image dans le scénario — je le fais dès que tu as
   les fichiers.

## Priorité conseillée

Si tu produits en lots :

- **Lot 1 (les plus iconiques)** : J1 collision, J7 Tour Heng, J9 valise grand lit, J14 thé.
- **Lot 2 (intimité)** : J5 carte recollée, J11 visite maman, J13 téléphone Camille.
- **Lot 3 (habillage)** : J3 calculs, J4 café Hanami, J6 tailleur miroir, J8 contrat, J10 fraises, J12 déjeuner Heng.
