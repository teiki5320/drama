import 'package:flutter_test/flutter_test.dart';

import 'package:drama/src/engine.dart';
import 'package:drama/src/models.dart';

void main() {
  test('un choix chronométré expire tout seul sur la branche du timeout',
      () async {
    final e = GameEngine(delayScale: 0);
    final futur = e.choice(
      'plateforme',
      const [
        ChoiceOption('Accepter la course', key: 'ok'),
        ChoiceOption('Laisser passer', key: 'non'),
      ],
      timeoutMs: 30000,
      timeoutOption:
          const ChoiceOption('(temps écoulé)', silent: true, key: 'non'),
    );
    final opt = await futur;
    expect(opt.key, 'non');
    expect(e.thread('plateforme').pending, isNull);
    // Silencieux : rien n'a été « envoyé » par Shen.
    expect(
      e.thread('plateforme').messages.where((m) => m.kind == MsgKind.outgoing),
      isEmpty,
    );
  });

  test('un choix sans chrono attend indéfiniment le joueur', () async {
    final e = GameEngine(delayScale: 0);
    e.choice('camille', const [ChoiceOption('A'), ChoiceOption('B')]);
    await Future<void>.delayed(Duration.zero);
    expect(e.thread('camille').pending, isNotNull);
    e.resolveChoice('camille', e.thread('camille').pending!.options.first);
    expect(e.thread('camille').pending, isNull);
  });

  test('Ma Banque : le solde égale le report plus les opérations', () {
    final e = GameEngine();
    final somme = e.bankOps.fold<double>(0, (s, o) => s + o.amount);
    expect(
      (GameEngine.bankOpeningBalance + somme - e.bankBalance).abs(),
      lessThan(0.005),
    );
    // La précarité est un choix d'écriture : pas de découvert autorisé.
    expect(e.bankBalance, greaterThan(0));
  });

  test('addBankOp met à jour la liste et le solde', () {
    final e = GameEngine();
    final avant = e.bankBalance;
    e.addBankOp('Mer. 15 juil.', 'PÉNALITÉ COURSE #14872', -38.00);
    expect(e.bankOps.first.label, 'PÉNALITÉ COURSE #14872');
    expect((e.bankBalance - (avant - 38.00)).abs(), lessThan(0.005));
  });
}
