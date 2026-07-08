import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/notes_data.dart';
import '../data/ubereats/courses.dart';
import '../data/ubereats/customers.dart';
import '../data/ubereats/restaurants.dart';
import 'ubereats_stats_provider.dart';

/// Provider dérivé : génère des `NoteEntry` (brouillons / étoilées) à
/// partir des courses UberEats livrées. Notes attachées aux courses
/// "narratives" (collision, vieux isolé, etc.) qui méritent une trace
/// dans le carnet de Shen.
///
/// Mapping courseId → NoteEntry — chaque course "spéciale" laisse une
/// trace écrite, voix Shen préservée.
final ubereatsTracesNotesProvider = Provider<List<NoteEntry>>((ref) {
  final stats = ref.watch(uberStatsProvider);
  final notes = <NoteEntry>[];
  for (final cid in stats.completedCourseIds) {
    final note = _traceFor(cid);
    if (note != null) notes.add(note);
  }
  return notes;
});

NoteEntry? _traceFor(String courseId) {
  final course = kCourses.firstWhere(
    (c) => c.id == courseId,
    orElse: () => kCourses.first,
  );
  if (course.id != courseId) return null;
  final customer = customerById(course.customerId);
  final restaurant = restaurantById(course.restaurantId);

  // Mapping selon courses spécifiques (narrative) ou clients-clés
  switch (courseId) {
    case 'c_j1_07h52_collision':
      // Cette course-là, la J1, ne devrait pas pouvoir être livrée
      // (collision). On laisse au scenario canon le soin de tracer.
      return null;

    case 'c_j7_07h20':
      return NoteEntry(
        day: course.minDay,
        time: '08:14',
        title: 'Tante Lihua',
        body:
            'Livraison Long Jing chez la tante de Tristan, rue de Berri.\n'
            'Elle m\'a dit « merci ma fille » sans me regarder.\n'
            'Elle ne me connaissait pas.',
        starred: true,
      );

    case 'c_j8_09h10':
      return NoteEntry(
        day: course.minDay,
        time: '10:48',
        title: 'Hélène R.',
        body:
            'rue de Berri, encore. 15 € de tip.\n'
            'Elle m\'a dit « mes pensées » comme à une orpheline.\n'
            'Elle connaît les Heng. Je n\'ai pas voulu poser de questions.',
      );

    case 'c_j10_11h30':
      return NoteEntry(
        day: course.minDay,
        time: '12:08',
        title: 'Auto-livraison',
        body:
            'Le concierge de l\'immeuble où je vis m\'a remis une commande '
            'que j\'avais moi-même livrée 4 min plus tôt.\n'
            'Il ne m\'a pas reconnue. C\'est mieux.',
      );

    case 'c_j12_14h12':
      return NoteEntry(
        day: course.minDay,
        time: '15:48',
        title: 'Résidence Aubert',
        body:
            'Pizza pour les pensionnaires du foyer Aubert, Pantin.\n'
            'Mme Boucher m\'a dit que les vieux adorent.\n'
            '5 € de tip et un sourire. Pourtant je n\'ai pas souri.',
      );

    case 'c_j14_15h22_vip':
      return NoteEntry(
        day: course.minDay,
        time: '15:48',
        title: 'Bonjour Mlle Marchand',
        body:
            'Thomas G., 7 rue de Berri.\n'
            'Trois étages au-dessous de chez moi.\n'
            'Il m\'a tendu 20 € sans hésiter en disant « pour vous, '
            'sincèrement ». Il ne m\'a pas reconnue.',
        starred: true,
      );

    case 'c_j15_22h32':
      return NoteEntry(
        day: course.minDay,
        time: '23:42',
        title: 'Camille a commandé pour moi',
        body:
            'Pizza à 22h32. Adresse : chez Camille. Tip 5 €.\n'
            '« Espèce de gourde. J\'ai commandé pour qu\'on bouffe ensemble. »\n'
            'Je suis restée trois heures. Elle a sorti une bouteille.',
        starred: true,
      );

    default:
      // Pas de trace par défaut. Mais certains profils-clé toujours :
      switch (customer.id) {
        case 'cl_mr_lebrun':
          return NoteEntry(
            day: course.minDay,
            time: course.hour > 12 ? '${course.hour + 1}:42' : '10:14',
            title: 'M. Lebrun',
            body:
                'Livraison ${restaurant.name} chez M. Lebrun, 82 ans.\n'
                'Il m\'a offert un café que je n\'ai pas pris.\n'
                'Je l\'ai regretté à 4h du matin.',
          );
        case 'cl_camille_gag':
          return NoteEntry(
            day: course.minDay,
            time: '23:42',
            title: 'Encore Camille',
            body:
                'Elle commande pour me forcer à venir.\n'
                'Tip 5 €. Note : « Espèce de gourde. »',
          );
        case 'cl_flirteur_a':
          return NoteEntry(
            day: course.minDay,
            time: '21:08',
            title: 'Alexandre B.',
            body:
                'Il m\'a tendu son numéro avec la commande.\n'
                'Je l\'ai posé sur la table d\'entrée sans le lire.',
            draft: true,
          );
        case 'cl_picky_b':
          return NoteEntry(
            day: course.minDay,
            time: '14:18',
            title: 'Bertrand',
            body:
                'Bertrand A. m\'a mis 2 étoiles parce que les sushis '
                'étaient tièdes. Ils étaient à 14 °C. C\'est la température.',
          );
        default:
          return null;
      }
  }
}
