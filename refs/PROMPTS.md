# Prompts génération d'image — personnages

Prompts en anglais (la plupart des modèles donnent de meilleurs résultats),
direction artistique en français pour le contexte. Format conseillé :
**carré 1024×1024**, style **portrait éditorial naturel** (pas glamour, pas
anime). Lumière douce, grain léger.

## Style commun à tous (à coller en suffixe)

```
Editorial portrait photography, natural soft daylight, neutral grey or muted
tone background, slight film grain, shallow depth of field, 35mm look,
realistic skin texture, no makeup heavy, no fashion-magazine glam, calm
composition, square 1:1 framing, head and shoulders or upper-body crop.
```

---

## 1. Camille Roux — meilleure amie de Shen *(priorité 1)*

Visuel attendu : **antithèse lumineuse de Shen**. Les deux ensemble doivent
faire image — Shen sérieuse / Camille rayonnante.

```
Portrait of Camille, a 24-year-old French woman, white skin with light tan,
warm hazel eyes, wavy chestnut shoulder-length hair pulled back loosely with
a few strands escaping. Wide candid smile mid-laugh, mouth slightly open as
if caught talking. Wearing a simple white cotton shirt with a black knit
cardigan loosely tied over the shoulders. A flaky butter croissant held in
one hand, near her face, like she just took a bite. Setting: bokeh-blurred
parisian café in the background, warm window light. Energetic, mischievous,
trustworthy. Law-student-meets-belleville-girl vibe — smart but not posh,
warm but sharp.
```

Fichier final : `assets/photos/characters/camille_rx.jpeg`

---

## 2. Madame Heng (Heng Lihua) — matriarche *(priorité 1)*

Visuel attendu : **autorité, élégance, regard qui sait des choses**.
Aucune chaleur affichée, mais aucune cruauté non plus. Un mur poli.

```
Portrait of Madame Heng, a 58-year-old Chinese woman, refined matriarch.
Black hair with subtle silver at temples, pulled back into an impeccable
low chignon. Pale powdered skin, sharp cheekbones, thin lips with neutral
lipstick, dark almond eyes that look directly at the camera without
warmth. Wearing a high-collared cream silk blouse with a single strand of
small white pearls. A jade bracelet on the left wrist. Setting: dark
lacquered wooden interior, soft side light, slightly out of focus. No
smile. Quiet authority, not cruel, not warm — observing. Old Chinese
elegance, Paris bourgeois variant.
```

Fichier final : `assets/photos/characters/heng_lihua.jpeg`

---

## 3. Vincent Heng — antagoniste *(priorité 2, devient nécessaire à J14)*

Visuel attendu : **le contraire exact de Tristan**. Tristan = glaçon
sincère. Vincent = sourire commercial qui fait peur quand on regarde de
près. Tout est en surface.

```
Portrait of Vincent Heng, a 31-year-old Chinese-French man. Slick black
hair carefully styled with pomade, clean-shaven, square jaw, slightly
warmer skin tone than his half-brother. Wearing a charcoal three-piece
bespoke suit with a silk tie, a luxury wristwatch visible at the cuff
(Patek-Philippe-style, no logo). A confident commercial smile — perfect
teeth, eyes calculating not joyful. Setting: dark luxe interior, walnut
panels, low warm light. The kind of man who closes deals and forgets
faces. Charming on the surface, cold underneath. Same family bone
structure as Tristan but everything more performative.
```

Fichier final : `assets/photos/characters/vincent_h.jpeg`

---

## 4. Wenbo jeune — père biologique de Shen, 24 ans, 1999 *(priorité 3)*

Pour les flashbacks / archives. Sa première rencontre avec Hélène à Paris,
été 1999. Personnage absent du présent du jeu, mais visuel canonique pour
la révélation à partir de la semaine 13.

```
Portrait of Wenbo, a 24-year-old Chinese man, 1999. Slim build, short
black hair simply combed, gentle eyes behind round wire-frame glasses.
Wearing a plain dark blue button-up shirt, no tie, slightly worn at the
collar, the look of an engineering student in Fujian who just arrived in
Paris. Sober, intelligent, kind expression with a hint of nervousness.
Setting: faded slightly sepia-toned photograph aesthetic, like an old
analog print, soft daylight from a window. The kind of face you'd believe
wrote 312 letters that never reached their destination.
```

Fichier final : `refs/scenes/wenbo_jeune_1999.jpeg` (utilisable dans une
scène de lettre / archive ; **pas** un portrait Insta).

---

## 5. Wenbo âgé — 42 ans, 2017 *(priorité 3)*

Le visage qui écrit la dernière lettre. Mort un an plus tard.

```
Portrait of Wenbo at 42, in 2017, Chinese man. Same gentle face as the
younger version but worn — five years of prison, fifteen years of waiting,
a missed daughter. Short greying-at-the-temples black hair, deeper lines
around the eyes, the same wire-frame glasses now scratched. Wearing a
plain grey work shirt. Holding a folded letter in one hand, looking down
at it, not at the camera. Setting: dim light from a single bulb, simple
provincial Chinese kitchen background, evening. Aching restraint, no
self-pity.
```

Fichier final : `refs/scenes/wenbo_age_2017.jpeg`

---

## 6. Dr Aubin — néphrologue de J2 *(priorité basse)*

Apparaît une fois, J2 hôpital Tenon. Annonce les 18 000€. Pas de fiche
profil, juste un visage de scène pour humaniser le diagnostic.

```
Portrait of Dr Aubin, a 52-year-old French male nephrologist. Salt-and-
pepper hair, neatly trimmed beard, tortoiseshell eyeglasses, kind tired
eyes. Wearing a white medical coat over a navy shirt, stethoscope around
the neck, a fountain pen visible in the breast pocket. Setting: bright
clinical hospital office, slightly out of focus, north-facing daylight.
Expression: professional, slightly weighed-down — the doctor who pauses
before speaking, not the doctor who reads from a chart.
```

Fichier final : `refs/scenes/J02_dr_aubin.jpeg`

---

## Cohérence visuelle entre Shen et les autres

La photo retenue pour Shen montre une jeune femme en gare asiatique avec
une valise rouge, dans une lumière néon nuit (caractères 東 = Hong Kong
ou Shanghai). C'est l'**ambiance acte 2-3** (Hong Kong, semaine 6 et après)
plus que celle du J1-J3 (Belleville pluvieux, livreuse).

→ Pour les autres portraits, ne pas chercher à matcher cette lumière néon.
   Garder un style portrait studio neutre. Les ambiances de scène habilleront
   les lieux séparément.

→ Si tu veux **une seconde version de Shen** plus Belleville (J1 lookbook,
   pour la stories Insta du début du jeu), prompt :

```
Portrait of Shen, 24-year-old French-Chinese woman, mixed heritage.
Long straight black hair, pale skin, distinctive green eyes inherited from
her French mother. Wearing a simple white tee with a worn olive-green
canvas jacket, hair slightly damp from rain. Belleville street in soft
overcast morning light, brick wall background. Tired but alert, a small
guarded half-smile, the look of someone who didn't sleep well but won't
say so. Sober, dignified, real.
```
