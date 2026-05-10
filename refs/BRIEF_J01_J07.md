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

**Tous les portraits ci-dessous sont nécessaires dès J1.** La stories row
Insta affiche chaque perso dont `appearsAtDay <= currentDay` (cf.
`lib/models/character.dart`) — Madame Heng, Tante Mei et Hélène ont
`appearsAtDay = null` donc s'affichent **dès le premier jour**, même si
elles n'apparaissent pas encore dans la narration. Sans portrait, le rond
de story tombe sur le fallback emoji.

| Fichier final | Perso | Direction artistique |
|---|---|---|
| `shen_y.jpg` | **Shen Marchand**, 24 ans | Franco-chinoise, cheveux noirs longs, **yeux verts** hérités de sa mère, peau claire. Lumière naturelle, fond Belleville flou. Tee-shirt simple, expression sérieuse mais un sourcil un peu haut. Pas glamour : véritable, fatiguée mais lumineuse. |
| `helene_marchand.jpg` | **Hélène Marchand**, 50 ans | Française, cheveux châtain mi-longs grisonnants, traits doux, légère fatigue. Pull crème, fond clair (pourrait être lit d'hôpital très flouté). Sourit à peine, les yeux disent qu'elle s'excuse. |
| `camille_rx.jpg` | **Camille Roux**, 24 ans | Française, énergique, sourire en coin, **croissant à la main**. Look étudiante en droit version cool — chemise + pull noué. Lumière café parisien, fond bokeh. |
| `t_heng.jpg` | **Tristan Heng**, 29 ans | Sino-français (mère française), 1m85, costume noir taillé, chemise blanche sans cravate, **yeux gris-vert clairs**. Visage glacial, mâchoire nette. Fond bureau de standing flou. Aucun sourire. |
| `heng_lihua.jpg` | **Madame Heng**, 58 ans | Chinoise, élégante, chignon impeccable, perles discrètes, blouse en soie crème, regard direct sans sourire. Fond appartement bourgeois flou (boiseries sombres). Posture droite, "matriarche". |
| `mei_fujian.jpg` | **Tante Mei**, 60 ans | Chinoise, cheveux gris tirés, peau marquée par le soleil, polaire ou pull en laine épaisse, sourire franc. Fond extérieur Fujian flou (verdure, mur en briques). Dignité simple, paysanne. |

### Optionnels mais conseillés

| Fichier final | Perso | Direction artistique |
|---|---|---|
| `vincent_h.jpg` | **Vincent Heng**, 31 ans | Sino-français, costume sur-mesure, sourire commercial trop parfait, montre signée bien visible. Cheveux gominés. Le contraste exact de Tristan : tout en surface. **Visible dès J14** dans la stories row, donc à anticiper. |

> Wenbo (le père) n'apparaît jamais — pas de portrait Insta. Il existe
> uniquement à travers les lettres et photos d'archive (à traiter dans
> `scenes/` plus tard, semaine 13+).

---

## 1bis. Personnages secondaires des scènes J1-J7

Pas dans `characters/` (pas de fiche profil Insta), mais utiles pour
illustrer une scène narrative.

| Fichier suggéré | Perso | Détails |
|---|---|---|
| `scenes/J02_dr_aubin.jpg` | **Dr Aubin**, néphrologue | Homme 50-55 ans, lunettes en écaille, blouse blanche, stylo posé, expression bienveillante mais lourde. Bureau d'hôpital, fenêtre nord. Photo en plan moyen depuis le siège du patient. |
| `scenes/J07_assistante_heng.jpg` | **Assistante de Tristan** | Femme 30 ans, tailleur sombre, casque téléphone, fond moquette épaisse + plante zen, regard professionnel un peu condescendant. (Optionnel — peut être suggérée par un détail seulement.) |

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

- **6 portraits Insta** (Shen, Hélène, Camille, Tristan, Madame Heng,
  Tante Mei) — tous indispensables dès J1 pour la stories row.
- **1 portrait optionnel** : Vincent (devient nécessaire à J14).
- **2 portraits scène** (Dr Aubin J2, assistante Heng J7).
- **5 lieux** (studio, avenue Montaigne, Tenon, café Hanami, Tour Heng).
- **5 scènes spécifiques** (carte déchirée J1, pivoines J2, calculs J3,
  carte recollée + plan remboursement J5, tailleur miroir J6, dossier
  prêt J7).

Soit **17 photos minimum** (6 portraits + 5 lieux + 5 scènes + Dr Aubin),
**20 si on inclut Vincent + assistante + une réserve**.

Suggestion d'ordre de priorité si tu veux échelonner :

1. **Lot 1 — débloquer Insta dès J1** : les 6 portraits Insta. Sans ça la
   stories row affiche un emoji à la place de la photo.
2. **Lot 2 — habillage des 3 jours iconiques** : `J01_studio_matin`,
   `J02_tenon_chambre` (avec pivoines), `J07_tour_heng_47e`.
3. **Lot 3 — détails narratifs** : carte déchirée J1, calculs J3, carte
   recollée J5, tailleur J6, dossier J7, Dr Aubin J2.
4. **Lot 4 — anticipation** : Vincent (pour J14+), café Hanami J4,
   avenue Montaigne J1, assistante Heng J7.
