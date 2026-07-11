# Romances (Tinder / arcs amoureux)

### ⚖️   ·  `avocate_adulte`

- Catégorie **** · démarre ≥ J1 · contact Estelle / Catherine / Florence (adult)
- _Femme 32-36 vie carrée, mère solo. Décide vite, coupe net sur urgence enfant._
- Fichier `lib/data/romance/avocate_adulte.dart` · 9 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:12 | l'autre | text | **3 variantes :** « Bonsoir. Je vais à l'essentiel. Vous êtes architecte, vous vivez où, êtes-vous mariée, vegan, ou en thérapie ? » ⁄ « Bonsoir. J'ai 2h le mardi soir et 4h le samedi quand ma mère prend Mateo. Plage horaire intéressante ? » ⁄ « Bonjour. Pas de petits jeux. Vous cherchez quoi exactement ? » |
| J+0 | 00:18 | **Shen** | choice | **CHOIX :** |
| | | | | · **Direct** → « Architecte, 24, célibataire officielle, ni vegan ni thérapie. » →`shen_direct_av` |
| | | | | · **Recule** → « Vous allez vite. » →`shen_recule_av` |
| | | | | · **Ignore** → « _(silence)_ » FIN `shen_ignore_av` |
| J+0 | 00:22 | l'autre | text | **3 variantes :** « Bien. Mardi 21h, Septime Cave, rue Charonne ? » ⁄ « Excellent. Dîner samedi 20h, Chez la Vieille, rue Bailleul. » ⁄ « OK. Verre demain 19h, Le Mary Celeste. Vous me direz vite si on continue. » _(si `shen_direct_av`)_ |
| J+0 | 00:24 | **Shen** | choice | **CHOIX :** _(si `shen_direct_av`)_ |
| | | | | · **Accepter** → « OK. » →`rdv_av` |
| | | | | · **Trop vite** → « Trop vite. La semaine prochaine. » →`rdv_av_decale` |
| J+2 | 18:14 | l'autre | mapLocation | _mapLocation_ _(si `rdv_av`)_ |
| J+2 | 22:48 | l'autre | text | **3 variantes :** « Merci pour ce soir. Sincèrement. ⏎ Votre métier vous occupe ou vous protège ? » ⁄ « Vous m'avez parlé d'un projet d'aménagement comme on parle de Bach. C'est rare. ⏎ On se revoit ? » ⁄ « Mateo dort. Je profite du calme pour vous écrire : c'était bien. » _(si `rdv_av`)_ |
| J+2 | 22:52 | **Shen** | choice | **CHOIX :** _(si `rdv_av`)_ |
| | | | | · **Continuer** → « Oui. Je voudrais vous revoir. » →`shen_continue_av` |
| | | | | · **Confier** → « Je dois être honnête : ma vie est en contrat. Je vis avec un homme. » →`shen_confesse_av` |
| | | | | · **Reculer** → « Je peux pas en fait. Pardon. » FIN `shen_recule_post_rdv_av` |
| J+3 | 08:32 | l'autre | text | **3 variantes :** « Bien. Merci de m'avoir dit. Mateo doit me voir et personne d'autre. Bonne suite. » ⁄ « Pas mon truc les vies contractuelles. Mais c'était bien. » ⁄ « Vous êtes courageuse de le dire. Je préfère m'éloigner. » _(si `shen_confesse_av`, FIN `av_arret_droit`)_ |
| J+7 | 21:08 | l'autre | text | **3 variantes :** « Crise petite. Mateo aux urgences. On reportera. » ⁄ « Garde demain matin. Trop tôt pour décider. On se voit dans 10 jours. » ⁄ « Désolée. Affaire qui prend tout l'air. Plus tard. » _(si `shen_continue_av`, FIN `av_coupe_urgence`)_ |

### 🩺   ·  `breadcrumber`

- Catégorie **** · démarre ≥ J1 · contact Karim / Vincent / Olivier (breadcrumb)
- _30-35 ans pros sérieux. Donne des miettes (1 msg/3-4j), jamais de RDV concret. 4 fins._
- Fichier `lib/data/romance/breadcrumber.dart` · 14 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:08 | l'autre | text | **3 variantes :** « Bonsoir. Belle photo. » ⁄ « Salut. Ton bio est intriguant. » ⁄ « Hello. Tu fais quoi dans la vie ? » |
| J+0 | 00:10 | **Shen** | choice | **CHOIX :** |
| | | | | · **Polie** → « Bonsoir. Et toi ? » →`shen_polie` |
| | | | | · **Curieuse** → « Bonsoir. Qu'est-ce qui t'intrigue ? » →`shen_curieuse` |
| | | | | · **Pas envie** → « _(silence)_ » FIN `shen_ghost_b` |
| J+0 | 23:48 | l'autre | text | **3 variantes :** « On en parle bientôt 😉 » ⁄ « Tu sembles bien. À voir. » ⁄ « Je note. Bonne nuit. » |
| J+3 | 22:14 | l'autre | text | **3 variantes :** « Hey. Désolé pour le silence. Semaine de garde. » ⁄ « Trop pris. Pardon. Tu vas bien ? » ⁄ « Bon week-end ? » |
| J+3 | 22:16 | **Shen** | choice | **CHOIX :** |
| | | | | · **Patient** → « Pas grave. Ça va. » →`shen_patient` |
| | | | | · **Direct** → « On se voit quand ? » →`shen_pousse` |
| | | | | · **Sarcastique** → « Trois jours pour répondre, c'est dans la moyenne haute. » →`shen_sarcasme` |
| J+3 | 22:18 | l'autre | text | **3 variantes :** « Bonne question. Bientôt promis ✨ » ⁄ « Cette semaine si garde finit tôt. » ⁄ « Je te dis demain. » _(si `shen_pousse`)_ |
| J+7 | 19:32 | l'autre | photoShared | _photoShared_ _(sauf `shen_sarcasme`)_ |
| J+11 | 14:28 | l'autre | text | **3 variantes :** « Tu es comment ? » ⁄ « Coucou, ça va ? » ⁄ « J'ai pensé à toi. » _(sauf `shen_sarcasme`)_ |
| J+11 | 14:32 | **Shen** | choice | **CHOIX :** _(sauf `shen_sarcasme`)_ |
| | | | | · **Patient encore** → « Ça va. Et toi ? » →`shen_re_patient` |
| | | | | · **Confronter** → « Tu fais quoi exactement avec moi ? » →`shen_confronte` |
| | | | | · **Unmatch** → « _(silence)_ » FIN `shen_unmatch_breadcrumb` |
| J+11 | 14:33 | l'autre | seenNoReply | _seenNoReply_ _(si `shen_confronte`)_ |
| J+11 | 23:08 | l'autre | typingThenNothing | _typingThenNothing_ _(si `shen_confronte`)_ |
| J+12 | 08:14 | **Shen** | choice | **CHOIX :** _(si `shen_confronte`)_ |
| | | | | · **Unmatch** → « _(silence)_ » FIN `shen_unmatch_silent_treatment` |
| | | | | · **Attendre encore** → « _(silence)_ » →`shen_attend` |
| J+16 | 21:08 | l'autre | text | Eh. Belle photo le truc d'hier 😉 _(si `shen_attend`, FIN `shen_apprend_lecon`)_ |
| J+3 | 22:20 | l'autre | text | **2 variantes :** « Touché. Bon courage. » ⁄ « Tu n'as pas tort. Bonne soirée. » _(si `shen_sarcasme`, FIN `lui_part_proprement`)_ |

### 🎧   ·  `catfish`

- Catégorie **** · démarre ≥ J1 · contact Damien / Marco / Antonin (catfish)
- _Profil trop lisse. Visio J+2 → reveal homme 47 ans. Block + signal._
- Fichier `lib/data/romance/catfish.dart` · 11 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:08 | l'autre | text | **3 variantes :** « Hello. T'as un sourire incroyable. » ⁄ « Bonjour. Ton bio est joli. » ⁄ « Salut. Toi sur Tinder, surprenant. » |
| J+0 | 00:14 | **Shen** | choice | **CHOIX :** |
| | | | | · **Polie** → « Merci. Et toi ? » →`shen_polie_cf` |
| | | | | · **Méfiante** → « Tes photos sont parfaites. Trop parfaites. » →`shen_mef_cf` |
| | | | | · **Ignore** → « _(silence)_ » FIN `shen_ignore_cf` |
| J+1 | 12:04 | l'autre | text | **3 variantes :** « Tu fais quoi ce soir ? » ⁄ « Ton métier te plaît ? » ⁄ « On se voit ? » _(sauf `shen_mef_cf`)_ |
| J+1 | 12:06 | l'autre | text | **2 variantes :** « Tu me trouves trop parfait ? J'ai un bon photographe. » ⁄ « C'est gentil. T'es la première à me le dire comme ça. » _(si `shen_mef_cf`)_ |
| J+2 | 19:14 | l'autre | text | **3 variantes :** « On s'appelle en vidéo ce soir 21h ? Pour de vrai, pas comme tout le monde. » ⁄ « Visioconf demain soir ? Histoire de mettre une voix sur l'écran. » ⁄ « Tu m'appelles ce soir ? Vidéo. 10 min. » |
| J+2 | 19:16 | **Shen** | choice | **CHOIX :** |
| | | | | · **OK** → « OK. 21h. » →`visio_acceptee` |
| | | | | · **Plus tard** → « Plus tard. Je préfère texter. » →`visio_decline` |
| | | | | · **Unmatch** → « _(silence)_ » FIN `shen_unmatch_cf` |
| J+2 | 21:00 | l'autre | callRing | Appel vidéo entrant — l'écran s'allume sur un homme de 47 ans en chemise blanche derrière un papier peint Ikea. Il sourit comme si tout allait bien : « Ah, finalement c'est toi. » _(si `visio_acceptee`)_ |
| J+2 | 21:01 | **Shen** | choice | **CHOIX :** _(si `visio_acceptee`)_ |
| | | | | · **Raccrocher + block** → « _(silence)_ » FIN `shen_block_catfish` |
| | | | | · **Confronter** → « Tu as quel âge vraiment ? » →`shen_confronte_cf` |
| J+2 | 21:04 | l'autre | text | **3 variantes :** « 47 ans. Pardon. Personne ne répond aux photos de mon âge. » ⁄ « 46 ans. Mais le sourire est vrai. » ⁄ « Quel âge ça change ? On a parlé. C'est pas suffisant ? » _(si `shen_confronte_cf`)_ |
| J+2 | 21:06 | **Shen** | choice | **CHOIX :** _(si `shen_confronte_cf`)_ |
| | | | | · **Block + signal** → « _(silence)_ » FIN `shen_block_signal_cf` |
| | | | | · **Disparaître** → « _(silence)_ » FIN `shen_disappear_cf` |
| J+3 | 09:14 | l'autre | text | **2 variantes :** « Pourquoi pas la vidéo ? T'as peur ? » ⁄ « On est tous bizarres. Allez juste 2 min. » _(si `visio_decline`)_ |

### 🔧   ·  `class_divide`

- Catégorie **** · démarre ≥ J1 · contact Yoann / Mehdi / Patrick (classDivide)
- _Métier manuel 30-38 ans. Honnête, direct. Malaise mutuel face au contrat Heng. Drame social en sourdine._
- Fichier `lib/data/romance/class_divide.dart` · 11 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:12 | l'autre | text | **3 variantes :** « Salut. T'es archi ? Cool. Je bosse avec des archis. Souvent ils me prennent de haut. » ⁄ « Bonsoir. Joli sourire. Tu fais quoi dans la vie ? » ⁄ « Hello. Belle photo. Tu vis où ? » |
| J+0 | 00:16 | **Shen** | choice | **CHOIX :** |
| | | | | · **Curieuse** → « Salut. Et toi tu fais quoi ? » →`shen_curieuse_c` |
| | | | | · **Tendre** → « Les archis sont parfois des cons. Je confirme. » →`shen_tendre_c` |
| | | | | · **Ignore** → « _(silence)_ » FIN `shen_ignore_c` |
| J+0 | 00:24 | l'autre | text | **3 variantes :** « Plombier-chauffagiste. Patron de ma boîte. Pas de complexe. » ⁄ « Chauffeur VTC. La nuit surtout. Je lis aux feux rouges. » ⁄ « Maçon. Comme mon père. Je sais plus rien faire d'autre. » |
| J+1 | 14:08 | l'autre | text | **3 variantes :** « Je te propose un verre Café des Anges, Bastille, jeudi 19h. Pas chichi. » ⁄ « On boit un coup ce week-end ? Pas dans le 8e par contre. » ⁄ « Tu veux qu'on déjeune mercredi ? Mais je m'habille pas. » |
| J+1 | 14:12 | **Shen** | choice | **CHOIX :** |
| | | | | · **Oui** → « OK. Jeudi 19h. » →`rdv_c` |
| | | | | · **Hésitante** → « OK mais tu me poses pas trop de questions sur où je vis. » →`shen_hesite_c` |
| | | | | · **Décliner** → « Je peux pas en ce moment. Bonne suite. » FIN `shen_decline_c` |
| J+3 | 13:32 | l'autre | mapLocation | _mapLocation_ _(sauf `shen_decline_c`)_ |
| J+3 | 22:32 | l'autre | text | **3 variantes :** « Merci. C'était court mais j'ai aimé t'entendre rire. » ⁄ « J'ai senti que t'étais à moitié. C'est rien. Mais c'est noté. » ⁄ « Tu m'as posé que des questions sur moi. Tu m'as dit zéro sur toi. » _(sauf `shen_decline_c`)_ |
| J+3 | 22:36 | **Shen** | choice | **CHOIX :** _(sauf `shen_decline_c`)_ |
| | | | | · **Honnête** → « Tu as raison. J'ai pas voulu te dire où je vis. » →`shen_honnete_c` |
| | | | | · **Esquiver** → « J'avais une longue journée pardon. » →`shen_esquive_c` |
| | | | | · **Confier** → « Je vis rue de Berri. Je sais comment ça sonne. C'est compliqué. » →`shen_confesse_c` |
| J+5 | 11:08 | l'autre | text | **3 variantes :** « Rue de Berri. OK. Tu choisis tes embrouilles. ⏎ Merci d'avoir dit. Bonne suite. » ⁄ « OK. C'est honnête de me le dire. Mais on n'a pas la même vie. ⏎ Prends soin de toi. » ⁄ « Rue de Berri. Tu sais quoi : tu m'as appris un truc. Sur moi. Pas sur toi. ⏎ Bye. » _(si `shen_confesse_c`, FIN `lui_part_class`)_ |
| J+5 | 18:32 | l'autre | text | **2 variantes :** « Pas grave. Bon week-end. » ⁄ « OK. À une prochaine peut-être. » _(si `shen_esquive_c`)_ |
| J+8 | 22:14 | l'autre | text | Je crois qu'on n'a pas le même monde. Pas grave. Bonne suite. _(si `shen_esquive_c`, FIN `lui_part_doux_class`)_ |

### 🪖   ·  `depart_imminent`

- Catégorie **** · démarre ≥ J1 · contact Nathan / Simon / Jules (imminent)
- _Va partir loin sous 2 semaines. Romance compressée intense. Vocal d'adieu 62s._
- Fichier `lib/data/romance/depart_imminent.dart` · 11 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:08 | l'autre | text | **3 variantes :** « Bonsoir. Important : je pars dans deux semaines pour longtemps. Tu décides si on perd notre temps ou pas. » ⁄ « Salut. Je dois t'avertir : départ imminent. Pas d'embrouilles. » ⁄ « Bonjour. Profil Tinder spécial départ : 12 jours avant l'avion. À toi. » |
| J+0 | 00:12 | **Shen** | choice | **CHOIX :** |
| | | | | · **Tentée** → « OK tu m'intrigues. » →`shen_tentee_d` |
| | | | | · **Trop court** → « Trop court pour moi. Pardon. » FIN `shen_decline_d` |
| | | | | · **Mathieu** → « Pourquoi tu veux rencontrer quelqu'un avant de partir ? » →`shen_question_d` |
| J+0 | 01:14 | l'autre | text | **3 variantes :** « Pour savoir que je sais encore. Avant la mission. » ⁄ « Pour ne pas partir avec des sacs en moins. » ⁄ « Pour ressentir un truc qui ne se termine pas dans un mémo militaire. » _(si `shen_question_d`)_ |
| J+1 | 12:08 | l'autre | text | **3 variantes :** « Je suis libre ce soir 20h. Le Petit Vendôme. Je te plais ? » ⁄ « Demain 19h, Le Mary Celeste. Pas besoin de te maquiller. » ⁄ « Ce week-end, balade Vincennes ? J'ai 8 jours. » _(sauf `shen_decline_d`)_ |
| J+1 | 12:14 | **Shen** | choice | **CHOIX :** _(sauf `shen_decline_d`)_ |
| | | | | · **OK ce soir** → « OK. Ce soir. » →`rdv_express_d` |
| | | | | · **Reporter doux** → « Demain plutôt. Aujourd'hui c'est compliqué. » →`rdv_d2` |
| | | | | · **Pas envie** → « En fait je peux pas. Bon départ. » FIN `shen_recule_d` |
| J+2 | 09:14 | l'autre | text | **3 variantes :** « Merci pour hier soir. C'était dense et bref. Comme moi. » ⁄ « J'ai rarement parlé autant avec quelqu'un. » ⁄ « Je crois que tu m'as donné une raison de revenir. » _(si `rdv_express_d`)_ |
| J+4 | 18:32 | l'autre | text | **3 variantes :** « Samedi 14h, Vincennes ? J'ai 6 jours. » ⁄ « Vendredi soir, restaurant ? J'invite. J'ai pas envie d'économiser. » ⁄ « On peut juste passer un week-end ensemble. Sans étiquette. » _(si `rdv_express_d`)_ |
| J+4 | 18:36 | **Shen** | choice | **CHOIX :** _(si `rdv_express_d`)_ |
| | | | | · **Tout donner** → « OK. Le week-end. Sans étiquette. » →`shen_donne_d` |
| | | | | · **Reculer** → « Je peux pas faire ça. Trop dur quand tu partiras. » →`shen_recule_d2` |
| J+8 | 23:32 | l'autre | voiceNote | vocal 62 s — voix grave et basse, fond de bagage qui se ferme — il dit qu'il ne demandera rien quand il sera là-bas et que s'il revient elle saura _(si `shen_donne_d`)_ |
| J+9 | 06:14 | l'autre | text | **2 variantes :** « Je pars dans 2h. Pas la peine de répondre. » ⁄ « Avion 8h. Je t'écrirai peut-être pas tout de suite. Pas peur. » _(si `shen_donne_d`, FIN `lui_part_promesse`)_ |
| J+6 | 22:14 | l'autre | text | **2 variantes :** « Je comprends. Je suis pas amer. » ⁄ « Tu as raison. Je pars vivant grâce à toi quand même. » _(si `shen_recule_d2`, FIN `shen_protege_d`)_ |

### 🧘‍♀️   ·  `drama_yoga`

- Catégorie **** · démarre ≥ J1 · contact Anaïs / Lila / Astrid (manipulative)
- _Femme prof yoga, drama professionnel s'invite J+3, demande argent J+4._
- Fichier `lib/data/romance/drama_yoga.dart` · 9 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:14 | l'autre | text | **3 variantes :** « Bonsoir. Tu as un visage qui mérite une heure de yoga par jour. » ⁄ « Hello. Ton bio dit calme. Le mien dit pareil. Hasard ? » ⁄ « Salut. Je viens d'enseigner 2h. Je t'écris doucement. » |
| J+0 | 00:22 | **Shen** | choice | **CHOIX :** |
| | | | | · **Curieuse** → « Bonsoir. Tu enseignes où ? » →`shen_curieuse_y` |
| | | | | · **Ignore** → « _(silence)_ » FIN `shen_ignore_y` |
| J+1 | 14:08 | l'autre | text | **3 variantes :** « Studio Tigre Yoga 4e. Tu connais ? » ⁄ « Marais et Belleville. Cours du soir. » ⁄ « Studio TruYoga 17e. Nouveau. » _(si `shen_curieuse_y`)_ |
| J+2 | 19:32 | l'autre | text | **3 variantes :** « Cours offert jeudi 19h, Tigre Yoga. Tu viens ? » ⁄ « Mardi 18h30, séance privée chez moi. Si tu veux essayer. » ⁄ « Vendredi 12h, méditation guidée Parc Monceau. Gratuit. Viens. » _(si `shen_curieuse_y`)_ |
| J+2 | 19:36 | **Shen** | choice | **CHOIX :** _(si `shen_curieuse_y`)_ |
| | | | | · **OK** → « OK. » →`rdv_y` |
| | | | | · **Refuser doux** → « Je préfère un café normal. » →`shen_cafe_y` |
| J+3 | 14:04 | l'autre | photoShared | _photoShared_ _(si `rdv_y`)_ |
| J+3 | 14:06 | l'autre | text | **3 variantes :** « Désolée de te dérouler ça mais je sais pas à qui parler. Tu en penses quoi ? » ⁄ « Je sors de 3 h de pleurer. Tu peux me dire quoi en regardant ce screenshot ? » ⁄ « Mon univers est en feu et je viens de te rencontrer. Pardon. » _(si `rdv_y`)_ |
| J+3 | 14:10 | **Shen** | choice | **CHOIX :** _(si `rdv_y`)_ |
| | | | | · **Soutenir** → « C'est dur. T'es pas obligée de tout porter seule. » →`shen_soutient_y` |
| | | | | · **Reculer** → « Je peux pas être ton thérapeute. Pardon. » FIN `shen_recule_y` |
| | | | | · **Block** → « _(silence)_ » FIN `shen_block_y` |
| J+4 | 23:18 | l'autre | text | **2 variantes :** « Je crois que je vais devoir fermer le studio. Tu peux me prêter 500 ? Je rembourse vite. » ⁄ « Tu peux dire à tes contacts archis de venir prendre cours chez moi ? J'ai besoin que ça remplisse. » _(si `shen_soutient_y`, FIN `lui_demande_argent_y`)_ |

### 🍸   ·  `escort_reveal`

- Catégorie **** · démarre ≥ J3 · contact Élise / Margaux / Charlotte (escort)
- _Femme escort qui chasse les clientes par jeu. Reveal J+3 au bar._
- Fichier `lib/data/romance/escort_reveal.dart` · 8 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:12 | l'autre | text | **3 variantes :** « Bonsoir. Vous êtes différente. » ⁄ « Salut. Ton bio est intriguant. » ⁄ « Hello. T'as un visage qui dit beaucoup et rien à la fois. » |
| J+0 | 00:18 | **Shen** | choice | **CHOIX :** |
| | | | | · **Curieuse** → « Bonsoir. Vous faites quoi ? » →`shen_curieuse_e` |
| | | | | · **Méfiante** → « Tu vends quelque chose ? » →`shen_mef_e` |
| | | | | · **Ignore** → « _(silence)_ » FIN `shen_ignore_e` |
| J+1 | 14:14 | l'autre | text | **3 variantes :** « Tu as l'air seule. Pas dans le sens triste. Dans le sens libre. » ⁄ « Tu sais ce que c'est, le luxe ? C'est avoir 10 min pour soi entre deux RDV. » ⁄ « Tu m'amuses. Tu sais ? » |
| J+2 | 20:08 | l'autre | text | **3 variantes :** « Demain 22h, bar du Park Hyatt, Vendôme ? » ⁄ « Mardi 23h, Hemingway au Ritz. Je t'attendrai au comptoir. » ⁄ « Tu viens dîner ce soir au Bristol ? Je connais le chef. » |
| J+2 | 20:14 | **Shen** | choice | **CHOIX :** |
| | | | | · **OK intriguée** → « OK. Pourquoi pas. » →`rdv_e` |
| | | | | · **Trop chic** → « Pas mon budget. » →`shen_budget_e` |
| J+3 | 23:32 | l'autre | text | **3 variantes :** « Avant que tu commandes. Je t'invite. Et je t'explique. ⏎ Je suis escort. Hommes clients. Je swipe les femmes pour le jeu. Pas pour l'argent. » ⁄ « Je dois te dire un truc. Je suis dans le métier. Hôtels, clients aisés. Les femmes ici c'est mon vrai loisir. » ⁄ « Tu me plais. Avant qu'on perde du temps : je vis avec un client à temps plein. Ceci est mes vacances. » _(si `rdv_e`)_ |
| J+3 | 23:36 | **Shen** | choice | **CHOIX :** _(si `rdv_e`)_ |
| | | | | · **Partir** → « Je m'en vais. Merci pour l'honnêteté. » FIN `shen_part_e` |
| | | | | · **Questionner** → « Tu fais ça parce que tu en as besoin ou parce que tu aimes ? » →`shen_question_e` |
| | | | | · **Block** → « _(silence)_ » FIN `shen_block_e` |
| J+3 | 23:42 | l'autre | text | **3 variantes :** « Les deux. C'est rare qu'on me pose la vraie question. » ⁄ « J'aime. C'est moche à dire. Mais je l'ai choisi. » ⁄ « C'est pour ne plus jamais avoir besoin. » _(si `shen_question_e`, FIN `e_conversation_lucide`)_ |

### 🔷   ·  `homonyme`

- Catégorie **** · démarre ≥ J7 · contact Tristan / Camille (intense)
- _Profil dont le prénom percute un proche de Shen. Panique 8 s puis arc normal court._
- Fichier `lib/data/romance/homonyme.dart` · 8 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:12 | l'autre | text | **3 variantes :** « Bonsoir. Tu as eu un quart de seconde de panique en lisant mon prénom ? » ⁄ « Salut. Je sais. Le prénom. Je l'entends souvent. » ⁄ « Bonjour. Si tu connais quelqu'un avec le même prénom et que ça t'a fait sursauter : pas moi. » |
| J+0 | 00:18 | **Shen** | choice | **CHOIX :** |
| | | | | · **Confier** → « Effectivement. Tu m'as fait peur 4 secondes. » →`shen_confie_ho` |
| | | | | · **Nier** → « Non, pas du tout. » →`shen_nie_ho` |
| | | | | · **Block** → « _(silence)_ » FIN `shen_block_ho` |
| J+0 | 00:24 | l'autre | text | **3 variantes :** « Bienvenue dans le club. J'ai eu une copine qui a mis 3 mois à appeler son ex Antoine quand on couchait. » ⁄ « Pas grave. Tu peux m'appeler par mon nom de famille si tu préfères. » ⁄ « Au moins on commence par une vérité. » _(si `shen_confie_ho`)_ |
| J+1 | 18:08 | l'autre | text | **3 variantes :** « Tu fais quoi demain soir ? On peut se voir, je te promets que je ressemble pas à ton ex si c'est ça. » ⁄ « Tu veux qu'on s'écrive d'abord beaucoup pour que mon prénom finisse par te dire moi et pas lui ? » ⁄ « Verre demain 19h Le Pavillon des Canaux ? » _(si `shen_confie_ho`)_ |
| J+1 | 18:14 | **Shen** | choice | **CHOIX :** _(si `shen_confie_ho`)_ |
| | | | | · **Tenter** → « OK. Pavillon des Canaux 19h. » →`rdv_ho` |
| | | | | · **Trop chargé** → « Je peux pas. Trop chargé. » FIN `shen_decline_ho` |
| J+2 | 19:00 | l'autre | mapLocation | _mapLocation_ _(si `rdv_ho`)_ |
| J+2 | 22:14 | l'autre | text | **2 variantes :** « C'était bien. Et mon prénom a fait son boulot — tu n'as pas sursauté une fois. » ⁄ « Tu m'as regardée comme si j'étais moi. Merci. » _(si `rdv_ho`, FIN `ho_normal`)_ |
| J+1 | 23:32 | l'autre | text | OK. Bonne soirée alors. _(si `shen_nie_ho`, FIN `ho_il_sent_le_truc`)_ |

### 🩺   ·  `infirmiere_refuge`

- Catégorie **** · démarre ≥ J2 · contact Olivia / Farah / Sandra (refuge)
- _Femme soignante 26-32 ans. Comprend Maman immédiatement. Support pratique et indirect._
- Fichier `lib/data/romance/infirmiere_refuge.dart` · 12 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:14 | l'autre | text | **3 variantes :** « Bonsoir. Je viens de finir un service de 12h. Ton sourire m'a réveillée. » ⁄ « Salut. Tu as un visage doux. Ça me change. » ⁄ « Hello. T'es archi, j'aime ça. Les gens qui construisent des trucs. » |
| J+0 | 00:18 | **Shen** | choice | **CHOIX :** |
| | | | | · **Curieuse** → « Bonsoir. Tu fais quoi comme service ? » →`shen_curieuse_i` |
| | | | | · **Soft** → « Bonsoir. Repose-toi. » →`shen_soft_i` |
| | | | | · **Ignore** → « _(silence)_ » FIN `shen_ignore_i` |
| J+1 | 09:22 | l'autre | text | **3 variantes :** « Bien dormi. Pas longtemps. Café fait. Et toi ? » ⁄ « Service de jour aujourd'hui. 12h. Tu vas bien ? » ⁄ « Tu as quoi ta journée ? » |
| J+2 | 21:04 | l'autre | text | **3 variantes :** « Question discrète : t'as quelqu'un à toi en ce moment ? (je veux pas savoir qui, juste savoir si t'es seule) » ⁄ « Tu as quoi qui te tient ? » ⁄ « On voit des yeux comme les tiens à l'hôpital. Pas souvent à Tinder. » |
| J+2 | 21:08 | **Shen** | choice | **CHOIX :** |
| | | | | · **Confier** → « Ma mère est malade. Je gère seule. C'est ça qui se voit ? » →`shen_confie_i` |
| | | | | · **Évasive** → « Famille. C'est tout. » →`shen_evasive_i` |
| | | | | · **Question** → « Tu poses des questions comme une soignante. Tu travailles encore ? » →`shen_question_i` |
| J+3 | 08:32 | l'autre | text | **3 variantes :** « Je travaille en onco. Si tu as besoin d'un avis sur un traitement ou un médecin, dis-moi. Sans engagement. » ⁄ « Je peux pas régler ton problème. Mais je connais bien ces semaines-là. Tu peux m'écrire si tu craques. » ⁄ « Si tu veux qu'on parle pratique : protocoles, soins palliatifs, aides, je peux. Si tu veux qu'on parle pas, je suis là quand même. » _(si `shen_confie_i`)_ |
| J+3 | 08:36 | **Shen** | choice | **CHOIX :** _(si `shen_confie_i`)_ |
| | | | | · **Accepter aide** → « Oui je veux bien. Merci. » →`shen_accepte_aide_i` |
| | | | | · **Refuser doux** → « Merci. Je vais essayer seule encore un peu. » →`shen_refuse_aide_i` |
| J+5 | 14:08 | l'autre | text | **3 variantes :** « Café samedi 11h, près de Tenon ? Je peux t'amener un truc administratif pour faciliter ses RDV. » ⁄ « On se voit dimanche balade Buttes-Chaumont ? Sans pression. » ⁄ « Je suis en garde demain mais lundi je suis dispo. Café Belleville ? » _(si `shen_accepte_aide_i`)_ |
| J+6 | 11:32 | l'autre | mapLocation | _mapLocation_ _(si `shen_accepte_aide_i`)_ |
| J+6 | 14:22 | l'autre | text | **3 variantes :** « Merci pour ce matin. La fiche est dans ton sac. » ⁄ « J'ai pas eu envie de te draguer. J'ai eu envie de t'écouter. » ⁄ « Si t'as besoin de parler à 3h du matin, t'envoie un message. Si je suis en garde, je vois plus tard. Mais je lis toujours. » _(si `shen_accepte_aide_i`)_ |
| J+12 | 21:14 | l'autre | text | **2 variantes :** « Tu vas comment ? Sa séance d'hier ? » ⁄ « Toujours là. Pas de pression romance. » _(si `shen_accepte_aide_i`, FIN `i_refuge_pratique`)_ |
| J+8 | 21:32 | l'autre | text | **2 variantes :** « OK. Bon courage. » ⁄ « Je reste là. Pas pesante. » _(si `shen_refuse_aide_i`, FIN `i_attend_doucement`)_ |

### 🗞️   ·  `journaliste_curieuse`

- Catégorie **** · démarre ≥ J1 · contact Inès / Alice / Sarah (adult)
- _Femme journaliste investigation. Pose questions pro, dérive vers Heng. Shen panique._
- Fichier `lib/data/romance/journaliste_curieuse.dart` · 10 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:12 | l'autre | text | **3 variantes :** « Bonsoir. Tu es archi, et ta bio dit que tu cherches du calme. Quel genre de calme ? » ⁄ « Salut. Architecte, c'est un métier de privilégiés ou d'esclaves ? Vrai question. » ⁄ « Bonjour. Tu fais des projets bureau ou résidentiel ? » |
| J+0 | 00:18 | **Shen** | choice | **CHOIX :** |
| | | | | · **Curieuse** → « Bonsoir. Question intéressante. » →`shen_curieuse_j` |
| | | | | · **Méfiante** → « Tu es journaliste, c'est ça ? » →`shen_mef_j` |
| | | | | · **Ignore** → « _(silence)_ » FIN `shen_ignore_j` |
| J+0 | 00:24 | l'autre | text | **3 variantes :** « Oui. Et alors ? » ⁄ « Bien vu. Libé. Tu connais ? » ⁄ « C'est mon métier mais c'est pas ce soir. » _(si `shen_mef_j`)_ |
| J+2 | 21:18 | l'autre | text | **3 variantes :** « Tu connais Heng International ? Je couvre un dossier là-dessus. » ⁄ « Tu m'as dit que tu vivais où exactement ? Le 8e a beaucoup changé. » ⁄ « Question chelou peut-être : tu connais Tristan Heng ? On me l'a cité dans une enquête. » |
| J+2 | 21:24 | **Shen** | choice | **CHOIX :** |
| | | | | · **Panique** → « Pourquoi tu poses cette question ? » →`shen_panique_j` |
| | | | | · **Évasive** → « De nom, comme tout le monde. » →`shen_evasive_j` |
| | | | | · **Block** → « _(silence)_ » FIN `shen_block_j` |
| J+2 | 21:28 | l'autre | text | **3 variantes :** « Oh. T'as réagi vite. Note prise. » ⁄ « Pardon. C'est mon réflexe. Je te lâche. » ⁄ « On peut juste boire un verre sans que je sois en interview, promis. » _(si `shen_panique_j`)_ |
| J+2 | 21:32 | **Shen** | choice | **CHOIX :** _(si `shen_panique_j`)_ |
| | | | | · **Block** → « _(silence)_ » FIN `shen_block_panic_j` |
| | | | | · **Tenter** → « Verre sans interview. Promis ? » →`rdv_j` |
| J+4 | 18:32 | l'autre | mapLocation | _mapLocation_ _(si `rdv_j`)_ |
| J+4 | 23:14 | l'autre | text | **3 variantes :** « Merci pour ce soir. J'ai pas posé une question pro. Tu vois. » ⁄ « C'était bien. Mais tu m'as à peine regardée dans les yeux. » ⁄ « Tu as menti deux fois ce soir. Petit mensonge, mais menti. » _(si `rdv_j`)_ |
| J+4 | 23:18 | **Shen** | choice | **CHOIX :** _(si `rdv_j`)_ |
| | | | | · **Confession partielle** → « Tu as raison. Je peux pas tout dire. » FIN `j_arret_propre` |
| | | | | · **Bloquer** → « _(silence)_ » FIN `shen_block_post_rdv_j` |

### 📕   ·  `libraire_potentiel`

- Catégorie **** · démarre ≥ J5 · contact Bastien / Pierre / Alex (sincere)
- _Libraire ami de Camille Roux. Vrai potentiel romance ou amitié. Si Shen ment, il sent et se retire._
- Fichier `lib/data/romance/libraire_potentiel.dart` · 12 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:14 | l'autre | text | **3 variantes :** « Salut. Camille Roux m'a montré ta photo dans le magasin. Petite blague entre amis. Tu me détestes ? » ⁄ « Bonsoir. Camille Roux dit que tu lis bien. C'est un bon argument. » ⁄ « Hello. Camille m'a parlé de toi sans le savoir. Du coup je swipe. » |
| J+0 | 00:18 | **Shen** | choice | **CHOIX :** |
| | | | | · **Camille !** → « Camille fait l'entremetteuse. Bien sûr. » →`shen_camille_l` |
| | | | | · **Curieuse** → « Comment tu connais Camille ? » →`shen_curieuse_l` |
| | | | | · **Ignore** → « _(silence)_ » FIN `shen_ignore_l` |
| J+0 | 00:22 | l'autre | text | **3 variantes :** « On bossait ensemble à la librairie Vendredi. Elle est partie en com, moi pas. » ⁄ « On a une relation amitié qui a survécu à 4 ans d'ennuis communs. » ⁄ « On boit des cafés depuis 6 ans. Pour toi ça veut dire quoi ? » |
| J+1 | 19:32 | l'autre | text | **3 variantes :** « Tu lis quoi en ce moment ? Et ne mens pas. Camille m'a dit que tu fais semblant parfois. » ⁄ « Question piège : tu lis encore par plaisir ou seulement par fatigue ? » ⁄ « Je viens de finir « La Recherche perdue » de Lispector. T'as déjà entendu parler ? » |
| J+2 | 14:14 | l'autre | text | **3 variantes :** « Je suis seul à la librairie samedi 10h-13h. Viens. Sans pression. » ⁄ « Ten Belles, samedi 11h. Camille peut venir si tu veux qu'elle te chaperonne. » ⁄ « Un verre chez moi vendredi 21h ? J'invite Camille pour la première fois si tu veux. » |
| J+2 | 14:18 | **Shen** | choice | **CHOIX :** |
| | | | | · **Avec Camille** → « Avec Camille. Plus simple pour moi. » →`rdv_avec_camille` |
| | | | | · **Sans Camille** → « Juste toi et moi. Camille en saura assez sans qu'on l'invite. » →`rdv_solo_l` |
| | | | | · **Reporter** → « Plus tard. Pas dispo cette semaine. » →`rdv_decale_l` |
| J+4 | 10:22 | l'autre | mapLocation | _mapLocation_ _(sauf `rdv_decale_l`)_ |
| J+4 | 18:32 | l'autre | text | **3 variantes :** « C'était bien. Je vais pas faire le malin. ⏎ Camille avait raison. Tu lis vraiment bien. » ⁄ « Tu m'as dit pas grand-chose mais ce que tu as dit était dense. » ⁄ « Tu m'as caché un truc cet après-midi. J'ai vu. Je dis rien. » _(sauf `rdv_decale_l`)_ |
| J+4 | 18:36 | **Shen** | choice | **CHOIX :** _(sauf `rdv_decale_l`)_ |
| | | | | · **Confier** → « Je vis avec quelqu'un. Camille le sait. C'est compliqué. » →`shen_confesse_l` |
| | | | | · **Continuer doux** → « On se revoit ? » →`shen_continue_l` |
| | | | | · **Mentir** → « Je vois pas de quoi tu parles. » →`shen_ment_l` |
| J+5 | 11:04 | l'autre | text | **2 variantes :** « OK. Merci d'avoir dit. Camille m'avait fait deviner sans dire. ⏎ On peut être amis. Vraiment. Si tu veux. » ⁄ « C'est dense ce que tu portes. Je prendrai pas la place de personne. ⏎ On peut juste continuer à lire ensemble. Si tu veux. » _(si `shen_confesse_l`, FIN `l_amitie_durable`)_ |
| J+7 | 21:14 | l'autre | text | **2 variantes :** « Viens samedi 16h, je ferme la librairie tôt. » ⁄ « J'ai pensé à toi en lisant un truc. Je te le mets de côté ? » _(si `shen_continue_l`, FIN `l_continue_quotidien`)_ |
| J+6 | 19:08 | l'autre | text | **2 variantes :** « OK. Je dirai rien à Camille. ⏎ Mais je vais me reculer. Bonne suite. » ⁄ « Tu mens mal. Camille m'avait prévenu. Bonne suite. » _(si `shen_ment_l`, FIN `l_recule_ment`)_ |

### 📸   ·  `lovebomber`

- Catégorie **** · démarre ≥ J1 · contact Léo / Adrien / Yann (lovebomb)
- _23-25 ans, créatif autoproclamé. Submerge en 24h, jaloux J+1, s'effondre J+2. 4 fins possibles._
- Fichier `lib/data/romance/lovebomber.dart` · 19 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:01 | l'autre | text | Salut |
| J+0 | 00:02 | l'autre | text | **3 variantes :** « T'es magnifique » ⁄ « Je crois que t'es spéciale » ⁄ « Wahou » |
| J+0 | 00:03 | l'autre | text | **3 variantes :** « T'aimes quoi » ⁄ « Tu fais quoi ce soir » ⁄ « On peut s'appeler ? » |
| J+0 | 00:04 | l'autre | text | **3 variantes :** « Moi photo » ⁄ « Moi cinéma c'est ma life » ⁄ « J'ai vu ta photo 4 fois en 2 min » |
| J+0 | 00:05 | l'autre | text | **3 variantes :** « Tu fais quoi vendredi » ⁄ « On se voit quand » ⁄ « Réponds bébé » |
| J+0 | 00:07 | l'autre | text | **4 variantes :** « Réponds » ⁄ « ? » ⁄ « Allô » ⁄ « Tu m'ignores ? » |
| J+0 | 00:08 | **Shen** | choice | **CHOIX :** |
| | | | | · **Calmer** → « Calme-toi, j'étais sous la douche. » →`shen_calme` |
| | | | | · **Sec** → « Tu as envoyé 6 messages en 7 minutes. Stop. » →`shen_stop` |
| | | | | · **Ironique** → « On a déjà fait l'amour, là ? J'ai loupé un truc ? » →`shen_ironique` |
| | | | | · **Unmatch direct** → « _(silence)_ » FIN `shen_unmatch_immediate` |
| J+1 | 07:14 | l'autre | text | **3 variantes :** « Bonjour bébé. Bien dormi ? » ⁄ « Coucou ma douce » ⁄ « Salut ma muse » |
| J+1 | 11:32 | l'autre | text | **3 variantes :** « Tu réponds à qui ce matin ? » ⁄ « T'es en ligne et tu me lis pas. C'est moche. » ⁄ « Tu fais exprès là » |
| J+1 | 11:35 | **Shen** | choice | **CHOIX :** |
| | | | | · **Distance** → « Je ne te dois rien. On s'est matchés hier. » →`shen_distance` |
| | | | | · **Cassant** → « Bébé je suis pas. Et tu sais pas mon prénom. » →`shen_cassant` |
| | | | | · **Silencieuse** → « _(silence)_ » →`shen_silence` |
| J+1 | 18:04 | l'autre | text | **3 variantes :** « OK TU SAIS QUOI OUBLIE » ⁄ « C'EST BON J'AI COMPRIS » ⁄ « Tu sais pas ce que tu perds » _(si `shen_cassant`)_ |
| J+1 | 18:05 | l'autre | text | **2 variantes :** « Pardon. Je voulais juste te parler. » ⁄ « Excuse-moi. Tu peux m'oublier. » _(si `shen_cassant`)_ |
| J+1 | 18:07 | l'autre | text | **2 variantes :** « En vrai j'avais bu deux gins. Pardon. » ⁄ « Bonne soirée. » _(si `shen_cassant`, FIN `lui_excuses_basses`)_ |
| J+2 | 14:02 | l'autre | text | **2 variantes :** « OUBLIE OUBLIE J'AI RIEN DIT » ⁄ « Tu m'ignores. C'est fait. Adieu. » _(si `shen_silence`)_ |
| J+2 | 23:12 | l'autre | unmatch | _unmatch_ _(si `shen_silence`, FIN `lui_unmatch_dignite`)_ |
| J+1 | 14:32 | l'autre | text | **3 variantes :** « On se voit ce soir 21h, chez moi 20e ? » ⁄ « Vendredi 18h, hôtel République ? » ⁄ « Je passe te chercher à 19h. Donne moi l'adresse. » _(si `shen_calme`)_ |
| J+1 | 14:35 | **Shen** | choice | **CHOIX :** _(si `shen_calme`)_ |
| | | | | · **Non merci** → « Non. Trop tôt. » FIN `shen_decline_rdv` |
| | | | | · **Unmatch maintenant** → « _(silence)_ » FIN `shen_unmatch_late` |
| J+0 | 00:12 | l'autre | text | **2 variantes :** « Tu te crois drôle ? » ⁄ « OK bouffonne. » _(si `shen_ironique`)_ |
| J+0 | 23:48 | l'autre | unmatch | _unmatch_ _(si `shen_ironique`, FIN `lui_unmatch_vexe`)_ |

### 💃   ·  `magnetique_vide`

- Catégorie **** · démarre ≥ J1 · contact Jade / Lola / Eva (intense)
- _Femme physiquement saisissante. Conversation en monosyllabes. Frustration esthétique 4 j._
- Fichier `lib/data/romance/magnetique_vide.dart` · 14 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:14 | l'autre | text | **3 variantes :** « hey 😊 » ⁄ « salut 🌹 » ⁄ « hi ✨ » |
| J+0 | 00:18 | **Shen** | choice | **CHOIX :** |
| | | | | · **Charmée** → « Salut. Tes photos sont folles. » →`shen_charmee_m` |
| | | | | · **Question** → « Salut. Tu fais quoi dans la vie ? » →`shen_question_m` |
| | | | | · **Ignore** → « _(silence)_ » FIN `shen_ignore_m` |
| J+0 | 00:22 | l'autre | text | **3 variantes :** « merci 😘 » ⁄ « aw merci toi ✨ » ⁄ « tnks ❤️ » |
| J+1 | 16:22 | l'autre | photoShared | _photoShared_ |
| J+1 | 16:23 | l'autre | text | **3 variantes :** « 🌞 » ⁄ « ✨✨ » ⁄ « mood » |
| J+2 | 21:14 | l'autre | text | **3 variantes :** « tu fais quoi ce soir ? 😏 » ⁄ « tu sors où d'habitude ? » ⁄ « on se boit un verre ? » |
| J+2 | 21:18 | **Shen** | choice | **CHOIX :** |
| | | | | · **Tenter** → « OK. Où ? » →`rdv_m` |
| | | | | · **Tester** → « Tu m'as répondu en monosyllabes 3 jours. Tu sais que je sais lire ? » →`shen_test_m` |
| | | | | · **Lâcher** → « En fait c'est pas ça. Bonne suite. » FIN `shen_lache_m` |
| J+2 | 21:22 | l'autre | text | **3 variantes :** « haha ok ben tant pis » ⁄ « tu es agressive là » ⁄ « je parle pas beaucoup je suis comme ça » _(si `shen_test_m`)_ |
| J+3 | 23:32 | l'autre | unmatch | _unmatch_ _(si `shen_test_m`, FIN `elle_unmatch_vexe`)_ |
| J+4 | 19:32 | l'autre | mapLocation | _mapLocation_ _(si `rdv_m`)_ |
| J+4 | 23:14 | l'autre | text | **3 variantes :** « c'était cool 🌹 » ⁄ « merci 😊 » ⁄ « on refait ? » _(si `rdv_m`)_ |
| J+4 | 23:18 | **Shen** | choice | **CHOIX :** _(si `rdv_m`)_ |
| | | | | · **S'éloigner** → « C'était joli. Mais c'est pas pour moi. » FIN `shen_lache_post_rdv` |
| | | | | · **Mensonge poli** → « Oui carrément. » →`shen_ment_m` |
| J+7 | 22:32 | l'autre | text | hey 😊 dispo ce week-end ? _(si `shen_ment_m`)_ |
| J+14 | 22:08 | l'autre | unmatch | _unmatch_ _(si `shen_ment_m`, FIN `elle_unmatch_oubli`)_ |

### 🪷   ·  `manipulatrice_soft`

- Catégorie **** · démarre ≥ J5 · contact Sophie / Isabelle / Helena (manipulative)
- _Femme 32-38 coach/healer. Pose de fausses questions thérapeutiques, pousse à payer ses séances. Malaise insidieux._
- Fichier `lib/data/romance/manipulatrice_soft.dart` · 11 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:14 | l'autre | text | **3 variantes :** « Bonsoir. Je sens beaucoup dans ton regard. Une fatigue ancienne. Je me trompe ? » ⁄ « Salut. Tu as un visage qui porte des choses. Je sens. C'est mon métier. » ⁄ « Hello. Tu cherches quelqu'un qui te voit vraiment, c'est ça ? » |
| J+0 | 00:18 | **Shen** | choice | **CHOIX :** |
| | | | | · **Hum...** → « Bonsoir. C'est rapide comme analyse. » →`shen_mef_man2` |
| | | | | · **Touchée** → « Oui un peu. Comment tu sais ? » →`shen_touche_man2` |
| | | | | · **Ignore** → « _(silence)_ » FIN `shen_ignore_man2` |
| J+0 | 00:22 | l'autre | text | **3 variantes :** « Je vois les âmes blessées. Je suis comme ça depuis petite. » ⁄ « Mon ex me disait : « Tu lis les gens comme un livre. » Pas fière, juste consciente. » ⁄ « C'est un don. Et une responsabilité. Tu sais. » _(si `shen_touche_man2`)_ |
| J+1 | 09:14 | l'autre | text | **3 variantes :** « J'ai dormi en pensant à toi. Doucement. Pas inquiète. » ⁄ « Tu portes une lourdeur. Tu peux me la confier sans peur. » ⁄ « Question : tes parents étaient comment quand tu étais enfant ? » _(si `shen_touche_man2`)_ |
| J+2 | 20:08 | l'autre | text | **3 variantes :** « Je sens que tu es très seule. Ne te juge pas. Tu as juste pas rencontré la bonne personne pour t'aider à te déposer. » ⁄ « Tu as besoin qu'on te tienne. Tu mérites ça. Je peux le faire si tu veux. » ⁄ « Je pense que tu es très abîmée mais récupérable. C'est pas une insulte. C'est un constat. » _(si `shen_touche_man2`)_ |
| J+2 | 20:14 | **Shen** | choice | **CHOIX :** _(si `shen_touche_man2`)_ |
| | | | | · **Réveil** → « Tu sais quoi. Tu me parles comme à une cliente. » →`shen_reveil` |
| | | | | · **Continue** → « Pardon. Tu as raison. J'ai besoin de ça. » →`shen_avalee` |
| | | | | · **Block** → « _(silence)_ » FIN `shen_block_man2` |
| J+2 | 20:18 | l'autre | text | **3 variantes :** « Tu te trompes. Mais OK, je respecte ta défense. » ⁄ « Bon courage. Tu en auras besoin. » ⁄ « Quand tu seras prête à recevoir, tu sauras où me trouver. » _(si `shen_reveil`, FIN `shen_arret_propre_man2`)_ |
| J+1 | 19:14 | l'autre | text | **2 variantes :** « Je suis pas analyste, juste sensible. Promis. » ⁄ « Tu te défends. C'est OK. Ça veut dire que j'ai touché juste. » _(si `shen_mef_man2`)_ |
| J+3 | 22:32 | l'autre | text | Je te laisse réfléchir. Je suis là quand tu veux. _(si `shen_mef_man2`, FIN `man2_lache`)_ |
| J+5 | 21:08 | l'autre | text | **3 variantes :** « Mon premier RDV individuel est à 80 €/séance. Tu en aurais besoin de 6 minimum. » ⁄ « Je peux te recommander une retraite à Bali en mai. 1 200 €. Je t'accompagne. » ⁄ « Mon livre est sorti. 18 €. Lis-le et on en reparle. » _(si `shen_avalee`)_ |
| J+5 | 21:14 | **Shen** | choice | **CHOIX :** _(si `shen_avalee`)_ |
| | | | | · **Réveil tardif** → « Tu as réussi ton coup. Bravo. » FIN `shen_reveil_tardif` |
| | | | | · **Block** → « _(silence)_ » FIN `shen_block_late_man2` |

### 📚   ·  `mansplainer`

- Catégorie **** · démarre ≥ J1 · contact Marc / Étienne / Florent (pedant)
- _32-36 ans intello. Corrige Shen sur son métier, cite des références. Comédie pénible 5 jours._
- Fichier `lib/data/romance/mansplainer.dart` · 13 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:08 | l'autre | text | **3 variantes :** « Bonsoir. Question : tu sais ce que veut dire « architecte » étymologiquement ? » ⁄ « Ton bio mentionne l'archi. Tu as lu Vitruve ? » ⁄ « Hello. Tu connais le concept de Bauen-Wohnen-Denken ? » |
| J+0 | 00:12 | **Shen** | choice | **CHOIX :** |
| | | | | · **Répondre vrai** → « Oui. Et toi tu sais ce que ça fait, dessiner un escalier ? » →`shen_tient` |
| | | | | · **Esquiver** → « Bonsoir. » →`shen_esq_man` |
| | | | | · **Unmatch** → « _(silence)_ » FIN `shen_unmatch_man_immediate` |
| J+0 | 00:18 | l'autre | text | **3 variantes :** « Joli renvoi. Sauf que justement, dessiner relève de la techné, pas de la poiesis. Petite confusion classique. » ⁄ « Tu aurais pu citer Alberti plutôt. Mais bon. » ⁄ « Hé hé. Tu me plais déjà. » _(si `shen_tient`)_ |
| J+1 | 08:32 | l'autre | text | **3 variantes :** « J'ai relu ta réponse d'hier. Quelques précisions s'imposent. » ⁄ « Tu permets que je te corrige un petit point ? » ⁄ « Lecture du jour : « L'origine de l'œuvre d'art ». Tu connais ? » |
| J+1 | 12:14 | l'autre | text | **3 variantes :** « En fait l'architecte est moins un créateur qu'un médiateur. Ton bio l'évoque mal. » ⁄ « Tu fais quoi exactement comme archi ? Intérieur ? Urbanisme ? Ça change tout. » ⁄ « Petit fact-checking : « Architecture » vient de archi-tekton, le maître charpentier. Pas l'artiste. » |
| J+1 | 12:16 | **Shen** | choice | **CHOIX :** |
| | | | | · **Vacharde** → « Tu as expliqué mon métier 3 fois en 24h. Bravo. » →`shen_vacharde` |
| | | | | · **Patiente** → « Merci pour la leçon. Je note. » →`shen_patient_man` |
| | | | | · **Ghost** → « _(silence)_ » FIN `shen_ghost_man` |
| J+1 | 14:22 | l'autre | text | **3 variantes :** « Oh. Je voulais juste élever la conversation. » ⁄ « Pardon, tu n'es pas obligée d'être agressive. » ⁄ « On peut quand même se voir si tu veux. Café samedi 11h, rue Soufflot ? » _(si `shen_vacharde`)_ |
| J+1 | 14:24 | **Shen** | choice | **CHOIX :** _(si `shen_vacharde`)_ |
| | | | | · **Pour rigoler** → « OK je viens pour voir. » →`rdv_man_curiosite` |
| | | | | · **Unmatch** → « _(silence)_ » FIN `shen_unmatch_man_late` |
| J+3 | 10:32 | l'autre | mapLocation | _mapLocation_ _(si `rdv_man_curiosite`)_ |
| J+3 | 13:08 | l'autre | text | **3 variantes :** « Ravi de t'avoir éclairée sur ton métier ce matin. Le livre est à la page 47. » ⁄ « Belle rencontre. J'espère que tu as pris des notes mentalement. » ⁄ « On refait ça vendredi ? J'ai préparé une bibliographie. » _(si `rdv_man_curiosite`)_ |
| J+3 | 13:10 | **Shen** | choice | **CHOIX :** _(si `rdv_man_curiosite`)_ |
| | | | | · **Block définitif** → « _(silence)_ » FIN `shen_block_man` |
| | | | | · **Sarcasme final** → « Page 47 c'est juste un peu prétentieux non ? » FIN `shen_sarcasme_final` |
| J+1 | 18:14 | l'autre | text | **2 variantes :** « Tu refuses d'engager le dialogue. Dommage. » ⁄ « Je te trouvais intrigante. Tant pis. » _(si `shen_esq_man`)_ |
| J+4 | 22:08 | l'autre | text | Une dernière question : tu lis Annie Ernaux ? _(si `shen_esq_man`, FIN `lui_lache_apres_3`)_ |

### 🔪   ·  `passion_fougueuse`

- Catégorie **** · démarre ≥ J1 · contact Théo / Lucas / Quentin (passionate)
- _28-31 ans chef/artiste. Démarre fort, RDV nocturne intense, disparaît dans son art. Revient 1× épuisé._
- Fichier `lib/data/romance/passion_fougueuse.dart` · 17 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:06 | l'autre | photoShared | _photoShared_ |
| J+0 | 00:07 | l'autre | text | **3 variantes :** « Je rentre. Tinder à 2h du matin, c'est mauvais signe. » ⁄ « Service fini. Je swipe sans regarder. Pardon. » ⁄ « Salut. Je suis crevé mais ton sourire m'a réveillé. » |
| J+0 | 00:12 | **Shen** | choice | **CHOIX :** |
| | | | | · **Curieuse** → « Tu cuisines quoi ? » →`shen_curieuse_p` |
| | | | | · **Sec** → « Va dormir. » →`shen_sec_p` |
| | | | | · **Ignore** → « _(silence)_ » FIN `shen_ghost_p` |
| J+1 | 15:22 | l'autre | text | **3 variantes :** « Cuisine de bistrot, viande maturée, légumes oubliés. Tu manges quoi le soir ? » ⁄ « Une cuisine de saison qui fait pleurer les vieux. Tu cuisines toi ? » ⁄ « Je tape vite parce que je dois être au labo dans 1h. Tu vis où ? » _(si `shen_curieuse_p`)_ |
| J+2 | 23:14 | l'autre | voiceNote | vocal 24 s — il chuchote depuis sa cuisine — « j'ai goûté le bouillon en pensant à toi, c'est ridicule, je sais » _(si `shen_curieuse_p`)_ |
| J+3 | 12:08 | l'autre | text | **3 variantes :** « Demain je ferme à minuit. Tu viens au resto à 23h30 ? Je te fais à manger après. » ⁄ « Lundi je suis off. Marché Aligre 9h, après mon appart. Je cuisine pour toi. » ⁄ « Vendredi 1h du matin, après service. Je sais c'est tard. Mais c'est la vérité. » _(si `shen_curieuse_p`)_ |
| J+3 | 12:12 | **Shen** | choice | **CHOIX :** _(si `shen_curieuse_p`)_ |
| | | | | · **OK fou** → « OK. Je viendrai. » →`rdv_intense` |
| | | | | · **Contre-proposer** → « Plutôt un café normal en pleine journée ? » →`rdv_normal` |
| | | | | · **Décliner** → « Trop intense pour moi. » FIN `shen_decline_p` |
| J+4 | 18:32 | l'autre | text | **2 variantes :** « Service du soir compliqué. On reste sur 23h30 si tu veux. » ⁄ « Désolé, gros service. À tout à l'heure. » _(si `rdv_intense`)_ |
| J+4 | 23:48 | l'autre | text | **3 variantes :** « Je sors dans 10 min. Tu es où ? » ⁄ « Pardon retard. Service infernal. J'arrive. » ⁄ « Encore 5 min. Bois un truc. » _(si `rdv_intense`)_ |
| J+5 | 09:14 | l'autre | text | **3 variantes :** « Hier était une nuit. Merci. » ⁄ « Je dors enfin. À ce soir si tu veux. » ⁄ « Tu as quitté ma cuisine il y a 4h, j'ai pas dormi. » _(si `rdv_intense`)_ |
| J+6 | 23:32 | l'autre | text | **3 variantes :** « Pardon. Semaine de fou. Sous-chef tombé malade. » ⁄ « Pas de signe. Je remonte de la cave dans 1h. » ⁄ « Plus d'oxygène. Reviens si tu veux. » _(si `rdv_intense`)_ |
| J+9 | 14:08 | **Shen** | choice | **CHOIX :** _(si `rdv_intense`)_ |
| | | | | · **Relancer** → « Tu es vivant ? » →`shen_relance` |
| | | | | · **Attendre** → « _(silence)_ » →`shen_attend_p` |
| | | | | · **Unmatch** → « _(silence)_ » FIN `shen_unmatch_p` |
| J+10 | 03:14 | l'autre | text | **3 variantes :** « Pardon. Je vois ça maintenant. Je suis défoncé. » ⁄ « Pardon pardon. La semaine m'a mangé. » ⁄ « Coucou. Désolé. Service de 18h. » _(si `shen_relance`)_ |
| J+10 | 03:18 | l'autre | text | **2 variantes :** « Je peux pas faire mieux. C'est mon métier. C'est moi. » ⁄ « Si tu veux d'un mec qui rentre à 1h, je suis ton homme. Sinon je comprendrai. » _(si `shen_relance`)_ |
| J+10 | 03:22 | **Shen** | choice | **CHOIX :** _(si `shen_relance`)_ |
| | | | | · **Accepter** → « OK. À ton rythme. » →`shen_accepte_rythme` |
| | | | | · **Lâcher** → « Je peux pas vivre dans tes restes de service. Bonne suite. » FIN `shen_lache_p` |
| J+12 | 02:14 | l'autre | text | Sous-chef remplacé. Je dors lundi. Tu viens ? _(si `shen_accepte_rythme`, FIN `rdv_planifie_long`)_ |
| J+14 | 22:08 | l'autre | unmatch | _unmatch_ _(si `shen_attend_p`, FIN `lui_unmatch_oubli`)_ |

### 👨‍👧‍👦   ·  `pere_divorce`

- Catégorie **** · démarre ≥ J1 · contact Vincent / Philippe / Thomas (fragile)
- _36-42 ans, séparé, enfants 50%. Fenêtres courtes, honnête. Amitié possible. 5 fins._
- Fichier `lib/data/romance/pere_divorce.dart` · 10 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:10 | l'autre | text | **3 variantes :** « Bonsoir. Je préviens d'avance : père divorcé, deux enfants. C'est pas une excuse, c'est une donnée. » ⁄ « Salut. Je swipe en couchant mon petit. Tu auras un retour tardif probablement. » ⁄ « Hello. Je suis honnête : peu de disponibilité, beaucoup de présence quand je suis là. » |
| J+0 | 00:14 | **Shen** | choice | **CHOIX :** |
| | | | | · **Respect** → « Merci d'être clair. Salut. » →`shen_respect_p` |
| | | | | · **Curieuse** → « Quel âge les enfants ? » →`shen_curieuse_p2` |
| | | | | · **Pas envie** → « _(silence)_ » FIN `shen_ghost_pere` |
| J+1 | 08:32 | l'autre | text | **3 variantes :** « Bonjour. Réveil 6h30 ce matin avec petit déj de gosses. » ⁄ « Bien dormi ? Moi pas vraiment, le grand a fait un cauchemar. » ⁄ « Hello. Tu fais quoi le matin avant que la vraie journée commence ? » |
| J+2 | 19:18 | l'autre | text | **3 variantes :** « Je suis libre mardi entre 14h et 16h pendant qu'ils sont chez leur mère. Café Square Daviel ? » ⁄ « Vendredi 12h-13h30, déjeuner rapide ? C'est la fenêtre que j'ai. » ⁄ « Samedi matin 8h-10h avant que je les récupère. Coutume Babylone ? » |
| J+2 | 19:22 | **Shen** | choice | **CHOIX :** |
| | | | | · **OK fenêtre** → « OK. Cette fenêtre me convient. » →`rdv_pere` |
| | | | | · **Plus tard** → « Pas cette semaine. Une autre ? » →`pere_plus_tard` |
| | | | | · **Trop compliqué** → « C'est trop compliqué pour moi. Pardon. » FIN `shen_decline_pere` |
| J+3 | 13:32 | l'autre | mapLocation | _mapLocation_ _(si `rdv_pere`)_ |
| J+3 | 16:08 | l'autre | text | **3 variantes :** « Merci pour cet entre-deux. C'était rare. » ⁄ « Je dois récupérer la grande à 17h. Mais c'était bien. » ⁄ « Je vois pas quand on se revoit avant 10 jours. Tu te projettes ? » _(si `rdv_pere`)_ |
| J+3 | 16:12 | **Shen** | choice | **CHOIX :** _(si `rdv_pere`)_ |
| | | | | · **OK long** → « OK on s'écrit en attendant. Pas pressée. » →`shen_patient_pere` |
| | | | | · **Amitié** → « Et si on restait amis simplement ? Sans projection ? » →`shen_amitie_pere` |
| | | | | · **Trop dur** → « Je vais pas pouvoir attendre 10 jours à chaque fois. » FIN `shen_lache_pere` |
| J+7 | 22:32 | l'autre | text | **3 variantes :** « OK. C'est sage. Tu seras la première personne qui me propose ça. » ⁄ « Sage. Merci. » ⁄ « Si tu veux qu'on se voie en ami, je dis oui. » _(si `shen_amitie_pere`, FIN `pere_amitie`)_ |
| J+8 | 21:08 | l'autre | text | **2 variantes :** « Tu es là encore ? J'aime bien. » ⁄ « Petit message du soir : t'es la première à qui j'écris ce soir. » _(si `shen_patient_pere`, FIN `pere_continue`)_ |

### 📖   ·  `poly_ambigu`

- Catégorie **** · démarre ≥ J1 · contact Hugo / Tanguy / Sacha (ambiguous)
- _Cache la couple ouvert 4 j, reveal J+5 avant RDV. Block, confronter ou tenter._
- Fichier `lib/data/romance/poly_ambigu.dart` · 10 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:12 | l'autre | text | **3 variantes :** « Bonsoir. Belle photo. Tu lis quoi ? » ⁄ « Salut. Ta bio me fait sourire. Tu écris ? » ⁄ « Hello. Tu fais quoi quand tu veux pas rentrer chez toi ? » |
| J+0 | 00:18 | **Shen** | choice | **CHOIX :** |
| | | | | · **Curieuse** → « Salut. Et toi ? » →`shen_curieuse_po` |
| | | | | · **Joueuse** → « Je marche sous la pluie. Toi ? » →`shen_joueuse_po` |
| | | | | · **Ignore** → « _(silence)_ » FIN `shen_ignore_po` |
| J+1 | 21:14 | l'autre | text | **3 variantes :** « Annie Ernaux, « L'événement ». Tu connais ? Je viens de le finir. » ⁄ « Tu écoutes quoi quand tu marches seule la nuit ? » ⁄ « Question idiote : tu préfères les gens qui parlent ou ceux qui écoutent ? » |
| J+3 | 22:32 | l'autre | voiceNote | vocal 28 s — voix douce, légère ironie — il dit que sa journée a été ridicule et qu'il a pensé à elle en faisant les courses |
| J+4 | 15:08 | l'autre | text | **3 variantes :** « Verre vendredi 19h, Combat dans le 19e ? » ⁄ « Café samedi 11h, Ten Belles ? » ⁄ « On se voit ? » |
| J+4 | 15:14 | **Shen** | choice | **CHOIX :** |
| | | | | · **Accepter** → « OK. Je serai là. » →`rdv_po` |
| | | | | · **Pas envie** → « Pas maintenant. Bonne suite. » FIN `shen_decline_po` |
| J+5 | 14:22 | l'autre | text | **3 variantes :** « Petit truc à préciser avant ce soir. Je suis en couple ouvert avec Léa depuis 4 ans. C'est cool ? » ⁄ « Avant qu'on se voie : ma copine et moi on est ouverts. Tu savais pas, je le dis maintenant. » ⁄ « Important : je suis pas mono. Ma partenaire est au courant. Toi tu décides si tu viens. » _(si `rdv_po`)_ |
| J+5 | 14:26 | **Shen** | choice | **CHOIX :** _(si `rdv_po`)_ |
| | | | | · **Block** → « _(silence)_ » FIN `shen_block_po` |
| | | | | · **Confronter** → « Tu pouvais pas le dire il y a 4 jours ? » →`shen_confronte_po` |
| | | | | · **OK essayer** → « C'est nouveau pour moi. On peut en parler ce soir ? » →`shen_ouvre_po` |
| J+5 | 14:32 | l'autre | text | **2 variantes :** « Tu as raison. J'ai pas voulu te perdre avant. ⏎ C'était lâche. Pardon. » ⁄ « Je sais. C'était calculé. J'ai pas su être direct. ⏎ Bonne suite si tu veux. » _(si `shen_confronte_po`, FIN `lui_lache_admis`)_ |
| J+5 | 19:08 | l'autre | text | **2 variantes :** « OK on en parle ce soir. Sans drama. » ⁄ « Merci. Vraiment. » _(si `shen_ouvre_po`, FIN `po_a_voir`)_ |

### 🍖   ·  `predator`

- Catégorie **** · démarre ≥ J1 · contact Quentin / Pierry / Léopold (predator)
- _26-32 ans fric. Direct, agressif, transactionnel. Sketch glaçant 2 jours._
- Fichier `lib/data/romance/predator.dart` · 8 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:04 | l'autre | text | **3 variantes :** « Salut. Toi ce soir ? » ⁄ « Salut. T'es belle. Où ? » ⁄ « Hey. Tu vis seule ? » |
| J+0 | 00:05 | **Shen** | choice | **CHOIX :** |
| | | | | · **Stop** → « Direct là. Tu peux ralentir ? » →`shen_stop_pred` |
| | | | | · **Ironique** → « Et toi t'as un Q.I. ? » →`shen_ironique_pred` |
| | | | | · **Block direct** → « _(silence)_ » FIN `shen_block_immediate` |
| J+1 | 14:08 | l'autre | text | **3 variantes :** « Tu fais quoi. Envoie une photo. » ⁄ « T'es libre maintenant ? » ⁄ « J'ai un appart à Bastille. Free pour toi. » _(si `shen_stop_pred`)_ |
| J+1 | 14:10 | **Shen** | choice | **CHOIX :** _(si `shen_stop_pred`)_ |
| | | | | · **Sec** → « Non. » →`shen_sec_pred` |
| | | | | · **Block + signal** → « _(silence)_ » FIN `shen_block_signal` |
| J+2 | 09:04 | l'autre | text | **3 variantes :** « J'ai un appart à République. 250 € la soirée. Je paie le trajet. » ⁄ « Tu veux quoi exactement ? Soyons clairs. » ⁄ « Tu t'inscris sur Tinder pour faire la sucrée ? » _(si `shen_sec_pred`)_ |
| J+2 | 09:08 | **Shen** | choice | **CHOIX :** _(si `shen_sec_pred`)_ |
| | | | | · **Block + signal** → « _(silence)_ » FIN `shen_block_signal_late` |
| J+0 | 00:08 | l'autre | text | **3 variantes :** « Bof. Pas intéressé en fait. » ⁄ « Tu te crois drôle. Bonne suite. » ⁄ « Pute. » _(si `shen_ironique_pred`)_ |
| J+0 | 00:10 | **Shen** | choice | **CHOIX :** _(si `shen_ironique_pred`)_ |
| | | | | · **Block + signal** → « _(silence)_ » FIN `shen_block_signal_insulte` |

### 📔   ·  `queer_douce`

- Catégorie **** · démarre ≥ J5 · contact Mathilde / Camille / Lucie (queer)
- _Femme 22-28 cultivée. RDV librairie/expo. Ouverture nouvelle. Long terme possible si confession._
- Fichier `lib/data/romance/queer_douce.dart` · 17 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:14 | l'autre | text | **3 variantes :** « Salut. Ton bio est très « je ne sais plus à quoi je crois ». J'aime. » ⁄ « Bonjour. T'as un visage qui n'essaie pas de plaire. C'est rare. » ⁄ « Hello. Tu lis quoi en ce moment ? » |
| J+0 | 00:18 | **Shen** | choice | **CHOIX :** |
| | | | | · **Curieuse** → « Hello. Et toi tu lis quoi ? » →`shen_curieuse_q` |
| | | | | · **Hésitante** → « Salut. Je suis nouvelle dans la catégorie femme. Tu prévois quoi ? » →`shen_hesite_q` |
| | | | | · **Décliner doux** → « En fait je me sens pas trop dispo. Bonne suite. » FIN `shen_decline_q` |
| J+0 | 00:32 | l'autre | text | **3 variantes :** « Maggie Nelson, « Bluets ». Un livre sur le bleu et sur le deuil. Pas mauvais pour Tinder à 23h. » ⁄ « Annie Ernaux, encore. Je relis pour la 4ᵉ fois. Tu connais ? » ⁄ « Lispector, « Près du cœur sauvage ». Ça me secoue. » _(si `shen_curieuse_q`)_ |
| J+0 | 00:36 | l'autre | text | **3 variantes :** « Rien. Je prévois rien. C'est la beauté. » ⁄ « Aucune pression. On peut juste parler. » ⁄ « Ouf. Pareil. On commence par un café ou un message ? » _(si `shen_hesite_q`)_ |
| J+1 | 21:08 | l'autre | text | **3 variantes :** « Tu as quoi sur ta table de chevet ? » ⁄ « Si tu pouvais retirer un mois de ta vie passée, ce serait lequel ? » ⁄ « Le silence te fait peur ? » |
| J+1 | 21:14 | **Shen** | choice | **CHOIX :** |
| | | | | · **Vrai** → « Le silence non. Le bruit oui. » →`shen_vrai_q` |
| | | | | · **Joueur** → « Question piège. Tu commences. » →`shen_joueur_q` |
| | | | | · **Esquiver** → « Compliqué là. » →`shen_esq_q` |
| J+3 | 15:08 | l'autre | text | **3 variantes :** « Tu veux un café à L'Écume des Pages samedi 16h ? On regarde les livres. » ⁄ « Expo « Femmes peintres » au Luxembourg dimanche après-midi. Si tu veux. » ⁄ « Petite balade Canal Saint-Martin samedi 11h. Sans pression. » _(sauf `shen_esq_q`)_ |
| J+3 | 15:12 | **Shen** | choice | **CHOIX :** _(sauf `shen_esq_q`)_ |
| | | | | · **Accepter** → « Oui. Bonne idée. » →`rdv_q` |
| | | | | · **Reporter** → « Pas ce week-end. La semaine prochaine ? » →`rdv_reporter_q` |
| | | | | · **Décliner doux** → « Je peux pas. Mais merci de proposer. » FIN `shen_decline_post_q` |
| J+5 | 10:32 | l'autre | mapLocation | _mapLocation_ _(si `rdv_q`)_ |
| J+5 | 18:32 | l'autre | text | **3 variantes :** « Merci pour cet après-midi. Tu m'as fait du bien sans le savoir. » ⁄ « J'ai aimé t'écouter parler de tes escaliers. » ⁄ « On peut se revoir quand tu veux. Vraiment. » _(si `rdv_q`)_ |
| J+5 | 18:36 | **Shen** | choice | **CHOIX :** _(si `rdv_q`)_ |
| | | | | · **Confier** → « Je vis avec un homme. Contrat. C'est compliqué. » →`shen_confesse_q` |
| | | | | · **Doux retour** → « Toi aussi tu m'as fait du bien. » →`shen_doux_q` |
| | | | | · **Esquiver** → « C'était sympa oui. » →`shen_esq_post_q` |
| J+6 | 11:04 | l'autre | text | **3 variantes :** « Oh. C'est dense. ⏎ Je préfère le savoir. On peut être amies, ou autre chose, ou rien. C'est toi qui sais. » ⁄ « Merci d'avoir dit. Vraiment. ⏎ Je reste là si tu veux. » ⁄ « Un contrat ? Tu m'expliqueras un jour. Pas obligée. » _(si `shen_confesse_q`)_ |
| J+10 | 21:08 | l'autre | text | **3 variantes :** « J'ai pensé à toi en lisant un truc. Je te l'envoie ? » ⁄ « Tu vas bien ? » ⁄ « Si tu veux qu'on se revoie sans étiquette, je suis là. » _(si `shen_confesse_q`)_ |
| J+20 | 19:32 | l'autre | text | Toujours là. _(si `shen_confesse_q`, FIN `q_amitie_durable`)_ |
| J+12 | 18:14 | l'autre | text | **2 variantes :** « On se revoit ce week-end ? Cinéma ? » ⁄ « Tu reviens à L'Écume avec moi ? » _(si `shen_doux_q`)_ |
| J+12 | 18:18 | **Shen** | choice | **CHOIX :** _(si `shen_doux_q`)_ |
| | | | | · **Oui** → « Oui. » FIN `q_relation_continue` |
| | | | | · **Reculer** → « Je peux pas en fait. Désolée. » FIN `q_shen_recule` |
| J+8 | 22:32 | l'autre | text | **2 variantes :** « Si tu te poses des questions, c'est OK. Prends ton temps. » ⁄ « Tu n'as pas répondu beaucoup. Pas grave. Bonne suite si on s'arrête là. » _(si `shen_esq_post_q`, FIN `q_fade_doux`)_ |

### 🍃   ·  `refuge_sain`

- Catégorie **** · démarre ≥ J1 · contact Sébastien / Thibault / Daniel (refuge)
- _28-33 ans, posé, écoute. Devient un espace calme. Peut durer 30 j+, ou s'éteint doucement._
- Fichier `lib/data/romance/refuge_sain.dart` · 18 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:12 | l'autre | text | **3 variantes :** « Salut. Pas pressé. Quand tu veux. » ⁄ « Bonjour. Pas obligée de répondre. » ⁄ « Salut. Tu m'as eu en swipant, je ne sais pas pourquoi mais ça m'a touché. » |
| J+1 | 19:04 | l'autre | text | **3 variantes :** « Pour info : t'es pas obligée de répondre vite. Ou pas du tout. » ⁄ « Tu as eu une journée comment ? » ⁄ « Pas de pression. Juste curieux. » |
| J+1 | 19:06 | **Shen** | choice | **CHOIX :** |
| | | | | · **Ouvert** → « Compliquée. Mais merci de le demander comme ça. » →`shen_ouvre` |
| | | | | · **Léger** → « Ça va. Toi ? » →`shen_leger` |
| | | | | · **Tester** → « Tu poses des questions comme ça à tout le monde ? » →`shen_teste` |
| J+2 | 21:18 | l'autre | text | **3 variantes :** « Tu as quelqu'un avec qui en parler ? » ⁄ « Si tu veux pas dire pourquoi, je comprends. Je suis là quand même. » ⁄ « Compliquée comment ? Si tu veux. » _(si `shen_ouvre`)_ |
| J+2 | 21:22 | **Shen** | choice | **CHOIX :** _(si `shen_ouvre`)_ |
| | | | | · **Maman** → « Ma mère est malade. Beaucoup d'argent à trouver. Beaucoup. » →`shen_dit_maman` |
| | | | | · **Vague** → « Famille. Argent. Le combo. » →`shen_vague` |
| | | | | · **Refermer** → « En fait je préfère qu'on parle de toi. » →`shen_referme` |
| J+2 | 21:28 | l'autre | text | **3 variantes :** « Ok. Je vais pas te dire que je comprends parce que je comprends pas. Mais je peux écouter. » ⁄ « Merci de m'avoir dit. Vraiment. » ⁄ « Je suis désolé. Tu te débrouilles toute seule pour l'argent ? » _(si `shen_dit_maman`)_ |
| J+4 | 20:08 | l'autre | voiceNote | vocal 52 s : voix calme et basse — il dit qu'il n'a pas de solution, qu'il n'essaiera pas d'en inventer, et que si elle veut parler à 3h du matin c'est ouvert _(si `shen_dit_maman`)_ |
| J+5 | 18:14 | l'autre | text | **3 variantes :** « Buttes-Chaumont dimanche matin si tu veux. Pas de pression. » ⁄ « Si tu as envie de marcher sans parler dimanche. Je suis là. » ⁄ « Café samedi 11h ou pas. Comme tu veux. » _(si `shen_dit_maman`)_ |
| J+5 | 18:18 | **Shen** | choice | **CHOIX :** _(si `shen_dit_maman`)_ |
| | | | | · **Oui** → « Oui. J'aimerais bien. » →`rdv_refuge` |
| | | | | · **Pas maintenant** → « Plus tard. Mais reste si tu veux. » →`rdv_plus_tard` |
| J+7 | 10:08 | l'autre | mapLocation | _mapLocation_ _(si `rdv_refuge`)_ |
| J+7 | 13:42 | l'autre | text | **3 variantes :** « Merci pour ce matin. Pas besoin de répondre. » ⁄ « C'était une belle marche. Vraiment. » ⁄ « Tu peux m'écrire à 3h du matin, je l'ai pensé. Je le dis. » _(si `rdv_refuge`)_ |
| J+15 | 21:04 | l'autre | text | **3 variantes :** « Hey. Je pense à toi. Pas plus. » ⁄ « Tu vas bien ? » ⁄ « J'ai vu un escalier ce matin qui m'a fait penser à toi sans savoir pourquoi. » _(si `rdv_refuge`)_ |
| J+22 | 22:14 | l'autre | text | **2 variantes :** « Si t'as besoin de quelqu'un qui connaît personne dans ta vie, je suis là. » ⁄ « Ne me réponds pas si tu veux. C'est juste un signe. » _(si `rdv_refuge`)_ |
| J+30 | 20:08 | l'autre | text | Toujours là. Sans urgence. _(si `rdv_refuge`, FIN `refuge_durable`)_ |
| J+5 | 21:18 | l'autre | text | **2 variantes :** « Ok. Bonne soirée alors. » ⁄ « Pas de problème. Bonne suite. » _(si `shen_referme`)_ |
| J+12 | 22:32 | l'autre | text | Prends soin de toi. _(si `shen_referme`, FIN `refuge_fade_doux`)_ |
| J+4 | 14:12 | l'autre | text | **2 variantes :** « Café samedi 11h, Coutume Babylone ? Sans engagement. » ⁄ « Si t'as envie d'un thé sans devoir parler de soi, dimanche 15h. » _(si `shen_leger`)_ |
| J+4 | 14:14 | **Shen** | choice | **CHOIX :** _(si `shen_leger`)_ |
| | | | | · **Oui léger** → « OK. Sans engagement. » →`rdv_leger` |
| | | | | · **Pas envie** → « Je préfère pas. Bonne suite. » FIN `shen_decline_leger` |

### 🏙️   ·  `retour_hk`

- Catégorie **** · démarre ≥ J35 · contact Romain / Vincent / Anthony (reunion)
- _Homme ex-expat HK rentré. Connaît les Heng. Contextuel ep 3+._
- Fichier `lib/data/romance/retour_hk.dart` · 9 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:12 | l'autre | text | **3 variantes :** « Bonsoir. J'ai vu sur ton bio une référence à HK. Vrai voyageuse ou hasard ? » ⁄ « Hello. Marchand. Ce nom me dit quelque chose. Tu as de la famille à Hong Kong ? » ⁄ « Salut. Je rentre d'HK. Tu y es allée récemment ? » |
| J+0 | 00:18 | **Shen** | choice | **CHOIX :** |
| | | | | · **Hésitante** → « J'y suis allée oui. Pourquoi ? » →`shen_hesite_h` |
| | | | | · **Évasive** → « Pourquoi cette question ? » →`shen_evasive_h` |
| | | | | · **Ignore** → « _(silence)_ » FIN `shen_ignore_h` |
| J+0 | 00:24 | l'autre | text | **3 variantes :** « J'ai vécu 5 ans là-bas. Banque, Causeway Bay. Et toi ? » ⁄ « Famille Heng, ça te dit quelque chose ? Je suis tombé sur eux pour un dossier. » ⁄ « Le Lan Kwai Fong te manque autant qu'à moi ? » |
| J+2 | 21:14 | l'autre | text | **3 variantes :** « Tu sais pourquoi je suis rentré ? J'ai dit que je reviendrais à quelqu'un. Je suis pas revenu. » ⁄ « Je crois que je viens à Paris pour oublier HK. Ça marche pas. » ⁄ « Petite question : tu vas y retourner ? » |
| J+2 | 21:18 | **Shen** | choice | **CHOIX :** |
| | | | | · **Mélancolique** → « Probablement. C'est compliqué. » →`shen_melanco_h` |
| | | | | · **Fermer** → « Je préfère pas en parler. » →`shen_ferme_h` |
| | | | | · **Ouvrir** → « J'y suis allée pour une famille qui s'appelle Heng. C'était pas un voyage normal. » →`shen_ouvre_h` |
| J+2 | 21:22 | l'autre | text | **2 variantes :** « Les Heng. OK. Pas mes amis non plus. Mais je connais. ⏎ Si tu veux qu'on en parle au sec, je t'invite à boire un thé. » ⁄ « Heng. Bien sûr. Je peux pas être objectif. Je sais des choses. ⏎ Tu veux quoi vraiment de moi ? » _(si `shen_ouvre_h`)_ |
| J+4 | 19:32 | l'autre | text | **3 variantes :** « Vendredi 19h, La Tour d'Argent — bar — pas le resto, je te rassure. » ⁄ « Bar du Park Hyatt mardi 22h. Calme. On peut parler. » ⁄ « Mon appart 8e. Thé, pas de jeu. Samedi 16h. » _(si `shen_ouvre_h`)_ |
| J+4 | 19:36 | **Shen** | choice | **CHOIX :** _(si `shen_ouvre_h`)_ |
| | | | | · **Accepter** → « OK je viens. » →`rdv_h` |
| | | | | · **Sentir piège** → « Je crois qu'on cherche pas la même chose. » FIN `shen_recule_h` |
| J+6 | 22:14 | l'autre | text | **3 variantes :** « Merci pour le thé. Tu m'as dit en 1h plus que personne en 6 mois. » ⁄ « On peut s'écrire en chinois si tu veux. Pour personne d'autre. » ⁄ « Je sais qui était Mei. Pas besoin de tout dire. » _(si `rdv_h`, FIN `h_complicite_lourde`)_ |

### ✏️   ·  `slow_burn_sincere`

- Catégorie **** · démarre ≥ J1 · contact Antoine / Paul / Marc / Théo / Julien (sincere)
- _Architecte calme, lecteur, propose un RDV au J4-5. Branche selon mensonge Shen : rupture honnête, ghost, fade._
- Fichier `lib/data/romance/slow_burn.dart` · 28 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:03 | l'autre | text | **7 variantes :** « Salut. Ton bio dit « Architecte ». Vrai ou clin d'œil ? » ⁄ « Hey. Tu bois quoi le matin ? » ⁄ « Bonjour. T'as quoi sur ta table de chevet ? » ⁄ « Salut. Tu jures bien quand tu travailles ? » ⁄ « Hey. Un projet en ce moment ? » ⁄ « T'as choisi ta photo principale exprès, ou tu jures que non ? » ⁄ « Salut. Je suis pas très texteur, donc voilà. » |
| J+0 | 00:04 | **Shen** | choice | **CHOIX :** |
| | | | | · **Posée** → « Salut. Vrai. Et toi ? » →`shen_posee` |
| | | | | · **Drôle** → « Clin d'œil. Je dessine pour de vrai mais ça sonne moins bien. » →`shen_drole` |
| | | | | · **Sèche** → « Vrai. Pas envie d'expliquer. » →`shen_seche` |
| | | | | · **Ignorer** → « _(silence)_ » FIN `shen_ghost_early` |
| J+1 | 09:12 | l'autre | photoShared | _photoShared_ _(sauf `shen_seche`)_ |
| J+1 | 09:13 | l'autre | text | **4 variantes :** « Mon dimanche commence comme ça. » ⁄ « C'est la quatrième fois que je redessine cet escalier. » ⁄ « J'ai pris la photo en pensant à ce que tu m'as répondu hier. » ⁄ « Voilà. Sans contexte. » _(sauf `shen_seche`)_ |
| J+1 | 09:20 | **Shen** | choice | **CHOIX :** _(sauf `shen_seche`)_ |
| | | | | · **Curieuse** → « Pourquoi quatre fois ? » →`shen_curieuse` |
| | | | | · **Renvoyer** → « Voilà le mien. *photo café froid Belleville* » →`shen_partage` |
| | | | | · **Esquiver** → « Joli. » →`shen_esquive` |
| J+1 | 09:24 | l'autre | text | **2 variantes :** « Parce que la troisième marche refuse d'être à la bonne hauteur. ⏎ C'est pas un détail. C'est tout le reste. » ⁄ « Parce que les escaliers tiennent les maisons. Si je rate ça, j'ai rien. » _(si `shen_curieuse`)_ |
| J+1 | 09:24 | l'autre | text | **2 variantes :** « Joli. Tu vis dans la lumière froide aussi. » ⁄ « C'est où ça ? Belleville haut ou bas ? » _(si `shen_partage`)_ |
| J+2 | 21:08 | l'autre | text | **4 variantes :** « T'es comment quand t'es fatiguée ? » ⁄ « C'était quoi ton dernier livre lu en entier ? » ⁄ « Question bête : t'aimes les escaliers ? » ⁄ « Si tu pouvais effacer une pièce d'une maison, ce serait laquelle ? » |
| J+2 | 21:09 | **Shen** | choice | **CHOIX :** |
| | | | | · **Honnête** → « Pas terrible en ce moment. Truc familial. » →`shen_confie` |
| | | | | · **Détourner** → « Je te raconterai si tu réponds toi-même d'abord. » →`shen_renvoie` |
| | | | | · **Mentir** → « Ça va. Beaucoup de boulot. » →`shen_ment` |
| J+3 | 22:14 | l'autre | voiceNote | vocal 38 s : voix calme — il dit qu'il n'attend pas de toi que tu sois bien, juste que tu sois là _(si `shen_confie`)_ |
| J+3 | 22:14 | l'autre | text | **2 variantes :** « Ok. Tu me dis quand t'as une vraie soirée libre ? » ⁄ « Beaucoup de boulot je comprends. On voit cette semaine ? » _(si `shen_ment`)_ |
| J+4 | 14:08 | l'autre | text | **8 variantes :** « Café samedi 10h, Boot Café rue Niel ? J'y suis souvent. » ⁄ « Y a un café qui ouvre à 8h dans le 11e qui sert le meilleur cortado de Paris. Dimanche matin ? » ⁄ « Verre jeudi 19h, Le Mary Celeste rue Commines ? » ⁄ « Un bar à vin pas prétentieux dans le 10e, ça te dit ? Vendredi 18h30. » ⁄ « Buttes-Chaumont dimanche matin si tu veux. Je marche lentement. » ⁄ « Promenade plantée dimanche après-midi ? On voit les toits. » ⁄ « Le Champo passe « L'Avventura » mardi 20h30. Ça te tente ? » ⁄ « On s'appelle mardi soir 22h ? Texto c'est trop lent. » |
| J+4 | 14:10 | **Shen** | choice | **CHOIX :** |
| | | | | · **Accepter** → « Oui. Je serai là. » →`rdv_accept` |
| | | | | · **Décaler** → « Pas ce week-end. La semaine d'après ? » →`rdv_decaler` |
| | | | | · **Décliner poli** → « C'est compliqué en ce moment. Une autre fois ? » →`rdv_decline` |
| | | | | · **Ghost** → « _(silence)_ » FIN `shen_ghost_pre_rdv` |
| J+5 | 19:32 | l'autre | text | **3 variantes :** « J'ai hâte. Bonne nuit. » ⁄ « Demain est demain. Dors bien. » ⁄ « Je sais pas pourquoi je suis nerveux. Pardon. » _(si `rdv_accept`)_ |
| J+6 | 09:14 | l'autre | mapLocation | _mapLocation_ _(si `rdv_accept`)_ |
| J+6 | 09:16 | l'autre | text | **3 variantes :** « À tout à l'heure. » ⁄ « Je serai en avance. Pas grave, je lis. » ⁄ « Pull bleu. Pour que tu me repères. » _(si `rdv_accept`)_ |
| J+6 | 11:42 | l'autre | photoShared | _photoShared_ _(si `rdv_accept`)_ |
| J+6 | 19:08 | l'autre | text | **4 variantes :** « Merci. J'ai pas eu envie de regarder mon téléphone une seule fois. » ⁄ « Pardon si j'étais trop bavard. » ⁄ « Je t'écris parce que j'ai pas voulu le faire devant toi. » ⁄ « C'était court, c'était bien. On recommence ? » _(si `rdv_accept`)_ |
| J+6 | 19:11 | **Shen** | choice | **CHOIX :** _(si `rdv_accept`)_ |
| | | | | · **Confier** → « Je vis avec quelqu'un. C'est compliqué. Pardon. » →`shen_confesse` |
| | | | | · **Renvoyer** → « Pareil. Je voulais le dire avant. » →`shen_partage_rdv` |
| | | | | · **Esquiver** → « C'était bien oui. » →`shen_evite` |
| J+7 | 11:04 | l'autre | text | **3 variantes :** « Ok. Merci d'être honnête. ⏎ Bonne suite, vraiment. » ⁄ « Je préfère le savoir maintenant. Prends soin de toi. » ⁄ « C'est dur à entendre. Mais merci. Je vais m'éloigner. » _(si `shen_confesse`, FIN `rupture_honnete`)_ |
| J+7 | 21:32 | l'autre | text | **2 variantes :** « Alors on fait quoi. » ⁄ « D'accord. C'est mieux qu'on s'arrête là, non ? » _(si `shen_partage_rdv`, FIN `rupture_mutuelle`)_ |
| J+8 | 22:14 | l'autre | text | **2 variantes :** « On se revoit ? » ⁄ « Tu m'as paru loin par moments. Je me trompe ? » _(si `shen_evite`)_ |
| J+8 | 22:16 | **Shen** | choice | **CHOIX :** _(si `shen_evite`)_ |
| | | | | · **Honnête tardive** → « Tu te trompes pas. Je ne peux pas. Pardon. » FIN `rupture_tardive` |
| | | | | · **Continuer mentir** → « Mais non. Juste fatiguée. » →`shen_ment_encore` |
| | | | | · **Ghost** → « _(silence)_ » FIN `shen_ghost_post_rdv` |
| J+10 | 14:08 | l'autre | text | On se revoit ce week-end ? _(si `shen_ment_encore`)_ |
| J+12 | 22:30 | l'autre | typingThenNothing | _typingThenNothing_ _(si `shen_ment_encore`)_ |
| J+13 | 23:08 | l'autre | unmatch | _unmatch_ _(si `shen_ment_encore`, FIN `il_unmatch_silencieux`)_ |
| J+1 | 21:14 | l'autre | text | **2 variantes :** « Ok. T'avais l'air sèche, je voulais vérifier. » ⁄ « Pardon. Bon courage. » _(si `shen_seche`)_ |
| J+3 | 18:04 | l'autre | text | Je suppose qu'on s'arrête là. Bonne suite. _(si `shen_seche`, FIN `il_fade_seche`)_ |

### 🏃‍♀️   ·  `sportive_dispo`

- Catégorie **** · démarre ≥ J1 · contact Romane / Camille / Élodie (sporty)
- _Femme 28-31 sportive. Footing 7h, Shen KO. Décalage physique._
- Fichier `lib/data/romance/sportive_dispo.dart` · 9 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:10 | l'autre | text | **3 variantes :** « Salut. Footing demain matin 7h Buttes-Chaumont ? Pas obligée de matcher mon allure. » ⁄ « Hello. Bassin demain 6h45 ? Je t'apprends crawl si tu veux. » ⁄ « Hey. Rando dimanche forêt de Fontainebleau ? 12 km. Tranquille. » |
| J+0 | 00:14 | **Shen** | choice | **CHOIX :** |
| | | | | · **Tentée** → « Tentée mais je suis pas en forme. » →`shen_tentee_sp` |
| | | | | · **Direct non** → « Pas possible physiquement. Mais on peut boire un café ? » →`shen_cafe_sp` |
| | | | | · **Ignore** → « _(silence)_ » FIN `shen_ignore_sp` |
| J+0 | 00:18 | l'autre | text | **2 variantes :** « Pas grave. On y va lentement. 30 min, jamais essoufflée. » ⁄ « OK tranquille. Plutôt balade rapide alors. 7h30 ? » _(si `shen_tentee_sp`)_ |
| J+0 | 00:22 | l'autre | text | **2 variantes :** « Tu sais quoi : OK pour un café. Mais après je t'amène marcher. » ⁄ « Un café d'abord, sport après si tu te sens. Samedi 10h ? » _(si `shen_cafe_sp`)_ |
| J+2 | 07:08 | l'autre | mapLocation | _mapLocation_ _(si `shen_tentee_sp`)_ |
| J+2 | 09:14 | l'autre | text | **3 variantes :** « T'as tenu 12 minutes. Bravo. On remet ça ? » ⁄ « Pardon je t'ai poussée. Tu vas bien ? » ⁄ « T'as failli vomir. Très charmant en vrai 😅 » _(si `shen_tentee_sp`)_ |
| J+2 | 09:18 | **Shen** | choice | **CHOIX :** _(si `shen_tentee_sp`)_ |
| | | | | · **Tenter encore** → « OK. Plus court la prochaine fois. » →`shen_essaie_sp` |
| | | | | · **Avouer** → « Je suis pas faite pour. Désolée. » FIN `shen_avoue_sp` |
| J+4 | 18:32 | l'autre | text | **2 variantes :** « Tu manges quoi le soir ? Si c'est sucre, on a un problème. » ⁄ « Marathon Berlin en sept. Tu viens m'encourager ? » _(si `shen_essaie_sp`, FIN `sp_decalage_durable`)_ |
| J+4 | 22:08 | l'autre | text | **2 variantes :** « C'était sympa le café. Mais je sens pas trop le truc. » ⁄ « Tu fumes encore. Je peux pas. Pardon. » _(si `shen_cafe_sp`, FIN `sp_lui_part_doux`)_ |

### 🚀   ·  `startup_narcissique`

- Catégorie **** · démarre ≥ J1 · contact Pierre-Henri / Gauthier / Édouard (narcissist)
- _30-34 ans founder/C-level. 95 % de lui, anglicismes, networking. Comédie pénible 4-6 j._
- Fichier `lib/data/romance/startup_narcissique.dart` · 10 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:08 | l'autre | text | **3 variantes :** « Hi. Ton profil est aligné avec ce que je cherche. On synchronise un coffee ? » ⁄ « Salut. Disrupting Tinder by actually being honest : je cherche une HVL. » ⁄ « Hello. Question : tu es plutôt early adopter ou late majority ? » |
| J+0 | 00:14 | **Shen** | choice | **CHOIX :** |
| | | | | · **Trolle** → « Plutôt « tu m'agaces déjà ». Tu KPIes ça comment ? » →`shen_trolle_s` |
| | | | | · **Polie** → « Bonsoir. Tu fais quoi exactement ? » →`shen_polie_s` |
| | | | | · **Ignore** → « _(silence)_ » FIN `shen_ignore_s` |
| J+0 | 00:18 | l'autre | text | **3 variantes :** « CEO d'une startup PropTech. On disrupte l'immo. Levée Série A imminente. » ⁄ « Founder. 4 ans McKinsey, 2 ans LVMH, maintenant je build mon thing. » ⁄ « CMO de Lydia. Avant Boston Consulting. Avant HEC. » _(si `shen_polie_s`)_ |
| J+1 | 08:14 | l'autre | text | **3 variantes :** « J'ai 2 réunions de board ce matin. Je t'écris entre deux. » ⁄ « Closing dans 12 jours. Tu auras peu de moi cette semaine. » ⁄ « Je vais à Dubai jeudi. Tu veux venir ? On en parle ce soir. » _(sauf `shen_trolle_s`)_ |
| J+0 | 00:16 | l'autre | text | **2 variantes :** « Hum. Pas la peine si tu prends pas au sérieux. » ⁄ « OK passe ton chemin. Ce sera dommage pour toi. » _(si `shen_trolle_s`)_ |
| J+1 | 23:48 | l'autre | unmatch | _unmatch_ _(si `shen_trolle_s`, FIN `lui_unmatch_vexe_s`)_ |
| J+3 | 16:22 | l'autre | text | **3 variantes :** « Cocktail VC vendredi 19h, Pavillon Royal. Plus 1 ? » ⁄ « Mon coach me dit que je devrais déléguer mes RDV Tinder. T'as un café 30min mardi ? » ⁄ « On peut faire un Zoom 15 min ? Plus efficient que texto. » _(sauf `shen_trolle_s`)_ |
| J+3 | 16:26 | **Shen** | choice | **CHOIX :** _(sauf `shen_trolle_s`)_ |
| | | | | · **Ironique** → « Tu calendly tes flirts ? OK. » →`shen_ironie_s` |
| | | | | · **Ghost** → « _(silence)_ » FIN `shen_ghost_s` |
| J+4 | 07:32 | l'autre | text | **3 variantes :** « Hum. Tu as un sense of humour intéressant. À discuter. » ⁄ « OK. Je te propose un slot de 20 min mardi 18h, mon resto fav 8e. » ⁄ « Tu sais que je peux te faire embaucher ? Tu es archi, j'ai des contacts. » _(si `shen_ironie_s`)_ |
| J+6 | 12:32 | l'autre | text | Tu ne m'as pas répondu sur le slot mardi. Je te re-propose mercredi. _(si `shen_ironie_s`, FIN `shen_lasse_s`)_ |

### 🌼   ·  `tendre_immature`

- Catégorie **** · démarre ≥ J1 · contact Marin / Gabriel / Théo (immature)
- _23-26 ans, doux mais pas prêt. Panique J+7 si pression. Frustration mélancolique 10 j._
- Fichier `lib/data/romance/tendre_immature.dart` · 11 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:08 | l'autre | text | **3 variantes :** « Salut. Je sais pas trop quoi dire. Mais tu as l'air bien. » ⁄ « Hello. Tes photos sont douces. Ça me plaît. » ⁄ « Bonsoir. Tu fais quoi ce soir ? » |
| J+0 | 00:14 | **Shen** | choice | **CHOIX :** |
| | | | | · **Douce** → « Salut. Toi aussi tu as l'air bien. » →`shen_douce_t` |
| | | | | · **Joueuse** → « Bonsoir. Tu sais pas trop quoi dire mais tu as essayé. C'est bien. » →`shen_joueuse_t` |
| | | | | · **Ignore** → « _(silence)_ » FIN `shen_ignore_t` |
| J+1 | 17:22 | l'autre | text | **3 variantes :** « J'ai pensé à toi en mangeant mes pâtes. C'est ridicule mais bon. » ⁄ « Mes parents demandent qui me fait sourire au téléphone. » ⁄ « Je dois rendre un mémoire dans 3 semaines. Et j'ai 4 lignes. » |
| J+3 | 21:08 | l'autre | text | **3 variantes :** « On se voit demain ? Café Belleville ? Je connais pas mais paraît bien. » ⁄ « Vendredi soir on boit un verre ? J'ai jamais proposé ça à personne. » ⁄ « Tu veux qu'on se voie ? Je peux quoi proposer ? » |
| J+3 | 21:12 | **Shen** | choice | **CHOIX :** |
| | | | | · **Accepter** → « OK. Tu choisis. » →`rdv_t` |
| | | | | · **Diriger** → « Café Ten Belles, samedi 16h. Je serai là. » →`rdv_t_shen_drive` |
| | | | | · **Pas envie** → « Je sens pas trop. Désolée. » FIN `shen_decline_t` |
| J+5 | 10:32 | l'autre | mapLocation | _mapLocation_ _(sauf `shen_decline_t`)_ |
| J+5 | 19:32 | l'autre | text | **3 variantes :** « Merci. C'était bizarre et bien. Tu m'as fait peur. » ⁄ « J'ai pas l'habitude de ce genre de moment. » ⁄ « Je rentre. Je dois réfléchir. Pardon si je dis ça. » _(sauf `shen_decline_t`)_ |
| J+5 | 19:36 | **Shen** | choice | **CHOIX :** _(sauf `shen_decline_t`)_ |
| | | | | · **Doux retour** → « Pareil. Pas obligée d'aller vite. » →`shen_doux_t` |
| | | | | · **Question** → « Peur de quoi ? » →`shen_question_t` |
| | | | | · **Pression** → « Tu veux quoi exactement ? » →`shen_pression_t` |
| J+7 | 22:14 | l'autre | text | **3 variantes :** « Je sais pas trop ce que je veux. Je crois. » ⁄ « C'est pas toi. C'est moi. (je sais c'est nul comme phrase) » ⁄ « Désolé. Je peux pas être ce que tu attends. Pardon. » _(si `shen_pression_t`, FIN `lui_recule_panique`)_ |
| J+7 | 22:14 | l'autre | text | **3 variantes :** « Peur de pas être assez. Peur que ça compte vraiment. » ⁄ « Peur de te décevoir. C'est bête. » ⁄ « Peur de devenir comme mon père. (sorry) » _(si `shen_question_t`)_ |
| J+9 | 21:08 | l'autre | text | **3 variantes :** « Je crois que je suis pas prêt. Pardon. » ⁄ « Tu m'aurais mérité quelqu'un de mieux. » ⁄ « On peut rester en contact ? Sans étiquette ? » _(si `shen_doux_t`, FIN `lui_fade_immature`)_ |

### 🌱   ·  `vegan_moralisateur`

- Catégorie **** · démarre ≥ J1 · contact Vincent / Léo / Tristan (pedant)
- _Vegan militant qui juge chaque choix de Shen. Comédie sermon 4 j._
- Fichier `lib/data/romance/vegan_moralisateur.dart` · 9 beats

| J+ | Heure | Qui | Type | Contenu / branches |
|---|---|---|---|---|
| J+0 | 00:14 | l'autre | text | **3 variantes :** « Bonsoir. Petit point avant : t'es plutôt omni ou vegan ? » ⁄ « Salut. Joli sourire mais ton bio dit rien sur l'alimentation. Tu manges quoi ? » ⁄ « Hello. Tu sais que le lait c'est du viol institutionnalisé ? » |
| J+0 | 00:18 | **Shen** | choice | **CHOIX :** |
| | | | | · **Honnête** → « Je mange de tout. Pas militante. » →`shen_omni_v` |
| | | | | · **Évasive** → « Pas une question pour Tinder à 23h. » →`shen_evasive_v` |
| | | | | · **Block** → « _(silence)_ » FIN `shen_block_v` |
| J+0 | 00:22 | l'autre | text | **3 variantes :** « OK. C'est un point bloquant pour moi mais je peux essayer. » ⁄ « Tu sais que chaque steak c'est 15 000 L d'eau ? » ⁄ « Je vais te dire un truc : tu fermes les yeux sur 60 milliards d'animaux par an. » _(si `shen_omni_v`)_ |
| J+1 | 12:14 | l'autre | text | **3 variantes :** « T'es archi ? Tu travailles pour qui ? Promoteurs ? » ⁄ « J'ai vu tes photos. Tu portes du cuir. Ça pue. » ⁄ « Tu vis dans le 8e ou le 16e ? Ces quartiers c'est des micro-mondes complices. » |
| J+1 | 12:18 | **Shen** | choice | **CHOIX :** |
| | | | | · **Patiente** → « Tu enchaînes les jugements depuis 24h. » →`shen_patient_v` |
| | | | | · **Ironique** → « Tu fais quoi sur Tinder un mardi à midi alors ? » →`shen_ironique_v` |
| | | | | · **Unmatch** → « _(silence)_ » FIN `shen_unmatch_v` |
| J+1 | 12:22 | l'autre | text | **3 variantes :** « Je sais. Mais j'assume. » ⁄ « Pardon je suis fatigué de devoir convaincre. » ⁄ « Tu vois pas que je veux juste être avec quelqu'un qui partage mes valeurs ? » _(si `shen_patient_v`)_ |
| J+2 | 19:14 | l'autre | text | **3 variantes :** « Café samedi 11h, Hank Vegan Burger. Si tu refuses, t'as ta réponse. » ⁄ « Resto 100% plant Wild & The Moon, mardi 20h. Test ultime. » ⁄ « Tu peux me prouver que tu peux manger sans cadavre 1 fois. » _(sauf `shen_ironique_v`)_ |
| J+2 | 19:18 | **Shen** | choice | **CHOIX :** _(sauf `shen_ironique_v`)_ |
| | | | | · **Tester** → « OK je teste. » →`rdv_v` |
| | | | | · **Unmatch** → « _(silence)_ » FIN `shen_unmatch_post_v` |
| J+3 | 23:14 | l'autre | text | **3 variantes :** « Tu m'as demandé du lait de soja pour ton café. Je suis déçu. » ⁄ « Tu as ri quand j'ai dit "antispéciste". Je crois qu'on n'est pas alignés. » ⁄ « Je sais que tu as commandé un kebab après. Mon copain t'a vue. » _(si `rdv_v`, FIN `lui_juge_final`)_ |
