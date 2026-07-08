import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/notes_data.dart';
import '../data/romance_templates.dart';
import '../models/romance.dart';
import 'romance_threads_provider.dart';

/// Provider dérivé : génère des `NoteEntry` (brouillons / étoilées) à
/// partir des arcs Tinder terminés. Ces notes apparaissent dans
/// l'app Notes en plus des notes canoniques.
///
/// Mapping endingId → NoteEntry. Quand un arc finit, sa fin (rupture
/// honnête, ghost, catfish, escort reveal, etc.) laisse une trace
/// écrite dans le carnet de Shen — la voix « je » qui répond à ce
/// qui vient de se passer.
final romanceTracesNotesProvider = Provider<List<NoteEntry>>((ref) {
  final state = ref.watch(romanceThreadsProvider);
  return state.archived
      .map(_traceNoteFor)
      .whereType<NoteEntry>()
      .toList();
});

NoteEntry? _traceNoteFor(RomanceInstance inst) {
  final template = kRomanceTemplates.firstWhere(
    (t) => t.id == inst.templateId,
    orElse: () => kRomanceTemplates.first,
  );
  final profile = template.profilePool[inst.profileIdx];
  // Jour de la trace : on prend le dernier message joué + 1 jour.
  final lastDay = inst.playedMessages.isNotEmpty
      ? inst.playedMessages.last.day
      : inst.startDay;
  final noteDay = lastDay + 1;

  switch (inst.endingId) {
    // ── Slow burn sincère
    case 'rupture_honnete':
      return NoteEntry(
        day: noteDay,
        time: '23:42',
        title: 'Le seul qui méritait',
        body:
            'J\'ai dit la vérité à ${profile.name}. Il est parti propre.\n'
            'C\'est rare et terrible.\n\n'
            'Camille dirait que c\'est dommage.\n'
            'Je ne sais pas si c\'est dommage.',
        starred: true,
      );
    case 'rupture_mutuelle':
      return NoteEntry(
        day: noteDay,
        time: '22:08',
        title: 'À deux',
        body:
            '${profile.name} a vu avant moi.\n'
            'On a arrêté en même temps.\n'
            'C\'est presque trop adulte.',
      );
    case 'il_unmatch_silencieux':
      return NoteEntry(
        day: noteDay,
        time: '23:58',
        title: 'Pas de mot',
        body:
            '${profile.name} a unmatch sans rien dire.\n'
            'Je l\'ai cherché trois fois dans la pile, comme une idiote.\n'
            'Il avait raison.',
        draft: true,
      );
    case 'shen_ghost_post_rdv':
      return NoteEntry(
        day: noteDay,
        time: '07:18',
        title: 'Lâcheté',
        body:
            'J\'ai disparu sur ${profile.name}.\n'
            'Pas de mot. Pas de fin.\n'
            'Je hais ce que je suis devenue cette semaine.',
        draft: true,
      );
    // ── Lovebomber
    case 'lui_unmatch_dignite':
    case 'shen_unmatch_immediate':
      return NoteEntry(
        day: noteDay,
        time: '23:12',
        title: 'Six messages en huit minutes',
        body:
            'Match ce matin, six messages avant le café.\n'
            'À ${profile.age} ans il appelle « bébé » dans la deuxième phrase.\n'
            'Je l\'ai unmatch sans regret. Camille rit déjà.',
      );
    // ── Breadcrumber
    case 'shen_unmatch_breadcrumb':
    case 'shen_unmatch_silent_treatment':
    case 'shen_apprend_lecon':
      return NoteEntry(
        day: noteDay,
        time: '23:42',
        title: 'Miettes',
        body:
            'Onze jours pour comprendre ce qu\'on appelle un breadcrumber.\n'
            'Une réponse tous les quatre jours, photo coucher de soleil sans contexte, '
            'puis « tu es comment ? » comme si rien.\n\n'
            '${profile.name} ne reviendra plus. Tant mieux.',
        starred: true,
      );
    // ── Refuge sain
    case 'refuge_durable':
      return NoteEntry(
        day: noteDay,
        time: '21:14',
        title: 'Quelqu\'un sans rien',
        body:
            '${profile.name} m\'écrit tous les quatre jours.\n'
            'Il ne me demande rien. Il dit juste qu\'il est là.\n\n'
            'Je n\'ai pas le droit de garder ça pour moi.\n'
            'Je le fais quand même.',
        starred: true,
      );
    case 'refuge_fade_doux':
      return NoteEntry(
        day: noteDay,
        time: '22:08',
        title: 'Doucement',
        body:
            'J\'ai laissé partir ${profile.name} sans rien dire.\n'
            'Il n\'a pas insisté. C\'est ça qui fait le plus mal.',
      );
    // ── Predator
    case 'shen_block_signal':
    case 'shen_block_signal_late':
    case 'shen_block_signal_insulte':
    case 'shen_block_immediate':
      return NoteEntry(
        day: noteDay,
        time: '09:14',
        title: 'Bloqué',
        body:
            '« 250 € la soirée, je paie le trajet. »\n'
            'Voilà ce que ${profile.name} m\'a écrit ce matin.\n'
            'J\'ai bloqué + signalé. Camille a un screenshot.',
      );
    // ── Catfish
    case 'shen_block_catfish':
    case 'shen_block_signal_cf':
    case 'shen_disappear_cf':
      return NoteEntry(
        day: noteDay,
        time: '23:08',
        title: 'Le papier peint était propre',
        body:
            'Visio acceptée. L\'écran s\'est allumé sur un homme de 47 ans '
            'en chemise blanche, derrière un papier peint Ikea.\n\n'
            '« Ah, finalement c\'est toi. »\n\n'
            'J\'ai raccroché. Le papier peint était propre.\n'
            'Je n\'ai pas dormi.',
        starred: true,
      );
    // ── Mansplainer
    case 'shen_block_man':
    case 'shen_sarcasme_final':
    case 'lui_lache_apres_3':
      return NoteEntry(
        day: noteDay,
        time: '14:18',
        title: 'Lis page 47',
        body:
            '${profile.name} m\'a offert un livre. Il m\'a dit : « lis page 47 ».\n'
            'À la page 47 il y avait une définition d\'« architecture ».\n'
            'Je suis architecte. Il m\'a expliqué mon métier en quatre jours.\n'
            'J\'ai unmatch en souriant.',
      );
    // ── Passion fougueuse
    case 'shen_lache_p':
    case 'lui_unmatch_oubli':
      return NoteEntry(
        day: noteDay,
        time: '02:14',
        title: 'Restes de service',
        body:
            '${profile.name} m\'a écrit à 3h du matin : « pardon je vois ça '
            'maintenant je suis défoncé ».\n'
            'Je lui ai dit que je ne pouvais pas vivre dans ses restes de service.\n'
            'Il n\'a pas répondu.',
      );
    case 'rdv_planifie_long':
      return NoteEntry(
        day: noteDay,
        time: '23:32',
        title: 'Lundi',
        body:
            '${profile.name} a remplacé son sous-chef.\n'
            'Lundi il dort. Lundi je le vois.\n'
            'Je l\'attends comme une dingue.',
      );
    // ── Queer douce
    case 'q_amitie_durable':
    case 'q_relation_continue':
      return NoteEntry(
        day: noteDay,
        time: '23:42',
        title: 'L\'inattendu',
        body:
            'Je n\'avais jamais swipé une femme.\n'
            '${profile.name} m\'a recommandé Maggie Nelson, m\'a écouté parler '
            'd\'escaliers, m\'a dit merci d\'avoir dit ce que j\'ai dit.\n\n'
            'C\'est la première personne à qui je n\'ai pas eu à mentir.',
        starred: true,
      );
    case 'q_fade_doux':
      return NoteEntry(
        day: noteDay,
        time: '22:18',
        title: 'Bluets',
        body:
            'Elle s\'est éteinte sans m\'en vouloir.\n'
            'Je n\'ai pas lu le livre qu\'elle m\'a recommandé.\n'
            'Je le ferai. Promis à personne.',
        draft: true,
      );
    // ── Père divorcé
    case 'pere_amitie':
    case 'pere_continue':
      return NoteEntry(
        day: noteDay,
        time: '21:18',
        title: 'Fenêtre',
        body:
            '${profile.name} a deux enfants et deux heures le mardi.\n'
            'Quand il a su que je vivais ailleurs, il a dit OK et il a tenu.\n'
            'Je ne sais pas si je veux ça. Je sais que ça existe.',
      );
    // ── Tendre immature
    case 'lui_recule_panique':
    case 'lui_fade_immature':
      return NoteEntry(
        day: noteDay,
        time: '23:14',
        title: 'Pas prêt',
        body:
            '${profile.name} a panique en deux jours.\n'
            'À ${profile.age} ans je l\'étais aussi. Sauf que personne ne me l\'a pardonné.',
      );
    // ── Départ imminent
    case 'lui_part_promesse':
      return NoteEntry(
        day: noteDay,
        time: '06:14',
        title: 'Avion 8h',
        body:
            '${profile.name} a pris l\'avion ce matin.\n'
            'Il m\'a laissé un vocal de 62 secondes la veille.\n'
            'Si je n\'ai jamais de ses nouvelles, je saurai que ça n\'a jamais été à moi.\n'
            'Si j\'en ai, je ne sais pas ce que je ferai.',
        starred: true,
      );
    case 'shen_protege_d':
      return NoteEntry(
        day: noteDay,
        time: '22:08',
        title: 'Protéger',
        body:
            'J\'ai dit non à ${profile.name} parce que j\'avais peur.\n'
            'C\'est honnête. C\'est triste.\n'
            'Camille dirait que les deux peuvent coexister.',
      );
    // ── Startup narcissique
    case 'shen_lasse_s':
    case 'shen_ghost_s':
    case 'lui_unmatch_vexe_s':
      return NoteEntry(
        day: noteDay,
        time: '19:42',
        title: 'HVL',
        body:
            'High Value Life Partner. C\'est ce qu\'il cherchait, ${profile.name}.\n'
            'Je crois que je suis pas HVL. Je crois qu\'on est plein à pas l\'être.',
      );
    // ── Class divide
    case 'lui_part_class':
    case 'lui_part_doux_class':
      return NoteEntry(
        day: noteDay,
        time: '23:18',
        title: 'Berri',
        body:
            'J\'ai dit rue de Berri à ${profile.name}.\n'
            'Il a dit « tu choisis tes embrouilles ».\n'
            'Il avait raison. Je l\'ai choisi.',
        starred: true,
      );
    // ── Poly
    case 'shen_block_po':
    case 'lui_lache_admis':
      return NoteEntry(
        day: noteDay,
        time: '15:28',
        title: 'Ouvert',
        body:
            '${profile.name} m\'a dit le jour du RDV qu\'il était en couple ouverte.\n'
            'Quatre jours de conversation pour ça.\n'
            'J\'ai bloqué sans drama.',
      );
    case 'po_a_voir':
      return NoteEntry(
        day: noteDay,
        time: '19:12',
        title: 'À voir',
        body:
            'J\'ai dit oui pour en parler le soir.\n'
            'Je sais pas où je vais.',
        draft: true,
      );
    // ── Magnétique vide
    case 'elle_unmatch_vexe':
    case 'elle_unmatch_oubli':
      return NoteEntry(
        day: noteDay,
        time: '23:32',
        title: 'Trop joli',
        body:
            'Quatre jours de monosyllabes et d\'emojis.\n'
            '${profile.name} était la plus belle personne à qui j\'aie '
            'jamais parlé. La plus vide aussi.',
      );
    // ── Journaliste
    case 'shen_block_j':
    case 'shen_block_panic_j':
    case 'j_arret_propre':
    case 'shen_block_post_rdv_j':
      return NoteEntry(
        day: noteDay,
        time: '23:42',
        title: 'Heng',
        body:
            'Elle m\'a demandé si je connaissais Tristan Heng.\n'
            'J\'ai paniqué en quatre secondes.\n'
            'C\'est ma vie maintenant : tressaillir au prénom.',
        starred: true,
      );
    // ── Infirmière
    case 'i_refuge_pratique':
      return NoteEntry(
        day: noteDay,
        time: '14:18',
        title: 'Quelqu\'un qui sait',
        body:
            '${profile.name} travaille à Tenon en onco.\n'
            'Elle m\'a donné une fiche. Pas de pitié, pas de pression.\n'
            'Elle a dit : « si tu veux qu\'on parle pratique, je peux ».',
        starred: true,
      );
    case 'i_attend_doucement':
      return NoteEntry(
        day: noteDay,
        time: '21:42',
        title: 'Doucement',
        body:
            'J\'ai refusé l\'aide de ${profile.name}.\n'
            'Elle a dit « OK, je reste là, pas pesante ».\n'
            'Je ne sais pas pourquoi je refuse ce qui me tient.',
      );
    // ── Manipulatrice
    case 'shen_block_man2':
    case 'shen_block_late_man2':
    case 'shen_arret_propre_man2':
    case 'shen_reveil_tardif':
      return NoteEntry(
        day: noteDay,
        time: '22:14',
        title: 'Tu es très abîmée mais récupérable',
        body:
            'Voilà ce qu\'elle m\'a écrit, ${profile.name}.\n'
            'Trois jours pour comprendre qu\'elle me coachait gratos pour me '
            'vendre 80 € la séance.\n'
            'J\'ai bloqué. Camille m\'a dit que j\'avais bien fait.',
      );
    // ── Sportive
    case 'sp_decalage_durable':
    case 'sp_lui_part_doux':
    case 'shen_avoue_sp':
      return NoteEntry(
        day: noteDay,
        time: '09:18',
        title: 'Douze minutes',
        body:
            'J\'ai tenu douze minutes de footing avec ${profile.name}.\n'
            'Je voulais vomir. Elle voulait recommencer.\n'
            'On n\'avait pas les mêmes corps.',
      );
    // ── Avocate
    case 'av_arret_droit':
    case 'av_couupe_urgence':
      return NoteEntry(
        day: noteDay,
        time: '22:48',
        title: 'Adulte',
        body:
            '${profile.name} m\'a parlé comme on parle d\'un dossier.\n'
            '« Vie carrée, fils, plage horaire ». J\'ai aimé. '
            'Elle a coupé sec quand j\'ai dit contrat.\n'
            'Je comprends.',
      );
    // ── Drama yoga
    case 'lui_demande_argent_y':
    case 'shen_recule_y':
    case 'shen_block_y':
      return NoteEntry(
        day: noteDay,
        time: '23:58',
        title: 'Studio en feu',
        body:
            '${profile.name} m\'a déroulé son drama professionnel en trois jours.\n'
            'Le quatrième elle m\'a demandé 500 €.\n'
            'J\'ai pas répondu. Camille me dit qu\'elle a fait le tour de mes amies.',
      );
    // ── Escort
    case 'shen_part_e':
    case 'e_conversation_lucide':
    case 'shen_block_e':
      return NoteEntry(
        day: noteDay,
        time: '00:18',
        title: 'Park Hyatt',
        body:
            '${profile.name} m\'a invitée au bar du Park Hyatt.\n'
            'Avant que je commande, elle m\'a dit : « je suis escort. Hommes '
            'clients. Je swipe les femmes pour le jeu. »\n\n'
            'Je suis partie. Elle a souri sans rancune.\n'
            'Le bar restait magnifique.',
        starred: true,
      );
    // ── Retour HK
    case 'h_complicite_lourde':
      return NoteEntry(
        day: noteDay,
        time: '23:14',
        title: 'Pas mes amis non plus',
        body:
            '${profile.name} a vécu cinq ans à Hong Kong. Il m\'a dit '
            '« les Heng, pas mes amis non plus, mais je connais ».\n'
            'On a bu un thé deux heures. J\'ai parlé en chinois pour la '
            'première fois à quelqu\'un que je n\'ai pas peur.\n'
            'Je ne sais pas ce que c\'est, cette complicité. Mais elle est lourde.',
        starred: true,
      );
    // ── Vegan moralisateur
    case 'shen_unmatch_v':
    case 'shen_unmatch_post_v':
    case 'lui_juge_final':
      return NoteEntry(
        day: noteDay,
        time: '23:42',
        title: 'Mon copain t\'a vue',
        body:
            '${profile.name} m\'a écrit : « je sais que tu as commandé un kebab '
            'après. Mon copain t\'a vue. »\n'
            'J\'ai unmatch. Camille a ri pendant dix minutes.',
      );
    // ── Libraire
    case 'l_amitie_durable':
      return NoteEntry(
        day: noteDay,
        time: '20:14',
        title: 'Vendredi',
        body:
            'Camille m\'a poussée vers ${profile.name} sans me prévenir.\n'
            'Il a vu que j\'avais menti. Il a dit OK pour l\'amitié.\n'
            'Il m\'a mis un livre de côté pour vendredi.',
        starred: true,
      );
    case 'l_continue_quotidien':
      return NoteEntry(
        day: noteDay,
        time: '21:14',
        title: 'Le potentiel',
        body:
            '${profile.name} ferme la librairie tôt samedi.\n'
            'Je vais y aller. Je sais que je vais y aller.\n'
            'Camille le sait aussi.',
      );
    case 'l_recule_ment':
      return NoteEntry(
        day: noteDay,
        time: '23:48',
        title: 'Il sent',
        body:
            'J\'ai menti à ${profile.name}. Il a senti.\n'
            'Il m\'a dit « tu mens mal ». Camille n\'a pas répondu à mon SMS.',
        draft: true,
      );
    // ── Homonyme
    case 'ho_normal':
      return NoteEntry(
        day: noteDay,
        time: '22:48',
        title: 'L\'autre Tristan',
        body:
            'Il s\'appelait ${profile.name}. Comme l\'autre.\n'
            'Au début je ne lisais pas son prénom, je tressaillais.\n'
            'Maintenant je lis son prénom. C\'est presque guéri.',
      );
    case 'ho_il_sent_le_truc':
      return NoteEntry(
        day: noteDay,
        time: '23:14',
        title: 'Tressaillir',
        body:
            'J\'ai nié avoir paniqué en lisant son prénom.\n'
            '${profile.name} a senti. Il est parti.\n'
            'C\'est moi qui suis bizarre.',
        draft: true,
      );
    default:
      return null;
  }
}
