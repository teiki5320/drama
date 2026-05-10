# Brief photo — semaine 1 (J1 → J7)

Liste des photos nécessaires pour habiller la première semaine du drama.
3 couches : **portraits casting**, **lieux récurrents**, **scènes
narratives**. Les portraits peuvent servir bien au-delà de J7, les lieux
aussi (le studio reviendra tout au long de l'acte 1). Les scènes, elles,
sont datées.

Format final attendu (livré dans `assets/photos/`) :

- Portraits → carré 1024×1024, ratio 1:1
- Lieux + scènes → 16:10 environ, 1600×1000

---

## 1. Portraits casting (`assets/photos/characters/`)

Personnages présents en J1-J7. Les fiches profils Insta s'affichent dès
qu'un perso a son photoAsset en place.

| Fichier final | Perso | Direction artistique |
|---|---|---|
| `shen_y.jpg` | **Shen Marchand**, 24 ans | Franco-chinoise, cheveux noirs longs, **yeux verts** hérités de sa mère, peau claire. Lumière naturelle, fond Belleville flou. Tee-shirt simple, expression sérieuse mais un sourcil un peu haut. Pas glamour : véritable, fatiguée mais lumineuse. |
| `helene_marchand.jpg` | **Hélène Marchand**, 50 ans | Française, cheveux châtain mi-longs grisonnants, traits doux, légère fatigue. Pull crème, fond clair (pourrait être lit d'hôpital très flouté). Sourit à peine, les yeux disent qu'elle s'excuse. |
| `camille_rx.jpg` | **Camille Roux**, 24 ans | Française, énergique, sourire en coin, **croissant à la main**. Look étudiante en droit version cool — chemise + pull noué. Lumière café parisien, fond bokeh. |
| `t_heng.jpg` | **Tristan Heng**, 29 ans | Sino-français (mère française), 1m85, costume noir taillé, chemise blanche sans cravate, **yeux gris-vert clairs**. Visage glacial, mâchoire nette. Fond bureau de standing flou. Aucun sourire. |

> Madame Heng, Vincent, Tante Mei, Hélène posée n'apparaissent pas avant
> la semaine 2-3. Tu peux générer leurs portraits plus tard.

---

## 2. Lieux récurrents (`assets/photos/locations/` ou directement scenes)

Ces lieux reviennent souvent — utiles comme image hero d'établissement de
journée. À utiliser dans `scenes/` avec une clé qui désigne le lieu.

| Fichier suggéré | Lieu | Détails |
|---|---|---|
| `scenes/J01_studio_matin.jpg` | **Studio Belleville**, 14 m², 7h42 | Petit studio sous-toit, papier peint usé, plante verte, kitchenette, **carnet vert** ouvert sur table avec stylo bic. Lumière du matin pluvieuse à travers la fenêtre. |
| `scenes/J01_avenue_montaigne.jpg` | **Avenue Montaigne 8h** | Vue depuis le sol — vélo de livraison couché, sac jaune éventré, **bowl renversé + smoothie sur le bitume**. Au-dessus, un pan de costume noir + chaussures cuir. Pluie fine. |
| `scenes/J02_tenon_hall.jpg` | **Hôpital Tenon**, 6h30 | Hall ou couloir, lumière nord froide, banc en bois, machine à café au fond. Vide. Beige institutionnel. |
| `scenes/J04_cafe_hanami.jpg` | **Café Hanami**, près du campus, 14h | Petit café franco-japonais, **deux croissants** + deux tasses sur table en bois, classeur de droit ouvert à côté. Bokeh chaud, pluie dehors. |
| `scenes/J07_tour_heng_47e.jpg` | **Tour Heng, 47e étage**, 10h47 | Bureau d'angle, baie vitrée du sol au plafond, vue sur Paris (Trocadéro idéal), bureau noir laqué, dossier kraft posé. Moquette épaisse. Silence. **Tristan à contre-jour** dos à la fenêtre (silhouette). |

---

## 3. Scènes narratives (insertions dans le carnet)

Pour chaque scène, j'ajouterai un `NarrativeBlock` de type `image` dans
`scenario.json` avec la légende italique.

### J1 — La collision

- `scenes/J01_studio_matin.jpg` *(cf. lieux)* — légende :
  *« 07:42. Carnet vert. La pluie sur la fenêtre. »*
- `scenes/J01_avenue_montaigne.jpg` *(cf. lieux)* — légende :
  *« 08:17. Le bowl coûte 38€ que je vais devoir rembourser. »*
- `scenes/J01_carte_dechiree.jpg` — gros plan sur la carte de visite
  Tristan Heng déchirée en 4 morceaux dans une flaque. Légende :
  *« Première erreur. »*

### J2 — Le diagnostic

- `scenes/J02_tenon_chambre.jpg` — chambre d'hôpital, Hélène allongée de
  dos (pas son visage, pour pas spoiler le portrait), une chaise vide à
  côté, **bouquet de pivoines** sur la table de chevet. Légende :
  *« Pivoines de chez le syrien — elle ne sait pas pour le diagnostic. »*

### J3 — Calculs

- `scenes/J03_calculs.jpg` — gros plan vue plongeante sur un cahier de
  brouillon avec des chiffres barrés, calculatrice, café froid. Lumière
  d'après-midi blafard. Légende : *« Trois fois la même réponse. »*

### J4 — Camille décide pour moi

- `scenes/J04_cafe_hanami.jpg` *(cf. lieux)* — légende :
  *« Camille pose son croissant. Mauvais signe. »*

### J5 — La carte recollée

- `scenes/J05_carte_recollee.jpg` — la carte de visite Tristan recollée au
  scotch transparent, posée sous une assiette pour rester plate, MacBook
  Air ouvert à côté avec un tableau Excel/Numbers de plan de
  remboursement. Légende :
  *« Je serai sa débitrice. Pas sa charité. »*

### J6 — Le tailleur

- `scenes/J06_tailleur_armure.jpg` — un tailleur noir sur cintre devant
  un miroir, dans le miroir on aperçoit Shen partiellement (épaule, bras),
  pas le visage. Légende : *« Pas plus belle. Plus coupée. »*

### J7 — Tour Heng

- `scenes/J07_tour_heng_47e.jpg` *(cf. lieux)* — légende :
  *« 47e étage. La moquette absorbe les pas. »*
- `scenes/J07_dossier_pret.jpg` — gros plan sur un dossier kraft posé sur
  un bureau noir laqué, étiquette tapée à la machine "Marchand — prêt
  personnel". Une main d'homme manchette + montre signée à côté.
  Légende : *« Avant. Que. J'arrive. »*

---

## Total semaine 1

- **4 portraits** (Shen, Hélène, Camille, Tristan)
- **5 lieux** (studio, avenue Montaigne, Tenon, café Hanami, Tour Heng)
- **5 scènes spécifiques** (carte déchirée, Tenon chambre + pivoines,
  calculs, carte recollée, tailleur, dossier prêt)

Soit **14 photos** au total pour rendre J1-J7 visuellement habillé.

Suggestion d'ordre de priorité si tu veux échelonner :
1. Les 4 portraits (débloque les fiches profils Insta + avatars Messages).
2. Les 3 lieux les plus impactants : `J01_studio_matin`,
   `J02_tenon_chambre`, `J07_tour_heng_47e`.
3. Le reste (collision, café, calculs, tailleur, dossier) — habillage.
