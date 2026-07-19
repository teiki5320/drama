/// Les fiches contact — ce que Shen « sait » de chaque correspondant.
library;

class ContactField {
  const ContactField(this.label, this.value);

  final String label;
  final String value;
}

class ContactInfo {
  const ContactInfo({
    required this.displayName,
    this.subtitle,
    this.fields = const [],
    this.emptyNote,
    this.canBlock = false,
  });

  final String displayName;
  final String? subtitle;
  final List<ContactField> fields;

  /// Affiché quand la fiche est vide (numéro inconnu).
  final String? emptyNote;

  /// Affiche la ligne rouge « Bloquer ce correspondant ».
  final bool canBlock;
}

const Map<String, ContactInfo> kContacts = {
  'moi': ContactInfo(
    displayName: 'Shen Marchand',
    subtitle: 'Ma fiche',
    fields: [
      ContactField('âge', '24 ans'),
      ContactField('métier', 'Livreuse à vélo — Livraisons Pro'),
      ContactField('domicile', 'Belleville, Paris 20ᵉ — chez Maman'),
      ContactField('mobile', '+33 6 24 81 07 56'),
      ContactField('notes',
          'Récupérer ce qu’il reste du vélo.\nArchitecte, un jour. Encore.'),
    ],
  ),
  'maman': ContactInfo(
    displayName: 'Maman ❤️',
    fields: [
      ContactField('mobile', '+33 6 12 44 87 30'),
      ContactField('domicile', 'Rue de Belleville, Paris 20ᵉ'),
      ContactField('notes',
          'Dimanche : dumplings.\nNe pas oublier le gingembre frais.'),
    ],
  ),
  'camille': ContactInfo(
    displayName: 'Camille',
    fields: [
      ContactField('mobile', '+33 6 48 27 91 15'),
      ContactField('travail', 'Chargée de com’ — événementiel'),
      ContactField('notes',
          'Meilleure amie.\nCroissants le samedi, sans négociation.'),
    ],
  ),
  'plateforme': ContactInfo(
    displayName: 'Livraisons Pro',
    subtitle: 'Numéro professionnel',
    fields: [
      ContactField('assistance', '0 805 08 14 87'),
      ContactField('notes',
          'Taux d’acceptation ≥ 80 %.\nRépondre sous 30 secondes.'),
    ],
  ),
  'inconnu': ContactInfo(
    displayName: 'Numéro inconnu',
    subtitle: '+33 7 68 ·· ·· ··',
    emptyNote: 'Aucune information partagée.',
    canBlock: true,
  ),
  'tristan': ContactInfo(
    displayName: 'Tristan H.',
    fields: [
      ContactField('mobile', '+33 7 68 12 47 03'),
      ContactField('société', 'Heng International — Tour Heng, 47ᵉ étage'),
      ContactField('notes', 'Conduit mal. Paie bien ?'),
    ],
  ),
  'aubin': ContactInfo(
    displayName: 'Dr Aubin',
    subtitle: 'Hôpital Tenon — Oncologie',
    fields: [
      ContactField('secrétariat', '01 56 01 60 00'),
      ContactField('adresse', '4 rue de la Chine, Paris 20ᵉ · cabinet 214'),
      ContactField('notes', 'L’oncologue de Maman. Direct, mais humain.'),
    ],
  ),
  'banque': ContactInfo(
    displayName: 'BNP INFO',
    subtitle: 'Numéro automatique',
    emptyNote: 'Messages d’information. Ce numéro n’accepte pas de réponses.',
  ),
};
