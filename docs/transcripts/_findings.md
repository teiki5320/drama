# Incohérences relevées — relecture systématique des transcripts

Analyse de tous les fils (5 relecteurs) croisée avec le canon et le moteur.
Statut moteur vérifié : romances et arcs **sautent** les beats dont la
branche ne correspond pas ; les romances clôturent en `fade_silencieux`
(fallback assumé, cf. `romance_threads_provider.dart:326`). → Les « branches
mortes » ne bloquent PAS le jeu : elles s'éteignent en silence, par design.

Légende : **BUG** = défaut factuel/logique réparable · **PROSE** = touche
une réplique écrite (décision auteur) · **CONVENTION** = mécanique sûre ·
**DESIGN** = géré par le moteur, non bloquant.

---

## A. Bugs mécaniques / factuels — réparables sans toucher la voix

| # | Lieu | Problème | Correctif |
|---|---|---|---|
| A1 | Maman J13 | 18:42 (« parfum différent ») listé avant 17:48 (« fleurs ce matin ») — désordre horaire | réordonner / corriger l'heure |
| A2 | Camille J26 | « ton dernier message date d'il y a **8 jours** » alors que le dernier date de J13 (**13 j**) | corriger le compte |
| A3 | Vincent J39 21:12 | « Un verre **en bas** ? » alors que Shen est à Hong Kong (J32→J40) et Vincent « a géré à distance » (J38) | « Un appel ? » |
| A4 | Tante Mei J35 10:52 | mandarin « 你是他的女儿吗 ? » **sans traduction** (canon : toujours traduit) | ajouter « (Es-tu sa fille ?) » |
| A5 | Tante Mei J78 19:32 | « 家里等你们。 » sans traduction | ajouter « (La maison vous attend.) » |
| A6 | Tristan J11 19:32 | « Mes parents passent **dimanche** » vs dîner officiel fixé **jeudi J14** (Madame Heng J12, Tristan J13) | « jeudi » |
| A7 | arc dr_aubin | après la branche **Reporter** (RDV → lundi), les beats non conditionnés « rappel demain » / « suite à votre passage ce matin » se jouent quand même | conditionner ce spine sur `≠ shen_reporte_a` |
| A8 | arc voisine J+5 | variante « pourquoi votre maman ne sait pas que vous habitez **rue de Berri** ? » — la voisine n'a jamais reçu l'adresse | retirer l'adresse |
| A9 | arc voisine | branche **Sèche** n'exclut pas l'intrigue fuite d'eau (J+3+) : le joueur qui sèche traverse quand même l'urgence | conditionner la fuite sur `≠ shen_seche_v` |
| A10 | arc sarah J+0 | réponse **OK** figée « OK pour **5400** » alors que 2 variantes sur 3 de la contre-offre disent 5500 / 4800 | neutraliser le chiffre du OK |
| A11 | arc karim | FIN `shen_confie_k` (J+5) listée avant `shen_ecoute_k` (J+4) — ordre des J+ | réordonner |
| A12 | arc stephane | ouverture « secteur **8e** » puis conseil « restez sur le **7e** » | harmoniser sur 8e |

## B. Bugs de continuité qui demandent une retouche de réplique (ton ton feu vert)

| # | Lieu | Problème | Piste |
|---|---|---|---|
| B1 | Camille J1 22:18 | « mes économies vont jamais aller jusqu'à **J45** » — spoile la deadline (révélée J2) + « J45 » est du méta-jeu dans un SMS | reformuler sans la deadline chiffrée |
| B2 | Maman J1 08:18 (Inquiète) | « Tu as bien pris tes **gélules de 16h** ? » — évoque une routine médicale avant la révélation J2 | détail non médical |
| B3 | Camille J4 (`camille_carte_j4`) | beat « Tu as gardé sa carte » + branche **Nier** « je l'ai déchirée » contredit J3 (carte recollée, Camille le sait déjà) | supprimer le beat J4 ou la branche Nier |
| B4 | Maman J11 | « premier jour de stage » (12:14) + « tu écris "bien" **depuis trois jours** » (même journée) | retirer « premier jour » ou l'antériorité |
| B5 | Madame Heng J19 | « **mon neveu** m'a dit que vous lisiez Duras » — aucun neveu au canon (ses proches = ses fils Tristan/Vincent) | « mon fils » |

## C. Décisions d'auteur — voix / intention (je ne touche pas sans toi)

- **Madame Heng J46 17:30** — tutoiement soudain (« Tu as les yeux de ta mère… ») chez un personnage qui vouvoie partout. Rupture volontaire (intimité) ou à rétablir ?
- **Maman J1 08:15** — « depuis trois jours » suppose un avant-J1 (écho du J11). Backstory assumée ?
- **Maman J13 17:48** — « fleurs chaque matin depuis quatre mois » vs départ du domicile J9.
- **Bio Tinder « architecte »** (transverse romances) — cover cohérente avec le contrat Heng, probablement volontaire.
- **Camille J4 14:02 / canon J3** — la poussée « rappelle-le » est au J4 ici, au J3 dans le canon. Décalage voulu ?

## D. Mineurs / conventions (mécaniques, sûrs)

- arc faux_sav J+1 : « 287.**50** € » → « 287**,**50 € »
- arc dr_aubin J+4 : « **Mme** Lemaitre » → « **Madame** Lemaître »
- arc voisine (contact) : « **Mme** Dubreuil » → « **Madame** Dubreuil »
- romance manipulatrice_soft : « 1200 € » → « 1 200 € »
- arc mathieu / sarah / romances : choix qui **promettent** une suite (« la semaine suivante ? », « laisse-moi 24h ») puis fade au silence — pas un bug (moteur), mais léger manque narratif à combler si on veut.

## E. Écartés après vérification moteur (NON-bugs)

- Les ~20 « branches mortes » des 27 romances + les culs-de-sac d'arcs
  (karim, mathieu, notaire, nadia, sarah 1er choix…) : le moteur saute les
  beats non atteints et clôt (romances) ou se met en sommeil (arcs). Un
  match qu'on éconduit s'éteint — **comportement voulu**.
- Ids de FIN dupliqués (nadia `nadia_alliee_silence`, notaire
  `notaire_pro_distant`) : branches mutuellement exclusives, aucune
  collision runtime. Cosmétique.
- `predator` / `escort_reveal` : chaque chemin laisse Shen bloquer/partir.
  Pas d'impasse toxique.

---

### Décompte
- **A (réparable sûr)** : 12 · **B (retouche réplique)** : 5 · **C (auteur)** : 5 · **D (conventions)** : ~5 · **E (écartés)** : ~25

---

## Résolution (« traite tout »)

**Corrigés (retouches de réplique / gating) :**
- B1 Camille J1 22:18 : « …jusqu'à J45 » → « …jusqu'au bout du mois » (spoiler + méta retirés).
- B2 Maman J1 (Inquiète) : « gélules de 16h » → « mangé quelque chose de chaud » (plus de pré-spoiler médical).
- B4 Maman J11 21:08 : « Premier jour de stage. » → « Alors, ce stage ? » (lève la redite / la tension avec « depuis trois jours »).
- B5 Madame Heng J19 : « Mon neveu » → « Mon fils » (aucun neveu au canon ; elle dit déjà « mon fils » ailleurs).
- A7 dr_aubin : `forbidBranch: 'shen_reporte_a'` sur « rappel demain » + « suite à votre passage » (incohérents si RDV reporté).
- A9 voisine : `forbidBranch: 'shen_seche_v'` sur l'intro fuite + son choix (le joueur « Sèche » reste sur le colis).
- A12 stephane : conseil « 7e » → « 8e » (secteur canon de Shen).

**Gardés + tranchés (NON-bugs après analyse) :**
- B3 Camille J4 « Nier » : option de MENSONGE valide (trust −8, Shen ment sciemment). Conservée.
- Madame Heng J46 tutoiement : rupture d'intimité volontaire (citation d'un moment tendre). Conservé.
- « SHEN MIAO » (badge refusé) : Tristan ne l'a pas déclarée. Conservé.
- « Mme » (clients/incidents, ~12 noms) : français correct, distinct de « Madame Heng » (voix canon). Conservé.
- Vincent J39 « verre en bas » : scène « poison au bar de l'hôtel » en présentiel voulue (Vincent à HK pour affaires). Conservé.
- Camille aperçu nuit à 7h30 : nécessiterait un beat de pacing J1 (authoring pur) — laissé tel quel, le moteur ne gate pas à l'horloge par design.
