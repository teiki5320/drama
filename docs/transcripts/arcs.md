# Arcs Messages secondaires

### 🩺 Dr Aubin — oncologue Maman  ·  `dr_aubin`

- Catégorie **medical** · démarre ≥ J2 · contact Dr Aubin (Tenon) (Oncologue)
- _Oncologue Tenon. Confirmation RDV, résultats, possibilité d'aide sociale si Shen ose demander. 3 fins._
- Fichier `lib/data/messages_arcs/dr_aubin.dart` · 10 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:06 | l'autre | text | **3 variantes :** « Bonjour Madame Marchand. Dr Aubin, Tenon. Confirmation RDV de Madame Marchand-mère vendredi 8h30, niveau 2, couloir K. Merci de venir accompagnée. » ⁄ « Bonjour. Dr Aubin. Je confirme la séance de chimio mardi matin. Apportez sa carte vitale et l'ordonnance précédente. » ⁄ « Bonjour Madame Marchand. Suite à l'examen sanguin de votre mère, je souhaite vous voir avec elle vendredi 11h. Cabinet 214. » |
| J+0 | 00:12 | **Shen** | choice | **CHOIX :** |
| | | | | · **Confirmer** → « Bonjour Docteur. Confirmé. Je serai là. » →`shen_confirme_a` |
| | | | | · **Demander pourquoi** → « Bonjour Docteur. Pourquoi me demandez-vous d'être présente à ce rendez-vous précisément ? » →`shen_inquiet_a` |
| | | | | · **Reporter** → « Je ne peux pas vendredi. Lundi possible ? » →`shen_reporte_a` |
| J+0 | 00:18 | l'autre | text | **3 variantes :** « Rien d'urgent au sens où il faudrait paniquer. Mais le résultat mérite que nous nous parlions à trois. Bonne soirée. » ⁄ « Examen de routine + un point que je souhaite discuter avec vous présente. Cela aide votre mère. À vendredi. » ⁄ « C'est un rendez-vous de protocole. Mais votre présence simplifie la conversation. Je vous expliquerai sur place. » _(si `shen_inquiet_a`)_ |
| J+0 | 00:22 | l'autre | text | **2 variantes :** « Lundi 11h alors. Cabinet 214. Apportez la carte vitale. » ⁄ « D'accord pour lundi mais je dois préciser que les nouveaux résultats ne s'attendent pas. Lundi 14h. » _(si `shen_reporte_a`)_ |
| J+2 | 17:14 | l'autre | text | **3 variantes :** « Rappel pour le rendez-vous demain matin. Pensez à arriver 15 min avant pour les formalités. » ⁄ « Petit rappel : RDV demain. Faites-la déjeuner légèrement la veille. » ⁄ « À demain. Si elle prend du Tramadol, ne pas en prendre 4h avant. » _(sauf `shen_reporte_a`)_ |
| J+3 | 15:38 | l'autre | text | **3 variantes :** « Suite à votre passage ce matin : votre mère a très bien réagi à la nouvelle. Comme toujours. Tenez bon. » ⁄ « Je vous rappelle le seuil important : nous avons jusqu'à J45. Au-delà la décision médicale change. » ⁄ « Je vous joins par mail le devis et la lettre pour votre mutuelle. Si quelque chose ne va pas, écrivez-moi. » _(sauf `shen_reporte_a`)_ |
| J+3 | 15:42 | **Shen** | choice | **CHOIX :** |
| | | | | · **Merci pro** → « Merci Docteur. Je vous tiens informé. » →`shen_pro_a` |
| | | | | · **Honnête** → « Docteur, je vais devoir trouver 18 000 € en 6 semaines. Est-ce qu'il existe des aides que je n'ai pas explorées ? » →`shen_honnete_a` |
| | | | | · **Silence** → « _(silence)_ » →`shen_silence_a` |
| J+4 | 09:14 | l'autre | text | **3 variantes :** « L'assistante sociale de l'hôpital, Madame Lemaître, est disponible le mardi. Je vous écris son numéro : 01 56 01 70 32. Dites que vous venez de ma part. » ⁄ « Il existe un fond d'urgence pour les cancers rares, dossier à monter sous 10 jours. Je vous envoie le formulaire par mail. » ⁄ « Je peux orienter votre dossier vers une bourse caritative qui finance jusqu'à 8 000 € en 4 semaines. Je vous joins demain. » _(si `shen_honnete_a`, FIN `aubin_aide_pratique`)_ |
| J+5 | 18:08 | l'autre | text | Bonne continuation. À votre disposition si besoin. _(si `shen_pro_a`, FIN `aubin_distance_pro`)_ |
| J+6 | 11:32 | l'autre | text | Pas de nouvelles. J'espère que votre mère va bien. Je reste joignable. _(si `shen_silence_a`, FIN `aubin_silence`)_ |

### ⚠️ Faux SAV Apple  ·  `faux_sav_apple`

- Catégorie **arnaque** · démarre ≥ J1 · contact +33 1 84 88 23 41 (Numéro inconnu)
- _Arnaque SMS Apple. Bloquer / cliquer / donner code. Si Shen donne le code = catastrophe bancaire._
- Fichier `lib/data/messages_arcs/faux_sav.dart` · 6 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:04 | l'autre | text | **3 variantes :** « APPLE INFO — Votre compte iCloud a été identifié comme compromis. Connectez-vous à appleid-secure.fr pour régulariser sous 24h. STOP au 38242. » ⁄ « APPLE SAV — Tentative d'accès non autorisée à votre Apple ID. Vérifiez maintenant : apple-id.fr/securite » ⁄ « INFO SECURITE APPLE — 3 connexions suspectes depuis Hong Kong. Sécurisez votre compte : apple-secure-fr.com » |
| J+0 | 00:06 | **Shen** | choice | **CHOIX :** |
| | | | | · **Bloquer + signaler** → « _(silence)_ » FIN `shen_block_sav` |
| | | | | · **Curieuse** → « Quel numéro de compte concerné ? » →`shen_curieuse_sav` |
| | | | | · **Cliquer** → « (elle ouvre le lien) » →`shen_clique_sav` |
| J+0 | 00:14 | l'autre | text | **3 variantes :** « Compte ID Apple terminant par les 4 derniers chiffres de votre numéro de téléphone. Confirmez en cliquant : apple-id.fr/X » ⁄ « Apple ID enregistré au nom de "marchand". Veuillez fournir le code à 6 chiffres reçu par SMS pour confirmer. » ⁄ « Votre compte sera désactivé dans 47 minutes. Sécurisez : appleid-x.com » _(si `shen_curieuse_sav`)_ |
| J+0 | 00:18 | **Shen** | choice | **CHOIX :** _(si `shen_curieuse_sav`)_ |
| | | | | · **Bloquer + signaler** → « _(silence)_ » FIN `shen_block_sav_late` |
| | | | | · **Donner code** → « (Shen envoie un code à 6 chiffres) » →`shen_donne_code` |
| J+1 | 06:24 | l'autre | text | **2 variantes :** « Merci. Votre compte est sécurisé. ⏎  ⏎ — BANQUE INFO : Prélèvement Apple Services 287,50 € — compte clôturé pour insuffisance. » ⁄ « Compte vérifié. Bonne journée. ⏎  ⏎ — ALERTE BNP : tentative de paiement à 320 € sur AliExpress refusée. Vérifiez votre application. » _(si `shen_donne_code`, FIN `shen_arnaquee`)_ |
| J+1 | 09:14 | l'autre | text | **2 variantes :** « Votre session a expiré. Reconnectez-vous : appleid-secure.fr » ⁄ « Tentative d'accès non autorisée toujours active. Sécurisez sous 12h. » _(si `shen_clique_sav`, FIN `shen_sauve_de_justesse`)_ |

### ❓ Karim (wrong number)  ·  `karim_wrong_number`

- Catégorie **wrongNumber** · démarre ≥ J1 · contact +33 6 79 24 31 88 (Numéro inconnu)
- _Wrong number qui devient confident d'angoisse. Karim mécano à Pantin, père en chimio._
- Fichier `lib/data/messages_arcs/karim_wrong.dart` · 11 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:04 | l'autre | text | **3 variantes :** « Salut Karim t'es où ? » ⁄ « Vas-y bro tu pars sans dire » ⁄ « T'es où t'as oublié les clés du garage » |
| J+0 | 00:12 | **Shen** | choice | **CHOIX :** |
| | | | | · **Doux** → « Bonjour, je crois que vous vous trompez de numéro. » →`shen_doux_k` |
| | | | | · **Joueuse** → « Je suis pas Karim mais j'ai pas les clés non plus. » →`shen_joueuse_k` |
| | | | | · **Ignore** → « _(silence)_ » FIN `shen_ignore_k_silent` |
| J+0 | 00:14 | l'autre | text | **3 variantes :** « Oh putain pardon. Mauvais numéro. ⏎ Désolé Madame. » ⁄ « Mince. Bonne soirée. » ⁄ « Pardon. Bonne journée. » _(sauf `shen_ignore_k_silent`)_ |
| J+0 | 00:16 | l'autre | text | **3 variantes :** « Haha. Vous m'avez fait rire en plein stress. Merci. Bonne soirée Madame. » ⁄ « C'est cool. Vraiment. J'avais pas la tête au taf, ça m'a remis en route. » ⁄ « Le mec à qui je tape ne répond jamais. Vous gagnez le concours du soir. » _(si `shen_joueuse_k`)_ |
| J+1 | 13:42 | l'autre | text | **3 variantes :** « Salut Madame. C'est moi du mauvais numéro hier. Karim — le vrai. 24 ans, mécano à Pantin. Pas relou je vous jure. » ⁄ « Du coup je m'appelle Karim aussi 😅 c'est mon prénom. Et hier j'écrivais à mon associé. Petite vie quoi. » ⁄ « Promis je vais pas devenir relou. Mais merci pour hier. C'était cool d'avoir un rire en plein gros caca. » _(si `shen_joueuse_k`)_ |
| J+1 | 13:48 | **Shen** | choice | **CHOIX :** _(si `shen_joueuse_k`)_ |
| | | | | · **Continuer** → « Hey Karim. Moi Shen. Pas tellement plus vieille que toi. Bonne fin de journée. » →`shen_continue_k` |
| | | | | · **Couper poli** → « C'est gentil. Bonne suite Karim. » →`shen_coupe_poli_k` |
| | | | | · **Couper sec** → « OK bye. » →`shen_coupe_sec_k` |
| J+3 | 21:14 | l'autre | text | **3 variantes :** « Salut. Petite question chelou : t'as déjà parlé à un inconnu plus simplement qu'aux gens que tu connais ? » ⁄ « Bizarre que je t'écrive. Je m'attendais pas à toi. Bonne soirée. » ⁄ « Je t'envoie ce truc parce qu'au taf personne écoute. Pas obligée de répondre. » _(si `shen_continue_k`)_ |
| J+3 | 21:22 | l'autre | text | **3 variantes :** « Mon père est en chimio depuis 8 mois. Ma mère est forte mais je vois qu'elle craque la nuit. Je travaille la journée et je suis ailleurs le soir. Voilà. » ⁄ « On ouvre un garage à 4. J'ai investi tout ce que j'avais. Si ça capote dans 6 mois je sais pas ce que je deviens. » ⁄ « Mon associé Karim — l'autre Karim — il vient de me lâcher. Du coup j'ai un truc qui pend. » _(si `shen_continue_k`)_ |
| J+3 | 21:28 | **Shen** | choice | **CHOIX :** _(si `shen_continue_k`)_ |
| | | | | · **Confier** → « Ma mère est malade aussi. C'est cher et c'est court. J'ai pas dit ça à grand monde. » →`shen_confie_k` |
| | | | | · **Écouter** → « Je suis désolée Karim. C'est dur. Tu fais comment ? » →`shen_ecoute_k` |
| | | | | · **Reculer** → « Pardon Karim, je peux pas être ton oreille. Bonne soirée. » FIN `k_recule_k` |
| J+5 | 22:14 | l'autre | text | **3 variantes :** « Wesh. On se ressemble plus que je pensais. Tu veux qu'on se voie pour un café ? Je suis pas chelou promis. » ⁄ « Pareil pour moi cette semaine. Si tu craques la nuit, tu m'écris. » ⁄ « Tu sais quoi : si t'as besoin d'un mec qui sait pas quoi dire mais qui répond, je suis là. » _(si `shen_confie_k`, FIN `karim_compagnon_angoisse`)_ |
| J+4 | 22:32 | l'autre | text | **2 variantes :** « Merci. Bonne soirée. » ⁄ « Merci d'avoir lu en fait. » _(si `shen_ecoute_k`, FIN `karim_ami_distant`)_ |

### 🌸 Mathieu B. (retour Tokyo)  ·  `mathieu_tokyo`

- Catégorie **ex** · démarre ≥ J6 · contact Mathieu B. (Ami d'enfance)
- _Ami d'enfance rentre de Tokyo. Ancien amour non avoué. Confession Heng possible._
- Fichier `lib/data/messages_arcs/mathieu_tokyo.dart` · 12 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:08 | l'autre | text | **3 variantes :** « Shen. C'est Mathieu B. Six ans c'est long. Je rentre à Paris mardi prochain. T'es là ? » ⁄ « Hello. Je sais pas si tu te rappelles de moi. CM2-3e à Buttes-Chaumont. Mathieu. Je rentre à Paris. » ⁄ « Bonjour Marchand. Mathieu. J'ai rêvé de toi à Shinjuku, c'est ridicule. Je rentre en France et je veux te voir. » |
| J+0 | 00:14 | **Shen** | choice | **CHOIX :** |
| | | | | · **Surprise heureuse** → « Mathieu ! Putain six ans oui. Reviens me dire. » →`shen_surprise_m` |
| | | | | · **Curieuse** → « Mathieu. Salut. Bizarre que tu m'écrives. Pourquoi maintenant ? » →`shen_curieuse_m` |
| | | | | · **Distante** → « Bonjour Mathieu. Heureuse pour ton retour. » →`shen_distante_m` |
| J+1 | 09:32 | l'autre | text | **3 variantes :** « OK alors quick update : Tokyo c'est fini, je suis vendu. J'ai failli ouvrir une boulangerie française là-bas. Failli. » ⁄ « Je suis chez ma sœur le temps de trouver un appart. Je veux te voir mais je veux pas que ça fasse vieux truc. » ⁄ « Petite question chelou : tu te rappelles de la fontaine derrière le collège ? On y était les jeudis. T'as gardé ces lieux ? » _(si `shen_surprise_m`)_ |
| J+1 | 12:14 | l'autre | text | **3 variantes :** « Parce que je me suis fiancé en juin et j'ai annulé en septembre. Je suis pas dans un bon état. Et tu as toujours été un point fixe pour moi. J'ai pas le droit, je le dis quand même. » ⁄ « Parce que mes parents ont divorcé fin août. Et je sais pas à qui parler à Paris. Tu es la seule à qui je veuille écrire. » ⁄ « Parce que je suis trop honnête à Tokyo et trop seul à Paris. Je voulais te dire bonjour avant qu'on devienne complètement des étrangers. » _(si `shen_curieuse_m`)_ |
| J+3 | 19:32 | l'autre | text | **3 variantes :** « Café samedi 11h, Boot Café Niel ? Tu peux refuser, je serai pas vexé. » ⁄ « On marche autour des Buttes-Chaumont dimanche matin ? Sans plan fixe. » ⁄ « Sushi vendredi 20h, rue Sainte-Anne ? Je connais un place que tu vas aimer. » _(sauf `shen_distante_m`)_ |
| J+3 | 19:36 | **Shen** | choice | **CHOIX :** _(sauf `shen_distante_m`)_ |
| | | | | · **Oui** → « Oui. Je viens. » →`rdv_m` |
| | | | | · **Plus tard** → « Pas cette semaine. La suivante ? » →`rdv_m_decale` |
| | | | | · **Refuser** → « Je peux pas. Pardon Mathieu. » FIN `shen_recule_m` |
| J+5 | 10:08 | l'autre | mapLocation | _mapLocation_ _(si `rdv_m`)_ |
| J+5 | 17:28 | l'autre | text | **3 variantes :** « On a parlé 4h. Je crois que j'ai pleuré. ⏎ Merci. » ⁄ « Tu m'as rien demandé sur Tokyo. T'as senti que c'était la bonne distance. Personne fait ça. » ⁄ « Je sais pas ce qu'on a fait là, mais on a fait quelque chose. » _(si `rdv_m`)_ |
| J+5 | 17:32 | **Shen** | choice | **CHOIX :** _(si `rdv_m`)_ |
| | | | | · **Confier** → « Mathieu, je vis avec un homme. C'est un contrat de 3 mois. Je voulais te le dire avant qu'on continue. » →`shen_confesse_m` |
| | | | | · **Doux** → « Moi aussi. C'était nécessaire. » →`shen_doux_post_m` |
| | | | | · **Esquiver** → « Sympa. » →`shen_esquive_post_m` |
| J+7 | 22:14 | l'autre | text | **3 variantes :** « Un contrat. OK. Pour ta mère ? ⏎ Je vais pas faire semblant que je comprends mais je vais pas te juger non plus. ⏎ Tu m'écris quand le contrat est fini ? » ⁄ « Tu sais quoi : tu mérites d'être aimée vraiment. ⏎ Quand ce sera fini, écris-moi. » ⁄ « Je vois Paris d'une autre façon depuis ce que tu m'as dit. Je vais essayer d'être patient. Si je dois être patient. » _(si `shen_confesse_m`, FIN `mathieu_attend`)_ |
| J+9 | 21:18 | l'autre | text | **3 variantes :** « On se revoit ce week-end ? » ⁄ « Je veux retravailler avec toi sur le projet de fontaine. » ⁄ « Cinéma mardi ? Le Champo. » _(si `shen_doux_post_m`, FIN `mathieu_continue`)_ |
| J+12 | 22:32 | l'autre | text | Bonne suite Shen. _(si `shen_esquive_post_m`, FIN `mathieu_blesse_silence`)_ |

### 🌿 Nadia (ex coloc Belleville)  ·  `nadia_coloc`

- Catégorie **ancien** · démarre ≥ J10 · contact Nadia (ex coloc) (Belleville)
- _Ex coloc Belleville. Shen est partie sans expliquer. Confession possible, alliance ou glaciation._
- Fichier `lib/data/messages_arcs/nadia_ex_coloc.dart` · 10 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:06 | l'autre | text | **3 variantes :** « Shen tu as oublié plein d'affaires. Je les ai mises dans 2 cartons. Tu repasses quand ? » ⁄ « Hello Shen. Trois semaines sans nouvelles. Tu vis où maintenant ? On était colocs depuis 2 ans quand même. » ⁄ « Shen. Sérieusement. Tu m'expliques ce qui s'est passé ? » |
| J+0 | 00:14 | **Shen** | choice | **CHOIX :** |
| | | | | · **Honnête** → « Nadia pardon. Je suis partie vite parce que je vis temporairement chez quelqu'un. C'est long à expliquer. » →`shen_honnete_n` |
| | | | | · **Évasive** → « Pardon Nadia. Je suis chez ma mère un moment. Je repasse samedi. » →`shen_evasive_n` |
| | | | | · **Pratique** → « Je passe samedi 14h prendre les cartons. Merci. » →`shen_pratique_n` |
| J+1 | 11:14 | l'autre | text | **3 variantes :** « OK. T'es pas obligée de m'expliquer. Mais t'aurais pu dire un mot. Je commence à payer ta part du loyer. » ⁄ « Merci de dire. Tu es chez qui ? Pas de jugement. » ⁄ « Ça va Shen ? Tu peux me dire si t'as besoin. » _(si `shen_honnete_n`)_ |
| J+1 | 11:18 | **Shen** | choice | **CHOIX :** _(si `shen_honnete_n`)_ |
| | | | | · **Tout dire** → « Je vis chez quelqu'un qui me paie pour qu'on fasse semblant pendant 3 mois. C'est pour Maman. Pour ses soins. » →`shen_tout_dit_n` |
| | | | | · **Pas plus** → « Je peux pas en dire plus là. Je te paie ta part de loyer jusqu'à la fin du bail, promis. » →`shen_loyer_n` |
| J+2 | 08:14 | l'autre | text | **3 variantes :** « Putain Shen. ⏎ T'aurais pu me le dire. Je suis là. ⏎ Viens dîner jeudi. Pas de pression. » ⁄ « Tu as fait ça pour ta mère. OK. Je vais pas te juger. Je suis là si tu veux. » ⁄ « Je suis pas sûre de comprendre mais je vais pas te juger. Tu peux venir dormir ici quand tu veux. » _(si `shen_tout_dit_n`, FIN `nadia_alliee_silence`)_ |
| J+4 | 19:08 | l'autre | text | **2 variantes :** « OK. Merci pour le loyer. Je trouve un nouveau coloc pour le mois prochain. » ⁄ « Reçu. Bonne suite Shen. J'espère que tu vas bien. » _(si `shen_loyer_n`, FIN `nadia_distance`)_ |
| J+2 | 14:32 | l'autre | text | **3 variantes :** « Ta mère a appelé pour récupérer ton courrier. Elle savait pas que tu étais pas chez Belleville. Tu lui as menti aussi ? » ⁄ « Shen. Je suis pas conne. Ta mère sait pas pour ton départ. Tu m'expliques ? » ⁄ « Bon. Je crois qu'on doit se voir. Tu peux passer samedi ? » _(si `shen_evasive_n`)_ |
| J+2 | 14:38 | **Shen** | choice | **CHOIX :** _(si `shen_evasive_n`)_ |
| | | | | · **Avouer** → « Pardon Nadia. C'est dur à dire. Ma mère sait pas. Je gère son traitement seule. J'ai un arrangement avec quelqu'un. Pour l'argent. » →`shen_avoue_n` |
| | | | | · **Fermer** → « Je peux pas en parler. Désolée. » FIN `nadia_blesse` |
| J+4 | 22:14 | l'autre | text | OK Shen. C'est lourd ce que tu portes. ⏎ Quand tu veux dîner, je suis là. _(si `shen_avoue_n`, FIN `nadia_alliee_silence`)_ |
| J+5 | 13:22 | l'autre | text | **2 variantes :** « Bon. Les cartons sont devant la porte. Bonne suite. » ⁄ « Pas la peine de sonner. Je serai sortie samedi. » _(si `shen_pratique_n`, FIN `nadia_glace`)_ |

### 📜 Maître Vidal (notaire)  ·  `notaire_vidal`

- Catégorie **admin** · démarre ≥ J9 · contact Maître Vidal (Notaire)
- _Notaire post-signature. Rappels clauses, possibilité d'explorer annulation (30 000 € pénalité)._
- Fichier `lib/data/messages_arcs/notaire.dart` · 8 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 10:08 | l'autre | text | **3 variantes :** « Mlle Marchand, Mtre Vidal. Confirmation : contrat signé hier sous référence 2026/AVN/0847. Original 14 pages dans votre dossier client. Cordialement. » ⁄ « Mlle Marchand. Suite à la signature : votre premier acompte de 10 000 € sera versé sous 48 h ouvrées. Le solde à mi-période. » ⁄ « Bonjour. Petit rappel : clause 11 — vous êtes tenue à la discrétion absolue. Aucun tiers ne doit être informé. » |
| J+0 | 10:14 | **Shen** | choice | **CHOIX :** |
| | | | | · **Accuser réception** → « Bonjour Maître. Bien reçu. Merci. » →`shen_recu_v` |
| | | | | · **Demander une copie** → « Bonjour. Pourriez-vous me renvoyer une copie PDF ? J'ai égaré l'original. » →`shen_pdf_v` |
| | | | | · **Question annulation** → « Bonjour Maître. Quelle est exactement la procédure d'annulation unilatérale ? » →`shen_annul_v` |
| J+1 | 09:32 | l'autre | text | **2 variantes :** « PDF envoyé sur votre adresse marchand.shen@gmail.com. Si vous ne le voyez pas, vérifiez les spams. » ⁄ « Document numérique envoyé. Veuillez le stocker dans un lieu sûr. L'original physique doit rester chez vous. » _(si `shen_pdf_v`)_ |
| J+1 | 09:32 | l'autre | text | **2 variantes :** « Clause 14 : en cas de rupture unilatérale de votre part, indemnité de 30 000 € à verser sous 30 jours. Les fonds déjà versés ne sont pas restitués. » ⁄ « Annulation unilatérale = pénalité 30 000 € + obligation de discrétion maintenue 10 ans. Je vous le rappelle pour mémoire. » _(si `shen_annul_v`)_ |
| J+1 | 09:36 | **Shen** | choice | **CHOIX :** _(si `shen_annul_v`)_ |
| | | | | · **Demander suite** → « Est-ce qu'il y a une marge de négociation pour réduire cette pénalité ? » →`shen_negocie_v` |
| | | | | · **Comprendre** → « Compris Maître. Merci de la précision. » →`shen_compris_v` |
| J+2 | 16:14 | l'autre | text | **2 variantes :** « Aucune. Le contrat est signé en l'état. Je vous suggère de relire l'article 14 avant toute action. » ⁄ « La marge dépend de votre contrepartie. Vous voulez en discuter en rendez-vous ? 250 € l'heure. » _(si `shen_negocie_v`, FIN `notaire_dur`)_ |
| J+3 | 11:04 | l'autre | text | À votre disposition pour toute question. Cordialement. _(si `shen_compris_v`, FIN `notaire_pro_distant`)_ |
| J+3 | 16:22 | l'autre | text | Confirmation : premier acompte de 10 000 € versé ce matin sur le compte indiqué. Bonne suite. _(si `shen_recu_v`, FIN `notaire_pro_distant`)_ |

### 📐 Sarah — ex-collègue archi  ·  `sarah_collegue`

- Catégorie **ancien** · démarre ≥ J4 · contact Sarah Vincent (Ancienne collègue Lyon)
- _Ex-collègue Lyon, propose mission archi freelance 4800 €. Négociation, suivi, possibilité aide._
- Fichier `lib/data/messages_arcs/sarah_collegue.dart` · 11 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:08 | l'autre | text | **3 variantes :** « Shen ! C'est Sarah V. de l'agence Bouchère à Lyon. Je suis à Paris pour 6 mois, t'as 5 min ? » ⁄ « Hello Shen. Ça fait 2 ans. Si je te dis "le projet du tram", tu te rappelles ? » ⁄ « Salut Shen. Tu cherches du freelance ? J'ai un truc qui pourrait t'intéresser. » |
| J+0 | 00:16 | **Shen** | choice | **CHOIX :** |
| | | | | · **Heureuse** → « Sarah ! Ouf que ça fait du bien d'avoir de tes nouvelles. Dis-moi tout. » →`shen_heureuse_s` |
| | | | | · **Mesurée** → « Sarah ! Oui je me rappelle. Dis-moi. » →`shen_mesuree_s` |
| | | | | · **Sceptique** → « Sarah. Salut. Tu me proposes quoi exactement ? » →`shen_sceptique_s` |
| J+0 | 00:22 | l'autre | text | **3 variantes :** « Voilà : une amie monte une boîte de design d'espace, basée 11e. Elle cherche un.e archi freelance pour modéliser 3 lofts en 6 semaines. 4 800 € net. » ⁄ « Mission Paris 11e : 3 lofts à modéliser et plans d'aménagement. Budget 4 800 €. Délai 6 semaines. Tu serais dispo ? » ⁄ « On a besoin de quelqu'un qui sait dessiner vite et bien. T'es la première à qui je pense. » |
| J+0 | 00:28 | **Shen** | choice | **CHOIX :** |
| | | | | · **Accepter** → « OK. Tu m'envoies les specs ce soir ? » →`shen_accept_s` |
| | | | | · **Négocier** → « 4800 c'est court. Tu peux remonter à 6500 ? » →`shen_negocie_s` |
| | | | | · **Hésiter** → « Laisse-moi y réfléchir 24h. » →`shen_hesite_s` |
| | | | | · **Refuser** → « Pas dispo en ce moment. Une autre fois. » FIN `shen_refuse_s` |
| J+0 | 00:36 | l'autre | text | **3 variantes :** « Je peux pousser à 5400. Pas plus. Elle est jeune, elle gère son cash. » ⁄ « Honnêtement non. Mais je peux te garantir 4800 + recommandation pour 2 autres missions plus tard. » ⁄ « Si tu me lâches pas en route, je peux monter à 5500. » _(si `shen_negocie_s`)_ |
| J+0 | 00:40 | **Shen** | choice | **CHOIX :** _(si `shen_negocie_s`)_ |
| | | | | · **OK** → « OK, marché conclu. On commence quand ? » →`shen_accept_s` |
| | | | | · **Refuser** → « Non c'est trop court pour moi. Désolée. » FIN `shen_refuse_negocie_s` |
| J+2 | 09:14 | l'autre | text | **3 variantes :** « Je t'envoie les specs par mail. RDV chez elle samedi 14h pour kick-off. 22 rue Saint-Maur. » ⁄ « Specs envoyées. Premier livrable : esquisses des 3 lofts pour le 10 du mois. » ⁄ « Tu reçois le brief. La cliente s'appelle Anaïs Becker, sympa mais perfectionniste. » _(si `shen_accept_s`)_ |
| J+5 | 18:22 | l'autre | text | **3 variantes :** « Anaïs m'a dit que tu lui as envoyé une première esquisse. Elle a aimé. Continue. » ⁄ « Petit point : tu cours dans 8 directions ? Anaïs m'a dit que tu as l'air débordée. » ⁄ « Tu tiens le délai ? Pas de pression mais elle est stricte. » _(si `shen_accept_s`)_ |
| J+5 | 18:26 | **Shen** | choice | **CHOIX :** _(si `shen_accept_s`)_ |
| | | | | · **Confier** → « Sarah franchement c'est compliqué. Ma mère est malade, je dois jongler. » →`shen_confie_s` |
| | | | | · **Rassurer** → « Tout va bien. Je tiens le délai. » →`shen_rassure_s` |
| | | | | · **Abandonner** → « Sarah je crois que je vais devoir lâcher la mission. » FIN `shen_lache_mission` |
| J+7 | 11:08 | l'autre | text | **3 variantes :** « Je suis désolée Shen. Si tu veux je peux te trouver un binôme. ⏎ Reste sur la mission. On t'aide. » ⁄ « Putain Shen pardon. Je savais pas. On va trouver une solution. Tiens bon. » ⁄ « Si tu veux que je redirige Anaïs pour qu'elle paie en avance, je peux essayer. » _(si `shen_confie_s`, FIN `sarah_alliee_pro`)_ |
| J+8 | 21:14 | l'autre | text | OK. Anaïs attend tes plans le 10. Tu gères. _(si `shen_rassure_s`, FIN `sarah_pro_distance`)_ |

### 🛵 Stéphane (patron UberEats)  ·  `stephane_patron`

- Catégorie **work** · démarre ≥ J3 · contact Stéphane (Livraisons Pro) (Manager UberEats)
- _Manager UberEats. Sermon sur taux d'acceptation, possibilité d'aide si Shen confie, suspension si elle pousse trop._
- Fichier `lib/data/messages_arcs/stephane_patron.dart` · 8 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 14:08 | l'autre | text | **3 variantes :** « Shen Marchand, c'est Stéphane, manager UberEats secteur 8e. Votre taux d'acceptation est tombé à 67 %. On doit en parler. » ⁄ « Bonjour. Stéphane, manager Livraisons. Vous avez refusé 4 commandes cette semaine. Au-delà de 3 sur une semaine glissante, sanction. » ⁄ « Shen, c'est Stéphane. Vous étiez chez les top 10 % du quartier. Vous tombez. On corrige ? » |
| J+0 | 14:14 | **Shen** | choice | **CHOIX :** |
| | | | | · **Excuser** → « Bonjour Stéphane. Pardon. Semaine compliquée. Je rectifie. » →`shen_excuse_st` |
| | | | | · **Demander stats** → « Mes 4 refus c'est 5h-8h matin sur vélo, dans la pluie. Vous proposez quoi ? » →`shen_pousse_st` |
| | | | | · **Confier** → « Stéphane, ma mère est malade. Je gère seule. C'est dur d'être à 100 % en ce moment. » →`shen_confie_st` |
| J+1 | 09:14 | l'autre | text | **3 variantes :** « OK. Vous remontez à 80 % dans 7 jours ou on vous bascule en priorité B. » ⁄ « Bien noté. Je vous donne 1 semaine. » ⁄ « OK Shen. Restez focus. 3 refus max par semaine glissante. » _(si `shen_excuse_st`)_ |
| J+1 | 11:14 | l'autre | text | **3 variantes :** « Hé Shen. Pas pire que le mois dernier. Je vous lâche un peu. ⏎ Restez sur le 8e, c'est plus stable. » ⁄ « OK je note. Mais 67 % c'est sous le seuil. Vous remontez ou je remonte la note. » ⁄ « Vous avez du caractère, j'aime ça. Mais le système, lui, il aime pas. » _(si `shen_pousse_st`)_ |
| J+1 | 14:14 | l'autre | text | **3 variantes :** « Ah. Désolé. Je peux passer votre dossier en priorité A pour 4 semaines. Ça vous laisse souffler. Promesse perso. » ⁄ « Mince. OK. Je peux activer un bonus parental pendant 3 semaines. C'est 200 € de plus par mois. » ⁄ « Ma mère est passée par là. Je peux pas faire grand-chose, mais je vais activer le "mode garde-malade" sur votre profil. Refus pas comptabilisés. » _(si `shen_confie_st`)_ |
| J+1 | 14:18 | **Shen** | choice | **CHOIX :** _(si `shen_confie_st`)_ |
| | | | | · **Accepter aide** → « Oh putain merci Stéphane. Vraiment. » FIN `stephane_pro_aidant` |
| | | | | · **Refuser fierté** → « Non merci. Je préfère pas être traitée à part. » FIN `stephane_distance` |
| J+5 | 19:32 | l'autre | text | **3 variantes :** « Mise à jour : vous êtes à 78 %. Pas mal. Continuez. » ⁄ « Vous êtes redescendue à 62 %. Avertissement formel transmis. » ⁄ « Top 15 % cette semaine. Bonus de 50 € activé. Merci. » _(si `shen_excuse_st`, FIN `stephane_resultats`)_ |
| J+7 | 11:14 | l'autre | text | Trois refus de plus cette semaine. Je suis obligé d'enclencher la procédure de mise en veille du compte. 30 jours. _(si `shen_pousse_st`, FIN `stephane_compte_suspendu`)_ |

### 👵🏼 Voisine Dubreuil  ·  `voisine_dubreuil`

- Catégorie **voisinage** · démarre ≥ J9 · contact Madame Dubreuil (3e) (Voisine)
- _Voisine 71 ans à Belleville. Colis perdu puis fuite plomberie chez Maman. 3 fins._
- Fichier `lib/data/messages_arcs/voisine.dart` · 16 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:08 | l'autre | text | **3 variantes :** « Bonsoir Madame Marchand, c'est Madame Dubreuil du 3e. Le livreur a déposé chez moi un colis à votre nom. Je le garde au chaud. Bonne soirée. » ⁄ « Bonjour, c'est votre voisine du dessous. La gardienne m'a dit que vous aviez emménagé. J'ai un colis pour vous arrivé hier. » ⁄ « Bonsoir, c'est Madame Dubreuil. Le facteur m'a remis un courrier recommandé à votre nom par erreur. Quand pourrez-vous passer ? » |
| J+0 | 00:12 | **Shen** | choice | **CHOIX :** |
| | | | | · **Polie** → « Bonsoir Madame Dubreuil. Merci beaucoup. Je passe demain matin si ça vous va. » →`shen_polie_v` |
| | | | | · **Pressée** → « Bonjour. Je passe ce soir, c'est possible ? » →`shen_pressee_v` |
| | | | | · **Sèche** → « Bonsoir. Je viens demain. Merci. » →`shen_seche_v` |
| J+1 | 09:32 | l'autre | text | **3 variantes :** « J'ai sonné à votre porte tout à l'heure mais vous étiez sortie. Je laisse le colis devant si ça vous arrange. » ⁄ « Vous avez deux paquets en fait. L'un est lourd. Je le porte à votre porte ? » ⁄ « Mon fils passe vers 18h, il peut monter le colis chez vous. Dites-moi. » |
| J+1 | 09:36 | **Shen** | choice | **CHOIX :** |
| | | | | · **Merci doux** → « C'est gentil. Je viens dans 1h. Ne vous embêtez pas. » →`shen_doux_v` |
| | | | | · **Accept fils** → « Si votre fils peut le monter, ça m'aiderait. Merci beaucoup. » →`shen_fils_v` |
| | | | | · **Évasive** → « Je passerai. Merci. » →`shen_evasive_v` |
| J+2 | 18:22 | l'autre | text | **3 variantes :** « Petit mot pour vous remercier de votre gentillesse. C'est rare. Vous me rappelez ma fille qui vit à Lyon. » ⁄ « J'ai vu votre maman dans l'entrée hier matin. Elle m'a souri. C'est une belle femme. » ⁄ « Le pâtissier du coin a refait son éclair café. Si vous passez demain matin, faites-vous le plaisir. » _(sauf `shen_seche_v`)_ |
| J+3 | 07:48 | l'autre | text | **3 variantes :** « Bonjour Madame Marchand. Je vous dérange pour une chose embêtante : il y a une fuite chez vous qui inonde mon plafond. J'ai vu apparaître une tache cette nuit. » ⁄ « Madame Marchand, désolée. Je crois qu'il y a une fuite au-dessus de chez moi. Pouvez-vous regarder votre salle de bain ? » ⁄ « Pardon de vous embêter au réveil. Je crois que ça coule chez vous et ça arrive chez moi. » _(sauf `shen_seche_v`)_ |
| J+3 | 07:52 | **Shen** | choice | **CHOIX :** _(sauf `shen_seche_v`)_ |
| | | | | · **Vérifier** → « Je regarde tout de suite. Pardon. Je vous rappelle. » →`shen_verifie_v` |
| | | | | · **Plus chez Belleville** → « Madame Dubreuil, je ne vis plus chez Belleville depuis 15 jours. Ma mère y est. Elle ne se rend pas compte sûrement. » →`shen_revele_v` |
| | | | | · **Esquiver** → « Je vais voir ça. Merci. » →`shen_esquive_plombe` |
| J+3 | 11:04 | l'autre | text | **3 variantes :** « Ah. Je comprends mieux. Je ne savais pas que vous étiez partie. ⏎ Votre maman est seule chez elle ? Je peux monter voir. » ⁄ « Oh. Je vois. Excusez ma confusion. Voulez-vous que j'aide votre maman à appeler un plombier ? » ⁄ « Je suis désolée. Si elle a besoin de quelqu'un de proche, je suis là. » _(si `shen_revele_v`)_ |
| J+3 | 11:08 | **Shen** | choice | **CHOIX :** _(si `shen_revele_v`)_ |
| | | | | · **Demander** → « Si vous pouviez monter voir, ça me rassure. Merci. » →`shen_demande_v` |
| | | | | · **Refuser doux** → « C'est gentil. Je passe ce soir, je gère. » →`shen_refuse_aide_v` |
| J+3 | 14:32 | l'autre | photoShared | _photoShared_ _(si `shen_verifie_v`)_ |
| J+3 | 14:34 | l'autre | text | **3 variantes :** « Voilà ce que ça donne chez moi. Pas grave si vous trouvez la source. Je suis assurée. » ⁄ « Ce n'est pas une accusation, hein. Je voulais juste vous alerter. » ⁄ « Pas d'urgence, mais si vous pouviez prévenir un plombier, ce serait gentil. » _(si `shen_verifie_v`)_ |
| J+4 | 19:04 | l'autre | text | **3 variantes :** « Bon. Je suis montée chez votre maman. Elle est charmante. La fuite vient de la salle de bain. Elle a appelé son plombier habituel, il vient demain. ⏎ Elle a accepté que je reste boire un thé. » ⁄ « Votre maman m'a fait du thé Long Jing. Elle m'a dit que vous travaillez beaucoup. Je n'ai rien dit de la fuite, on s'en est occupé entre nous. » ⁄ « Tout est sous contrôle. Votre maman est une femme bien. Elle s'inquiète, mais ne dit rien. » _(si `shen_demande_v`)_ |
| J+4 | 21:14 | l'autre | text | **3 variantes :** « Vous avez trouvé ? Je n'ai pas de nouvelles depuis ce matin. » ⁄ « Tout va bien chez vous ? » ⁄ « Ma fuite continue. Si vous pouviez juste me dire ce que vous avez vu. » _(si `shen_verifie_v`)_ |
| J+5 | 11:22 | l'autre | text | **3 variantes :** « Plombier passé. C'est réglé. Votre maman m'a redonné un sachet de thé pour vous. Passez quand vous pouvez. » ⁄ « Tout est réparé. J'ai laissé un mot à votre maman avec mon numéro. Au cas où. » ⁄ « Tout va bien. J'ai une question : pourquoi votre maman ne sait pas que vous avez déménagé ? » _(si `shen_demande_v`, FIN `voisine_alliée`)_ |
| J+6 | 22:08 | l'autre | text | **3 variantes :** « La fuite s'est arrêtée. Tant mieux. Je ne vous embête plus. » ⁄ « J'ai appelé moi-même un plombier qui est passé chez vous. Votre maman a payé. Vous me remercierez à l'occasion. » ⁄ « Bon. Je comprends que vous ne pouviez pas. Je n'ai rien dit à votre maman. » _(si `shen_esquive_plombe`, FIN `voisine_dignite_blessee`)_ |
| J+5 | 09:14 | l'autre | text | Je vous ai laissé le colis devant votre porte hier. Bonne réception. _(si `shen_seche_v`, FIN `voisine_distance`)_ |
