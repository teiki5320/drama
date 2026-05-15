# Photos manquantes — prompts pour OpenArt

Ce document liste les photos qu'il manque pour compléter visuellement
À Contre-Jour (Épisode 1, J1-J14). Pour chaque image, tu trouveras :

- **Slot canon** : où elle ira (`assets/photos/ep1/jXX_xxx.webp`)
- **Référence visuelle** : photo existante du repo à fournir comme image de
  conditionnement (style consistency)
- **Prompt OpenArt** : à coller tel quel
- **Format** : 3:4 portrait (1024×1536) ou 1:1 carré (1024×1024)

## Conventions cadrage

- **Photos canon** (full screen Photos app) : 3:4 portrait
- **Posts Instagram** : 1:1 carré
- **Stories Insta** : 9:16 portrait (1080×1920)
- **Pj WhatsApp/iMessage** : 3:4 ou 1:1
- **Avatars** (rare, on a déjà tout) : 1:1 carré centré sur visage

## Conventions style global

Toujours inclure dans le prompt :
- `cinematic photography, natural lighting, paris setting, melancholic
  mood, muted color palette, film grain, slight haze`
- `--style raw --ar [ratio] --no text, watermark, signature`

Référence visuelle universelle : `assets/photos/ref_characters/` contient
les portraits des persos. À fournir comme **reference image** pour assurer
la cohérence visage / style entre images.

---

## Manquantes prioritaires (J1-J14)

### J1 — Vendredi 3 juin

#### `j01_07h00_reveil_belleville.webp`
- **Référence** : `ref_characters/IMG_4362.jpeg` (Shen visage)
- **Prompt** : *« Young Asian woman, 24, dark hair, just waking up in
  small Parisian studio, grey rainy morning light through window, white
  duvet rumpled, hand on forehead, melancholic, 3:4 portrait, cinematic
  photography, film grain »*

#### `j01_07h35_velo_pluie.webp`
- **Référence** : `ref_characters/IMG_4362.jpeg` + `_tampon/IMG_4622.webp`
  (rue Paris pluvieuse)
- **Prompt** : *« Young Asian woman in yellow delivery jacket riding
  bicycle through rainy Paris street, wet asphalt reflections, blurred
  car lights, hood up, focused look, 3:4 portrait, cinematic, motion
  blur background »*

#### `j01_08h15_avenue_montaigne.webp`
- **Référence** : aucune (lieu)
- **Prompt** : *« Avenue Montaigne Paris luxury fashion district, Dior
  and Chanel storefronts blurred in background, wet pavement, light
  drizzle, golden hour despite cloud cover, 3:4 portrait, cinematic,
  empty street »*

### J2 — Samedi 4 juin

#### `j02_06h45_dr_aubin_face.webp`
- **Référence** : aucune (médecin nouveau perso)
- **Prompt** : *« Asian male doctor, 55, white coat, kind tired face,
  glasses, sitting at desk in modern hospital office, soft morning light
  through blinds, plant in corner, papers stacked, 3:4 portrait,
  cinematic »*

#### `j02_07h12_devis_18000.webp`
- **Référence** : aucune
- **Prompt** : *« Hospital cost estimate document close-up, hand-typed
  letterhead "Hôpital Tenon - Néphrologie", red stamp "HORS AMM", "18 000
  €" highlighted in yellow marker, on dark wooden desk with steel
  stethoscope partially visible, 3:4 portrait, cinematic, paper
  texture »*

### J3 — Dimanche 5 juin

#### `j03_facade_bnp_belleville.webp`
- **Référence** : aucune (façade)
- **Prompt** : *« BNP Paribas bank facade in Belleville Paris, narrow
  street, green awning, rainy reflections, no people, melancholic
  cloudy day, 3:4 portrait, cinematic, ground level perspective »*

#### `j03_aide_sociale_voicemail.webp`
- **Référence** : aucune (objet)
- **Prompt** : *« iPhone 15 Pro screen showing voicemail interface, "Aide
  sociale" missed call, transcript visible "Six mois minimum pour
  instruire un dossier mademoiselle", neutral background dark wood,
  hand holding phone, 3:4 portrait, cinematic, depth of field »*

### J4-J6 — Préparation Heng

#### `j04_camille_hanami_close.webp`
- **Référence** : `avatars/camille.webp`
- **Prompt** : *« Curly-haired Caucasian woman early 20s in Paris coffee
  shop "Hanami", smirking, cup of espresso steam visible, law book open,
  warm wooden interior, golden afternoon light, 3:4 portrait, cinematic,
  intimate framing »*

#### `j06_22h31_tailleur_lit.webp`
- **Référence** : `_tampon/chat_shen_ascenseur_selfie.webp`
- **Prompt** : *« Black tailored women's suit jacket draped on white
  bedsheet, size 38 label visible, red wax thread tag "Atelier Madame
  Roux", soft bedside lamp casting warm glow, late evening, 3:4
  portrait, cinematic, intimate »*

### J7 — Tour Heng (Manquantes)

#### `j07_10h45_secretaire_marchand.webp`
- **Référence** : aucune
- **Prompt** : *« Asian female secretary 40s, sharp grey suit, behind
  glass desk reading "HENG INTERNATIONAL — Mlle Marchand", phone receiver
  in hand, modern luxury office reception, marble walls, large windows
  Paris view, 3:4 portrait, cinematic »*

#### `j07_11h00_tristan_visage_proche.webp`
- **Référence** : `avatars/tristan.webp`
- **Prompt** : *« Asian man 30, sharp tailored grey suit, standing close
  to camera, intense calm expression, slight smile not quite warm,
  background blurred Tour Eiffel through floor-to-ceiling window, 3:4
  portrait, cinematic, dramatic lighting from window »*

### J8 — Notaire

#### `j08_signature_stylo.webp`
- **Référence** : aucune
- **Prompt** : *« Close-up of feminine hand holding Mont Blanc fountain
  pen above legal contract page 14, large red wax seal next to signature
  line, dark wooden notary table, soft directional light, hand hesitates
  mid-air, 3:4 portrait, cinematic, paper texture »*

### J9 — Avenue Foch

#### `j09_18h00_avenue_foch_fenetre.webp`
- **Référence** : aucune
- **Prompt** : *« Haussmannian apartment Paris 16e, view from interior
  through tall French windows showing Avenue Foch tree-lined boulevard
  at dusk, wrought iron balcony, parquet floor, Asian young woman
  silhouette looking out, 3:4 portrait, cinematic, golden hour »*

### J11 — Maman fenêtre

#### `j11_19h_maman_assise.webp`
- **Référence** : `avatars/maman.webp`
- **Prompt** : *« Caucasian woman 55 with grey-blond hair, sitting at
  small kitchen table in modest Belleville apartment, hands wrapped
  around tea cup, gentle tired smile, soft evening lamp light, plants on
  windowsill, books visible, 3:4 portrait, cinematic, warm intimate »*

### J14 — Madame Heng dîner

#### `j14_19h_table_dressee.webp`
- **Référence** : `_tampon/openart-image_1778459867095...` (mains thé)
- **Prompt** : *« Formal Chinese-French dining table for 6 in luxury
  Paris apartment, perfectly arranged: porcelain plates, crystal
  glasses, gaiwan tea ceremony set, single white peony in center, no
  people, soft chandelier light, 3:4 portrait overhead angle,
  cinematic, restrained luxury »*

#### `j14_madame_heng_face.webp`
- **Référence** : `avatars/madame_heng.webp`
- **Prompt** : *« Asian woman 60s, sharp elegant face, jade earrings,
  cream silk blouse, sitting at dinner table holding tea cup with both
  hands at chest level, looking directly at camera with knowing
  expression, soft warm dining room light blurred behind, 3:4 portrait,
  cinematic »*

---

## Lieux génériques manquants (réutilisables)

#### `lieu_belleville_studio_int.webp`
*« Cramped Parisian studio apartment 18m², single bed, small desk with
laptop, books stacked floor to ceiling, plants on windowsill, warm
afternoon light, lived-in feel, no people, wide angle, 3:4 portrait,
cinematic »*

#### `lieu_metro_couronnes.webp`
*« Couronnes metro station Paris line 2, empty platform 6am, fluorescent
lights, wet floor, advertising posters faded, single figure in distance,
3:4 portrait, cinematic, harsh lighting »*

#### `lieu_avenue_foch_exterieur.webp`
*« Avenue Foch Paris from sidewalk, Haussmannian buildings, autumn
plane trees, golden afternoon light, no traffic, wide angle 3:4
portrait, cinematic »*

---

## Documents / objets

#### `doc_carte_visite_heng.webp`
*« Business card close-up "Tristan HENG — HENG INTERNATIONAL — 47e
étage — 8 Avenue Montaigne 75008 Paris", textured cream cardstock,
embossed gold "H" logo, slight tear on corner, dark wood surface,
shallow depth of field, 1:1 square, cinematic »*

#### `doc_contrat_14_pages_pile.webp`
*« Stack of 14-page legal contract on dark wooden notary desk, "CONTRAT
DE PARTENARIAT TRIPARTITE" cover page visible, fountain pen beside,
red wax seal, soft directional window light, 3:4 portrait, cinematic »*

#### `doc_passport_marchand.webp`
*« French passport open to identity page, "MARCHAND / SHEN" name
visible, age 24, blurred photo, on white linen background, top-down
flat lay, 1:1 square, cinematic, paper texture »*

---

## Workflow recommandé

1. Copier le prompt
2. Aller sur OpenArt (Flux Dev ou Flux Pro)
3. Uploader la **référence visuelle** indiquée comme « image to image » à
   force ~30-50 % (assez pour cohérence, pas trop pour laisser créer)
4. Générer 2-4 variations
5. Récupérer la meilleure, l'enregistrer avec le **slot canon** comme
   nom de fichier
6. Déposer dans `assets/_originaux/_tampon/` (PNG/JPEG)
7. Me dire « j'ai déposé X images », je redirige vers `assets/photos/ep1/`
   en WebP cap 1500px et je wire dans le code

## État actuel des slots déjà remplis

Voir `assets/photos/ep1/` — 35 fichiers WebP, dont :
- 22 scènes canon
- 7 posts Instagram
- 4 pièces jointes
- 2 photos Cloud (papa + Tante Mei billets)
