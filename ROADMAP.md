# À CONTRE-JOUR (逆光) — ROADMAP COMPLÈTE

> Drama romantique mobile **Flutter** (Android + iOS, ex-SwiftUI). 112 jours, 16 semaines, 5 fins.
> Document de référence unique pour Claude Code. À placer à la racine du repo.
>
> **Note pivot stack** : la spec d'origine ciblait SwiftUI / Swift 6. Le projet est désormais
> implémenté en Flutter / Dart avec Riverpod. Toute la narration, les mécaniques, les ressources,
> les triggers, les 5 fins et les 3 catalogues JSON restent **strictement identiques**. Seules les
> sections techniques 6.1, 6.3, 6.4 et le bloc Swift de 4.7 ont été portés. La structure des
> données JSON (`scenario.json`, `shop_catalog.json`, `investments.json`, `insta_seed.json`) est
> inchangée et lue à l'identique côté Dart.

---

## ÉTAT D'AVANCEMENT — handoff pour la prochaine session

**Dernière session : mai 2026.** Si tu es une nouvelle conversation Claude qui reprend ce repo, lis cette section avant tout.

### Identité de l'app (App Store Connect)
- **Nom App Store** : `Drama` (pas "À Contre-Jour" — ça reste le titre narratif dans le code/docs et c'est le `description` du pubspec)
- **Bundle ID** : `com.teiki5320.drama`
- **Dart package name** (pubspec) : `contre_jour` (NE PAS RENOMMER, `package:contre_jour/...` est utilisé partout)
- **Cible** : iOS via TestFlight (Android prévu mais non testé)
- **Versions sémantiques** vivent dans `pubspec.yaml` ; `MARKETING_VERSION` et `CURRENT_PROJECT_VERSION` du Xcode project sont liés à `$(FLUTTER_BUILD_NAME)` / `$(FLUTTER_BUILD_NUMBER)` — donc `pubspec.yaml: version: X.Y.Z+N` est la source de vérité

### Pipeline build / livraison
- **Xcode Cloud** est configuré pour build sur push à `main` uniquement (workflow "iOS Build & TestFlight")
- `ios/ci_scripts/ci_post_clone.sh` : install Flutter SDK stable, `flutter pub get`, **`dart run flutter_launcher_icons`** (régénère l'icône depuis `assets/icon/icon.png`), `pod install`
- À chaque merge sur main, Xcode Cloud déclenche un build → upload auto vers TestFlight (Internal Testing group "Dev")
- **App Privacy** : "We do not collect data" (déjà rempli)
- Conformité chiffrement : `ITSAppUsesNonExemptEncryption = false` dans `Info.plist`, plus de prompt par build

### Push : règles à connaître impérativement
- **Le sandbox Claude ne peut PAS pousser direct sur `main`** (proxy local renvoie 403). Workflow obligatoire :
    1. `git checkout -b claude/<topic>` puis push de la branche (ça marche)
    2. `mcp__github__create_pull_request` (base=main, head=claude/topic)
    3. `mcp__github__merge_pull_request` (squash merge)
- **Pour les fichiers texte uniquement**, on peut court-circuiter avec `mcp__github__create_or_update_file` qui écrit direct sur main via l'API GitHub. Utilisé pour les bumps de pubspec.
- **Pour les fichiers binaires** (PNG icônes, etc.) : passer obligatoirement par git+branche+PR, l'API contents accepte mal le binaire dans les outils MCP exposés.
- **L'utilisateur** lui pousse direct sur main depuis Working Copy (iPad) ou son Mac sans souci, c'est uniquement le sandbox qui est bridé.

### État du contenu narratif (au $(date 'mai 2026'))
- **Scénario encodé** : J1 → J14 dans `assets/data/scenario.json` (14/112 jours)
- **Catalogues complets** : `shop_catalog.json` (27 items), `investments.json` (5 actions), `insta_seed.json` (8 posts)
- **Scènes canoniques rédigées dans le ROADMAP** mais pas encore atteintes en gameplay : J23 (dispute des fraises), J46 (phrase Madame Heng), J69 (Hélène lit la lettre), J102 (312ème lettre), J109 (le parc)
- **Branches narratives à coder** :
    - Burn-out (mood ≤ 2 sur 3 jours) — pas implémenté
    - Deuil (deadline maman J45 ratée) — pas implémenté ; pour la v1, rediriger vers épilogue 10.3 directement
    - Cadeaux spontanés aux paliers mood 6/7/8/9 — pas implémenté
- **Trading bourse** : tickers déclarés mais pas de UI achat/vente, pas de tick journalier, pas des triggers J35/J52/J76/J88 — à coder

### État de l'UI (refonte mai 2026)
- **Sidebar verticale gauche** (84 dp) au lieu d'un bottom tab bar : stats compactes en haut (J+, € kilo-formaté, 😊, ⭐), 4 nav (CARNET / BANQUE / INSTA / INVIT.), engrenage en bas pour reset partie
- `lib/providers/ui_provider.dart` : `selectedTabProvider` (StateProvider Riverpod) pilote l'onglet actif
- `lib/core/big_title.dart` : titre serif Crimson Pro qui remplace les AppBar Material partout
- Pills custom pour sous-onglets Banque (Compte / Investissement / Achats), souligné orange, démarrage par défaut sur **Achats**
- Cartes Achats avec carte "RÉCOMPENSES" pastel en tête, pills catégories avec emoji, grid responsive
- Posts Insta dans des conteneurs blancs avec image en dégradé pastel teinté par auteur (Camille = pêche, Tristan = bleu acier, etc.)
- Tuiles Messages avec rond avatar teinté par perso

### Modèle de données — extension récente
- **`ChoiceOption.setsFlags: List<String>?`** (champ optionnel). Permet à un choix narratif de poser un flag du `GameState`. Utilisé actuellement pour `isMomTreatmentPaid` (J8 option A : -18 000 € + flag posé). À étendre pour de futurs flags (`hasReadFatherDossier`, etc.) si besoin.
- `EconomyEngine.applyChoice` honore `setsFlags`, et le test `test/engine/economy_engine_test.dart` couvre la branche.

### Suite logique de travail
1. Encoder **J15 → J21** (semaine 3 — premières fissures, Tristan suit Shen à l'hôpital, Camille dit ses 4 vérités à Tristan).
2. Implémenter le système d'investissement (UI achat/vente + tick journalier ±2% + triggers narratifs J35/J52/J76/J88).
3. Encoder **J22 → J42** (Acte 2 complet, scène canonique J23 fraises).
4. Branches alternatives (burn-out + deuil) avec jours alternatifs.
5. Continuer le scénario par lots de 7-14 jours.

---

## TABLE DES MATIÈRES

1. **PITCH & CONCEPT**
2. **BIBLE NARRATIVE** — Personnages, univers, secret du père
3. **STRUCTURE EN 16 SEMAINES** — Beats narratifs détaillés
4. **MÉCANIQUES DE JEU** — Ressources, déblocages, fins
5. **SCÈNES NON-NÉGOCIABLES** — Dialogues canoniques
6. **SPÉCIFICATIONS TECHNIQUES** — Stack, structure, modèles
7. **INTERFACE** — Les 4 onglets en détail
8. **CATALOGUES JSON** — Achats, investissements, Insta
9. **SCÉNARIO COMPLET J1 → J112** — Tous les jours rédigés
10. **5 ÉPILOGUES** — Écrits en intégralité

---

# 1. PITCH & CONCEPT

**À Contre-Jour** est un jeu narratif mobile où le joueur incarne **Shen Marchand**, jeune femme franco-chinoise de 24 ans, sur les 16 semaines de l'été 2025.

L'histoire se déroule sous forme de **carnet intime à la première personne**, ponctué de **SMS retranscrits façon screenshots iPhone**. Chaque jour, le joueur lit une entrée du carnet et fait **un choix entre 3 options**, qui modifie trois ressources : argent, mood, réputation.

Le drama suit Shen depuis une collision matinale avec l'héritier glacial Tristan Heng, jusqu'à la révélation du secret de son père chinois — un homme qu'elle n'a jamais rencontré, qu'on a longtemps pris pour un déserteur, et qui en réalité n'a jamais pu venir.

Le jeu fait coexister une **boucle narrative** (le drama) et une **boucle de simulation** (banque, investissements, achats, followers Instagram). Les achats et voyages se transforment en posts Instagram ; la réputation génère des followers ; les followers génèrent des revenus passifs.

5 fins possibles selon les ressources finales.

---

# 2. BIBLE NARRATIVE

## 2.1 — UNIVERS

L'histoire se passe à **Paris** (parfois nommé NeoCity dans l'interface) en 2025, et au **Fujian** (Chine) pour le dernier acte. Pas de SF, pas de fantasy. Drama réaliste contemporain.

L'univers économique inclut un fictif "groupe Heng International" (hôtellerie + cabinet notarial à Shanghai) et son rival "Lu Group" (immobilier + tech).

## 2.2 — PERSONNAGES PRINCIPAUX

### Shen Marchand (héroïne, 24 ans)

Jeune femme franco-chinoise. Cheveux noirs longs, yeux verts hérités de sa mère. Vit à Belleville dans un studio de 14m² avec sa mère malade. Travaille comme livreuse à vélo le jour et serveuse de nuit pour payer le loyer et les soins. A abandonné ses études d'architecture en deuxième année quand sa mère est tombée malade.

Parle un mandarin courant appris seule (YouTube + restaurants du 13ème), jamais transmis par personne. Tient depuis ses 14 ans un carnet où elle écrit des lettres à un père qu'elle n'a jamais rencontré — 311 lettres jamais postées au début du jeu.

**Caractère** : fière, lumineuse, mauvaise menteuse, allergique à la pitié, drôle quand elle a confiance, perfectionniste cachée. Refuse d'être un "pourboire" et refuse la charité — son moteur principal est la dignité.

### Hélène Marchand (mère de Shen, 50 ans)

Fille d'un notaire de province. À 24 ans en 1999, accepte un mariage par correspondance avec un homme chinois qu'elle n'a jamais vu — fuite d'un milieu étouffant, lectures de Marguerite Duras, romantisme naïf. Ancienne étudiante en lettres, lectrice de Duras et Annie Ernaux. Travaille à la blanchisserie depuis 15 ans. Aujourd'hui gravement malade des reins (besoin d'un protocole hors AMM, 18 000€ sur six mois).

Douce, distante, traditionnelle malgré sa singularité, ne se plaint jamais. Cache à sa fille la gravité de sa maladie. A recommencé secrètement à écrire à une adresse au Fujian dont elle n'est plus sûre qu'elle existe encore.

### Shen Wenbo (père biologique, fantôme du drama)

Ingénieur originaire du Fujian. A épousé Hélène par correspondance en 1999. Personnage absent pendant tout le drama, mais omniprésent à travers les lettres, les archives et la mémoire d'Hélène.

**Timeline complète de Wenbo** :

- **1998** : entame une correspondance avec Hélène via une agence parisienne de mariages internationaux
- **Été 1999** : vient à Paris deux semaines pour les papiers, rencontre Hélène une seule fois (deux semaines)
- **Septembre 1999** : mariage par procuration au Fujian. Hélène prend l'avion. Wenbo est arrêté à Shanghai DEUX JOURS avant l'arrivée d'Hélène, suite à une dénonciation politique liée à son frère aîné dissident. **Cinq ans de prison.**
- **2004** : sortie de prison. Tente d'écrire à Hélène. **Toutes ses lettres sont interceptées par sa propre famille**, qui considère l'épouse française comme un déshonneur familial.
- **2007** : apprend par une rumeur qu'il a une fille en France
- **2017** : écrit une dernière lettre à *"ma fille que je n'ai pas connue"*. Ne l'envoie jamais.
- **2018** : meurt dans un accident de chantier à Fuzhou, sans avoir revu Hélène ni rencontré Shen.

Sa correspondance complète (lettres reçues d'Hélène + ses propres lettres jamais envoyées) est conservée dans une boîte en bois, chez sa cousine éloignée Mei au village natal au Fujian.

### Tristan Heng (Heng Zixuan, 29 ans)

Héritier du groupe Heng International. Mère française morte quand il avait 12 ans. Élevé en Chine puis en pension en Suisse. Dirige les opérations européennes du groupe depuis Paris.

**Détail crucial** : le groupe Heng possède aussi, depuis trois générations, **un cabinet de notaires à Shanghai spécialisé dans les mariages internationaux des années 80-90**. C'est dans ces archives que dort le dossier du mariage Marchand-Shen.

**Caractère** : glacial en apparence, méthodique, sec. En vérité : profondément seul, allergique aux émotions par discipline, incapable de mentir longtemps quand quelqu'un voit clair en lui. Allergique aux fraises. Allergique au désordre.

A eu UN seul arrangement contractuel similaire deux ans plus tôt qui s'est mal terminé. Ce détail est référencé mais pas développé en backstory.

### Camille Roux (24 ans)

Meilleure amie de Shen depuis le lycée. Étudiante en droit, future avocate. Colocataire occasionnelle. Machine à vannes, radar à mensonges, fan absolue de Shen. Toujours un croissant à la main. Dit des phrases trop sages avec la bouche pleine.

**Rôle structurel** : c'est ELLE qui pousse Shen à appeler Tristan pour le prêt. C'est elle qui démasquera plus tard la manipulation de Vincent en recoupant des informations.

### Madame Heng (Heng Lihua, 58 ans)

Tante de Tristan, matriarche du clan parisien. Élégante, redoutable. **Pivot caché du drama** : elle reconnaît dès le premier dîner quelque chose dans le visage de Shen sans pouvoir mettre le doigt dessus. Elle est la **gardienne réelle des archives notariales** Heng à Shanghai.

Sa phrase canonique au J46, en mandarin : *"Tu as les yeux de ta mère, mais tu as la bouche de quelqu'un d'autre. Quelqu'un que j'ai connu."*

Plus tard, elle deviendra l'alliée inattendue qui démasque Vincent et qui aide Tristan à organiser le rapatriement des cendres de Wenbo et le voyage au Fujian.

### Vincent Heng (31 ans)

Demi-frère aîné de Tristan. Charmeur, manipulateur, rival d'affaires. Avait approché Shen six mois avant le début du jeu sous une fausse identité, pour lui proposer un job de modèle qu'elle avait refusé. Réapparaît à Hong Kong (semaine 6) et orchestre la rupture entre Shen et Tristan. **Vrai antagoniste du drama.**

### Tante Mei (60 ans)

Cousine éloignée de Wenbo, vit toujours dans le village natal du père au Fujian. Détient la boîte en bois avec toute la correspondance. Femme simple, directe, généreuse. Accueille Shen et Hélène au dernier acte. Parle un peu français appris dans les années 80.

## 2.3 — LE SECRET DU PÈRE (synthèse)

C'est le **vrai cœur émotionnel du drama**, caché derrière l'arc romantique apparent.

Hélène a toujours dit à Shen : *"Ton père n'a pas pu venir. Un jour je te raconterai."* Ce jour n'est jamais arrivé. Shen a grandi en se persuadant qu'il l'avait abandonnée.

La vérité, révélée progressivement par Tristan via les archives Heng (entre J53 et J62) :

1. Wenbo n'a pas abandonné Hélène
2. Il a été emprisonné en septembre 1999, deux jours avant son arrivée
3. À sa sortie en 2004, sa propre famille a intercepté toutes ses lettres
4. Il a appris par rumeur l'existence de Shen en 2007
5. Il a écrit une dernière lettre en 2017, jamais envoyée
6. Il est mort en 2018 sans jamais avoir rencontré sa fille

Cette vérité est **le pivot du drama**. Elle change la signification de toute l'enfance de Shen, et de toute la vie d'Hélène. C'est ce qui rendra possible le voyage au Fujian (Acte 5) et le pardon final.

---

# 3. STRUCTURE EN 16 SEMAINES

## ACTE 1 — LA COLLISION (semaines 1-3, jours 1-21)

**Thème** : la dignité face à la précarité. Shen refuse l'argent facile, puis cède pour sa mère.

### Semaine 1 (J1-J7) — La rencontre forcée

Shen, en livraison du matin, est percutée par la berline de Tristan Heng. Elle refuse les 200€ qu'il lui tend, déchire sa carte. Le lendemain, l'hôpital lui annonce que sa mère a besoin de 18 000€ pour un protocole hors AMM. Camille la pousse à appeler Tristan. Shen recolle la carte au scotch sur sa table de cuisine. Elle se présente à la Tour Heng dans un tailleur emprunté, demande un prêt à rembourser. Tristan propose autre chose : 30 000€ pour devenir sa fausse fiancée pendant trois mois. Shen accepte avec clauses ajoutées au stylo (pas de baisers, pas de mensonges sur sa mère, droit aux fraises).

### Semaine 2 (J8-J14) — Le contrat et l'emménagement

Signature du contrat de 14 pages. Emménagement dans l'appartement de Tristan dans le 8ème. Choc des mondes : elle range mal, chante en cuisinant, il déteste. Il dort dans son bureau. Premier mensonge à Hélène (Shen prétend faire un stage chez un paysagiste à Vincennes). Madame Heng convoque le premier dîner familial. Shen tient tête sur la qualité du thé Long Jing. La matriarche la regarde longuement, sans rien dire.

### Semaine 3 (J15-J21) — Premières fissures

Tristan suit Shen un soir et la voit pleurer dans un couloir d'hôpital où Hélène est traitée. Le meilleur néphrologue de Paris contacte Hélène "par hasard" le lendemain. Confrontation. Tristan prétend que c'était un investissement pour protéger leur arrangement. Shen ne le croit pas, mais cette nuit-là elle pose une couverture sur lui endormi dans son fauteuil. Camille rencontre Tristan "par accident" et lui dit ses quatre vérités sur Shen.

## ACTE 2 — LA VIE COMMUNE (semaines 4-6, jours 22-42)

**Thème** : le glaçon fond. La fausse fiancée devient un vrai trouble. Préparation Hong Kong.

### Semaine 4 (J22-J28) — Le glaçon fond

Shen découvre que Tristan a fait nettoyer son ancien vélo. Au matin, dispute autour des fraises : il avoue par lapsus qu'il a "signé sous la contrainte affective". Elle s'arrête. Il sort de la pièce. SMS panique avec Camille. Silence et tensions pendant trois jours. Madame Heng convoque Shen seule pour un thé — test de la matriarche, qui ne révèle rien mais observe tout. Le dimanche, Tristan apporte des fraises à Shen sans rien dire et part travailler.

### Semaine 5 (J29-J35) — Préparation Hong Kong

Annonce du gala à Hong Kong dans deux semaines. Essayage de robe. Hélène devine au téléphone que sa fille cache quelque chose. À J32, Tristan propose étrangement de "réviser les clauses" du contrat. À J33, Shen découvre dans son bureau du papier à en-tête : *Cabinet Heng & Associés — Notaires — Shanghai depuis 1962*. Elle se fige : sa mère lui a toujours dit que les papiers du mariage avaient été tamponnés à Shanghai. Coïncidence ? Elle note dans son carnet : *"Et si c'était eux ?"* Départ pour Hong Kong. Bourse : HENG +12% (signature contrat asiatique).

### Semaine 6 (J36-J42) — Hong Kong, première partie

Arrivée à Hong Kong, hôtel familial. Vue sur la baie. *"Je n'ai jamais vu autant de lumière en même temps."* Préparation gala. Le soir du gala, Shen descend l'escalier en robe et Tristan s'arrête net en la voyant. Première vraie attirance non niée. Vincent arrive, reconnaît Shen (l'avait approchée six mois plus tôt sous fausse identité). Il commence à manœuvrer. Tristan et Shen dansent — les fronts se touchent, pas de baiser. Vincent glisse à Shen, mine de rien : *"Mon frère a déjà eu trois fausses fiancées contractuelles avant toi."* (mensonge partiel : il y en a eu UNE).

## ACTE 3 — LE SECRET ÉCLATE (semaines 7-9, jours 43-63)

**DEADLINE MAMAN : J45.** Si argent < 18 000€ → branche "deuil".

### Semaine 7 (J43-J49) — La phrase de Madame Heng

Shen, troublée par les mots de Vincent, demande à Tristan ce que sa tante a voulu dire l'autre jour. Tristan ne sait pas, mais commence à se poser des questions sur le nom *Shen*. Il fait, sans le dire à Shen, une recherche dans les archives numérisées du cabinet Heng. Il trouve un dossier : *Marchand H. / Shen W. — septembre 1999*. **Deadline maman : J45**. Le lendemain (J46), Madame Heng croise Shen dans un couloir et lui prend doucement le poignet : *"Tu as les yeux de ta mère, mais tu as la bouche de quelqu'un d'autre. Quelqu'un que j'ai connu."* Shen confronte la matriarche, qui refuse de répondre mais dit : *"Demande à Zixuan."* Shen demande à Tristan. Il ment par omission ("juste un homonyme dans nos archives"). Shen sent qu'il ment.

### Semaine 8 (J50-J56) — Les manœuvres de Vincent

Vincent multiplie les insinuations face à Tristan : *"Je l'ai vue dans un café avec un homme."* Bourse : HENG -18% (Vincent attaque le conseil). Tristan, isolé, demande discrètement à acheminer le dossier physique Marchand-Shen depuis les archives de Shanghai. Le dossier arrive à Hong Kong (ils sont encore là-bas). Tristan le lit seul, la nuit, dans la chambre d'hôtel. Il découvre toute la vérité : l'arrestation politique de Wenbo en 1999, les 5 ans de prison, la lettre de 2017 jamais envoyée. **Il ne dit rien à Shen. Il ne sait pas comment.**

### Semaine 9 (J57-J63) — La rupture

Vincent, sentant le piège se refermer, accélère. Il fait croire à Shen que Tristan a déjà eu trois fausses fiancées (mensonge partiel). Il glisse à Shen, vrai cette fois : *"J'ai entendu Tristan parler d'un dossier Marchand avec sa tante."* Shen comprend que Tristan lui cache quelque chose qui la concerne ELLE, sa famille, son père. C'est la trahison ultime — pire que les fausses fiancées. Shen entre dans la chambre d'hôtel, trouve le dossier ouvert sur le bureau, lit les premières pages. Choc. Le père n'a pas abandonné. Il a été emprisonné. Il est mort en 2018. Shen prend la dernière lettre de Wenbo (celle de 2017, *"à ma fille que je n'ai pas connue"*). Elle quitte l'hôtel. Elle ne dit pas à Tristan qu'elle a lu. Retour Paris en avion. Silence. Elle rend l'appartement, l'argent qu'il reste, garde ce qu'elle a déjà payé pour maman.

## ACTE 4 — LE RETOUR (semaines 10-12, jours 64-84)

**Thème** : Belleville comme refuge, Hélène lit la lettre, démasquage de Vincent.

### Semaine 10 (J64-J70) — Belleville, encore

Retour au studio Belleville. Hélène devine tout sans rien demander. Shen reprend ses livraisons. Plus dure cette fois — elle sait à quoi ressemble l'autre vie maintenant. Camille débarque, comprend, écoute, ne juge pas. Tristan cherche Shen partout : restaurants, plateformes de livraison, blanchisseries. Hélène finit par poser la question. Shen lui tend la lettre de Wenbo de 2017. **Scène pivot J69** : Hélène lit la lettre devant Shen. Pour la première fois en 25 ans, elle pleure devant sa fille. Elle dit : *"Je l'ai attendu jusqu'en 2010. Après j'ai arrêté de compter."* Shen prend la décision d'aller au Fujian.

### Semaine 11 (J71-J77) — Démasquer Vincent

Madame Heng démasque Vincent (Camille a recoupé des informations, l'a appelée). Tristan apprend toute la manipulation, et apprend aussi que Shen a lu le dossier en cachette. Il comprend pourquoi elle est partie. Il s'en veut profondément. Il essaye d'écrire à Shen. Brouillons déchirés. Bourse : HAN +35% (Hanami ouvre 3 cafés). Tristan fait quelque chose qu'il n'a jamais fait : il quitte la direction Europe.

### Semaine 12 (J78-J84) — La porte ouverte

Tristan organise sur ses fonds personnels le rapatriement officiel des cendres de Shen Wenbo depuis le Fujian, avec l'accord de Tante Mei qu'il a fini par retrouver. Il propose à Hélène et Shen un voyage au village natal du père. Sans lui. Juste comme une porte ouverte. Shen reçoit le message. Elle ne répond pas tout de suite. Hélène dit oui. Shen dit oui aussi, mais sans message à Tristan. Préparation du voyage. Départ pour le Fujian.

## ACTE 5 — LE FUJIAN (semaines 13-15, jours 85-105)

**Thème** : le deuil enfin possible. La 312ème lettre brûlée.

### Semaine 13 (J85-J91) — L'arrivée

Arrivée à Fuzhou, train vers le village. Tante Mei les accueille. Première rencontre avec la famille du père. Visite de la maison où Wenbo a grandi. Tante Mei sort la boîte en bois. Toutes les lettres conservées. Hélène lit en silence pendant des heures. Apprend que Wenbo avait gardé toutes ses lettres à elle. Shen lit pour la première fois l'écriture de son père. Marché du village, vie quotidienne.

### Semaine 14 (J92-J98) — Le deuil

Les deux femmes prennent leur place dans le village, aident à la cuisine, à la cour, au potager. Shen apprend que son père l'avait imaginée avec un prénom différent — *Yuelan* (orchidée de la lune). Visite de la tombe de Wenbo. Hélène brûle un encens, parle à Wenbo en français qu'il n'aurait pas compris. Bourse : NCB -22% (scandale).

### Semaine 15 (J99-J105) — La 312ème lettre

Shen écrit, sur place, dans la cour de Tante Mei, une lettre à son père. C'est la 312ème de son carnet depuis ses 14 ans. Shen brûle la 312ème lettre dans la cour. Elle peut commencer. Photo retrouvée dans la boîte : Hélène et Wenbo jeunes, posés côte à côte un jour de 1999 à Paris. La SEULE photo qui existe d'eux ensemble. Préparation du retour. Retour à Paris.

## ACTE 6 — LE CHOIX (semaine 16, jours 106-112)

**Thème** : à parts égales. Pas de mariage, pas de bague.

Retour à Paris, Hélène va mieux, traitement effectif. Shen reprend l'archi en cours du soir. Camille la pousse à recontacter Tristan ("il t'a attendue, il y va tous les samedis"). Shen retrouve Tristan dans un parc, sans rendez-vous. Il y va tous les samedis depuis trois mois. Elle dit : *"Je ne veux pas être sauvée, ni épousée, ni installée. Je veux essayer, lentement, à parts égales."* Il dit oui à tout. Un an plus tard (ellipse) — Shen présente son projet de fin d'année à l'école d'archi. Épilogue selon ending calculé. Dernière entrée du carnet, plan final.

---

# 4. MÉCANIQUES DE JEU

## 4.1 — TROIS RESSOURCES

```
💰 ARGENT (€)        — entier, point de départ : 2 384€
😊 MOOD (0-10)       — point de départ : 5
⭐ RÉPUTATION (0-∞)  — point de départ : 0
```

## 4.2 — BOUCLES DE RESSOURCES

```
💰 ARGENT
   ← Choix narratifs (livraisons, contrat Heng, mockups)
   ← Followers (revenus passifs quotidiens)
   ← Investissements gagnants
   → Traitement maman (vital, 18 000€ avant J45)
   → Achats et investissements

⭐ RÉPUTATION
   ← Posts Insta réussis, dîners Heng, presse
   → Followers (★1 = 1 000 abonnés)
   → Achats luxe (gating)
   → Accès événements (gala Hong Kong)

😊 MOOD (0-10)
   ← Voyage Fujian, choix authentiques, vrais amis, achats narratifs
   ↘ Mensonges, achats vides, isolement
   → Cadeaux spontanés (paliers ≥ 6, 7, 8, 9)
   → Déblocage progressif onglets achats
   → Romance Tristan (≥ 8)
   → Filtre choix vertueux (< 3)

📱 FOLLOWERS
   ← Réputation × 1000
   → Revenus passifs quotidiens
```

## 4.3 — REVENUS PASSIFS FOLLOWERS

```
< 1 000 followers       : 0 €/jour
1 000 - 9 999           : 5 €/jour
10 000 - 24 999         : 25 €/jour
25 000 - 49 999         : 80 €/jour
50 000+                 : 200 €/jour
```

Tagline du profil Insta selon followers :

- < 1K : "petite tribu"
- 1-10K : "petite tribu"
- 10-25K : "communauté"
- 25-50K : "influence locale"
- 50K+ : "vraie influence"

## 4.4 — DÉBLOCAGES ONGLETS ACHATS PAR MOOD

```
TOUJOURS ACCESSIBLES :
🛵 Véhicule
🏠 Immobilier
🎨 Art
🌸 Beauté

PROGRESSION PAR MOOD :
🌿 Déco        — mood ≥ 4   (cocon, faire de chez soi un refuge)
📱 Tech        — mood ≥ 5   (outils, créativité)
👗 Mode        — mood ≥ 6   (envie de plaire, sortir)
💎 Bijoux      — mood ≥ 7   (s'offrir du précieux, se célébrer)
✈️ Voyage      — mood ≥ 8   (capacité à partir, s'ouvrir au monde)
```

Si le mood retombe sous le seuil, l'onglet redevient grisé. Les items déjà achetés restent possédés.

## 4.5 — EFFETS NARRATIFS DU MOOD

- **Mood < 3** : grise certaines options "vertueuses" du choix du jour (filtre punitif)
- **Mood ≤ 2 sur 3 jours consécutifs** : déclenche la branche narrative "burn-out" (jours alternatifs J100-103)
- **Mood = 0** : fin "effondrement" immédiate
- **Mood ≥ 6, 7, 8, 9** : à chaque palier atteint pour la 1ère fois, déclenche un cadeau spontané narratif (mini-scène bonus, pas de choix)

## 4.6 — DEADLINE MAMAN

- Objectif : `argent ≥ 18 000€` avant J+45
- Atteint : `isMomTreatmentPaid = true`, mood +2 immédiat
- Raté : branche narrative "deuil" se déclenche à J+46. Plusieurs jours alternatifs jusqu'à J70. Fin orientée vers "Le deuil et la route".

## 4.7 — CALCUL DE LA FIN À J112

```dart
String computeEnding(GameState s) {
  if (!s.isMomTreatmentPaid) return 'le_deuil_et_la_route';
  if (s.argent >= 30000 && s.mood >= 7 && s.reputation >= 10) {
    return 'a_parts_egales'; // fin canonique
  }
  if (s.argent >= 30000 && s.mood < 5 && s.reputation >= 15) {
    return 'la_cage_doree';
  }
  if (s.mood >= 8 && s.reputation <= 5) return 'belleville';
  return 'lentre_deux'; // fin par défaut
}
```

## 4.8 — TRIGGERS BOURSE NARRATIFS

Variations aléatoires ±2% par défaut chaque jour. Triggers narratifs forcés à des jours précis :

| Jour | Action | Variation | Cause narrative |
| --- | --- | --- | --- |
| J35 | HENG | +12% | Signature contrat asiatique |
| J52 | HENG | -18% | Vincent attaque le conseil |
| J76 | HAN | +35% | Hanami ouvre 3 cafés |
| J98 | NCB | -22% | Scandale bancaire |

---

# 5. SCÈNES NON-NÉGOCIABLES

Ces dialogues sont **canoniques**. À reproduire mot pour mot dans le scénario.

## J23 — LA DISPUTE DES FRAISES

```
Tristan : Tu sais que je suis allergique.
Shen : C'est dans le contrat. Clause 14, tu as signé.
Tristan : J'ai signé sous la contrainte affective.
Shen : (elle s'arrête, fraise à mi-chemin) Pardon ?
Tristan : (silence) J'ai dit commerciale. Sous la contrainte commerciale.
Shen : Tu as dit affective.
Tristan : (il sort de la pièce)
```

## J46 — LA PHRASE DE MADAME HENG

> *"Tu as les yeux de ta mère, mais tu as la bouche de quelqu'un d'autre. Quelqu'un que j'ai connu."*

## J69 — HÉLÈNE LIT LA LETTRE

> Hélène : (après un long silence) *"Je l'ai attendu jusqu'en 2010. Après j'ai arrêté de compter."*

## J102 — LA 312ème LETTRE

> Shen pose la lettre dans le brasero de la cour. Tante Mei ne dit rien. La fumée monte droit. *"Voilà. Je n'ai plus besoin de t'écrire pour te parler."*

## J109 — LE PARC

```
Shen : Je ne veux pas être sauvée. Ni épousée. Ni installée.
       Je veux essayer. Lentement. À parts égales.
Tristan : Oui. À tout.
```

---

# 6. SPÉCIFICATIONS TECHNIQUES

## 6.1 — STACK

- **Flutter (Dart)**, channel stable
- Cibles : **Android** (minSdk 23) et **iOS** (iOS 14+)
- Architecture **MVVM** via **Riverpod** (`flutter_riverpod`)
- Persistance : **`shared_preferences`** (clé `gameState_v1` en JSON sérialisé) + assets JSON locaux (`scenario.json`, `shop_catalog.json`, `investments.json`, `insta_seed.json`)
- Dépendances minimales :
    - `flutter_riverpod` — state management
    - `shared_preferences` — persistance locale
    - `google_fonts` — substitut élégant à New York/SF Pro (cf. 6.2)
- Pas de backend, pas d'analytics, pas de réseau.
- Tout en français.

## 6.2 — STYLE VISUEL

- **Light mode papier crème** : fond `#FBF7EF`, texte `#1A1A1A`
- **Accent orange** : `#D97757` pour boutons primaires et onglets actifs
- **Italique gris** : `#6B6B6B` pour descriptions
- **Bulles SMS iMessage** : bleu `#007AFF` (Shen, à droite), gris `#E9E9EB` (autres, à gauche)
- **Police titres** (substitut serif élégant) : `Crimson Pro` via `google_fonts` (équivalent visuel proche de New York)
- **Police corps** : `Inter` via `google_fonts` (équivalent SF Pro)
- Coins arrondis : 16 dp cartes, 22 dp boutons CTA
- Ces choix sont centralisés dans `lib/core/theme.dart`.

## 6.3 — STRUCTURE DU PROJET

```
contre_jour/
├── pubspec.yaml
├── assets/
│   └── data/
│       ├── scenario.json
│       ├── shop_catalog.json
│       ├── investments.json
│       └── insta_seed.json
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── theme.dart
│   │   └── colors.dart
│   ├── models/
│   │   ├── game_state.dart
│   │   ├── day_entry.dart
│   │   ├── choice.dart
│   │   ├── sms_message.dart
│   │   ├── shop_item.dart
│   │   ├── investment.dart
│   │   └── insta_post.dart
│   ├── data/
│   │   ├── scenario_loader.dart
│   │   ├── catalog_loader.dart
│   │   └── game_state_repository.dart
│   ├── providers/
│   │   ├── game_state_provider.dart
│   │   ├── scenario_provider.dart
│   │   └── catalogs_provider.dart
│   ├── engine/
│   │   ├── economy_engine.dart
│   │   └── ending_calculator.dart
│   └── ui/
│       ├── root_tab_view.dart
│       ├── carnet/
│       │   ├── carnet_screen.dart
│       │   ├── day_narrative_view.dart
│       │   ├── sms_bubble.dart
│       │   └── choice_card.dart
│       ├── banque/
│       │   ├── banque_screen.dart
│       │   ├── compte_tab.dart
│       │   ├── investissement_tab.dart
│       │   └── achats_tab.dart
│       ├── insta/
│       │   ├── insta_screen.dart
│       │   ├── profile_header.dart
│       │   └── post_card.dart
│       └── messages/
│           ├── messages_screen.dart
│           └── conversation_view.dart
├── test/
│   └── engine/
│       ├── economy_engine_test.dart
│       └── ending_calculator_test.dart
├── android/
└── ios/
```

## 6.4 — MODÈLES DE DONNÉES

Tous les modèles sont des classes Dart immuables avec `fromJson` / `toJson` manuels (pas de `json_serializable` pour rester sans codegen).

### GameState

```dart
class GameState {
  final int currentDay;
  final int argent;
  final int mood;
  final int reputation;
  final int followers;
  final Map<String, int> stockHoldings;
  final List<String> ownedItems;
  final Map<int, int> choicesMade;
  final int lowMoodStreak;
  final bool isMomTreatmentPaid;
  final List<String> unlockedConversations;
  final List<String> seenInstaPosts;
  final String? ending;

  const GameState({
    this.currentDay = 1,
    this.argent = 2384,
    this.mood = 5,
    this.reputation = 0,
    this.followers = 712,
    this.stockHoldings = const {},
    this.ownedItems = const [],
    this.choicesMade = const {},
    this.lowMoodStreak = 0,
    this.isMomTreatmentPaid = false,
    this.unlockedConversations = const ['maman', 'camille'],
    this.seenInstaPosts = const [],
    this.ending,
  });
  // copyWith / fromJson / toJson : voir lib/models/game_state.dart
}
```

### DayEntry

```dart
class DayEntry {
  final int id;
  final String date;
  final String location;
  final String time;
  final List<NarrativeBlock> narrative;
  final Choice choice;
  final List<Trigger>? triggers;
}

enum NarrativeBlockType { prose, sms, sectionTitle }

class NarrativeBlock {
  final NarrativeBlockType type;
  final String? content;
  final String? conversation;
  final List<SmsMessage>? messages;
}

class SmsMessage {
  final String sender;
  final String content;
  final String? time;
}

class Choice {
  final String prompt;
  final List<ChoiceOption> options;
}

class ChoiceOption {
  final String text;
  final int argent;
  final int mood;
  final int reputation;
  final List<String>? unlocks;
  final String? triggersScene;
}

class Trigger {
  final String type;
  final Map<String, String> payload;
}
```

### ShopItem

```dart
class ShopItem {
  final String id;
  final String category;
  final String emoji;
  final String name;
  final String description;
  final int price;
  final int moodGain;
  final int reputationGain;
  final int requiredReputation;
  final int requiredMood;
  final bool generatesInstaPost;
  final String? instaPostCaption;
  final String? instaPostEmoji;
}
```

### Investment

```dart
class Investment {
  final String ticker;
  final String name;
  final String sector;
  final double price;
  final String description;
  final int? unlockedAtDay;
  String get id => ticker;
}
```

### InstaPost

```dart
class InstaPost {
  final String id;
  final String author;
  final int day;
  final String emoji;
  final String caption;
}
```

---

# 7. INTERFACE — LES 4 ONGLETS

## 7.1 — CARNET (onglet par défaut)

- **Header** : avatar Shen + jour ("Jour 12 — Mardi 14 juin")
- **Sidebar gauche fixe** : J+ courant, argent, mood emoji, réputation étoiles, accès 4 onglets, icône engrenage en bas (réglages avec reset partie)
- **Corps scrollable** : alternance de blocs prose (italique pour les pensées, droit pour les descriptions) et bulles SMS retranscrites façon iMessage
- **Footer** : carte du choix du jour (3 options en cartes empilées, chaque option montre les deltas en pictos colorés : 💰 +50€ vert, 😊 +1 vert, ⭐ -2 rouge)
- **Bouton "Jour suivant"** : visible uniquement après le choix, plein largeur, orange

## 7.2 — BANQUE

3 sous-onglets en pills : **COMPTE / INVESTISSEMENT / ACHATS**

### Compte

- Grand chiffre du compte courant centré
- Cartes "Portefeuille" (valeur actions) et "PNL latente" (gain/perte couleur)
- Carte "Patrimoine total"
- Liste "Derniers mouvements" avec emoji + montant + date

### Investissement

- Section "Tes positions" : pour chaque action possédée, ticker + nb actions + prix moyen + prix actuel + bouton Vendre
- Section "Entreprises" : liste des actions disponibles, prix actuel, variation %, descriptions narratives liées au drama (ex: *"Lu Healthcare. Filiale santé. C'est elle qui facture le traitement de ta mère."*)

### Achats

- Filtres en pills horizontales scrollables : Tout, Véhicule, Mode, Immobilier, Art, Beauté, Voyage, Tech, Déco, Bijoux
- Onglets grisés selon mood (icône cadenas + texte "Mood ≥ X requis")
- Grille 2 colonnes de cartes produit (emoji, nom, description italique, prix, deltas mood/réputation, bouton Acheter / Trop cher / Réputation X requise)

## 7.3 — INSTAGRAM (@shen\_y)

- **Header** : "Instagram" titre serif + icône profil
- **Profil de Shen** en haut : avatar + @shen\_y + "X abonnés · [tagline évolutif]"
- **Stories** : ronds avec bordure orange, photos des autres personnages
- **Feed scrollable** : posts du joueur (générés par les achats) + posts narratifs des autres personnages
- Chaque post : avatar, nom, "il y a Xh", image (utiliser des emojis grand format ou couleurs pleines), caption, ligne d'icônes

## 7.4 — MESSAGES

- Liste des conversations actives (Maman ❤️, Camille, Tristan apparaît J7, Vincent apparaît J40)
- Chaque ligne : avatar emoji, nom, dernier message, heure
- Tap → ConversationView plein écran style iMessage avec bulles bleues (Shen) à droite et grises (l'autre) à gauche, header avec nom + bouton retour

---

# 8. CATALOGUES JSON

## 8.1 — shop\_catalog.json (catalogue d'achats complet)

```
[
  {"id":"velo_neuf","category":"vehicule","emoji":"🚲","name":"Vélo neuf","description":"Pour livrer plus vite. Investissement utile.","price":200,"moodGain":1,"reputationGain":0,"requiredReputation":0,"requiredMood":0,"generatesInstaPost":false},
  {"id":"scooter","category":"vehicule","emoji":"🛵","name":"Scooter électrique","description":"Pour zigzaguer entre les tours sans le métro.","price":2400,"moodGain":1,"reputationGain":0,"requiredReputation":0,"requiredMood":0,"generatesInstaPost":true,"instaPostCaption":"Nouveau compagnon de route 🛵","instaPostEmoji":"🛵"},
  {"id":"citadine","category":"vehicule","emoji":"🚗","name":"Citadine d'occasion","description":"Volkswagen Polo, 60 000 km. Garage agréé.","price":8900,"moodGain":2,"reputationGain":1,"requiredReputation":0,"requiredMood":0,"generatesInstaPost":true,"instaPostCaption":"Première voiture 🚗","instaPostEmoji":"🚗"},
  {"id":"tesla","category":"vehicule","emoji":"⚡","name":"Tesla Model 3","description":"Vitre teintée, supercharge, autopilote.","price":42000,"moodGain":3,"reputationGain":4,"requiredReputation":5,"requiredMood":0,"generatesInstaPost":true,"instaPostCaption":"Silent ride ⚡","instaPostEmoji":"⚡"},
  {"id":"porsche","category":"vehicule","emoji":"🏎️","name":"Porsche Taycan","description":"Tu es passée à autre chose. Tout NeoCity le verra.","price":110000,"moodGain":-2,"reputationGain":7,"requiredReputation":12,"requiredMood":0,"generatesInstaPost":true,"instaPostCaption":"🤍","instaPostEmoji":"🏎️"},

  {"id":"robe_acne","category":"mode","emoji":"👗","name":"Robe Acne Studios","description":"Coupe minimaliste suédoise. Bureau ou dîner.","price":480,"moodGain":1,"reputationGain":1,"requiredReputation":0,"requiredMood":6,"generatesInstaPost":true,"instaPostCaption":"Premier dîner 🍷","instaPostEmoji":"👗"},
  {"id":"manteau_apc","category":"mode","emoji":"🧥","name":"Manteau A.P.C.","description":"Laine vierge, coupe française, intemporel.","price":690,"moodGain":1,"reputationGain":1,"requiredReputation":0,"requiredMood":6,"generatesInstaPost":false},
  {"id":"sac_chanel","category":"mode","emoji":"👜","name":"Sac Chanel vintage","description":"Marché de seconde main du Marais. Conservé impeccable.","price":5800,"moodGain":2,"reputationGain":4,"requiredReputation":4,"requiredMood":6,"generatesInstaPost":true,"instaPostCaption":"Trouvaille du Marais","instaPostEmoji":"👜"},
  {"id":"talons_louboutin","category":"mode","emoji":"👠","name":"Talons Louboutin","description":"Pigalle 100. Semelles rouges. Pour les soirées Lu Group.","price":720,"moodGain":2,"reputationGain":2,"requiredReputation":2,"requiredMood":6,"generatesInstaPost":false},
  {"id":"montre_omega","category":"mode","emoji":"⌚","name":"Montre Omega","description":"Acier brossé, mouvement automatique.","price":4900,"moodGain":2,"reputationGain":3,"requiredReputation":3,"requiredMood":6,"generatesInstaPost":false},

  {"id":"bracelet_or","category":"bijoux","emoji":"💍","name":"Bracelet en or fin","description":"Or 18 carats, joaillerie indépendante.","price":1200,"moodGain":1,"reputationGain":2,"requiredReputation":0,"requiredMood":7,"generatesInstaPost":false},

  {"id":"weekend_kyoto","category":"voyage","emoji":"🌸","name":"Week-end Kyoto","description":"Vol direct + ryokan traditionnel 3 nuits.","price":2200,"moodGain":4,"reputationGain":1,"requiredReputation":0,"requiredMood":8,"generatesInstaPost":true,"instaPostCaption":"Kyoto en avril 🌸","instaPostEmoji":"🌸"},
  {"id":"bali","category":"voyage","emoji":"🏝️","name":"Bali (10 jours)","description":"Villa privée, plongée, vacances IRL.","price":4500,"moodGain":5,"reputationGain":2,"requiredReputation":0,"requiredMood":8,"generatesInstaPost":true,"instaPostCaption":"Reset 🏝️","instaPostEmoji":"🏝️"},
  {"id":"billet_fujian","category":"voyage","emoji":"✈️","name":"Billet Fujian (aller-retour)","description":"Pour rencontrer la cousine de papa. Le plus rentable émotionnellement.","price":1100,"moodGain":3,"reputationGain":0,"requiredReputation":0,"requiredMood":8,"generatesInstaPost":false},
  {"id":"visite_village","category":"voyage","emoji":"🚆","name":"Visite au village (Fujian)","description":"Train + nuit chez Tante Mei. Pour de vrai.","price":320,"moodGain":5,"reputationGain":3,"requiredReputation":0,"requiredMood":8,"generatesInstaPost":true,"instaPostCaption":"Mes racines 🌿","instaPostEmoji":"🌿"},

  {"id":"iphone","category":"tech","emoji":"📱","name":"iPhone Pro","description":"Dernier modèle, 256 Go.","price":1300,"moodGain":1,"reputationGain":1,"requiredReputation":0,"requiredMood":5,"generatesInstaPost":false},
  {"id":"ipad","category":"tech","emoji":"📓","name":"iPad Pro + Pencil","description":"Tablette de design, écran ProMotion.","price":1400,"moodGain":1,"reputationGain":1,"requiredReputation":0,"requiredMood":5,"generatesInstaPost":false},
  {"id":"macbook","category":"tech","emoji":"💻","name":"MacBook Pro 16\"","description":"M4 Max, 64 Go. Pour les nuits de mockups.","price":3200,"moodGain":2,"reputationGain":1,"requiredReputation":0,"requiredMood":5,"generatesInstaPost":false},
  {"id":"leica","category":"tech","emoji":"📸","name":"Leica Q3","description":"Appareil photo full-frame compact.","price":5800,"moodGain":3,"reputationGain":2,"requiredReputation":4,"requiredMood":5,"generatesInstaPost":true,"instaPostCaption":"Premier shoot Leica 📸","instaPostEmoji":"📸"},

  {"id":"bonsai","category":"deco","emoji":"🌲","name":"Bonsaï pin noir","description":"20 ans d'âge. Vendeur du marché aux fleurs.","price":240,"moodGain":2,"reputationGain":0,"requiredReputation":0,"requiredMood":4,"generatesInstaPost":false},
  {"id":"kakemono","category":"deco","emoji":"🪴","name":"Kakemono calligraphie","description":"Encre sumi, montage soie, signé.","price":280,"moodGain":1,"reputationGain":1,"requiredReputation":0,"requiredMood":4,"generatesInstaPost":false},
  {"id":"lampe_noguchi","category":"deco","emoji":"💡","name":"Lampe Isamu Noguchi","description":"Akari 75A, papier washi. Lumière douce.","price":690,"moodGain":2,"reputationGain":1,"requiredReputation":0,"requiredMood":4,"generatesInstaPost":false},
  {"id":"tapis_persan","category":"deco","emoji":"🧶","name":"Tapis persan vintage","description":"Laine nouée main, 2x3m, ton crème.","price":1900,"moodGain":2,"reputationGain":2,"requiredReputation":0,"requiredMood":4,"generatesInstaPost":false},

  {"id":"spa_jasmin","category":"beaute","emoji":"💆","name":"Cure spa jasmin (1 sem)","description":"Maison de thé, soins sur mesure.","price":1600,"moodGain":4,"reputationGain":1,"requiredReputation":0,"requiredMood":0,"generatesInstaPost":false},
  {"id":"coiffeur","category":"beaute","emoji":"💇","name":"Coiffeur haut de gamme","description":"Coupe + couleur + soin. Salon Marais.","price":320,"moodGain":2,"reputationGain":1,"requiredReputation":0,"requiredMood":0,"generatesInstaPost":false},
  {"id":"skincare","category":"beaute","emoji":"✨","name":"Routine skincare premium","description":"Sérum + crème + masque pour 6 mois.","price":480,"moodGain":1,"reputationGain":0,"requiredReputation":0,"requiredMood":0,"generatesInstaPost":false},
  {"id":"chanel5","category":"beaute","emoji":"🌼","name":"Parfum Chanel N°5","description":"Le classique. Toujours.","price":220,"moodGain":1,"reputationGain":1,"requiredReputation":0,"requiredMood":0,"generatesInstaPost":false}
]
```

## 8.2 — investments.json

```
[
  {"ticker":"LUG","name":"Lu Group","sector":"Immobilier / Tech","price":139,"description":"Conglomérat de NeoCity. Le siège est dans la Tour Lu. Action solide, croissance steady.","unlockedAtDay":null},
  {"ticker":"NCT","name":"NeoCity Tower Holdings","sector":"Immobilier","price":88,"description":"Gestionnaire des tours du quartier financier. 40% de leurs contrats viennent de Lu Group, donc corrélé.","unlockedAtDay":null},
  {"ticker":"NCB","name":"NeoCity Bank","sector":"Banque","price":69,"description":"Banque commerciale historique. Stable, peu de croissance, dividende régulier.","unlockedAtDay":null},
  {"ticker":"HENG","name":"Heng International","sector":"Hôtellerie","price":220,"description":"Le groupe de Tristan. Volatile, dépend des contrats asiatiques.","unlockedAtDay":10},
  {"ticker":"HAN","name":"Hanami Café Co.","sector":"Food & Beverage","price":12,"description":"Chaîne de cafés artisanaux. Action pas chère. Opportunité ou piège — selon comment tu lis le secteur.","unlockedAtDay":null}
]
```

## 8.3 — insta\_seed.json (posts initiaux des autres personnages)

```
[
  {"id":"camille_j1","author":"@camille_rx","day":1,"emoji":"📚","caption":"Code civil, 14h, je suis vivante par miracle ✏️"},
  {"id":"madame_heng_j13","author":"@heng_lihua","day":13,"emoji":"🍵","caption":"Le thé Long Jing première récolte, c'est chez nous ce soir."},
  {"id":"tristan_j20","author":"@t_heng","day":20,"emoji":"🌃","caption":"Hong Kong la semaine prochaine."},
  {"id":"vincent_j40","author":"@vincent.h","day":40,"emoji":"🥂","caption":"Closed the deal. Champagne in 30."},
  {"id":"camille_j64","author":"@camille_rx","day":64,"emoji":"☕","caption":"Belleville un samedi matin, la meilleure énergie."},
  {"id":"madame_heng_j72","author":"@heng_lihua","day":72,"emoji":"📜","caption":"Certaines histoires de famille s'écrivent sur trois générations."},
  {"id":"tante_mei_j86","author":"@mei_fujian","day":86,"emoji":"🌿","caption":"Visiteurs de France aujourd'hui. Le potager en témoin."},
  {"id":"camille_j105","author":"@camille_rx","day":105,"emoji":"🥐","caption":"Quand ta meilleure amie rentre du bout du monde 🤍"}
]
```

---

# 9. SCÉNARIO COMPLET — J1 à J112

> Format : pour chaque jour, narration en prose + SMS s'il y en a + 1 choix à 3 options avec deltas (€, mood, réputation).
> Ces textes doivent être encodés tels quels dans `scenario.json`. Convention : Hélène = "Maman" dans les SMS, Tristan = "Tristan" ou "Lui" selon le contexte.

## ACTE 1 — LA COLLISION

### J1 — Vendredi 3 juin · Studio, Belleville · 07:42

**Prose** :
Je note tout depuis hier. C'est Camille qui m'a dit de le faire. « Tu vas vivre des trucs que tu vas oublier de vivre si tu les écris pas. » Camille dit toujours des phrases comme ça avec un croissant dans la bouche.

Donc voilà. Carnet. Stylo bic vert parce que je n'ai pas trouvé le noir.

Maman a passé une mauvaise nuit. Je l'ai entendue tousser à 4h. J'ai fait semblant de dormir parce que si elle sait que je l'ai entendue, elle va s'excuser. Maman s'excuse de tomber malade. C'est insupportable.

Je pars livrer dans dix minutes. Vélo, pluie, le 8ème encore. Les riches commandent leur petit-déj à 8h pile, c'est mathématique.

**08:14 — Avenue Montaigne**

**SMS Maman** :

- Maman : Tu as mangé ?
- Moi : Oui.
- Maman : « Oui ». Tu réponds « oui » depuis trois jours. Donne-moi un détail.
- Moi : Pain au chocolat de la veille trempé dans du thé. Ça m'a tenu.
- Maman : Merci ma fille. Couvre-toi, il pleut.
- Moi : Toi couvre-toi surtout.

**Prose** : Je range le téléphone. Le feu passe au vert.

**08:17 — La collision**

**Prose** :
Une berline noire surgit de la rue François 1er. Freins. Pas assez tôt.

Le vélo finit sous la roue avant. Mon genou s'ouvre sur le bitume. Le sac de livraison explose — bowl renversé, smoothie sur ma jambe, le tout vaut 38€ que je vais devoir rembourser à la plateforme.

L'homme qui sort de la voiture a un costume qui coûte plus que mon loyer annuel. Il regarde sa montre avant de me regarder moi. Première erreur.

**Échange inline** :

- Lui : Ça va aller. Pour le vélo et la consultation. (Il sort 200€.)
- Moi : Gardez votre argent.
- Lui : Pardon ?
- Moi : Votre assurance va payer correctement, comme tout le monde. Je ne suis pas un pourboire.

**Prose** :
Il me tend une carte de visite. *Tristan Heng — Heng International — Directeur Europe.* Je la déchire devant lui et je laisse tomber les morceaux dans la flaque.

Je repars en boitant avec mon vélo cassé sur l'épaule.

**Choix : Comment je raconte ça à Camille ce soir ?**

- A. « Je l'ai humilié. C'était jouissif. » → 💰 0 / 😊 -1 / ⭐ +1
- B. « Je crois que j'ai été conne. » → 💰 0 / 😊 +1 / ⭐ 0
- C. « J'ai gardé sa carte. » (mensonge) → 💰 0 / 😊 0 / ⭐ 0 [triggersScene: carte\_recollee]

---

### J2 — Samedi 4 juin · Hôpital Tenon · 06:30

**Prose** :
Le néphrologue veut me parler en privé. Quand un médecin veut te parler en privé à 6h30 du matin, c'est jamais pour te dire que ça va.

Le Dr Aubin a un visage que j'aime bien. Il porte des lunettes en écaille et il prend toujours le temps. Il pose son stylo avant de parler — c'est quelqu'un qui ne lit pas à haute voix une fiche, c'est quelqu'un qui réfléchit.

— Madame Marchand, votre mère a besoin d'un traitement de seconde ligne. C'est un protocole hors AMM, donc non remboursé.
— Combien ?
— Dix-huit mille euros sur six mois.

Je n'ai pas dix-huit mille euros. Je n'ai pas dix-huit *cents* euros. Sur mon compte courant il y a 2 384€ et c'est déjà un miracle de fin de mois.

Je ressors. Le hall sent l'eau de Javel et le café froid. Je m'assois sur un banc et je calcule trois fois. Trois fois la même réponse.

**Choix : Premier réflexe ?**

- A. Pleurer dans les toilettes du rez-de-chaussée → 💰 0 / 😊 -1 / ⭐ 0
- B. Sortir un carnet et faire un tableau Excel mental → 💰 0 / 😊 0 / ⭐ +1
- C. Appeler Camille immédiatement → 💰 0 / 😊 +1 / ⭐ 0

---

### J3 — Dimanche 5 juin · Studio · 14:30

**Prose** :
Calculs. Calculs. Calculs.

Si je double les livraisons : +400€/mois. Si je prends un troisième service de nuit : +600€/mois mais je ne dors plus. Total potentiel sur six mois : 6 000€. Manque : 12 000€.

J'ai appelé la banque. Pas de prêt sans garant. Mon père français — celui de mon nom, Antoine Marchand, parti quand j'avais 6 ans — ne sera jamais garant de quoi que ce soit, on ne s'est pas vus depuis dix-huit ans.

Maman regarde un film français des années 80 dans le canapé. Catherine Deneuve sourit. Maman sourit aussi. Elle ne sait rien.

**Choix : Que faire ?**

- A. Demander un crédit conso (refusé d'avance mais essayer) → 💰 -50 / 😊 -1 / ⭐ 0 [frais dossier]
- B. Chercher un troisième job → 💰 +100 / 😊 -2 / ⭐ 0
- C. Recoller la carte de Tristan Heng → 💰 0 / 😊 -1 / ⭐ +1 [triggersScene: tentation]

---

### J4 — Lundi 6 juin · Café Hanami, près du campus · 14:02

**Prose** :
Camille pose son croissant.

— Tu vas le rappeler.
— Non.
— Shen. Dix-huit mille. Ta mère.
— Je ne mendie pas chez les Heng.
— C'est pas mendier si tu rends. C'est emprunter.
— …
— Tu as gardé sa carte hein.
— …

J'ai recollé les morceaux hier soir sur la table de la cuisine. Avec du scotch transparent. C'est ridicule. Le numéro est lisible.

**SMS Camille (le soir)** :

- Camille : Alors ?
- Moi : J'y réfléchis.
- Camille : Ça veut dire oui.
- Moi : Ça veut dire que j'y réfléchis.
- Camille : Ça veut dire oui mais avec dignité.
- Moi : 🙄

**Choix : J'appelle Tristan Heng ?**

- A. Oui, lundi prochain. Je demande un prêt à rembourser. → 💰 0 / 😊 -2 / ⭐ +2 [unlocks: tristan\_phone]
- B. Non. Je trouve une autre solution. → 💰 0 / 😊 0 / ⭐ 0 [⚠️ branche difficile]
- C. J'attends une semaine pour décider. → 💰 0 / 😊 -1 / ⭐ 0

---

### J5 — Mardi 7 juin · Studio · 23:15

**Prose** :
La carte est recollée. Le scotch a légèrement jauni le carton. Le numéro forme une diagonale parce que j'ai mal aligné les morceaux. J'ai mis une assiette dessus pour qu'elle reste plate.

Maman dort. La pluie tombe contre la fenêtre. C'est le moment où je suis le plus seule de la journée, et c'est aussi le moment où je m'aime le plus. Curieux.

Je relis les SMS de Camille. *« Ça veut dire oui mais avec dignité. »* Elle a raison. Si j'y vais, c'est avec un dossier. Pas en quémandeuse.

J'ouvre mon vieux MacBook Air. J'écris un plan de remboursement sur dix ans. Taux légal. Échéancier mensuel. Je veux un contrat notarié. Je serai sa débitrice, pas sa charité.

**Choix : Comment je me prépare ?**

- A. Tableur Excel propre, dossier imprimé chez Camille → 💰 -10 / 😊 +1 / ⭐ +1
- B. Note vocale dans mon téléphone, je ferai au feeling → 💰 0 / 😊 0 / ⭐ 0
- C. Je n'apporte rien, je veux voir comment il réagit → 💰 0 / 😊 -1 / ⭐ +2

---

### J6 — Mercredi 8 juin · Studio · 19:00

**Prose** :
Camille est là. Elle a apporté un tailleur noir. *"Il était à ma mère, il devrait te tomber comme un gant. Non — comme une armure."*

Je l'enfile. Le miroir me dit quelqu'un d'autre. Pas plus belle, pas moins. Juste plus coupée. Plus tranchante.

— Tu ressembles à une avocate qui va plaider sa propre affaire, dit Camille.
— C'est exactement ça.
— Tu parles à peine mandarin avec lui hein ? Ça serait con de glisser sur ça.
— Il est franco-suisse-chinois. Mon mandarin restera dans ma poche.

**SMS Maman (à 21h)** :

- Maman : Tu as un rendez-vous important demain ?
- Moi : Comment tu sais ?
- Maman : Tu n'as pas chanté en cuisinant. C'est mon baromètre depuis que tu as 8 ans.
- Moi : Juste un truc administratif. T'inquiète pas.
- Maman : Je m'inquiéterai jamais pour toi sur ces choses-là. Tu es trop préparée.

**Choix : Le dernier détail avant demain ?**

- A. Je révise mon dossier une dernière fois → 💰 0 / 😊 0 / ⭐ +1
- B. Je dors comme une masse, je laisse l'instinct → 💰 0 / 😊 +1 / ⭐ 0
- C. Je relis les lettres que j'ai écrites à mon père cette année (rituel) → 💰 0 / 😊 +2 / ⭐ 0

---

### J7 — Jeudi 9 juin · Tour Heng, 47e étage · 10:47

**Prose** :
Tailleur. Cheveux relevés. Marche calme. La moquette du 47e absorbe les pas — j'avais oublié que la richesse, c'est aussi du silence.

L'assistante me dévisage. Je dévisage le mur. Le mur gagne.

Tristan me reçoit.

— Mademoiselle Marchand. Vous avez recollé ma carte.
— Je suis là pour un prêt. Dix-huit mille euros. Remboursement sur dix ans, taux légal, échéancier mensuel. Je veux un contrat notarié.

Il pose son stylo.

— Pourquoi pas un don ?
— Parce que je ne suis pas un pourboire. Je vous l'ai déjà dit.

Il me regarde. Vraiment. Pour la première fois depuis que je suis entrée. Ses yeux sont plus clairs que ce que je pensais. Gris-vert. Maman dirait que c'est l'œil de quelqu'un qui a appris à mentir tôt.

— J'ai mieux qu'un prêt. Une proposition. Trois mois.

Et là il sort un dossier que sa secrétaire a préparé avant que j'arrive.

**Avant. Que. J'arrive.**

Donc il savait que je viendrais.

**Choix : Sa proposition de fausse fiancée pendant 3 mois pour 30 000€ ?**

- A. J'accepte mais j'ajoute des clauses (pas de baisers, pas de mensonges sur maman, fraises). → 💰 +30000 / 😊 -2 / ⭐ +5 [unlocks: tristan\_sms]
- B. Je refuse et je pars. → 💰 0 / 😊 +3 / ⭐ -2 [⚠️ ferme l'arc principal]
- C. Je négocie le montant à la hausse (40 000€). → 💰 +35000 / 😊 -3 / ⭐ +6 [risqué]

---

### J8 — Vendredi 10 juin · Cabinet notarial, Paris · 11:30

**Prose** :
Quatorze pages. Quatorze pages pour décrire trois mois de mensonge encadré par un papier signé.

Le notaire — un type chauve qui sourit poliment comme s'il faisait ce genre de contrat tous les jours, et peut-être que oui — fait défiler les clauses.

Article 14. *"Aucun contact physique non public ne sera exigé entre les parties."*

Je prends son stylo. J'écris en marge, à la main : *"Pas de baisers. Pas de mensonges sur ma mère malade. Droit de manger des fraises devant lui même s'il est allergique."*

Tristan me regarde. Le notaire fait semblant de ne rien voir.

— Vous signez avec ça ?
— Je signe avec ça.

Il signe. En serrant les dents.

Le virement est programmé pour J+3. 30 000€. Le traitement de maman est dans le sac.

**Choix : Quelle est ma première dépense ?**

- A. Premier versement direct à l'hôpital → 💰 -18000 / 😊 +3 / ⭐ +1 [isMomTreatmentPaid: true]
- B. Je garde tout en attendant, je verse étalé → 💰 0 / 😊 0 / ⭐ 0
- C. Je rembourse mes dettes (loyer, plateforme) puis le reste à l'hôpital → 💰 -800 / 😊 +1 / ⭐ 0

---

### J9 — Samedi 11 juin · Appartement Heng, 8ème · 17:20

**Prose** :
350 m². J'ai compté.

Il y a une cuisine qu'on dirait sortie d'un magazine japonais et un salon où le canapé seul vaut probablement plus que tout ce que je possède. Les murs sont gris ardoise. Le sol est en chêne fumé. Il y a une bibliothèque qui occupe un mur entier et qui ne contient que des livres en chinois ou en allemand.

Tristan me montre ma chambre. La mienne. Pas la nôtre. Bien.

— J'ai libéré la moitié de la penderie. Vous pouvez utiliser la salle de bain attenante. Je dormirai dans le bureau.
— Vous avez un bureau dans cet appartement ? En plus du bureau du 47e ?
— Oui.
— Évidemment.

Je pose ma valise sur le lit. Une seule valise. Je la regarde longtemps. Elle a l'air toute petite.

**SMS Camille** :

- Camille : Alors ? T'es dans le palace ?
- Moi : C'est plus grand que mon ancien lycée.
- Camille : Photo.
- Moi : Non.
- Camille : SHEN. PHOTO.
- Moi : Plus tard. Faut que je m'installe.
- Camille : Tu vas survivre ?
- Moi : Je sais pas.

**Choix : Comment j'occupe le territoire ?**

- A. Je range discrètement, je ne touche à rien → 💰 0 / 😊 -1 / ⭐ 0
- B. Je sors mes livres, ma plante, je m'impose dans l'espace → 💰 0 / 😊 +1 / ⭐ 0
- C. Je garde ma valise faite, prête à partir si ça tourne mal → 💰 0 / 😊 0 / ⭐ +1

---

### J10 — Dimanche 12 juin · Cuisine Heng · 08:00

**Prose** :
Premier petit-déjeuner. Il porte un pull noir et il a les cheveux mouillés. Il prépare un café qui sent fort. Je n'ose pas lui dire que je ne bois pas de café, parce que ça aurait l'air d'un caprice de fausse fiancée.

— Thé ? me demande-t-il.
— Oui, merci.
— Quel thé ?
— Celui que vous voulez.
— Ce n'est pas une réponse.
— Long Jing s'il y en a.

Il se retourne lentement.

— Vous connaissez le Long Jing.
— Ma mère m'a élevée avec.
— Votre mère est française.
— Ma mère lit Duras et boit du thé chinois. Elle n'aime pas qu'on la résume.

Il fait le thé. En silence. Il le fait bien — il chauffe la théière d'abord, il rince les feuilles, il jette la première eau. Mon arrière-grand-mère aurait approuvé.

**Choix : Comment j'occupe le silence ?**

- A. Je lis le journal qu'il a posé sur la table → 💰 0 / 😊 0 / ⭐ +1
- B. Je tente la conversation : "Vous êtes allé à Hangzhou ?" → 💰 0 / 😊 +1 / ⭐ 0
- C. Je file dans ma chambre, j'évite l'inconfort → 💰 0 / 😊 -1 / ⭐ -1

---

### J11 — Lundi 13 juin · Studio Belleville (visite à maman) · 19:00

**Prose** :
J'ai préparé l'histoire avec Camille pendant deux jours. Je suis "stagiaire dans une équipe de paysagistes à Vincennes". L'équipe travaille sur "des potagers pédagogiques pour des écoles". Le chef s'appelle "Lao Chen", c'est un Sino-français de 60 ans. Camille a même créé un faux compte LinkedIn au cas où maman vérifie.

Maman vérifie jamais. Maman fait confiance.

Maman me regarde longuement quand j'arrive. Elle a un châle gris sur les épaules. Elle me dit :

— Tu as l'air différent.
— J'ai dormi.
— Tu as l'air d'avoir dormi dans un endroit chaud.

Je me détourne pour faire le thé.

**SMS Maman (le soir)** :

- Maman : Premier jour de stage. Comment ça s'est passé ?
- Moi : Bien.
- Maman : « Bien ». Tu écris « bien » depuis trois jours. Donne-moi un détail.

**Choix : Quel détail je donne ?**

- A. Un détail vrai (Tristan a fait du thé Long Jing comme grand-mère) → 💰 0 / 😊 +1 / ⭐ 0 [risque détection]
- B. Un détail menteur (Lao Chen a parlé de la pluie) → 💰 0 / 😊 -2 / ⭐ +1
- C. Je promets de l'appeler dimanche pour de vrai → 💰 0 / 😊 0 / ⭐ 0 [unlocks: scene\_dimanche]

---

### J12 — Mardi 14 juin · Appartement Heng · 12:01

**SMS Maman** :

- Maman : Premier jour de stage. Comment ça s'est passé ?
- Moi : Bien.
- Maman : « Bien ». Tu écris « bien » depuis trois jours. Donne-moi un détail.
- Moi : Tiens. La courge du potager a doublé en deux jours. Lao Chen dit que c'est l'humidité.
- Maman : On respire avec toi, dans la maison. T'oublies pas ça.

**Prose** :
Je regarde l'écran longtemps. La courge n'existe pas. Lao Chen non plus. Le stage non plus.

Je lui mens depuis douze jours et chaque mensonge en appelle un autre. Le pire c'est qu'elle me croit. Le pire c'est aussi qu'elle ne me croit peut-être pas, mais qu'elle joue le jeu.

Tristan entre dans la cuisine pendant que je tape la réponse. Il voit l'écran. Il ne dit rien. Il se sert un verre d'eau et il sort.

Plus tard, en passant devant ma chambre, il dit :

— Si vous avez besoin que quelqu'un confirme votre histoire à votre mère, dites-le-moi. J'ai un assistant qui peut jouer Lao Chen au téléphone.

Je le déteste pour cette gentillesse-là. Non parce qu'elle est moche. Parce qu'elle tombe trop juste.

**Choix : Comment je réagis à sa proposition ?**

- A. Je refuse fermement (je ne mêle personne à mes mensonges) → 💰 0 / 😊 +1 / ⭐ 0
- B. Je garde l'option en réserve sans répondre → 💰 0 / 😊 0 / ⭐ +1
- C. J'accepte (Lao Chen aura une voix grave et un accent du Sichuan) → 💰 0 / 😊 -2 / ⭐ +1

---

### J13 — Mercredi 15 juin · Appartement Heng · 18:30

**Prose** :
Tristan me parle dans le couloir, à mi-voix, comme si c'était une mauvaise nouvelle.

— Ma tante organise un dîner samedi. Elle a tenu à vous voir.
— Madame Heng ?
— Elle-même.
— C'est obligatoire ?
— Disons qu'elle l'a énoncé comme une invitation, mais que c'en est un ordre.

Je rigole malgré moi. Il me regarde, surpris. C'est probablement le premier rire que je lâche dans cet appartement.

— Qu'est-ce qui vous fait rire ?
— Que vous ayez peur de votre tante.
— Tout le monde a peur de ma tante.
— Y compris vous ?
— Y compris moi. Surtout moi.

**SMS Camille** :

- Moi : Dîner avec la matriarche samedi.
- Camille : OH MON DIEU.
- Moi : Robe ?
- Camille : Mauvaise question. La vraie c'est : QUEL THÉ ?
- Moi : ?
- Camille : Si elle te sert un thé et que tu fais une remarque dessus, tu gagnes ou tu perds. Étudie. Vite.

**Choix : Comment je prépare le dîner ?**

- A. Je révise les thés chinois pendant 4h sur YouTube → 💰 0 / 😊 -1 / ⭐ +2
- B. Je m'en remets à mes souvenirs de grand-mère → 💰 0 / 😊 +1 / ⭐ +1
- C. Je n'étudie pas, je veux être moi-même → 💰 0 / 😊 0 / ⭐ 0

---

### J14 — Samedi 18 juin · Appartement Heng (dîner familial) · 20:30

**Prose** :
Madame Heng porte un qipao bleu marine. Elle a 58 ans et le port d'une femme qui a déjà gagné des batailles que je ne connaîtrai jamais. Elle me tend la main. Je la prends.

— Mademoiselle Marchand. Tristan m'a beaucoup parlé de vous.
— Très peu, je le crains.
— C'est pour ça qu'il m'a beaucoup parlé.

Le dîner. Six personnes autour de la table — Madame Heng, Tristan, son cousin Adrien, sa femme Léa, une cousine d'Asie qui ne parle pas français, et moi.

On sert le thé. Madame Heng me regarde porter la tasse à mes lèvres.

— Long Jing ? Belle initiative.
— C'est de la première récolte ? je demande.
— Je l'espère. C'est ce qu'a dit le marchand.
— Je crois que c'est de la deuxième.

Silence à table. Madame Heng repose sa tasse.

— Vraiment ?
— L'amertume arrive trop tôt. La première récolte est plus douce sur la fin.

Elle me regarde longuement. Vraiment longuement.

— Tu as raison, ma fille. Je vais avoir une conversation avec mon marchand demain.

Elle a dit *ma fille*. En français. Ce n'est pas anodin.

**Choix : Comment je continue la soirée ?**

- A. Je reste discrète, je laisse l'effet retomber → 💰 0 / 😊 +1 / ⭐ +2
- B. Je continue à participer naturellement (anecdote sur grand-mère) → 💰 0 / 😊 +2 / ⭐ +3
- C. Je m'éclipse aux toilettes pour reprendre mon souffle → 💰 0 / 😊 -1 / ⭐ +1

## ACTE 2 — LA VIE COMMUNE

### J15 — Dimanche 19 juin · Studio Belleville · 11:00

**Prose** :
J'ai dit à Tristan que je passais le dimanche chez maman. C'est vrai. Mais c'est aussi un soulagement de quitter l'appartement Heng pour quelques heures.

Maman m'a fait des dumplings au porc-ciboulette. Elle est fatiguée — les séances de dialyse l'épuisent — mais elle voulait absolument cuisiner. Je l'ai laissée faire. Aider quelqu'un qui veut cuisiner pour vous, c'est lui voler quelque chose.

— Tu as l'air pensive, dit-elle.
— J'ai trop réfléchi cette semaine.
— Tu réfléchis toujours trop. Mange.

Le porc est parfait. Le tofu fumé qu'elle ajoute toujours à la farce vient de la boutique de Madame Wong rue de Belleville. C'est une saveur que je ne retrouve nulle part ailleurs.

**Choix : Je lui dis quelque chose ?**

- A. Je commence à lui dire la vérité (je m'arrête à mi-phrase) → 💰 0 / 😊 -1 / ⭐ 0
- B. Je lui demande de me parler de papa pour la première fois depuis 5 ans → 💰 0 / 😊 +1 / ⭐ 0
- C. Je profite, en silence, de chaque dumpling → 💰 0 / 😊 +2 / ⭐ 0

---

### J16 — Lundi 20 juin · Appartement Heng · 22:30

**Prose** :
Tristan rentre tard. Je suis dans le salon, en pyjama, en train de lire *L'Amant* de Duras pour la quatrième fois cette année.

Il s'arrête en me voyant.

— Vous lisez Duras.
— Vous trouvez ça étonnant ?
— Je vous voyais plus du genre Annie Ernaux.
— Vous me voyez comment exactement ?
— …
— Allez. Dites.
— Quelqu'un qui n'aime pas les détours.
— Duras fait que des détours.
— C'est pour ça que vous la lisez.

Il dit ça avec un demi-sourire. Premier demi-sourire en seize jours.

**Choix : Je continue la conversation ?**

- A. Je lui pose une question sur lui (sa lecture du dimanche) → 💰 0 / 😊 +2 / ⭐ 0
- B. Je hoche la tête, je retourne à mon livre → 💰 0 / 😊 0 / ⭐ +1
- C. Je ferme le livre, je vais me coucher → 💰 0 / 😊 -1 / ⭐ 0

---

### J17 — Mardi 21 juin · Hôpital Tenon · 18:45

**Prose** :
Maman a une séance qui s'est mal passée. Sa tension est tombée. Ils l'ont gardée deux heures de plus en observation.

Je suis dans le couloir du 4e étage. Lumière néon. Personne. Je m'assois par terre contre le mur. Mes mains tremblent. Je ne pleure pas — je suis trop fatiguée pour pleurer — mais quelque chose tombe quand même de mes yeux. Deux gouttes, pas plus.

Je crois que personne ne me voit.

Je rentre vers 21h. Tristan est dans la cuisine. Il fait semblant de chercher quelque chose dans le frigo. Je sais qu'il fait semblant parce que le frigo est vide — il commande tout en livraison.

— Vous avez dîné ? demande-t-il.
— Non.
— Je vais vous faire des œufs.
— Pas la peine.
— C'est moi qui vois.

Il fait des œufs brouillés. Ils sont parfaits. Il met juste un peu de ciboulette. Je mange en silence. Il ne pose aucune question.

**Choix : Comment je reçois ce geste ?**

- A. Je le remercie avec une formule polie → 💰 0 / 😊 0 / ⭐ +1
- B. Je lui dis vraiment merci, en le regardant dans les yeux → 💰 0 / 😊 +2 / ⭐ 0
- C. Je mange et je file me coucher sans un mot → 💰 0 / 😊 -1 / ⭐ 0

---

### J18 — Mercredi 22 juin · Hôpital Tenon · 11:00

**Prose** :
Maman me dit, presque en passant :

— Le Dr Aubin m'a parlé d'un confrère qui peut me prendre en suivi rapproché. Le Dr Mercier. Il paraît qu'il est très bien.
— Le Dr Mercier ?
— C'est lui-même qui m'a appelée hier. Il m'a dit que mon dossier l'intéressait.

Le Dr Mercier est le meilleur néphrologue de Paris. Je ne le connais pas mais je connais son nom — Camille m'a fait lire un article sur lui dans Le Monde. Il consulte 20 patients par mois. Il ne prend pas de nouveaux dossiers depuis 3 ans.

— Il t'a appelée ?
— Oui. Apparemment, mon profil est rare. C'est un coup de chance, ma fille. Tu vois, des fois la vie aide.

Je souris. Je l'embrasse. Je ressors.

Dans la rue, je sors mon téléphone et je tape un seul SMS.

**SMS Tristan** :

- Moi : Vous avez fait quoi ?
- Tristan : Pardon ?
- Moi : Le Dr Mercier. Vous avez fait quoi.
- Tristan : Rien que vous deviez savoir.
- Moi : Répondez.
- Tristan : J'ai pris contact, il m'a accordé une faveur. C'est tout.
- Moi : Ce n'est pas tout. C'est beaucoup.

**Choix : Comment je réagis ?**

- A. Je rentre furieuse, je veux lui faire une scène → 💰 0 / 😊 -1 / ⭐ +1
- B. Je reste calme, je vais lui parler posément ce soir → 💰 0 / 😊 +1 / ⭐ +1
- C. Je ne dis rien, je note dans mon carnet : *"Il fait des choses sans demander."* → 💰 0 / 😊 +2 / ⭐ 0

---

### J19 — Jeudi 23 juin · Appartement Heng · 21:00

**Prose** :
Confrontation.

— Pourquoi vous avez fait ça ?
— Le contrat dit qu'on doit avoir l'air crédible. Une fiancée dont la mère meurt dans un hôpital de quartier, ce n'est pas crédible pour ma famille.
— Vous mentez.
— Pardon ?
— Vous mentez. Vous l'avez fait pour moi. Pas pour le contrat. Pour moi.

Il se tait. Il pose son verre. Il dit, calmement :

— Et alors ?
— Et alors je ne sais pas comment recevoir ça. Je suis désolée mais je ne sais pas.

Je pars dans ma chambre. Je ferme la porte. Je l'entends rester debout dans le salon longtemps. Très longtemps.

**SMS Camille** :

- Moi : Camille.
- Camille : Quoi.
- Moi : Le glaçon a fait quelque chose de pas-glaçon.
- Camille : DÉTAIL.
- Moi : Médecin top niveau pour maman. Sans rien dire.
- Camille : Shen. Shen. SHEN.
- Camille : C'est le scénario d'un drama coréen.
- Moi : Je sais.

**Choix : La nuit, dans ma chambre ?**

- A. Je sors, je vais lui parler → 💰 0 / 😊 +2 / ⭐ 0
- B. Je reste, mais je lui envoie un SMS de remerciement bref → 💰 0 / 😊 +1 / ⭐ +1
- C. Je dors, on en reparle un autre jour → 💰 0 / 😊 0 / ⭐ 0

---

### J20 — Vendredi 24 juin · Appartement Heng · 02:30

**Prose** :
Je n'arrive pas à dormir. Je sors dans le salon pour aller boire de l'eau. Tristan est endormi dans son fauteuil, un livre ouvert sur le ventre — Annie Ernaux, *La place*. Il a écouté ce que je lui ai dit l'autre jour.

Il a un grain de beauté sous l'oreille gauche que je n'avais jamais vu.

Je prends le plaid sur le canapé. Je le pose sur lui sans le toucher. Il bouge à peine. Il dort vraiment.

Je retourne dans ma chambre.

Le lendemain matin, le plaid est plié sur le canapé, le livre est rangé. Il ne dit rien. Moi non plus.

**Choix : Le matin, en le voyant à la cuisine ?**

- A. Je fais comme si rien ne s'était passé → 💰 0 / 😊 0 / ⭐ +1
- B. Je lui dis "vous étiez fatigué hier soir" — petit clin d'œil → 💰 0 / 😊 +2 / ⭐ 0
- C. Je le tease : "vous savez que j'ai ressorti l'artillerie lourde des plaids" → 💰 0 / 😊 +1 / ⭐ -1

---

### J21 — Samedi 25 juin · Café Hanami, près du campus · 16:00

**Prose** :
Camille a tout organisé. Elle a "par hasard" donné rendez-vous à Tristan dans son café préféré, en sachant qu'elle y serait avec moi. Sauf que je ne le savais pas.

Je vois Tristan entrer. Il me voit. Il s'arrête.

— Camille, tu as fait quoi ?
— Je l'ai invité à boire un café. Y a un problème ?

Tristan s'assoit. Camille se lève dramatiquement.

— Bon. Je vais aux toilettes, ça va prendre vingt minutes. Vous discutez. Je ne reviendrai pas avant que vous ayez parlé d'autre chose que de tableaux Excel.

Elle part. Tristan me regarde. Je le regarde. On éclate de rire en même temps. Premier rire partagé.

Pendant qu'on rit, Camille passe en douce par derrière, paie l'addition à l'avance, et s'éclipse. On ne s'en rend compte qu'une heure plus tard.

**SMS Camille (le soir)** :

- Camille : Alors ?
- Moi : Tu es manipulatrice et géniale.
- Camille : Réponds à la question.
- Moi : On a parlé d'archi. Il connaît Zaha Hadid mieux que moi.
- Camille : C'est quoi ce drama subtil.
- Moi : C'est rien. C'est un café.
- Camille : C'EST PAS RIEN.

**Choix : Le soir, j'écris dans mon carnet ?**

- A. Une longue page sur les yeux gris-vert → 💰 0 / 😊 +2 / ⭐ 0
- B. Trois lignes factuelles : "On a ri. C'est tout." → 💰 0 / 😊 +1 / ⭐ +1
- C. Rien. Je ferme le carnet sans écrire → 💰 0 / 😊 0 / ⭐ 0

---

### J22 — Dimanche 26 juin · Cour de l'immeuble Heng · 10:00

**Prose** :
Je descends sortir les poubelles (oui, je sors les poubelles, même dans cet immeuble — je refuse que la concierge le fasse pour moi). Je passe devant le local à vélos.

Mon vieux vélo est là. Sauf qu'il n'est plus mon vieux vélo. Il a été nettoyé. Le cadre a été redressé. La selle déchirée a été remplacée. Les pneus sont neufs. Il y a même un panier en osier à l'avant.

Sur le guidon, un mot manuscrit : *"Pour les livraisons. — T."*

Je reste plantée. Cinq minutes. Peut-être dix.

**Choix : Je remonte et je dis quoi ?**

- A. Merci, simplement → 💰 0 / 😊 +2 / ⭐ +1
- B. Je ne dis rien, je sors avec le vélo → 💰 0 / 😊 +1 / ⭐ 0
- C. Je proteste : "vous ne devez pas m'acheter" → 💰 0 / 😊 -2 / ⭐ 0

---

### J23 — Lundi 27 juin · Cuisine Heng · 09:15 ⭐ SCÈNE CANONIQUE

**Prose** :
Petit-déjeuner. Je mange des fraises. J'ai acheté une barquette pour 6€ au marché de la rue Coquillière. C'est ma vengeance et mon plaisir réunis.

Tristan entre. Il s'arrête. Il regarde la barquette comme si c'était une grenade dégoupillée.

**Échange canonique** :

- Tristan : Tu sais que je suis allergique.
- Moi : C'est dans le contrat. Clause 14, tu as signé.
- Tristan : J'ai signé sous la contrainte affective.
- Moi *(je m'arrête, fraise à mi-chemin)* : Pardon ?
- Tristan *(silence)* : J'ai dit *commerciale*. Sous la contrainte commerciale.
- Moi : Tu as dit *affective*.
- Tristan *(il sort de la pièce)* :

**Prose** :
Je reste seule dans la cuisine avec ma fraise. Le frigo bourdonne. Je m'entends respirer.

Affective.

**Choix : Je fais quoi maintenant ?**

- A. Je finis mes fraises, dignement, en silence → 💰 0 / 😊 +1 / ⭐ +2
- B. Je rappelle Camille en panique → 💰 0 / 😊 0 / ⭐ -1
- C. Je vais frapper à la porte de son bureau → 💰 0 / 😊 -1 / ⭐ +1 [risqué]

---

### J24 — Mardi 28 juin · Studio Belleville · 19:00

**Prose** :
Je passe chez maman. Je veux juste être avec elle, sans réfléchir à Tristan, sans réfléchir aux fraises, sans réfléchir à *affective*.

Elle remarque tout, évidemment.

— Tu as un visage de fille amoureuse qui ne veut pas l'être.
— Maman.
— Quoi ? Je te dis ce que je vois.
— Je suis pas amoureuse.
— Je n'ai pas dit que tu l'étais. J'ai dit que tu avais le visage de quelqu'un qui ne veut pas l'être.

Elle a 50 ans, elle est malade, et elle continue d'être plus fine que moi. C'est insupportable. C'est rassurant aussi.

**SMS Camille** :

- Moi : Camille, ma mère a deviné.
- Camille : Deviné quoi ?
- Moi : Que je sais pas.
- Camille : Donc tu sais.
- Moi : Camille je raccroche.

**Choix : Je dis quoi à maman ?**

- A. Je nie tout : "Tu te fais des films." → 💰 0 / 😊 -1 / ⭐ 0
- B. Je détourne : "C'est mon stage qui me crève." → 💰 0 / 😊 -2 / ⭐ +1
- C. J'avoue à demi-mot : "C'est compliqué, je te raconte un autre jour." → 💰 0 / 😊 +1 / ⭐ 0

---

### J25 — Mercredi 29 juin · Appartement Heng · 22:00

**Prose** :
Silence depuis le matin du *affective*. Il rentre tard, mange dans son bureau, sort tôt. Je fais pareil de mon côté.

C'est étrange comme deux silences peuvent occuper 350 m².

Je l'entends taper sur son clavier. Il travaille. Il fait toujours semblant de travailler quand il est mal.

Vers 23h, il sort de son bureau. Il a l'air fatigué.

— Vous êtes encore debout ?
— Oui.
— Vous voulez du thé ?
— D'accord.

Il fait du thé. Long Jing. On boit en silence. Il ne dit rien. Je ne dis rien. Quelque chose se règle quand même.

**Choix : Avant de me coucher, je lui dis ?**

- A. "Bonne nuit, Tristan." (la première fois que je l'appelle par son prénom) → 💰 0 / 😊 +2 / ⭐ +1
- B. Un signe de tête, je file → 💰 0 / 😊 0 / ⭐ +1
- C. "On en reparle, du mot d'avant-hier ?" → 💰 0 / 😊 -1 / ⭐ +1 [risqué]

---

### J26 — Jeudi 30 juin · Tour Heng (déjeuner imposé) · 13:00

**Prose** :
Madame Heng me convoque pour un déjeuner. Sans Tristan. *"Juste nous deux."*

Restaurant chinois discret du 16e. Elle commande pour nous deux sans me demander. Elle a une voix très douce et un regard très tranchant. Combinaison redoutable.

— Mademoiselle Marchand.
— Madame.
— Je voulais vous voir seule. Mon neveu m'a dit que vous lisiez Marguerite Duras.
— C'est exact.
— *L'Amant* ou *Hiroshima* ?
— *L'Amant*. Quatre relectures cette année.
— Pourquoi quatre fois la même chose en un an ?
— Parce que je trouve quelque chose de différent à chaque fois.

Elle me sourit.

— Continuez. Vous m'intéressez.

Le déjeuner dure deux heures. Elle ne me demande aucune question piège. Mais à la fin :

— Mademoiselle Marchand. Je voudrais vous dire que je vois ce que je vois. Et que je n'en parlerai pas. Pour l'instant.

Je ne sais pas ce qu'elle voit. Mais elle voit.

**Choix : Je rentre et je raconte à Tristan ?**

- A. Tout, dans le détail → 💰 0 / 😊 0 / ⭐ +1
- B. Le strict minimum, la phrase finale → 💰 0 / 😊 +1 / ⭐ +1
- C. Rien. Je garde ça pour moi → 💰 0 / 😊 -1 / ⭐ +2

---

### J27 — Vendredi 1er juillet · Appartement Heng · 18:00

**Prose** :
Je rentre des livraisons (oui, je continue à livrer trois jours par semaine, c'est dans mes propres règles, c'est dans aucun contrat). Je suis trempée, j'ai un genou cassé qui me fait mal depuis le 3 juin et qui ne guérit pas.

Tristan est là. Il regarde mon genou.

— Vous voulez que je regarde ?
— Vous êtes médecin ?
— Trois ans de médecine avant de basculer. Je peux désinfecter ça correctement.

J'hésite. Je m'assois. Il s'agenouille devant moi avec un kit de premiers secours impeccable. Il nettoie. Il colle un pansement. Ses mains ne tremblent pas.

Tout dure quatre minutes. Je ne respire pas pendant les quatre minutes.

— Voilà. Désinfectez ça matin et soir. Vous devriez vraiment voir un médecin pour ce genou.
— Vous êtes médecin.
— Pas vraiment.
— Suffisamment.

Il sourit. Vraiment, cette fois. Pas un demi-sourire. Un vrai.

**Choix : Je fais quoi maintenant ?**

- A. Je dîne avec lui (pour la première fois) → 💰 0 / 😊 +2 / ⭐ +1
- B. Je file dans ma chambre, je suis trop bouleversée → 💰 0 / 😊 0 / ⭐ 0
- C. Je le remercie poliment et je vais lire → 💰 0 / 😊 +1 / ⭐ +1

---

### J28 — Dimanche 3 juillet · Cuisine Heng · 11:00

**Prose** :
Je descends faire le café (le sien, pas le mien — je continue avec mon thé). Sur le plan de travail, il y a une barquette de fraises. Pas la mienne — moi je les avais finies. Une nouvelle barquette. Bio. 8€ à l'étiquette.

Pas de mot.

Je souris dans la cuisine vide.

**SMS Camille** :

- Moi : Camille.
- Camille : Quoi.
- Moi : Il m'a acheté des fraises.
- Camille : ALERTE. ALERTE. ALERTE.
- Moi : Calme-toi.
- Camille : C'EST DU LANGAGE D'AMOUREUX SI TU SAIS LIRE.
- Moi : Camille je raccroche.

**Choix : Je fais quoi des fraises ?**

- A. Je les mange avec un yaourt grec, je remercie pas → 💰 0 / 😊 +2 / ⭐ +1
- B. Je laisse un mot à côté de la barquette : *"Merci."* → 💰 0 / 😊 +1 / ⭐ +1
- C. Je laisse un mot piquant : *"Vous voulez essayer une bouchée ?"* → 💰 0 / 😊 0 / ⭐ -1

---

### J29 — Lundi 4 juillet · Appartement Heng · 20:00

**Prose** :
Tristan rentre. Il a un dossier sous le bras et une nouvelle dans l'œil.

— Hong Kong dans deux semaines.
— Pardon ?
— Le gala annuel de la fondation familiale. Vous m'accompagnez. C'est dans le contrat.
— Hong Kong.
— Ma tante a insisté pour que vous y soyez. Elle veut vous présenter.

Je m'assois. Hong Kong. Je ne suis jamais sortie d'Europe. Mon passeport est tout neuf, je l'avais fait à 18 ans pour aller à Londres et il n'a jamais servi.

— Combien de temps ?
— Une semaine. Hôtel familial. Vols réservés. Vous aurez besoin d'une robe.

Il ajoute, sans me regarder :

— Si vous voulez, je peux vous accompagner pour la robe. Sinon, ma tante a une boutique de confiance qui peut envoyer trois options.

**Choix : La robe ?**

- A. Je vais avec lui à la boutique → 💰 -1500 / 😊 +1 / ⭐ +2 [unlocks: scene\_robe]
- B. Je laisse Madame Heng envoyer les options → 💰 0 / 😊 -1 / ⭐ +1
- C. J'achète moi-même quelque chose au marché Saint-Pierre → 💰 -200 / 😊 +2 / ⭐ -1

---

### J30 — Mardi 5 juillet · Hôpital + Appartement · journée

**Prose** :
Maman a une bonne séance aujourd'hui. Le Dr Mercier l'a rassurée sur les chiffres. Elle souriait en me racontant. Elle a ri pour la première fois depuis longtemps.

Je rentre chez Tristan. Je tombe sur son téléphone qui vibre sur la table. Je ne regarde pas — c'est pas mon genre — mais le nom du contact reste affiché : *Vincent*. Le prénom est barré d'un trait noir dans son répertoire (je l'avais déjà vu une fois). Je n'avais pas demandé qui c'était.

Tristan rentre, voit le téléphone, le retourne immédiatement.

— Quelqu'un d'important ? je demande.
— Mon frère. Demi-frère. Il essaie de me joindre depuis trois mois.
— Vous lui parlez ?
— Non.
— Pourquoi ?
— C'est compliqué.
— Vous me direz un jour ?
— Probablement.

**Choix : J'insiste ou pas ?**

- A. J'insiste : "Vous me direz quand ?" → 💰 0 / 😊 -1 / ⭐ +1
- B. Je laisse tomber, j'attends qu'il vienne → 💰 0 / 😊 +1 / ⭐ +1
- C. Je fais ma propre recherche sur Internet ce soir → 💰 0 / 😊 0 / ⭐ +2 [unlocks: vincent\_intel]

---

### J31 — Mercredi 6 juillet · Appartement (appel Maman) · 21:00

**SMS puis appel** :

- Maman : Tu peux m'appeler ?
- Moi : Oui, je te rappelle dans 5 min.

**Prose** :
J'appelle. Sa voix est plus posée que d'habitude. Trop posée.

— Ma fille.
— Oui ?
— Je voulais te dire. J'ai senti ces dernières semaines que tu me cachais quelque chose. Je ne te demande pas quoi. Je veux juste que tu saches que je le sens.
— Maman…
— Non, écoute. Si c'est quelque chose qui te rend heureuse, je suis contente. Si c'est quelque chose qui te fait peur, sache que tu peux me le dire. Je ne te jugerai pas.
— …
— Je n'attends pas de réponse maintenant. Je t'embrasse.

Elle raccroche. Je reste avec le téléphone à l'oreille pendant une minute.

**Choix : Cette nuit ?**

- A. Je rappelle pour tout lui dire → 💰 0 / 😊 +3 / ⭐ -1 [⚠️ change le ton du drama]
- B. Je lui écris une longue lettre que je n'envoie pas → 💰 0 / 😊 +2 / ⭐ 0
- C. Je continue à mentir, je sécurise le traitement d'abord → 💰 0 / 😊 -2 / ⭐ +1

---

### J32 — Jeudi 7 juillet · Appartement Heng · 23:00

**Prose** :
Tristan toque à la porte de ma chambre. Il a un dossier dans la main.

— Je voudrais réviser certaines clauses du contrat.
— Lesquelles ?
— Toutes celles qui me semblent… inadaptées à la réalité.

Je me redresse sur le lit. Il s'assoit sur la chaise à côté.

— Article 14, par exemple. La clause sur les contacts physiques. Je voudrais qu'on ajoute la possibilité d'une révision conjointe en cas d'accord mutuel.
— Vous voulez le droit de m'embrasser.
— *(silence)* Pas exactement. Je veux qu'on enlève l'interdiction préventive.
— Pourquoi ?
— Parce qu'elle ne correspond plus à ce que je crois être.

Il pose le dossier. Il sort.

Je ne rouvre pas le dossier de la nuit.

**Choix : Que je fais le lendemain ?**

- A. Je biffe la clause moi-même au stylo et je laisse sur la table → 💰 0 / 😊 +2 / ⭐ +1
- B. J'ajoute mes propres conditions au verso → 💰 0 / 😊 +1 / ⭐ +2
- C. Je rends le dossier intact et je lui dis : "On en reparle après Hong Kong." → 💰 0 / 😊 0 / ⭐ +1

---

### J33 — Vendredi 8 juillet · Bureau de Tristan · 16:00

**Prose** :
Je suis dans son bureau pendant qu'il est sorti. Je cherche un livre. Sur l'étagère du bas, il y a une pile de papier à en-tête.

*Cabinet Heng & Associés — Notaires — Shanghai depuis 1962.*

Je me fige.

Je connais ce nom. Je l'ai vu une fois, sur les papiers du mariage de maman. Quand j'étais ado, j'avais ouvert sa boîte aux trésors. Il y avait un certificat de mariage tamponné par un cabinet notarial à Shanghai. Le nom commençait par *H*.

Je ne me souviens plus si c'était *Heng*. Mais ça ressemblait.

Je remets le papier exactement où il était.

**Choix : Je fais quoi de cette information ?**

- A. Je note dans mon carnet : *"Et si c'était eux ?"* → 💰 0 / 😊 -1 / ⭐ +2 [unlocks: archive\_intel]
- B. J'oublie, c'est sûrement une coïncidence → 💰 0 / 😊 0 / ⭐ 0
- C. J'appelle maman pour vérifier le nom du notaire → 💰 0 / 😊 -2 / ⭐ +1 [⚠️ peut alerter Hélène]

---

### J34 — Samedi 9 juillet · Studio Belleville · 14:00

**Prose** :
Je suis chez maman, je cherche un prétexte pour ouvrir sa boîte aux trésors. Elle est dans le placard du haut, derrière les serviettes de bain.

— Maman, je peux prendre une serviette ?
— Bien sûr, ma fille.

Je grimpe. Je cherche. La boîte est en bois laqué noir. Elle sent encore son parfum d'il y a vingt ans (Chanel N°5, fidèle). À l'intérieur, il y a quatre choses : la photo de leur unique rencontre à Paris en 1999, mon premier dessin de papa imaginaire (j'avais 5 ans), un ruban rouge, et le certificat de mariage.

Je regarde le certificat. Le tampon en bas. Caractères chinois traditionnels.

*Heng & Associés.*

Je referme la boîte. Je redescends. Je ne dis rien à maman.

**Choix : Qu'est-ce que je fais avec cette information ?**

- A. Je décide de tout dire à Tristan dès ce soir → 💰 0 / 😊 -1 / ⭐ +1
- B. Je ne dis rien — je veux comprendre seule d'abord → 💰 0 / 😊 -2 / ⭐ +2
- C. J'envoie une photo à Camille pour qu'elle creuse → 💰 0 / 😊 0 / ⭐ +1 [unlocks: camille\_recherche]

---

### J35 — Dimanche 10 juillet · Aéroport CDG · 08:00 ✈️ DÉPART HONG KONG

**Prose** :
Je porte un trench beige. Tristan porte un costume noir. On a l'air d'un couple de cinéma. Sauf qu'on est un faux couple qui ne sait plus si c'est faux.

Sa tante nous attend en business class. Elle est ravie. Elle commande du champagne dès le décollage. Tristan en boit une demi-coupe. Moi je n'y touche pas.

— Vous ne buvez pas ? me demande Madame Heng.
— Pas avant 11h.
— Vous avez des principes ?
— J'ai un foie.

Elle rit. Tristan aussi.

**Trigger bourse : HENG +12%** (signature contrat asiatique, action que les joueurs ayant investi voient grimper).

**Choix : Pendant le vol, je fais quoi ?**

- A. Je dors → 💰 0 / 😊 +2 / ⭐ 0
- B. Je relis *L'Amant* (encore) → 💰 0 / 😊 +1 / ⭐ +1
- C. Je commence à parler vraiment avec Madame Heng → 💰 0 / 😊 0 / ⭐ +3

---

### J36 — Lundi 11 juillet · Hôtel Heng, Hong Kong · 23:00 (heure locale)

**Prose** :
Notre suite donne sur la baie de Victoria. Les tours brillent. La nuit tombe sur Kowloon. Je n'ai jamais vu autant de lumière en même temps. C'est presque vulgaire et c'est magnifique.

Je suis sur le balcon en peignoir blanc. Tristan vient me rejoindre, deux verres d'eau dans les mains.

— Vous regardez quoi ?
— Tout. Je regarde tout.
— Vous voulez rester combien de temps ?
— Pour toujours.
— Vous savez qu'il est 23h ici, et 17h à Paris.
— Je sais. Mon corps ne sait pas.

Il rit doucement. On reste comme ça, accoudés à la balustrade, pendant 20 minutes. On ne dit rien. C'est confortable.

**Choix : Avant de me coucher ?**

- A. Je l'embrasse sur la joue, naturellement → 💰 0 / 😊 +3 / ⭐ +1 [⚠️ rupture du contrat clause 14]
- B. Je lui souhaite bonne nuit en mandarin : *Wǎn'ān.* → 💰 0 / 😊 +2 / ⭐ +1
- C. Je file dans ma chambre sans rien dire → 💰 0 / 😊 0 / ⭐ 0

---

### J37 — Mardi 12 juillet · Hong Kong, marché de Mong Kok · 10:00

**Prose** :
Tristan a un meeting toute la matinée. Je sors seule. Mong Kok. Le marché. L'odeur de l'humidité, du poisson, du jasmin, de la friture, de l'encens. Tout en même temps.

Je me sens chez moi. C'est étrange. Je ne suis jamais venue. Mais ma grand-mère m'a parlé de ce genre de marché toute mon enfance. Mes pieds savent où aller.

J'achète un éventail en bambou peint à la main. 40 HKD. Le vendeur me parle en cantonnais. Je réponds en mandarin. Il rit, il passe au mandarin avec un fort accent.

— D'où viens-tu ?
— De Paris. Mais ma mère est française et mon père chinois.
— Le visage de la France et la bouche du Fujian.

Je m'arrête. Je le regarde. Il sourit, il ne sait pas ce qu'il vient de dire.

**Choix : Qu'est-ce que je fais de cette remarque ?**

- A. Je note dans mon carnet : *"Bouche du Fujian. Madame Heng a dit la même chose."* → 💰 0 / 😊 -1 / ⭐ +2
- B. J'oublie, c'est un cliché → 💰 0 / 😊 0 / ⭐ 0
- C. Je rachète quelque chose juste pour parler avec lui plus longtemps → 💰 -50 / 😊 +1 / ⭐ +1

---

### J38 — Mercredi 13 juillet · Suite Heng · soirée

**Prose** :
Robe pour le gala demain soir. Je l'essaye dans la suite, devant le miroir en pied. Bleu nuit, dos nu, simple, parfaite.

J'entends Tristan ouvrir la porte derrière moi. Je me retourne.

Il s'arrête. Il ne dit rien. Il me regarde pendant trois secondes — très longues, trois secondes. Puis il dit :

— Vous êtes prête.
— Oui.
— Je voulais dire… *(il s'arrête, il cherche)* …vous serez bien demain.
— Merci.

Il sort. Je reste devant le miroir. Je me regarde, et pour la première fois depuis longtemps, je trouve que je suis belle. Pas attendrissante, pas mignonne, pas "bien pour ce que tu vis". Belle.

**Choix : Avant de me coucher, j'écris dans mon carnet ?**

- A. *"Je crois qu'il m'aime. Et je crois que je l'aime aussi. C'est un problème."* → 💰 0 / 😊 +3 / ⭐ 0
- B. *"Demain c'est le gala. Concentre-toi. Le reste ne compte pas."* → 💰 0 / 😊 +1 / ⭐ +1
- C. Rien. Je referme le carnet → 💰 0 / 😊 0 / ⭐ 0

---

### J39 — Jeudi 14 juillet · Hôtel Heng, gala · 20:00

**Prose** :
Je descends l'escalier d'apparat. Tristan m'attend en bas, en smoking. Il lève les yeux. Il s'arrête net. Cette fois, il ne fait pas semblant de pas s'arrêter.

Madame Heng nous regarde, avec un demi-sourire qui dit *je le savais*.

Le gala. Trois cents personnes. Des discours. Des photos. Tristan et moi en couple "officiel" pour la première fois. Je tiens son bras. Il tient le mien.

À 22h, on danse. Une valse. Je connais juste les pas de base — Camille m'avait fait répéter une heure avant de partir. Tristan me guide. Nos fronts se touchent au troisième tour. On reste comme ça pendant huit mesures. C'est plus long qu'un baiser. C'est plus fort.

Personne ne nous dérange. Personne n'ose.

**Choix : Après la danse ?**

- A. On sort sur la terrasse, on parle → 💰 0 / 😊 +3 / ⭐ +2
- B. On retourne à la table, on fait diversion → 💰 0 / 😊 +1 / ⭐ +1
- C. Je prétexte un mal de tête, je monte → 💰 0 / 😊 -1 / ⭐ +1

---

### J40 — Vendredi 15 juillet · Hôtel Heng · 11:00

**Prose** :
Je prends mon café (mon thé) au bar de l'hôtel. Un homme s'approche. Beau, charmant, faux. Je le reconnais avant même qu'il ne parle.

— Mademoiselle Marchand. Quel hasard.
— Vincent Heng.
— Vous m'avez identifié vite.
— Vous m'aviez approchée il y a six mois sous un faux nom. Vous me proposiez de poser pour des photos. J'avais refusé.
— J'avais espéré que vous m'oubliez.
— Je n'oublie pas.

Il s'assoit sans demander. Il commande un café.

— Mon frère a beaucoup de chance.
— Pardon ?
— Vous, en faux couple, en vrai couple, peu importe. Il a de la chance.
— Vous savez que je suis sa fausse fiancée ?
— Tout NeoCity sait. Mais ne vous inquiétez pas, je ne dirai rien. C'est juste fascinant à observer.

Il sourit. Il part. Il a laissé une carte de visite sur la table. *V. Heng — Conseil stratégique.* Sans entreprise.

**Choix : Que je fais de la carte ?**

- A. Je la déchire devant lui → 💰 0 / 😊 +1 / ⭐ +2 [il l'a vu]
- B. Je la garde, je l'observe → 💰 0 / 😊 -1 / ⭐ +2
- C. Je la mets directement à la poubelle après son départ → 💰 0 / 😊 0 / ⭐ +1

---

### J41 — Samedi 16 juillet · Hong Kong, île de Lamma · journée

**Prose** :
Tristan a libéré sa journée. *"On va à Lamma."* Bateau de 30 minutes. Plage. Restaurant de fruits de mer.

On marche sur la plage pieds nus. Lui en chemise blanche relevée aux coudes, moi en robe d'été simple. On a l'air normal. C'est étrange à quel point ça me manquait, d'avoir l'air normal.

— Si on n'avait pas signé le contrat, on serait là quand même ? je demande.
— Sans doute pas. On ne se serait pas rencontrés.
— Et si on s'était rencontrés autrement ?
— Alors oui. On serait là quand même.

Il dit ça simplement. Sans ironie. Sans calcul.

On déjeune. Crevettes au gingembre, riz blanc, bok choy. Il rit de quelque chose que je dis. Je ris parce qu'il rit. Je n'ai pas ri comme ça depuis le décès de ma grand-mère il y a trois ans.

**Choix : En rentrant en bateau ?**

- A. Je m'endors sur son épaule → 💰 0 / 😊 +3 / ⭐ +1
- B. Je m'assois à côté de lui mais je garde de la distance → 💰 0 / 😊 +1 / ⭐ +1
- C. Je m'assois loin pour préserver le contrat → 💰 0 / 😊 -2 / ⭐ 0

---

### J42 — Dimanche 17 juillet · Hong Kong, dernier soir · 22:30

**Prose** :
Vincent est à un bar de l'hôtel. Il me croise dans le couloir, comme par hasard. Évidemment pas par hasard.

— Mademoiselle Marchand. Un dernier verre avant le départ ?
— Je n'ai pas envie.
— Juste cinq minutes. Je voulais vous dire quelque chose qui pourrait vous intéresser.

Je m'arrête. Je le regarde. Il sourit toujours pareil — ce sourire qui n'atteint pas les yeux.

— Mon frère a déjà eu trois fausses fiancées contractuelles avant vous. Vous êtes la quatrième. Je dis ça… je dis rien.

Il s'éloigne. Il sait qu'il a planté quelque chose.

(Vrai partiel : il y en a eu UNE. Vincent triple le chiffre exprès.)

**SMS à Camille** :

- Moi : Camille. Quatrième fausse fiancée. Vincent vient de me le dire.
- Camille : Quoi ?
- Moi : Tristan en aurait eu trois avant moi.
- Camille : C'est lui qui te le dit, toi tu sais que c'est suspect.
- Moi : Je sais.
- Camille : Demande à Tristan directement.
- Moi : Je sais pas si je veux la réponse.

**Choix : Comment je rentre dormir ?**

- A. Je demande à Tristan dès ce soir → 💰 0 / 😊 -2 / ⭐ +1
- B. J'attends Paris, je veux pas casser Hong Kong → 💰 0 / 😊 -1 / ⭐ +1
- C. Je note dans mon carnet et je dors → 💰 0 / 😊 -3 / ⭐ +2

## ACTE 3 — LE SECRET ÉCLATE

### J43 — Lundi 18 juillet · Vol retour Hong Kong-Paris · 11:00 (heure locale)

**Prose** :
Treize heures de vol pour réfléchir. Tristan dort à côté de moi en business. J'ai sa veste sur les genoux. Je regarde par le hublot — la mer de Chine, l'Asie qui défile en bleu.

Je repense à *quatre fausses fiancées*. Vincent ment, c'est sûr. Mais combien il y en a eu ? Une ? Deux ? La vérité fait mal même quand elle est petite.

Je repense aussi au papier à en-tête. *Heng & Associés, Shanghai*. Au certificat de mariage de maman. Aux mots de Madame Heng. *"La bouche de quelqu'un que j'ai connu."*

Trois choses qui ne devraient pas être liées. Et qui le sont peut-être.

**Choix : Une fois à Paris, dans la voiture qui nous ramène ?**

- A. Je demande à Tristan : "C'est qui Cabinet Heng & Associés à Shanghai ?" → 💰 0 / 😊 -2 / ⭐ +2 [unlocks: enquete]
- B. Je demande : "Combien de fausses fiancées avant moi ?" → 💰 0 / 😊 -3 / ⭐ +1
- C. Je ne demande rien. Je l'observe. → 💰 0 / 😊 -1 / ⭐ +2

---

### J44 — Mardi 19 juillet · Bureau de Tristan, Tour Heng · 14:00

**Prose** :
Tristan, sans le dire à Shen, fait sa propre recherche.

Il ouvre la base de données numérisée du cabinet familial. Il tape : *Marchand*. Trois résultats. Il clique sur celui de 1999.

*Marchand H. / Shen W. — septembre 1999. Mariage par procuration. Fujian. Témoins : néant. Notaire : H. Lihua.*

Il fronce les sourcils. *H. Lihua.* C'est sa tante.

Il n'avait jamais croisé ce dossier. Il n'a aucune raison de l'avoir croisé. C'est sa tante qui gère les archives de cette époque.

Il ne descend pas voir Shen ce soir. Il dîne au bureau. Il pense.

(Cette journée est observée à distance par le joueur — Shen ne sait pas ce qui se passe. C'est une narration au "il" pour bien marquer le retour à Shen au choix.)

**Prose chez Shen, le soir** :
Tristan rentre tard. Il est étrange. Il évite mon regard. Il dîne dans son bureau.

**Choix : Je fais quoi ?**

- A. Je vais le voir directement : "Qu'est-ce qui se passe ?" → 💰 0 / 😊 -1 / ⭐ +1
- B. Je le laisse, je note le changement → 💰 0 / 😊 -1 / ⭐ +2
- C. J'appelle Camille pour analyser → 💰 0 / 😊 0 / ⭐ +1

---

### J45 — Mercredi 20 juillet · Hôpital Tenon · 11:00 ⚠️ DEADLINE MAMAN

**Prose** :
Le Dr Mercier convoque les deux. Maman et moi.

— Le traitement a très bien pris. Les marqueurs sont stables. On peut envisager une stabilisation longue.

Maman me prend la main. Elle pleure doucement. Le Dr Mercier nous laisse seules quelques minutes.

— Tu as fait ça comment, ma fille ? me demande maman.
— J'ai trouvé une solution.
— Quelle solution ?
— Une solution qui marche.
— Tu me diras un jour ?
— Un jour.

Elle ne pousse pas. Elle ne pousse jamais.

**[Branche bifurcation]**

- Si argent ≥ 18 000€ payés à l'hôpital : `isMomTreatmentPaid = true`, mood +2 immédiat. Continuation normale.
- Si argent < 18 000€ : déclenchement de la branche "deuil", J46 alternatif avec annonce que le protocole ne pourra pas être renouvelé. Maman commence à décliner.

**Choix : En sortant de l'hôpital ?**

- A. Je passe au bureau de Tristan pour le remercier (il a contacté Mercier) → 💰 0 / 😊 +2 / ⭐ +1
- B. J'appelle papa biologique français (Antoine Marchand) pour la première fois en 10 ans → 💰 0 / 😊 -2 / ⭐ +2 [⚠️ contenu inattendu]
- C. Je rentre chez Tristan en silence → 💰 0 / 😊 +1 / ⭐ 0

---

### J46 — Jeudi 21 juillet · Couloir bureau Tristan · 17:00 ⭐ SCÈNE CANONIQUE

**Prose** :
Je viens chercher Tristan pour aller dîner. Je passe devant le bureau de Madame Heng — sa porte est ouverte. Elle sort dans le couloir au moment où je passe.

Elle me prend doucement le poignet. Geste tendre, mais fermé. Elle me regarde dans les yeux.

**Phrase canonique** :

> *"Tu as les yeux de ta mère, mais tu as la bouche de quelqu'un d'autre. Quelqu'un que j'ai connu."*

(En mandarin dans le texte original. Sous-titre français en italique.)

Elle me lâche. Elle continue son chemin. Elle ne se retourne pas.

Je reste dans le couloir.

**Choix : J'attends Tristan ou je vais chercher Madame Heng pour exiger une explication ?**

- A. Je vais frapper à la porte de Madame Heng tout de suite → 💰 0 / 😊 -2 / ⭐ +3 [unlocks: madame\_heng\_dialogue]
- B. J'attends Tristan, je lui en parle ce soir → 💰 0 / 😊 -1 / ⭐ +2
- C. Je note la phrase, je rentre seule → 💰 0 / 😊 -3 / ⭐ +1

---

### J47 — Vendredi 22 juillet · Bureau de Madame Heng · 11:00

**Prose** :
Je reviens à la Tour. Je demande un rendez-vous à l'assistante. Madame Heng me reçoit immédiatement.

— Vous savez ce que vous avez dit hier.
— Oui.
— De qui je tiens cette bouche, Madame ?
— Mademoiselle Marchand. Je ne suis pas en mesure de répondre à cette question.
— Pourquoi ?
— Parce que ce n'est pas mon histoire à raconter.
— C'est l'histoire de qui ?
— Demande à Zixuan. Je vous prie. Demandez à mon neveu.

Elle me regarde longtemps. Il y a une douceur immense dans son regard, et quelque chose qui ressemble à de la pitié — mais pas une pitié hautaine, une pitié de quelqu'un qui a vu les mêmes choses que vous trente ans plus tôt.

— Allez. Mais soyez douce avec lui. Il est en train d'apprendre quelque chose qu'il ignorait lui aussi.

**Choix : Je vais voir Tristan tout de suite ou j'attends ?**

- A. Tout de suite, dans son bureau → 💰 0 / 😊 -2 / ⭐ +2
- B. Ce soir, à l'appartement → 💰 0 / 😊 -1 / ⭐ +2
- C. Je le laisse venir vers moi → 💰 0 / 😊 -3 / ⭐ +1

---

### J48 — Samedi 23 juillet · Appartement Heng · 21:00

**Prose** :
— Tristan, qu'est-ce que ta tante a voulu dire ?
— Je ne sais pas.
— Tu mens.
— …
— Qu'est-ce que tu sais que je ne sais pas ?
— Shen, je ne suis pas prêt à te dire ce que j'ai trouvé. Je ne sais pas encore moi-même ce que ça veut dire.
— Tu as trouvé quoi ?
— Un dossier. Dans nos archives. Un dossier qui pourrait te concerner. Mais je veux le voir physiquement avant de te dire quoi que ce soit. Il est à Shanghai. J'ai demandé qu'on me l'envoie.
— Combien de temps ?
— Une semaine.
— Tristan. Si c'est ce que je crois, tu n'as pas le droit de me cacher ça une semaine.
— Et si c'est pire que ce que tu crois ?

Je le regarde. Il est blanc. Il ne ment pas en disant qu'il a peur de ce qu'il y a dans ce dossier.

**Choix : Je lui demande quoi maintenant ?**

- A. "Promets-moi de me montrer dès que tu l'as." → 💰 0 / 😊 -1 / ⭐ +2
- B. "Je veux le voir en même temps que toi." → 💰 0 / 😊 0 / ⭐ +3
- C. "Je vais à Shanghai moi-même la semaine prochaine." → 💰 -1500 / 😊 -2 / ⭐ +1 [⚠️ ouvre une branche]

---

### J49 — Dimanche 24 juillet · Studio Belleville · 15:00

**Prose** :
Je passe l'après-midi avec maman. Je veux la regarder, juste la regarder. Elle s'occupe de ses plantes sur le rebord de la fenêtre. Elle a un basilic qui sent fort, une menthe qui est en train de mourir, et un pied de tomate cerise qui s'accroche.

— Maman.
— Mmm ?
— Comment tu as rencontré papa ?
— *(elle se retourne, surprise)* Pourquoi tu me demandes ça ?
— Parce que tu m'as jamais raconté.
— Tu m'as jamais demandé.
— Je demande aujourd'hui.

Elle s'assoit. Elle réfléchit longtemps.

— C'était une agence à Paris. Une agence qui présentait des hommes chinois cherchant une épouse française. C'était très en vogue en 1998. Une de mes copines de fac l'avait fait — elle vit toujours à Pékin avec son mari, je crois. Moi j'ai répondu à une annonce. C'est tout.
— Et lui ?
— Il s'appelait Wenbo. Il avait deux ans de plus que moi. Il était ingénieur. Il était… *(elle s'arrête)* …il était doux. C'est tout ce que je peux te dire, ma fille. Il était doux.

Elle ne pleure pas. Elle ne tremble pas. Mais elle ne peut pas continuer.

**Choix : J'insiste ou pas ?**

- A. J'insiste : "Maman, dis-moi." → 💰 0 / 😊 -2 / ⭐ +2
- B. J'arrête : "Ok, tu me raconteras un autre jour." → 💰 0 / 😊 +1 / ⭐ +1
- C. Je lui dis : "J'ai trouvé un certificat de mariage chez toi. C'était bien Heng ?" → 💰 0 / 😊 -3 / ⭐ +3 [⚠️ relance la mère]

---

### J50 — Lundi 25 juillet · Tour Heng · 19:00

**Prose** :
Vincent est dans le hall de la Tour quand je sors. Je n'avais pas vu qu'il était à Paris.

— Mademoiselle Marchand. Encore vous.
— Je vis ici.
— Bien sûr. *(il sourit)* Vous savez que mon frère traverse une période compliquée en ce moment ?
— Pardon ?
— Il a perdu trois contrats clés cette semaine. Le conseil d'administration est nerveux. Je dis ça… je dis rien.

Il s'éloigne.

**Trigger bourse : HENG -8%** (pré-attaque de Vincent au conseil).

**Choix : J'en parle à Tristan ?**

- A. Oui, immédiatement. → 💰 0 / 😊 -1 / ⭐ +2
- B. J'observe d'abord pour comprendre → 💰 0 / 😊 0 / ⭐ +2
- C. Je note dans mon carnet : *"Vincent attaque. Sur quoi ?"* → 💰 0 / 😊 -1 / ⭐ +1

---

### J51 — Mardi 26 juillet · Appartement Heng · 22:00

**Prose** :
Tristan rentre tard. Il a les yeux rouges. Il s'assoit sur le canapé. Je m'assois en face de lui sans rien dire.

— Mauvaise journée ? je demande.
— Mauvaise semaine.
— Vincent ?
— …
— Je l'ai croisé hier. Il m'a dit que vous traversiez une période compliquée.
— Il fait ça depuis des années. C'est sa stratégie. Il insinue à mes investisseurs que je suis instable, instable que je suis incompétent, à mes amis que je suis distant.
— Pourquoi il fait ça ?
— Parce que mon père lui a préféré moi pour la direction Europe. Il a 31 ans. Il a passé toute sa vie à se sentir le second.

Il se lève. Il vient s'asseoir à côté de moi. Pas tout contre. Pas loin. Le bon distance.

— Le dossier de Shanghai arrive vendredi.

**Choix : Comment je l'aide ce soir ?**

- A. Je lui prépare un thé et on regarde un film bête → 💰 0 / 😊 +2 / ⭐ +1
- B. Je l'écoute parler de sa stratégie pour vendredi → 💰 0 / 😊 +1 / ⭐ +2
- C. Je lui propose de dormir dans la même chambre — pas pour autre chose, juste pour ne pas être seul → 💰 0 / 😊 +3 / ⭐ +1 [⚠️ rupture clause]

---

### J52 — Mercredi 27 juillet · Salle du conseil Heng · 11:00

**Prose** :
Trigger bourse : HENG -18%. Vincent a attaqué le conseil ce matin avec un dossier de griefs. Tristan est en pleine défense. Je ne suis pas dans la salle — je suis avec Camille au café d'en face, je guette son visage à travers la baie vitrée.

À 14h, Tristan ressort. Vivant. Il a tenu. Mais il a perdu trois voix au conseil.

Il vient me voir au café. Camille lui paie un thé. Il sourit faiblement.

— Vous avez tenu, dit Camille.
— J'ai tenu.

**Choix : Je lui dis quoi ?**

- A. "Bravo." Simplement. → 💰 0 / 😊 +1 / ⭐ +1
- B. "Vincent ne s'arrêtera pas. Tu vas faire quoi ?" → 💰 0 / 😊 0 / ⭐ +2
- C. "On annule le contrat. On arrête de jouer. Si je dois être à tes côtés, je suis à tes côtés vraiment." → 💰 0 / 😊 +3 / ⭐ -2 [⚠️ pivot majeur]

---

### J53 — Jeudi 28 juillet · Bureau de Tristan · 09:00

**Prose** :
Le dossier est arrivé.

Tristan ne le m'a pas dit. C'est sa secrétaire qui m'envoie un SMS par erreur (elle a confondu le numéro avec celui de Madame Heng) : *"Le dossier de Shanghai vient d'arriver dans le bureau de M. Heng."*

Je relis trois fois. Je suis dans le métro. Je remonte à la Tour Heng en taxi.

Je passe devant l'assistante sans m'annoncer. J'entre dans le bureau de Tristan. Il n'est pas là — il est en réunion.

Le dossier est sur son bureau. Fermé. Une chemise marron usée. Sur l'étiquette : *Marchand H. / Shen W. — Septembre 1999*.

**Choix : Je l'ouvre ?**

- A. Je l'ouvre. Je lis. → 💰 0 / 😊 -3 / ⭐ +3 [⚠️ irréversible]
- B. Je l'emporte avec moi sans l'ouvrir → 💰 0 / 😊 -2 / ⭐ +2
- C. Je ressors et j'attends qu'il me le montre → 💰 0 / 😊 -1 / ⭐ +1

---

### J54 — Vendredi 29 juillet · Bureau de Tristan · 09:30

**Prose** :
[Si Shen a ouvert le dossier au J53]

Je lis. Je lis tout.

Acte de mariage par procuration, septembre 1999.
Témoins : néant.
Notaire instructeur : Heng Lihua (Madame Heng).

Note manuscrite, en chinois traditionnel, datée du 6 septembre 1999, signée d'un policier nommé Liu Wei : *"L'époux Shen Wenbo a été appréhendé ce jour à Shanghai dans le cadre de l'enquête politique liée à l'activité de son frère aîné Shen Wenshan. Procédure suspendue."*

Une lettre, en chinois, datée de 2017. Écrite à la main. Signée Wenbo. Adressée à *"ma fille que je n'ai pas connue"*.

J'arrête de lire. Je ne peux pas continuer. Mes mains tremblent. Je remets tout en place. Je sors. Je redescends. Je marche dans la rue jusqu'à ce qu'il fasse nuit.

[Si Shen n'a pas ouvert le dossier]

Tristan vient me voir le lendemain matin à la maison. Il a le dossier sous le bras. Il est blanc.

— On doit parler. Maintenant.

**Choix : Je l'écoute ?**

- A. Oui, je m'assois → 💰 0 / 😊 -3 / ⭐ +2
- B. "Dis-moi juste l'essentiel maintenant. Le reste plus tard." → 💰 0 / 😊 -2 / ⭐ +2
- C. "Donne-moi le dossier. Je veux le lire seule." → 💰 0 / 😊 -3 / ⭐ +3

---

### J55 — Samedi 30 juillet · Appartement Heng · 14:00

**Prose** :
On a parlé pendant six heures.

Tristan a tout posé. Il a expliqué les archives de sa tante, le cabinet, la procédure des mariages internationaux des années 90. Il a confirmé que mon père avait été arrêté deux jours avant l'arrivée de maman. Il a confirmé qu'il avait fait cinq ans de prison. Il a confirmé qu'à sa sortie, sa famille avait intercepté toutes les lettres qu'il écrivait à maman.

Il a confirmé qu'il était mort en 2018. Accident de chantier. Fuzhou.

Il a confirmé qu'il existe une lettre de 2017 — la dernière. Adressée à *"ma fille que je n'ai pas connue"*.

Je n'ai pas pleuré. Pas une fois. Je suis trop sidérée pour pleurer.

— Pourquoi tu ne m'as rien dit dès que tu as commencé à comprendre ? je lui demande à la fin.
— Parce que je voulais être sûr.
— Sûr de quoi ?
— Sûr que ce n'était pas un mensonge de plus dans ta vie.

Je le regarde. Il a les yeux rouges. Il a failli me protéger en me cachant la vérité — c'est exactement ce que faisait maman pendant 25 ans.

**Choix : Je lui dis quoi ?**

- A. "Merci d'avoir essayé de me protéger." → 💰 0 / 😊 +2 / ⭐ +1
- B. "Tu n'aurais jamais dû me cacher ça, même une heure." → 💰 0 / 😊 -2 / ⭐ +2
- C. "Je veux la lettre. Je veux la lire seule." → 💰 0 / 😊 -3 / ⭐ +3

---

### J56 — Dimanche 31 juillet · Appartement Heng · 23:00

**Prose** :
Je tiens la lettre. C'est du papier kraft. L'écriture est ferme, ronde, lente. Caractères chinois traditionnels. La date en haut : *14 septembre 2017.*

J'ai mis la lettre dans une enveloppe transparente. Je ne l'ai pas encore lue. Je ne suis pas prête.

Je sais que je vais la lire. Je sais que ça va casser quelque chose qui ne se réparera pas. Je veux choisir le moment.

**SMS Camille** :

- Camille : Tu es où ?
- Moi : Toujours chez Tristan.
- Camille : Je peux venir ?
- Moi : Pas ce soir. Je veux être seule.
- Camille : Je suis là dès que tu m'appelles.
- Moi : Je sais. Merci.

**Choix : Je lis la lettre ce soir ?**

- A. Oui, je la lis seule, dans ma chambre → 💰 0 / 😊 -2 / ⭐ +2 [unlocks: lettre\_lue]
- B. J'attends d'être avec maman pour la lire à deux → 💰 0 / 😊 +1 / ⭐ +2
- C. Je l'enferme dans un tiroir, je décide demain → 💰 0 / 😊 -1 / ⭐ +1

---

### J57 — Lundi 1er août · Appartement Heng · 19:00

**Prose** :
Vincent appelle. Sur mon portable. Comment a-t-il eu mon numéro ?

— Mademoiselle Marchand.
— Comment vous avez mon numéro ?
— Peu importe. Je veux juste vous prévenir. Mon frère a déjà eu trois fausses fiancées avant vous. Il en a renvoyé une chez elle après l'avoir fait tomber amoureuse — elle a tenté de se suicider. C'est de notoriété dans la famille. Je ne dis pas ça pour faire mal. Je le dis parce que je trouve ça injuste pour vous.

Je raccroche. Je sais que c'est faux. Je sais que c'est Vincent. Mais une partie de moi… une petite partie… écoute.

**Choix : Je fais quoi ?**

- A. J'en parle à Tristan tout de suite → 💰 0 / 😊 -1 / ⭐ +2
- B. Je mène ma propre enquête → 💰 0 / 😊 -2 / ⭐ +3
- C. Je n'en parle à personne, ça ronge → 💰 0 / 😊 -3 / ⭐ +1

---

### J58 — Mardi 2 août · Tour Heng (croise Vincent) · 14:00

**Prose** :
Vincent m'attend dans le hall. Cette fois, je me dis qu'il fait exprès. Il sait probablement quel jour je viens.

— Une dernière chose, Mademoiselle. J'ai entendu mon frère parler d'un *dossier Marchand* avec ma tante l'autre jour. Vous savez de quoi il s'agit ?

Je me fige. Là, c'est une vraie information. Vincent ne pouvait pas inventer ça. Il a entendu vraiment.

Donc Tristan a parlé du dossier à sa tante. Mais à moi, il a attendu une semaine pour me le dire. Et même quand il m'en a parlé, je sens qu'il a édulcoré. Il a dit "lettre de 2017", il n'a pas dit "lettre adressée à ma fille".

Vincent dit la vérité, peut-être pour la première fois.

**Choix : Je vais où maintenant ?**

- A. Voir Tristan immédiatement, exiger toute la vérité → 💰 0 / 😊 -2 / ⭐ +2
- B. Je rentre lire la lettre seule → 💰 0 / 😊 -3 / ⭐ +2
- C. Je vais voir maman avec la lettre → 💰 0 / 😊 -1 / ⭐ +3

---

### J59 — Mercredi 3 août · Appartement Heng · 02:00

**Prose** :
Je n'arrive pas à dormir. Je sors la lettre. Je la lis.

*"Ma fille que je n'ai pas connue.*

*J'écris cette lettre sachant que tu ne la liras probablement jamais. Je suis ton père. Je m'appelle Shen Wenbo. Tu as 17 ans aujourd'hui — du moins j'imagine, parce que j'ai appris ton existence par hasard il y a dix ans, et j'ai compté.*

*Je n'ai pas pu venir te chercher. J'ai été arrêté avant. Quand je suis sorti, ma famille a confisqué mon courrier. Ta mère a cru pendant longtemps que je l'avais abandonnée. Je le sais.*

*Si un jour tu lis ces mots, sache trois choses.*

*Premièrement : tu ne dois rien à mon souvenir. Tu n'as pas à me pleurer, ni à me chercher, ni à venir au Fujian. Vis ta vie. C'est mon dernier cadeau.*

*Deuxièmement : ta mère est la femme la plus courageuse que j'ai rencontrée. Plus courageuse que moi, qui n'ai pas eu la force de m'évader pour la rejoindre. Sois douce avec elle.*

*Troisièmement : tu portes mon nom de famille. Shen, en chinois, signifie 'profond'. C'est tout ce que je te transmets. Sois profonde, ma fille. Plus profonde que les apparences. Plus profonde que les abandons. Plus profonde que ce que les autres voient en toi.*

*Je t'aime sans t'avoir connue. Pardon pour ce paradoxe.*

*Ton père, Wenbo, le 14 septembre 2017."*

J'ai lu la lettre cinq fois. Je ne pleure toujours pas. Quelque chose de plus grand que les pleurs.

**Choix : Que je fais maintenant ?**

- A. Je rends le dossier à Tristan, je rentre chez maman → 💰 0 / 😊 -1 / ⭐ +2
- B. J'écris une lettre de réponse à mon père dans mon carnet — la 312ème → 💰 0 / 😊 +1 / ⭐ +2
- C. Je quitte l'appartement Heng cette nuit avec mes affaires → 💰 0 / 😊 -3 / ⭐ +3 [⚠️ rupture]

---

### J60 — Jeudi 4 août · Appartement Heng · 07:00

**Prose** :
Je fais ma valise. Je laisse la lettre dans une enveloppe sur la table de la cuisine, avec un mot pour Tristan.

*"J'ai lu. Tout. Je pars chez ma mère.*
*Tu m'as caché trop, trop longtemps. Pour de bonnes raisons sans doute. Mais le résultat est le même.*
*Je ne suis pas en colère. Je suis fatiguée. Je dois être avec ma mère, pas avec un homme qui a pris des décisions à ma place.*
*Pour le contrat : je rends ce qui n'a pas été utilisé. Je ne suis pas un pourboire. Je ne suis pas une dette non plus.*
*Shen."*

Je sors. Je prends le métro à 7h08. Belleville, ligne 11.

**Choix : Je préviens qui ?**

- A. Camille, elle vient me chercher → 💰 0 / 😊 +1 / ⭐ +1
- B. Personne. Je veux être seule un moment → 💰 0 / 😊 0 / ⭐ +2
- C. J'écris à maman pour la prévenir : "Je rentre. Pour de bon." → 💰 0 / 😊 +1 / ⭐ +2

---

### J61 — Vendredi 5 août · Studio Belleville · 11:00

**Prose** :
Maman. Maman me regarde quand j'arrive. Je n'ai pas besoin de dire quoi que ce soit. Elle voit. Elle voit toujours.

— Tu rentres à la maison ?
— Oui.
— Pour de bon ?
— Pour un moment.

Elle hoche la tête. Elle me prépare un thé. Long Jing, première récolte (elle l'achète chez Madame Wong à 12€ les 50g — elle l'avait déjà avant que je connaisse Tristan).

— Maman, j'ai quelque chose à te montrer.
— Maintenant ?
— Quand tu seras prête.
— Demain matin.

Elle ne me demande pas ce que c'est. Elle attend.

**SMS Tristan (le soir)** :

- Tristan : J'ai lu ta lettre. Je comprends.
- Tristan : Je ne te demanderai pas de revenir.
- Tristan : Je suis désolé.
- Tristan : Si jamais tu veux parler. Je suis là.

Je ne réponds pas.

**Choix : Avant de me coucher ?**

- A. J'écris une réponse à Tristan dans mon carnet (sans envoyer) → 💰 0 / 😊 +1 / ⭐ +1
- B. Je relis la lettre de mon père → 💰 0 / 😊 +1 / ⭐ +1
- C. Je dors. Je n'ai plus la force. → 💰 0 / 😊 0 / ⭐ 0

---

### J62 — Samedi 6 août · Studio Belleville · 09:00

**Prose** :
J'apporte la lettre à maman au petit-déjeuner. Je lui tends. Elle la prend. Elle la regarde longtemps avant de l'ouvrir. Le papier kraft. Son écriture à lui, qu'elle reconnaît même après vingt-cinq ans.

Elle lit. Elle ne fait pas de bruit. Pas un. Pas un soupir, pas un sanglot.

À la fin, elle pose la lettre sur la table. Elle me regarde.

> *"Je l'ai attendu jusqu'en 2010. Après j'ai arrêté de compter."*

Elle dit ça simplement. Comme on dit qu'il pleut.

Puis :

— On va au Fujian.

**Choix : Je réponds quoi ?**

- A. "Oui. Quand tu veux." → 💰 0 / 😊 +3 / ⭐ +1
- B. "Tu es sûre ? Avec ta santé…" → 💰 0 / 😊 +1 / ⭐ +1
- C. Je la prends dans mes bras sans rien dire → 💰 0 / 😊 +4 / ⭐ +1

---

### J63 — Dimanche 7 août · Studio Belleville · journée

**Prose** :
Maman et moi parlons toute la journée. Pour la première fois en 25 ans, elle me raconte vraiment.

Sa fac de lettres à Bordeaux. L'agence parisienne en 1998. Les premières lettres en français maladroit de Wenbo. Sa décision en deux semaines. Le voyage à Shanghai en septembre 1999. L'attente à l'hôtel. Personne. Trois jours. Le retour en France, enceinte sans le savoir.

Elle me raconte aussi ce que je ne savais pas : qu'elle a continué à écrire à Wenbo jusqu'en 2003. Aucune réponse. Qu'en 2010, elle a fait un dernier voyage à Shanghai pour essayer de retrouver sa trace. Personne ne savait. Elle est rentrée. Elle a fermé la boîte aux trésors.

— Je n'ai jamais cessé de penser qu'il était peut-être en vie. Mais je ne pouvais plus me permettre d'y penser.

**Choix : Je la console comment ?**

- A. Je lui dis que ce n'est pas sa faute → 💰 0 / 😊 +2 / ⭐ +1
- B. Je l'écoute, sans dire un mot → 💰 0 / 😊 +3 / ⭐ +1
- C. Je lui montre mon carnet — les 311 lettres au père — pour qu'elle voie qu'elle n'est pas seule → 💰 0 / 😊 +4 / ⭐ +2

Maman embrasse le caractère. Pas avec ses lèvres, avec sa main qui passe sur sa bouche puis sur le bois.

**Choix : Le soir, je fais quoi ?**

- A. J'écris à mon père dans le nouveau carnet → 💰 0 / 😊 +2 / ⭐ +1
- B. Je reste avec maman dans la cour, en silence → 💰 0 / 😊 +3 / ⭐ +1
- C. J'envoie un SMS à Tristan : "On y est." → 💰 0 / 😊 +1 / ⭐ +1

---

### J80 — Mercredi 24 août · Maison de Tante Mei · 15:00

**Prose** :
Tante Mei nous a apporté la boîte en bois. Elle est grande comme une boîte à chaussures. Bois sombre, non verni. Une serrure simple, sans clé — Tante Mei l'a forcée il y a longtemps.

À l'intérieur : trois liasses.

Liasse 1 : les lettres d'Hélène à Wenbo, 1998-2003. Reçues, conservées par lui.
Liasse 2 : les lettres de Wenbo à Hélène, jamais envoyées, 2004-2017.
Liasse 3 : photos. Une photo d'Hélène et Wenbo à Paris en 1999. Trois photos de Wenbo seul (à 30 ans, à 40 ans, à 50 ans). Une photo de groupe au village, 2015.

Maman prend la liasse 1 (les siennes). Elle sort dans la cour pour les relire seule. Je la laisse partir.

Je prends la liasse 2.

**Choix : Comment je lis les lettres de mon père ?**

- A. Toutes d'un coup, ce soir → 💰 0 / 😊 -2 / ⭐ +2
- B. Une par jour, dans l'ordre chronologique → 💰 0 / 😊 +2 / ⭐ +2
- C. Je commence par la dernière, 2017 (déjà lue) puis je remonte → 💰 0 / 😊 0 / ⭐ +1

---

### J81 — Jeudi 25 août · Cour de la maison · 09:00

**Prose** :
Maman lit toute la matinée. Elle ne pleure toujours pas. Elle a une tasse de thé à côté d'elle, qui refroidit. Elle relit certaines lettres deux ou trois fois. À midi, elle vient vers moi, elle me tend une lettre.

— Lis celle-ci. C'est moi qui l'ai écrite. Elle est revenue ici. Elle ne s'est jamais perdue.

C'est une lettre d'octobre 1999, juste après son retour de Shanghai. Elle annonce à Wenbo qu'elle est enceinte. Elle écrit : *"Si tu reçois cette lettre, écris-moi. Sinon je comprendrai. Je porterai notre enfant comme la promesse qu'on n'a pas eu le temps de se faire."*

Wenbo a reçu cette lettre en 2004, à sa sortie de prison. Sa famille l'avait gardée tout ce temps.

Je rends la lettre à maman. Je n'ai pas de mots.

**Choix : Que fais-je ?**

- A. Je prends maman dans mes bras → 💰 0 / 😊 +3 / ⭐ +1
- B. Je vais marcher dans le village pour digérer → 💰 0 / 😊 +1 / ⭐ +1
- C. J'écris la 312ème lettre dans le nouveau carnet → 💰 0 / 😊 +2 / ⭐ +2

---

### J82 — Vendredi 26 août · Village, marché · 09:00

**Prose** :
Je vais au marché avec Tante Mei. Elle achète du tofu fermenté, des champignons, du chou pak choï. Elle salue tout le monde. Tout le monde la connaît. Tout le monde me regarde — la fille de Wenbo, qui est revenue.

Une vieille dame s'approche. Elle me prend la main. Elle me dit en mandarin :

— Ton père m'a appris à lire. J'avais 50 ans. Lui en avait 30. Il était patient.

Une autre :

— Ton père a aidé à reconstruire le pont après l'inondation de 2010. Sans demander d'argent.

Une autre encore, plus jeune :

— Ton père est mort en sauvant deux ouvriers sous lui. C'est pour ça qu'il est mort. L'accident de chantier — il aurait pu sortir, il a refait un passage pour aller chercher les autres.

Je m'arrête. Je n'avais pas su ça. Maman ne le savait pas non plus.

**Choix : Je rentre dire à maman ?**

- A. Tout de suite → 💰 0 / 😊 +2 / ⭐ +1
- B. Ce soir, à un moment plus tranquille → 💰 0 / 😊 +1 / ⭐ +2
- C. Je le garde pour moi, je veux digérer d'abord → 💰 0 / 😊 0 / ⭐ +1

---

### J83 — Samedi 27 août · Cour · soir

**Prose** :
Je dis à maman, le soir, ce que j'ai appris au marché. Elle écoute. Elle sourit doucement.

— Il m'avait dit qu'il aimait les ponts. Dans ses lettres de 1999. Il disait qu'il aurait voulu être ingénieur des ponts.
— Il l'a été, en quelque sorte.
— Oui.

Elle reste silencieuse longtemps. Puis :

— Tu sais quoi, ma fille ?
— Quoi ?
— Je suis venue ici pour pleurer. Mais je n'arrive pas à pleurer. Je suis trop reconnaissante.
— Reconnaissante de quoi ?
— De savoir. C'est tout ce que je voulais. Savoir.

**Choix : Le soir, dans le carnet, j'écris ?**

- A. Une lettre à mon père : "Aujourd'hui, j'ai entendu trois personnes te décrire." → 💰 0 / 😊 +3 / ⭐ +2
- B. Une note pour moi-même : "Maman ne pleurera pas ici. Elle a fini de pleurer en France." → 💰 0 / 😊 +2 / ⭐ +1
- C. Une lettre à Tristan que je n'enverrai pas : "Tu ne sais pas ce que tu nous a permis de découvrir." → 💰 0 / 😊 +2 / ⭐ +1

---

### J84 — Dimanche 28 août · Tombe de Wenbo · 10:00

**Prose** :
Tante Mei nous emmène au cimetière. C'est sur la colline, derrière le village. La tombe de Wenbo est simple. Pierre grise, caractères gravés à la main : *沈文博 (1969-2018)*. Pas d'épitaphe. Pas de fleurs. Juste un petit brûle-encens devant.

Maman pose les fleurs qu'on a apportées. Du jasmin et des chrysanthèmes blancs. Elle reste debout devant la tombe pendant cinq minutes sans rien dire. Puis elle se met à parler à Wenbo, en français.

— *Wenbo. Je suis venue. Notre fille est avec moi. Tu vois, on l'a fait. Pas comme on l'avait imaginé. Mais on l'a fait quand même.*

Elle ne pleure pas. Elle parle calmement. Comme à un vieil ami.

Je suis derrière elle, deux mètres en arrière. Je ne pleure pas non plus. Je sens quelque chose se déposer en moi. Lentement. Comme du sable.

**Choix : Je m'avance ?**

- A. Je viens à côté de maman, je dis bonjour à mon père en mandarin → 💰 0 / 😊 +3 / ⭐ +2
- B. Je reste en arrière, je laisse maman seule avec lui → 💰 0 / 😊 +2 / ⭐ +2
- C. Je m'agenouille à distance, je touche la terre, je me dis : *"Sois profonde."* → 💰 0 / 😊 +4 / ⭐ +3

---

### J85 — Lundi 29 août · Cour de Tante Mei · 14:00

**Prose** :
Tante Mei nous montre une photo qu'on n'avait pas vue. Au fond de la boîte, il y avait une enveloppe glissée sous le double-fond. Maman l'avait ratée.

Photo en couleur, octobre 1999. Hélène et Wenbo, sur le pont des Arts à Paris. Lui en pull beige, elle en imperméable bleu marine. Ils ne se touchent pas. Ils sont à 30 cm l'un de l'autre. Ils sourient timidement à l'objectif.

C'est la seule photo qui existe d'eux ensemble.

— Comment elle est arrivée ici ?
— Wenbo l'avait toujours sur lui. Elle était dans son portefeuille quand il est mort. La police me l'a rendue avec ses affaires.

Maman prend la photo. Elle la regarde. Elle dit :

— On dirait deux étrangers qui viennent de se rencontrer.
— Vous étiez deux étrangers qui veniez de vous rencontrer.
— Oui. Mais on s'est aimés quand même.

**Choix : Je veux quoi de cette photo ?**

- A. Faire une copie pour ma chambre à Belleville → 💰 0 / 😊 +2 / ⭐ +1
- B. La laisser ici, c'est sa place → 💰 0 / 😊 +2 / ⭐ +2
- C. La photographier avec mon téléphone, pour Camille → 💰 0 / 😊 +1 / ⭐ +1

---

### J86 — Mardi 30 août · Village · journée

**Prose** :
Maman fatigue. Elle a besoin de dormir l'après-midi. Je passe la journée à aider Tante Mei dans le potager. On plante des choux pour l'automne. Elle me parle de Wenbo enfant, de ses parents, du frère aîné dissident dont elle dit du bien malgré tout.

— Wenshan était un homme bon. Il a juste cru qu'il pouvait changer le pays. Il a payé pour ça. Wenbo aussi a payé, sans rien faire.

Elle plante un chou. Elle tasse la terre.

— Mais c'est passé maintenant. Tu es ici. Ta mère est ici. C'est ce qui compte.

**Choix : Le soir, j'écris à Tristan ?**

- A. Long SMS : "Maman va mieux. Le voyage a été le bon choix. Merci." → 💰 0 / 😊 +1 / ⭐ +2
- B. Court SMS : "Tu avais raison." → 💰 0 / 😊 +1 / ⭐ +1
- C. Rien. Je parlerai à mon retour. → 💰 0 / 😊 0 / ⭐ +1

---

### J87 — Mercredi 31 août · Village · 16:00

**Prose** :
Je marche seule sur la route en terre rouge qui sort du village. Champs de riz à droite. Montagne à gauche. Le soleil tombe.

Je m'arrête. Je m'assois sur une pierre. Je sors le nouveau carnet. J'écris.

*"312ème lettre. La première dans le nouveau carnet.*

*Cher papa,*

*Aujourd'hui j'ai marché sur la route que tu marchais enfant. Tante Mei me l'a montrée hier. Tu allais à l'école par là.*

*Je voulais te dire trois choses :*

*1. Maman va bien. Elle te pardonne. Elle ne pleure même pas. Elle te parle.*

*2. Je ne suis plus en colère contre toi. Je l'ai été pendant 24 ans, sans le savoir. Maintenant je sais ce qu'on m'a caché. Tu n'avais rien à te faire pardonner.*

*3. Il y a un homme, à Paris. Il s'appelle Tristan. Il n'est pas comme moi. Il n'est pas comme toi. Il est comme personne. Mais il a fait pour moi ce que tu n'as pas pu faire pour maman. Il a réuni les morceaux. Sans rien demander en échange. Tu l'aurais aimé je crois.*

*Sois profond. Tu m'as dit ça dans ta lettre. Je le serai. Je l'étais déjà.*

*— Ta fille."*

**Choix : Je fais quoi de la lettre ?**

- A. Je la garde dans le carnet → 💰 0 / 😊 +2 / ⭐ +1
- B. Je la brûlerai à la fin du séjour → 💰 0 / 😊 +3 / ⭐ +2
- C. Je la lis à voix haute devant la tombe demain → 💰 0 / 😊 +4 / ⭐ +2

---

### J88 — Jeudi 1er septembre · Tombe · 10:00

**Prose** :
Je viens seule à la tombe. Maman se repose. J'apporte le carnet. Je lis la 312ème lettre à voix haute. En français. Mon père ne comprend pas le français. Mais il y a des choses qui passent dans une langue qu'on n'a pas apprise.

Je referme le carnet. Je touche la pierre. Elle est tiède.

— Salut, papa.

Je redescends.

**Trigger bourse : NCB -22%** (scandale bancaire NeoCity Bank).

**Choix : Je dis quoi à maman en rentrant ?**

- A. Je lui dis que j'ai lu la lettre à papa → 💰 0 / 😊 +2 / ⭐ +1
- B. Je garde ça pour moi → 💰 0 / 😊 +2 / ⭐ +2
- C. Je lui demande si elle veut venir avec moi écrire la sienne → 💰 0 / 😊 +3 / ⭐ +2

---

### J89 — Vendredi 2 septembre · Maison · 19:00

**Prose** :
Wang appelle Tante Mei. Il vient pour la dialyse de maman demain à Fuzhou. Une heure de route. Il propose de nous emmener avant et de faire une journée à Fuzhou — visite de la vieille ville, déjeuner près du fleuve.

Maman dit oui.

Je prépare le sac. Je glisse le nouveau carnet dans mon sac à main. Maman remarque.

— Tu écris beaucoup en ce moment.
— Beaucoup, oui.
— Tu m'en lis un jour ?
— Quand je serai prête.
— Pas de pression.

**Choix : Le soir je dors comment ?**

- A. Bien, profondément → 💰 0 / 😊 +2 / ⭐ +1
- B. Je rêve de mon père pour la première fois — je ne raconterai à personne → 💰 0 / 😊 +3 / ⭐ +2
- C. Mal, je suis nerveuse pour la dialyse de maman → 💰 0 / 😊 -1 / ⭐ +1

---

### J90 — Samedi 3 septembre · Fuzhou · journée

**Prose** :
Dialyse de maman le matin. Trois heures. Je l'attends dans le café d'en face. J'écris dans le carnet.

L'après-midi, on visite la vieille ville. Quartier de Sanfang Qixiang. Maisons en bois sombre, ruelles pavées, vieux thé qu'on boit accroupis sur de petits tabourets. Maman est lumineuse.

Wang nous photographie devant une vieille maison à étage.

— Ton père est venu ici en 2015, dit-il. Avec un groupe d'ingénieurs. Il a aidé à la rénovation de la rue.
— Comment vous savez ça ?
— Tante Mei me l'a dit. Tout le monde sait, ici.

Maman touche le mur.

**Choix : En rentrant le soir au village ?**

- A. J'écris une longue page dans le carnet → 💰 0 / 😊 +2 / ⭐ +1
- B. J'envoie une photo à Camille avec un mot → 💰 0 / 😊 +1 / ⭐ +1
- C. Je m'endors en pensant à Tristan pour la première fois depuis dix jours → 💰 0 / 😊 +2 / ⭐ +1

---

### J91 — Dimanche 4 septembre · Maison · 11:00

**Prose** :
Je découvre, en rangeant les lettres dans la boîte, un détail. Sur l'enveloppe d'une lettre de Wenbo de 2009, l'adresse de retour est écrite à la main : *Shen Wenbo, c/o Cabinet Heng & Associés, Shanghai, 200120*.

Tante Mei m'explique. Wenbo, à sa sortie de prison, n'avait plus de domicile fixe pendant deux ans. Le notaire qui avait validé son mariage en 1999 — *Madame Heng* — lui avait offert d'utiliser l'adresse du cabinet comme adresse de retour pour ses lettres.

Madame Heng connaissait Wenbo personnellement. En 1999. Et après.

Elle a choisi de ne rien dire à maman quand elle était notaire. Pourquoi ? Je ne sais pas encore.

Mais je sais qu'elle n'était pas neutre dans cette histoire. Elle protégeait quelqu'un. Quelqu'un qui était en prison. Quelqu'un dont la famille interceptait le courrier.

**Choix : Je note quoi dans le carnet ?**

- A. *"Madame Heng n'était pas neutre. Elle protégeait papa. Pourquoi ?"* → 💰 0 / 😊 0 / ⭐ +3
- B. *"Je veux la voir au retour. Je veux comprendre."* → 💰 0 / 😊 +1 / ⭐ +3
- C. Rien — je veux d'abord finir le voyage. → 💰 0 / 😊 +1 / ⭐ +1

---

### J92 — Lundi 5 septembre · Cour · 14:00

**Prose** :
Maman et Tante Mei préparent ensemble des dumplings pour le dîner. Elles parlent en mandarin lentement. Maman a perdu son mandarin en 25 ans, mais il revient quand elle le pratique. Tante Mei est patiente.

Je les regarde de la véranda. Deux femmes qui auraient dû être belles-sœurs depuis 1999. Vingt-six ans plus tard, elles plient enfin des dumplings ensemble.

**Choix : Je fais quoi de cette image ?**

- A. Je la photographie discrètement → 💰 0 / 😊 +2 / ⭐ +1
- B. Je la grave dans ma mémoire, sans photo → 💰 0 / 😊 +3 / ⭐ +2
- C. Je vais les rejoindre, je plie aussi → 💰 0 / 😊 +4 / ⭐ +1

---

### J93 — Mardi 6 septembre · Maison · 16:00

**Prose** :
Tante Mei me prend à part. Elle a une chose à me dire qu'elle n'a pas voulu dire devant maman.

— Wenbo t'avait imaginé un autre prénom. Un prénom chinois. Il l'avait gardé pour lui. Il ne l'a jamais envoyé à ta mère parce qu'il pensait qu'elle aurait préféré choisir elle-même.
— Quel prénom ?
— *Yuelan.* 月蘭. Orchidée de la lune.

Je répète. *Yuelan.* Le caractère me parle. Yue = lune. Lan = orchidée.

Tante Mei me prend la main.

— Garde-le pour toi. Ou pas. Comme tu veux.

**Choix : Que je fais de ce prénom ?**

- A. Je le garde pour moi, c'est mon trésor → 💰 0 / 😊 +3 / ⭐ +2
- B. Je le dis à maman ce soir → 💰 0 / 😊 +2 / ⭐ +1
- C. Je l'écris dans le carnet, je le calligraphie même → 💰 0 / 😊 +4 / ⭐ +2

---

### J94 — Mercredi 7 septembre · Village · matin

**Prose** :
Je commence à apprendre la calligraphie avec Tante Mei. Elle a un pinceau de Wenbo qu'elle a gardé. Encre noire. Papier de riz.

Premier caractère : 心. Cœur. Je le rate cinq fois. Au sixième, c'est mieux. Tante Mei sourit.

— Ton père a aussi raté cinq fois la première fois. Il avait dix ans.

Je continue.

**Choix : Je note quoi ce soir ?**

- A. Une réflexion sur le geste répété → 💰 0 / 😊 +2 / ⭐ +1
- B. Je calligraphie 心 en bas de la lettre 312 → 💰 0 / 😊 +3 / ⭐ +2
- C. Rien, je dors fatiguée → 💰 0 / 😊 +1 / ⭐ 0

---

### J95 — Jeudi 8 septembre · Maison · 11:00

**Prose** :
Camille m'envoie un long SMS depuis Paris.

- Camille : Comment va maman ? Comment vas-tu ?
- Moi : On va. C'est plus dur à dire qu'à vivre. On va.
- Camille : Tristan est venu chez moi hier.
- Moi : Quoi ?
- Camille : Il voulait juste savoir si j'avais des nouvelles. Il s'inquiétait pour ta mère.
- Camille : Je lui ai dit que vous alliez bien.
- Camille : Il est reparti.
- Camille : Tu es sûre que tu veux pas lui écrire ?
- Moi : Je veux pas lui écrire.
- Moi : Je veux le voir au retour.
- Moi : Pas avant.

**Choix : Le soir ?**

- A. J'écris quand même un SMS court : "Je rentre dans 10 jours." → 💰 0 / 😊 +1 / ⭐ +1
- B. Je tiens ma position → 💰 0 / 😊 +1 / ⭐ +2
- C. Je m'autorise une lettre dans le carnet, longue, pour Tristan → 💰 0 / 😊 +2 / ⭐ +1

---

### J96 — Vendredi 9 septembre · Tombe · 09:00

**Prose** :
Dernière visite à la tombe avant la fin du séjour. Maman m'accompagne. On apporte de l'encens. On en brûle trois bâtons. La fumée monte droit — c'est bon signe, dit Tante Mei.

Maman parle à Wenbo une dernière fois. En français, comme toujours.

— *Je vais rentrer. Je ne reviendrai peut-être pas. Je voulais te dire merci. Pour les lettres. Pour la patience. Pour notre fille. Tu peux dormir.*

Elle se retourne. Elle me tend la main. Je la prends. On redescend ensemble.

**Choix : Je dis quoi à mon père avant de partir ?**

- A. Rien. C'est dit. → 💰 0 / 😊 +2 / ⭐ +2
- B. Je touche la pierre une dernière fois. → 💰 0 / 😊 +3 / ⭐ +1
- C. Je laisse la 312ème lettre, papier plié, glissée sous une pierre → 💰 0 / 😊 +4 / ⭐ +2

---

### J97 — Samedi 10 septembre · Maison · 18:00

**Prose** :
Le rapatriement officiel des cendres. Wang nous accompagne au crématorium municipal. Démarches. Papiers. Cachets. Trois heures.

À la fin, on a une petite urne. Cendres de Wenbo. On les ramène en France. Maman et moi avons décidé qu'on les disperserait sur la Seine, à Paris, là où ils s'étaient promenés en 1999 — pont des Arts.

Sur le chemin du retour à la maison, Wang dit, doucement :

— Monsieur Tristan a tout payé en avance. Crématorium, démarches, transport en France. Il y a un dossier à la préfecture quand vous arriverez à Paris. Il vous dira ce qu'il faut signer.

Je regarde l'urne sur les genoux de maman. Je serre les mâchoires.

**Choix : Le soir ?**

- A. J'écris un long SMS de remerciement à Tristan → 💰 0 / 😊 +2 / ⭐ +2
- B. Je ne dis rien. Je remercierai en personne. → 💰 0 / 😊 +1 / ⭐ +2
- C. J'envoie un seul mot : "Merci." → 💰 0 / 😊 +1 / ⭐ +1

---

### J98 — Dimanche 11 septembre · Cour · 14:00

**Prose** :
Avant-dernier jour. On commence à préparer les valises. Tante Mei nous donne des cadeaux : pour maman, un châle qu'elle a tissé elle-même. Pour moi, le pinceau de Wenbo et un petit carnet de calligraphie qu'il avait commencé enfant.

Je ne peux pas accepter. C'est trop. Tante Mei insiste.

— Il n'a pas eu d'enfants ici. Tu es son enfant. Ces choses-là sont à toi.

Je prends. Je m'incline profondément.

**Choix : Le soir, je fais quoi ?**

- A. Je vais marcher seule sur la route rouge une dernière fois → 💰 0 / 😊 +3 / ⭐ +2
- B. Je reste avec maman et Tante Mei dans la cour, sous les étoiles → 💰 0 / 😊 +3 / ⭐ +1
- C. J'écris la 313ème lettre dans le carnet → 💰 0 / 😊 +2 / ⭐ +2

---

### J99 — Lundi 12 septembre · Maison · 06:00

**Prose** :
Dernier matin au village. Wang vient nous chercher à 7h. Vol Fuzhou-Paris à 11h.

Tante Mei nous embrasse à la porte. Elle pleure, doucement, pour la première fois.

— Vous reviendrez ?
— Oui, dit maman.
— Promis.

Maman tient l'urne dans ses bras pendant tout le trajet en voiture. Comme un nourrisson. Elle ne dit pas un mot.

**Choix : Pendant le vol ?**

- A. Je relis la 312ème lettre une dernière fois, puis je l'arrache du carnet → 💰 0 / 😊 +2 / ⭐ +1
- B. Je tiens la main de maman et je dors → 💰 0 / 😊 +2 / ⭐ +1
- C. Je commence à préparer mentalement ma rencontre avec Tristan → 💰 0 / 😊 +1 / ⭐ +2

---

### J100 — Mardi 13 septembre · Aéroport CDG · 18:00

**Prose** :
On atterrit. Camille nous attend au terminal avec un panneau qu'elle a fait elle-même : *"Bienvenue à la maison."*

Maman pleure pour la première fois en 25 jours.

Je ne pleure toujours pas. Je crois que je n'arrive plus à pleurer. C'est sorti autrement.

**Choix : Je dis à Camille pour Tristan ?**

- A. Je lui demande si elle peut organiser un rendez-vous → 💰 0 / 😊 +2 / ⭐ +1
- B. Je lui dis qu'on en parlera demain → 💰 0 / 😊 +1 / ⭐ +1
- C. Je ne dis rien — je veux le contacter moi-même → 💰 0 / 😊 +1 / ⭐ +2

---

### J101 — Mercredi 14 septembre · Studio Belleville · 09:00

**Prose** :
Première matinée à Paris. Maman dort encore. Je sors faire les courses chez Madame Wong. Le quartier est exactement le même. Moi, je ne suis plus la même.

Je passe devant la boulangerie. Je m'achète un pain au chocolat. Je le mange en marchant. Le pain au chocolat de Belleville a un goût différent maintenant. Je sais à quoi compare.

**SMS Tristan** :

- Moi : Je suis rentrée hier soir.
- Tristan : Je sais. Camille m'a écrit.
- Tristan : Tu vas comment ?
- Moi : Bien.
- Moi : On peut se voir samedi ?
- Tristan : Oui.
- Tristan : Où tu veux ?
- Moi : Parc des Buttes-Chaumont. 15h. Banc face au lac.

**Choix : J'ajoute quoi ?**

- A. "Je serai seule." → 💰 0 / 😊 0 / ⭐ +1
- B. "Je veux te dire des choses." → 💰 0 / 😊 +1 / ⭐ +1
- C. "À samedi." → 💰 0 / 😊 +1 / ⭐ +1

---

### J102 — Jeudi 15 septembre · Studio · 14:00 ⭐ SCÈNE CANONIQUE BIS

**Prose** :
On disperse les cendres. Pont des Arts. 14h. Camille est là. Maman tient l'urne.

C'est elle qui ouvre l'urne. Le vent prend les cendres. Direction nord-ouest. Vers la Seine. Vers la mer.

**Phrase canonique** :

> *"Voilà. Je n'ai plus besoin de t'écrire pour te parler."*

Maman dit ça sans avoir prévu de le dire.

Camille me serre dans ses bras. Maman est calme. Elle a le visage d'une femme libérée.

**Choix : Le soir ?**

- A. J'écris la 313ème lettre — la dernière — dans le carnet → 💰 0 / 😊 +3 / ⭐ +2
- B. Je dîne dehors avec maman et Camille — on va dans un petit chinois du 13ème → 💰 -45 / 😊 +2 / ⭐ +1
- C. Je rentre tôt, je dors → 💰 0 / 😊 +1 / ⭐ 0

---

### J103 — Vendredi 16 septembre · Studio · 17:00

**Prose** :
Je vais voir Madame Heng. Sans Tristan. Elle me reçoit dans son salon privé. Elle me sert un thé qu'elle dit avoir gardé exprès pour moi — du Long Jing première récolte 2024.

— Mademoiselle Marchand. Vous êtes revenue.
— Vous saviez pour mon père. En 1999. Et après.
— Oui.
— Pourquoi vous n'avez rien dit à maman ?
— Parce qu'à l'époque, votre père m'avait demandé le silence. Il pensait protéger votre mère en disparaissant. Je l'ai cru. J'avais tort. C'est ma plus grande faute professionnelle. Et personnelle.
— Pourquoi vous me dites ça maintenant ?
— Parce que vous êtes revenue avec une réponse plus forte que ma faute. Et parce que je vous le devais.

Elle me tend une enveloppe. Dedans : une copie certifiée du dossier complet. Pour mes archives. Pour celles de maman.

**Choix : Que je fais ?**

- A. Je la remercie. Je pars. → 💰 0 / 😊 +2 / ⭐ +2
- B. Je reste. Je veux entendre toute son histoire. → 💰 0 / 😊 +3 / ⭐ +3
- C. Je refuse l'enveloppe. "Je n'en ai plus besoin." → 💰 0 / 😊 +4 / ⭐ +1

---

### J104 — Samedi 17 septembre · Belleville · 11:00

**Prose** :
Je me prépare. Je ne mets ni le tailleur, ni la robe d'été. Je mets un jean et un pull crème. Je laisse mes cheveux libres. Je ne mets pas de maquillage.

Camille passe me voir avant.

— Tu es prête ?
— Je crois.
— Tu sais ce que tu vas lui dire ?
— Pas exactement.
— Bien. Improvise.

Elle m'embrasse. Elle s'en va.

Je marche jusqu'aux Buttes-Chaumont. 15h pile.

**Choix : J'arrive comment ?**

- A. En avance, je m'assois sur le banc, je l'attends → 💰 0 / 😊 +2 / ⭐ +1
- B. Pile à l'heure → 💰 0 / 😊 +1 / ⭐ +1
- C. Trois minutes en retard → 💰 0 / 😊 0 / ⭐ +1

---

### J105 — Samedi 17 septembre · Buttes-Chaumont · 15:00 ⭐ SCÈNE CANONIQUE

**Prose** :
Il est sur le banc. Il a un pull noir. Il a maigri. Il se lève quand il me voit.

On ne s'embrasse pas. On ne se serre pas la main. On reste à un mètre l'un de l'autre.

— Salut, dit-il.
— Salut.

On s'assoit sur le banc. Côte à côte. Pas tout contre. Bonne distance.

Je regarde le lac. Lui aussi.

**Phrase canonique** :

- Moi : *"Je ne veux pas être sauvée. Ni épousée. Ni installée. Je veux essayer. Lentement. À parts égales."*
- Tristan : *"Oui. À tout."*

On reste sur le banc une heure. On ne se touche toujours pas. Mais quand on se lève, on marche côte à côte, et nos mains se frôlent sans se prendre.

C'est plus doux que tout ce que j'avais imaginé.

**Choix : Avant qu'on se quitte ?**

- A. Je l'embrasse — premier baiser, simple → 💰 0 / 😊 +4 / ⭐ +2
- B. Je lui prends la main, juste pour traverser une rue → 💰 0 / 😊 +3 / ⭐ +2
- C. Rien encore. On reprend le rythme. Petit à petit. → 💰 0 / 😊 +3 / ⭐ +3

---

### J106 — Lundi 19 septembre · Studio · 09:00

**Prose** :
Je m'inscris à l'école d'archi en cours du soir. Reprise en deuxième année. Cours trois soirs par semaine. Je continue les livraisons trois jours en journée.

Je vis chez maman. Pour l'instant. Plus tard on verra.

**SMS Tristan** :

- Tristan : J'ai une question.
- Moi : Vas-y.
- Tristan : Je peux t'inviter à dîner mercredi ? Pas chez moi. Au resto.
- Moi : Oui.
- Tristan : Je passe te chercher à 19h ?
- Moi : Je viens à pied. Donne l'adresse.

**Choix : Je dis quoi ce soir à maman ?**

- A. "Je le revois mercredi. C'est un dîner. C'est tout." → 💰 0 / 😊 +2 / ⭐ +1
- B. "Je le revois mercredi." (sans plus) → 💰 0 / 😊 +1 / ⭐ +1
- C. Rien — elle le verra à mon visage → 💰 0 / 😊 0 / ⭐ +1

---

### J107 — Mercredi 21 septembre · Restaurant · 19:00

**Prose** :
Petit restaurant italien près du Canal Saint-Martin. Pas chic. Pas pourri. Bien. Il a réservé sous mon nom de famille — *Marchand* — comme s'il voulait souligner que c'est moi qui pilote.

On parle. Vraiment. Pendant trois heures. De tout. Du Fujian. De Madame Heng. De Vincent (parti à Hong Kong, plus aucune fonction, en thérapie). De son démarrage de cabinet de conseil indépendant. De mes cours d'archi. Des cendres.

Il me demande si maman va mieux. Je dis oui. Il me demande comment je vais. Je dis : *"Je suis en train de réapparaître."*

Il sourit.

**Choix : En sortant ?**

- A. Il me raccompagne à pied jusqu'à Belleville (35 minutes) → 💰 0 / 😊 +3 / ⭐ +1
- B. On prend un Uber chacun → 💰 0 / 😊 +1 / ⭐ +1
- C. On boit un verre dans un bar avant → 💰 -16 / 😊 +2 / ⭐ +1

---

### J108 — Vendredi 23 septembre · École d'archi, cours du soir · 21:00

**Prose** :
Premier cours du soir. *Théorie de l'espace habité, M. Lacroix.* Vingt-cinq étudiants en deuxième année reprise. Plus jeunes que moi, pour la plupart. Plus expérimentés aussi (la plupart sont arrivés avec un bac+3 ailleurs).

Le prof me regarde sur ma fiche.

— Marchand. Vous avez interrompu ?
— Oui. Trois ans. Je reprends.
— Pourquoi vous reprenez ?
— Parce que je veux dessiner des maisons pour les gens qui ne se rencontrent pas.

Il s'arrête. Il me regarde.

— C'est une belle phrase. Je vais m'en souvenir.

Je rougis. Je m'assois.

**Choix : Le soir ?**

- A. Je rentre, j'écris dans le carnet : "Je suis revenue à l'école. Je suis vivante." → 💰 0 / 😊 +3 / ⭐ +2
- B. J'envoie un SMS à Tristan : "J'ai pris ma place." → 💰 0 / 😊 +2 / ⭐ +1
- C. Je rentre, je dors comme un caillou → 💰 0 / 😊 +1 / ⭐ 0

---

### J109 — Dimanche 25 septembre · Studio · 11:00

**Prose** :
Maman cuisine. Camille passe. Tristan vient déjeuner — première fois qu'il vient à Belleville. Il apporte des fleurs pour maman et un livre pour Camille (un essai sur le droit des femmes en Chine — Camille est sciée).

À table, il est silencieux. Il observe. Maman lui raconte des anecdotes sur Wenbo.

— Vous savez, Tristan, dit maman à un moment, je voulais vous remercier. Pour les cendres. Pour Tante Mei. Pour ma fille.
— Je n'ai rien fait.
— Vous avez tout fait.

Il rougit. Premier rougissement que je lui vois.

**Choix : En débarrassant ?**

- A. Je l'embrasse pour la première fois devant ma mère → 💰 0 / 😊 +4 / ⭐ +1
- B. Je lui dis "merci" doucement, dans la cuisine → 💰 0 / 😊 +3 / ⭐ +2
- C. Je lui prends la main une seconde, puis je la lâche → 💰 0 / 😊 +3 / ⭐ +1

---

### J110 — Vendredi 30 septembre · Belleville · 18:00

**Prose** :
Je marche. Belleville. Boulevard de la Villette. Je suis chargée — courses pour maman, sac de cours, manteau d'automne.

Je passe devant le café Hanami. Le serveur me reconnaît. Il sourit. Il m'apporte un thé sans que je commande. C'est le mien : Long Jing.

Je m'assois à la fenêtre. Je sors le carnet. J'écris la dernière phrase de la 313ème lettre :

*"Cher papa,*

*Je n'écris plus de lettres pour te parler. Je vis maintenant. Je vis avec maman, avec Camille, avec Tristan, avec Tante Mei à 9000 km. Je vis avec toi aussi, mais autrement.*

*Tu es dans la Seine. Tu es dans mon nom. Tu es dans ma bouche, comme l'a dit Madame Heng.*

*Sois en paix.*

*— Yuelan."*

Je signe Yuelan. Pour la première fois.

Je referme le carnet.

**Choix : Le soir ?**

- A. Je rentre directement chez maman → 💰 0 / 😊 +2 / ⭐ +1
- B. Je passe chez Tristan (pour la première fois depuis le retour) → 💰 0 / 😊 +3 / ⭐ +2
- C. Je marche jusqu'à la Seine, lentement → 💰 0 / 😊 +4 / ⭐ +2

---

### J111 — Samedi 1er octobre · Studio · matin

**Prose** :
Camille débarque, surexcitée.

— Shen. Shen Shen Shen.
— Quoi ?
— Le concours d'archi étudiant. Le Prix Jeune Architecte. Tu peux t'inscrire en deuxième année reprise. Date limite mardi.
— Camille je viens de reprendre.
— Justement. Tu as une histoire à raconter qu'aucun de ces gosses n'a. Inscris-toi.

Je l'écoute. Je télécharge le formulaire. Sujet libre. Maquette + texte de 2000 mots. Présentation orale.

Je commence à dessiner sur une feuille A4. Une maison pour deux personnes qui ne se sont jamais rencontrées. Cuisine partagée. Deux ailes séparées. Un patio central. Une fenêtre qui regarde toujours à l'est.

**Choix : Je m'inscris ?**

- A. Oui, immédiatement. → 💰 -50 / 😊 +3 / ⭐ +3
- B. Oui mais je prends 24h pour réfléchir. → 💰 -50 / 😊 +2 / ⭐ +2
- C. Non, c'est trop tôt. → 💰 0 / 😊 -1 / ⭐ 0

---

### J112 — Vendredi 7 octobre · Studio · 21:00 — DERNIÈRE ENTRÉE DU CARNET

**Prose** :
Aujourd'hui j'ai déposé le projet. La maquette est dans une boîte chez le concierge de l'école. Le texte est imprimé en trois exemplaires. Je présente dans trois semaines.

Je ferme ce carnet. Pas le carnet de Camille — celui-là je continuerai. Mais le grand carnet de l'été, celui que j'ai commencé le 3 juin avec un stylo bic vert.

Je relis la première page. *"Je note tout depuis hier. C'est Camille qui m'a dit de le faire. 'Tu vas vivre des trucs que tu vas oublier de vivre si tu les écris pas.'"*

Camille avait raison.

J'écris la dernière entrée :

*"112 jours. Une mère retrouvée deux fois — avant et après. Un père enfin connu, enfin pleuré, enfin pardonné. Un homme à mes côtés qui n'attend rien et qui donne tout. Une amie qui plie le linge à 14h sans qu'on lui demande.*

*Je m'appelle Shen Marchand. Je m'appelle aussi Yuelan. J'ai 24 ans. J'ai trois noms et deux pays. Je ne demande plus à choisir.*

*Je referme.*

*Demain c'est samedi. Tristan vient déjeuner. Maman fait des dumplings. Camille viendra avec un croissant.*

*Demain c'est tout. Et c'est beaucoup."*

[FIN — DÉCLENCHEMENT DE L'ÉPILOGUE SELON ENDING CALCULÉ]

---

# 10. LES 5 ÉPILOGUES

## 10.1 — "À PARTS ÉGALES" (fin canonique)

**Conditions** : `argent ≥ 30 000€` ET `mood ≥ 7` ET `reputation ≥ 10` ET `isMomTreatmentPaid`

**Texte de l'épilogue** :

*Un an plus tard.*

Salle de jury de l'école d'archi. Vingt-cinq étudiants présentent leur projet de fin d'année devant un jury de huit personnes. Je passe en avant-dernière. Mon projet s'appelle *Maison pour deux qui ne se sont jamais rencontrés*.

Ma maquette est blanche, avec deux ailes courbes qui se rejoignent en un patio. Au centre, un seul érable. L'érable que mes parents auraient pu planter en 2000.

Je présente pendant douze minutes. Le jury me pose des questions techniques. Je réponds. À la fin, le président du jury — un architecte japonais de 70 ans, Kuma Hiro — me regarde longtemps.

— Mademoiselle Marchand. C'est un projet personnel ?
— Oui.
— Vous savez que les jurys détestent généralement les projets personnels ?
— Je sais.
— Vous savez aussi que les bons projets personnels gagnent les jurys ?
— Je l'espère.

Il sourit. Il m'invite à m'asseoir.

Au fond de la salle, je vois Tristan, maman (en bonne santé, manteau crème), Camille (qui pleure déjà), et Madame Heng (en qipao gris, venue exprès).

Je descends de l'estrade. Je croise le regard de Tristan. Il me sourit. Pas un demi-sourire. Pas un sourire de drama. Un sourire d'égal à égal.

Je rentre à Belleville le soir. J'habite encore avec maman. Tristan habite à dix minutes à pied. On dîne deux fois par semaine ensemble, parfois à trois avec maman, parfois à quatre avec Camille. On ne se mariera probablement pas. On ne vit probablement jamais ensemble. Et c'est exactement comme on voulait.

Sur le mur de mon studio, encadrée : la photo de mes parents en 1999, pont des Arts. À côté, en noir sur blanc : la calligraphie 心 que j'ai faite chez Tante Mei.

À côté encore : un papier kraft. La lettre de mon père.

Et au-dessus de tout ça, sur l'étagère, le carnet vert offert par Camille. À l'intérieur, la 313ème lettre se termine par : *"— Yuelan."*

Je n'ai pas gagné le Prix Jeune Architecte. Je suis arrivée troisième. Tristan a ouvert une bouteille pour fêter ça. Maman a souri. Camille a dit *"Troisième sur 25 en deuxième année reprise, t'es une bête."*

J'ai tout. Je n'ai rien à prouver à personne.

Je suis profonde. C'est tout ce que mon père m'a demandé.

---

## 10.2 — "LA CAGE DORÉE"

**Conditions** : `argent ≥ 30 000€` ET `mood < 5` ET `reputation ≥ 15`

**Texte de l'épilogue** :

*Un an plus tard.*

Mariage Heng-Marchand. 200 invités. Top of the Tour Heng. Vue sur Paris la nuit. Les photographes du Figaro, de Vogue Paris, de quatre magazines asiatiques. Robe Givenchy, sur mesure.

Je suis belle. C'est objectif. Tout le monde le dit.

Maman est présente. Elle est en bonne santé. Elle porte un tailleur gris. Elle ne sourit pas autant que je l'avais imaginé.

Camille est invitée mais elle a refusé de venir. Elle m'a écrit une lettre la veille. *"Je t'aime. Je viens pas. Tu sais pourquoi. Si tu changes d'avis dans un mois, dans un an, dans dix ans, je suis là."*

Tristan est élégant. Il est doux. Il est tendu.

À 23h, je m'éclipse aux toilettes. Je me regarde dans le miroir. Je me dis : *"J'ai oublié pourquoi je voulais devenir architecte."*

Je n'ai pas repris l'archi. J'ai monté une marque de mode capsule avec 80 000 followers Instagram. J'ai 30 000€ par mois en partenariats. Je n'écris plus dans le carnet. J'écris des captions Insta.

Je rentre à la table. Je souris pour les photos.

Le carnet vert offert par Camille est dans un tiroir fermé à clé. La clé est dans le tiroir d'à côté, mais je ne l'ouvre pas. Je ne suis pas allée au Fujian depuis le voyage de l'été 2025. Tante Mei m'a écrit deux fois. Je n'ai pas répondu.

Sur le mur de notre appartement (350m², 8ème), il y a une œuvre d'art contemporain à 220 000€.

Il n'y a pas de photo de mes parents en 1999.

Il n'y a pas de calligraphie 心.

Il n'y a pas de lettre de mon père.

J'ai gagné. C'est tout ce que tout le monde dit.

---

## 10.3 — "LE DEUIL ET LA ROUTE"

**Conditions** : `!isMomTreatmentPaid` (maman n'a pas reçu le traitement à temps)

**Texte de l'épilogue** :

*Six mois plus tard.*

Maman est partie en juillet. Elle a tenu jusqu'au bout. Elle m'a souri la dernière nuit. Elle m'a dit : *"Va au Fujian, ma fille. C'est tout ce que je te demande."*

J'y suis. J'habite chez Tante Mei depuis quatre mois. Le village. La calligraphie tous les matins. Le potager. Le silence.

J'apprends le mandarin. Le vrai. Pas celui des restaurants du 13ème. Celui qu'on parle dans les champs.

Je n'ai pas encore décidé si je rentrerai en France. Tristan attend. Il m'a écrit deux pages magnifiques. Je lui ai répondu trois lignes. *"Je ne sais pas quand. Je sais juste que ce n'est pas encore."*

Camille m'écrit une fois par semaine. Elle me raconte sa fin de master. Elle me dit qu'elle viendra me voir en juin. Elle compte les jours.

Sur la table de Tante Mei, il y a deux urnes. Celle de Wenbo, qu'on a finalement gardée ici. Et celle de maman, que j'ai rapportée en septembre. On les a placées côte à côte sur l'autel familial. Vingt-six ans plus tard, ils sont enfin réunis. Pas comme on l'avait prévu. Mais ensemble.

Je calligraphie 心 tous les matins, sur du papier de riz. Au bout du sixième mois, mon trait commence à ressembler au sien — celui de mon père enfant, gravé sur le chambranle de sa chambre.

J'écris dans le carnet vert tous les soirs. Camille avait raison. Le nouveau carnet, c'est une nouvelle écriture.

Je ne sais pas comment cette histoire finit. C'est pour ça qu'elle continue.

---

## 10.4 — "BELLEVILLE"

**Conditions** : `mood ≥ 8` ET `reputation ≤ 5` ET `isMomTreatmentPaid`

**Texte de l'épilogue** :

*Un an plus tard.*

Je n'ai pas accepté la proposition de Tristan. Pas parce que je ne l'aimais pas. Parce que je m'aime mieux à Belleville.

J'habite avec maman. Studio 14m². Je continue les livraisons trois jours par semaine. Je suis en deuxième année d'archi en cours du soir. Je présente mon projet de fin d'année dans deux mois.

Je n'ai pas de followers Instagram. J'ai 712 abonnés, comme au début, et c'est très bien. Pas de partenariats. Pas de robes Acne offertes. Pas de week-ends Kyoto. Pas de Tesla.

J'ai 1 200€ sur mon compte courant. C'est largement assez.

Tristan vient dîner deux fois par mois. Il connaît maman. Maman l'aime. Camille l'aime aussi. On rit beaucoup quand il est là. On rit aussi quand il n'est pas là.

Il ne me demande plus de venir vivre avec lui. Il a compris. Il vient quand je l'invite. Je l'invite souvent.

Sur le mur du studio, encadrées : la photo de 1999. La calligraphie 心. La lettre de mon père.

Je suis allée au Fujian deux fois cette année. J'apprends le mandarin avec Tante Mei par appel vidéo le dimanche.

Madame Heng m'envoie un thé Long Jing toutes les saisons. Je lui envoie des cartes postales de Paris.

Le matin je livre. L'après-midi je dessine. Le soir j'apprends.

Camille frappe à la porte ce dimanche, croissant à la main. Maman ouvre. Tristan arrive trente minutes plus tard avec une bouteille de vin.

On dîne. Ensemble. Comme tous les dimanches.

Je suis profonde. Je suis pauvre. Je suis libre.

---

## 10.5 — "L'ENTRE-DEUX"

**Conditions** : par défaut, `argent ≥ 18 000€` ET `mood ≥ 6`

**Texte de l'épilogue** :

*Six mois plus tard.*

J'ai quitté Paris il y a deux mois. Programme d'échange Architecture Franco-Chinoise. Un an à Shanghai. Pas le Shanghai que je connais — celui de Madame Heng, des tours, des galas. L'autre. Celui des étudiants. Du dernier métro à 23h. Des petits appartements partagés à trois.

Je vis dans un *long tang* du quartier français. 18m². Je peux toucher les deux murs en bas du lit en écartant les bras. C'est petit. C'est parfait.

Je vais à l'école six jours sur sept. J'apprends le mandarin technique de l'architecture. Le professeur Lu Jianyu nous fait travailler sur la rénovation des hutongs. C'est passionnant.

Le week-end, je prends le train pour le Fujian. Trois heures vingt. Tante Mei m'attend avec du congee. Je passe deux jours, je rentre.

Tristan ne m'a pas suivie. Mais il vient. Il vient deux fois par mois. Il prend l'avion le vendredi soir. Il repart le dimanche soir. On vit nos vies. On se retrouve. Ça marche.

Je n'ai pas dit oui. Je n'ai pas dit non. J'ai dit : *"Pas maintenant, et peut-être jamais comme tu le rêves, mais regardons ce qu'on construit."*

Maman est à Paris. Elle va bien. Camille passe la voir une fois par semaine. Elle dit que maman est plus en forme que jamais.

J'écris dans le carnet vert tous les soirs. La 313ème lettre est terminée. La 314ème commence par : *"Cher papa, aujourd'hui j'ai vu un pont à Hangzhou que tu aurais aimé."*

Je suis quelque part entre deux pays, entre deux langues, entre deux hommes (toi qui n'est plus, lui qui patiente). Je suis dans l'entre-deux. Et je m'y trouve enfin.

Je suis profonde. Je continue d'apprendre à l'être.

---

# 11. NOTES POUR CLAUDE CODE

## 11.1 — Comment utiliser ce document

Ce ROADMAP.md est la **vérité narrative** du projet. Tout le contenu textuel du jeu doit s'y conformer.

Pour chaque jour J1 à J112 :

1. La **prose** narrative doit être encodée fidèlement dans `scenario.json` sous forme de blocs `prose`.
2. Les **SMS** doivent être encodés sous forme de blocs `sms` avec la conversation correspondante (`maman`, `camille`, `tristan`, `vincent`, ou `_inline` pour un dialogue oral retranscrit en bulles).
3. Les **3 choix** par jour doivent être encodés avec leurs deltas exacts.
4. Les **scènes canoniques** (J23, J46, J62, J69, J102, J105) doivent être reproduites mot pour mot.

## 11.2 — Branches narratives à implémenter

- **Branche deuil** (J46+) : si `argent < 18000` à J45, ne pas charger les jours canoniques J46-J112 mais des jours alternatifs orientés "Le deuil et la route". Pour la v1, rediriger directement vers l'épilogue 10.3 sans détailler les jours alternatifs (à enrichir en v2).
- **Branche burn-out** (mood ≤ 2 sur 3 jours) : afficher une scène hospitalière, restaurer mood à 4, pénaliser argent de -500€, retour au scénario normal.
- **Filtre choix** (mood < 3) : griser visuellement l'option la plus "vertueuse" du jour, afficher "Tu n'as plus la force aujourd'hui."

## 11.3 — Triggers à programmer

| Jour | Trigger | Détail |
| --- | --- | --- |
| J7 | unlock conversation | Tristan dans Messages |
| J35 | bourse HENG +12% | gala asiatique |
| J40 | unlock conversation | Vincent dans Messages |
| J52 | bourse HENG -18% | attaque Vincent |
| J45 | check deadline maman | branche deuil si raté |
| J71 | scène raconté à distance | démasquage Vincent |
| J76 | bourse HAN +35% | Hanami 3 cafés |
| J88 | bourse NCB -22% | scandale |
| J112 | calcul ending | redirection épilogue |

## 11.4 — Ressources de départ

```
argent: 2384 €
mood: 5
reputation: 0
followers: 712 (= 0 × 1000, déjà offset par narration)
currentDay: 1
```

## 11.5 — Cadeaux spontanés (paliers de mood atteints pour la première fois)

- **Mood 6 atteint pour la 1ère fois** : un voisin offre un bouquet de fleurs (note carnet, +1 mood)
- **Mood 7 atteint pour la 1ère fois** : Camille prête une robe (note carnet, +1 mood)
- **Mood 8 atteint pour la 1ère fois** : Tristan laisse un mot manuscrit sur la table (note carnet, +2 mood)
- **Mood 9 atteint pour la 1ère fois** : Hélène ressort un bijou ancien et l'offre à Shen (note carnet, +2 mood, +1 réputation)

Ces scènes ne sont pas des choix, juste des écrans narratifs courts, déclenchés une seule fois.

## 11.6 — Posts Instagram automatiques

Quand le joueur achète un item avec `generatesInstaPost: true`, créer un nouveau post dans le feed Insta avec :

- Avatar : Shen
- Caption : `instaPostCaption` de l'item
- Emoji image : `instaPostEmoji`
- Likes : (followers × 0.05) ± 20%

---

# FIN DU ROADMAP

Document complet à la date du 9 mai 2026.
Total : 112 jours scénarisés + 5 épilogues + bible + specs techniques + catalogues.
