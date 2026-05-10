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
    this.selectedIndex,
  });

  final Choice choice;
  final ChoicePicked onPicked;
  final bool disabled;
  final int? selectedIndex;

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
            selected: selectedIndex == i,
            dimmed: selectedIndex != null && selectedIndex != i,
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
    required this.selected,
    required this.dimmed,
  });

  final int index;
  final ChoiceOption option;
  final VoidCallback? onTap;
  final bool selected;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final letter = String.fromCharCode('A'.codeUnitAt(0) + index);
    final borderColor = selected
        ? AppColors.accentOrange
        : const Color(0x141A1A1A);
    final bgColor = selected
        ? AppColors.accentOrange.withValues(alpha: 0.10)
        : AppColors.cardBg;
    final tile = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: selected ? 1.6 : 1,
        ),
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
                  color: selected
                      ? AppColors.accentOrange
                      : AppColors.accentOrange.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  letter,
                  style: TextStyle(
                    color: selected ? Colors.white : AppColors.accentOrange,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  option.text,
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.4,
                    color: AppColors.textPrimary,
                    fontWeight:
                        selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (selected)
                const Padding(
                  padding: EdgeInsets.only(left: 6),
                  child: Icon(
                    Icons.check_circle,
                    size: 18,
                    color: AppColors.accentOrange,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),
          _DeltasRow(option: option),
        ],
      ),
    );

    final wrapped = AnimatedOpacity(
      duration: const Duration(milliseconds: 180),
      opacity: dimmed ? 0.45 : 1.0,
      child: tile,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: wrapped,
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
