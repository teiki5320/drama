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
};
