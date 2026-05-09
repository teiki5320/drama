import 'package:flutter/material.dart';

import '../../core/colors.dart';
import '../../models/choice.dart';

typedef ChoicePicked = void Function(int index, ChoiceOption option);

class ChoiceCard extends StatelessWidget {
  const ChoiceCard({
    super.key,
    required this.choice,
    required this.onPicked,
    required this.disabled,
  });

  final Choice choice;
  final ChoicePicked onPicked;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          choice.prompt,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 10),
        for (var i = 0; i < choice.options.length; i++) ...[
          _OptionTile(
            index: i,
            option: choice.options[i],
            onTap:
                disabled ? null : () => onPicked(i, choice.options[i]),
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _OptionTile extends StatelessWidget {
  const _OptionTile({
    required this.index,
    required this.option,
    required this.onTap,
  });

  final int index;
  final ChoiceOption option;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final letter = String.fromCharCode('A'.codeUnitAt(0) + index);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
        decoration: BoxDecoration(
          color: AppColors.cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0x141A1A1A)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    letter,
                    style: const TextStyle(
                      color: AppColors.accentOrange,
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    option.text,
                    style: const TextStyle(
                      fontSize: 14.5,
                      height: 1.4,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _DeltasRow(option: option),
          ],
        ),
      ),
    );
  }
}

class _DeltasRow extends StatelessWidget {
  const _DeltasRow({required this.option});

  final ChoiceOption option;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      children: [
        _DeltaChip(emoji: '💰', value: option.argent, suffix: '€'),
        _DeltaChip(emoji: '😊', value: option.mood),
        _DeltaChip(emoji: '⭐', value: option.reputation),
      ],
    );
  }
}

class _DeltaChip extends StatelessWidget {
  const _DeltaChip({required this.emoji, required this.value, this.suffix = ''});
  final String emoji;
  final int value;
  final String suffix;

  @override
  Widget build(BuildContext context) {
    if (value == 0) {
      return Text(
        '$emoji 0$suffix',
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textSecondary,
        ),
      );
    }
    final positive = value > 0;
    final color = positive ? AppColors.positive : AppColors.negative;
    final sign = positive ? '+' : '';
    return Text(
      '$emoji $sign$value$suffix',
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: color,
      ),
    );
  }
}
