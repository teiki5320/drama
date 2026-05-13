import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../core/app_version.dart';
import '../core/colors.dart';
import '../providers/game_state_provider.dart';
import '../providers/ui_provider.dart';

/// Modal bottom sheet for app settings (replaces the old "Recommencer ?"
/// alert dialog). Sections: about/version, règles du jeu, réinitialiser.
class SettingsSheet extends ConsumerWidget {
  const SettingsSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0x141A1A1A),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Text(
              'Réglages',
              style: GoogleFonts.crimsonPro(
                fontSize: 26,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18),

            // SECTION : RÈGLES
            _SectionLabel('AIDE'),
            const SizedBox(height: 6),
            _RowsCard(children: [
              _ActionRow(
                icon: Icons.help_outline,
                label: 'Comment jouer',
                onTap: () {
                  Navigator.of(context).pop();
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: AppColors.paperCream,
                    isScrollControlled: true,
                    showDragHandle: true,
                    builder: (_) => const _RulesSheet(),
                  );
                },
              ),
            ]),

            const SizedBox(height: 16),

            // SECTION : PARTIE
            _SectionLabel('PARTIE'),
            const SizedBox(height: 6),
            _RowsCard(children: [
              _ActionRow(
                icon: Icons.restart_alt,
                label: 'Recommencer la partie',
                destructive: true,
                onTap: () async {
                  HapticFeedback.lightImpact();
                  final ok = await _confirmReset(context);
                  if (ok != true) return;
                  await ref.read(gameStateProvider.notifier).reset();
                  // Reset → on revient au CARNET (onglet 1). L'onglet 0
                  // (ACE) est expérimental et ne pilote pas la save.
                  ref.read(selectedTabProvider.notifier).state = 1;
                  if (context.mounted) {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text('Partie réinitialisée'),
                        backgroundColor: AppColors.textPrimary,
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            ]),

            const SizedBox(height: 16),

            // SECTION : À PROPOS
            _SectionLabel('À PROPOS'),
            const SizedBox(height: 6),
            _RowsCard(children: [
              _InfoRow(
                label: 'À Contre-Jour (逆光)',
                value: 'v$kAppVersion · build $kBuildNumber',
              ),
              _InfoRow(
                label: 'Drama romantique mobile',
                value: '112 jours · 5 fins',
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

Future<bool?> _confirmReset(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('Recommencer la partie ?'),
      content: const Text(
        'Toute ta progression actuelle (jours, choix, banque, conversations) sera perdue.',
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: const Text('Annuler'),
        ),
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          style: TextButton.styleFrom(foregroundColor: AppColors.negative),
          child: const Text('Recommencer'),
        ),
      ],
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────
// RULES SHEET
// ─────────────────────────────────────────────────────────────────────

class _RulesSheet extends StatelessWidget {
  const _RulesSheet();

  static const _rules = <_Rule>[
    _Rule(
      icon: '😊',
      title: 'Mood (0–100)',
      body:
          'L\'humeur de Shen. Tous les 10 points, une catégorie d\'achats s\'ouvre (bouffe à 30, déco à 40, tech à 50, mode à 60, bijoux à 70, voyage à 80, mécénat à 90). Si elle retombe sous le seuil, la catégorie redevient grisée. Les choix journaliers font bouger doucement.',
    ),
    _Rule(
      icon: '⭐',
      title: 'Réputation',
      body:
          'L\'influence sociale de Shen. Chaque ★ ouvre l\'accès à des items / lieux et augmente ses partenariats Insta (revenus passifs quotidiens).',
    ),
    _Rule(
      icon: '💰',
      title: 'Argent',
      body:
          'Tu démarres avec 2 384 €. Trois sources de revenu : choix narratifs, partenariats Insta (selon followers), et investissements en bourse.',
    ),
    _Rule(
      icon: '🏥',
      title: 'Deadline Maman',
      body:
          'Hélène a besoin de 18 000 € pour son traitement avant J45. Si tu n\'as pas réuni la somme, le drama bascule sur la branche du deuil — sans retour.',
    ),
    _Rule(
      icon: '📈',
      title: 'Investissements',
      body:
          'Le cours bouge ±2 % chaque jour, plus des chocs scénarisés à dates fixes (J35, J52, J76, J98). À toi de spéculer pour compenser.',
    ),
    _Rule(
      icon: '📷',
      title: 'Instagram',
      body:
          'Chaque achat « bling » de Shen génère un post automatique. Tes followers grandissent avec ta réputation : 1 ★ ≈ 1 000 abonnés.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Comment jouer',
                style: GoogleFonts.crimsonPro(
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Tu incarnes Shen Marchand, 24 ans, livreuse à vélo à Belleville. Sa mère est malade. 112 jours pour que ça finisse bien — ou pas.',
                style: GoogleFonts.inter(
                  fontSize: 13.5,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 18),
              for (final r in _rules) ...[
                _RuleCard(rule: r),
                const SizedBox(height: 10),
              ],
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'J\'ai compris',
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accentOrange,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Rule {
  final String icon;
  final String title;
  final String body;
  const _Rule({required this.icon, required this.title, required this.body});
}

class _RuleCard extends StatelessWidget {
  const _RuleCard({required this.rule});
  final _Rule rule;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFFF3EEDF),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(rule.icon, style: const TextStyle(fontSize: 18)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rule.title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  rule.body,
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────
// HELPERS
// ─────────────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.0,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

class _RowsCard extends StatelessWidget {
  const _RowsCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final withDividers = <Widget>[];
    for (var i = 0; i < children.length; i++) {
      withDividers.add(children[i]);
      if (i < children.length - 1) {
        withDividers.add(
          const Divider(height: 1, indent: 14, color: Color(0x0F1A1A1A)),
        );
      }
    }
    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardBg,
        border: Border.all(color: const Color(0x141A1A1A)),
        borderRadius: BorderRadius.circular(14),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: withDividers),
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({
    required this.icon,
    required this.label,
    required this.onTap,
    this.destructive = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final color =
        destructive ? AppColors.negative : AppColors.textPrimary;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        child: Row(
          children: [
            Icon(icon, size: 20, color: color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ),
            const Icon(Icons.chevron_right,
                color: AppColors.textSecondary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 12.5,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
