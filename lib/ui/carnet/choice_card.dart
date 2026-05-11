import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';
import '../../models/choice.dart';

typedef ChoicePicked = void Function(int index, ChoiceOption option);

class ChoiceCard extends StatefulWidget {
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
  State<ChoiceCard> createState() => _ChoiceCardState();
}

class _ChoiceCardState extends State<ChoiceCard>
    with SingleTickerProviderStateMixin {
  AnimationController? _timerCtrl;
  Timer? _hapticTimer;
  bool _expiredPicked = false;

  bool get _hasTimer =>
      widget.choice.timeLimitSeconds != null &&
      !widget.disabled &&
      widget.selectedIndex == null;

  @override
  void initState() {
    super.initState();
    if (_hasTimer) _startTimer();
  }

  @override
  void didUpdateWidget(covariant ChoiceCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    final shouldRun = _hasTimer;
    final isRunning = _timerCtrl != null && _timerCtrl!.isAnimating;
    if (shouldRun && !isRunning && !_expiredPicked) {
      _startTimer();
    } else if (!shouldRun && isRunning) {
      _timerCtrl?.stop();
    }
  }

  void _startTimer() {
    final seconds = widget.choice.timeLimitSeconds!;
    _timerCtrl?.dispose();
    _timerCtrl = AnimationController(
      vsync: this,
      duration: Duration(seconds: seconds),
    );
    _timerCtrl!.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_expiredPicked) {
        _expiredPicked = true;
        HapticFeedback.heavyImpact();
        final fallbackIdx = widget.choice.defaultOptionIndex ??
            (widget.choice.options.length - 1);
        widget.onPicked(
          fallbackIdx,
          widget.choice.options[fallbackIdx],
        );
      }
    });
    // Tick haptique léger sur les 5 dernières secondes pour la tension.
    _hapticTimer?.cancel();
    _hapticTimer = Timer.periodic(const Duration(milliseconds: 1000), (t) {
      final c = _timerCtrl;
      if (c == null || !mounted) {
        t.cancel();
        return;
      }
      final remaining =
          (c.duration!.inSeconds * (1 - c.value)).ceil();
      if (remaining <= 5 && remaining > 0) {
        HapticFeedback.selectionClick();
      }
    });
    _timerCtrl!.forward();
  }

  @override
  void dispose() {
    _timerCtrl?.dispose();
    _hapticTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                widget.choice.prompt,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            if (_timerCtrl != null && widget.selectedIndex == null)
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: _Countdown(controller: _timerCtrl!),
              ),
          ],
        ),
        if (_timerCtrl != null && widget.selectedIndex == null) ...[
          const SizedBox(height: 8),
          _TimerBar(controller: _timerCtrl!),
        ],
        const SizedBox(height: 10),
        for (var i = 0; i < widget.choice.options.length; i++) ...[
          _OptionTile(
            index: i,
            option: widget.choice.options[i],
            selected: widget.selectedIndex == i,
            dimmed: widget.selectedIndex != null && widget.selectedIndex != i,
            onTap: widget.disabled
                ? null
                : () {
                    HapticFeedback.selectionClick();
                    _timerCtrl?.stop();
                    widget.onPicked(i, widget.choice.options[i]);
                  },
          ),
          const SizedBox(height: 8),
        ],
      ],
    );
  }
}

class _Countdown extends StatelessWidget {
  const _Countdown({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final remaining =
            (controller.duration!.inSeconds * (1 - controller.value)).ceil();
        final danger = remaining <= 5;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: (danger ? AppColors.negative : AppColors.accentOrange)
                .withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.timer_outlined,
                size: 14,
                color: danger ? AppColors.negative : AppColors.accentOrange,
              ),
              const SizedBox(width: 4),
              Text(
                '${remaining}s',
                style: GoogleFonts.inter(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: danger ? AppColors.negative : AppColors.accentOrange,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TimerBar extends StatelessWidget {
  const _TimerBar({required this.controller});
  final AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final remaining = 1 - controller.value;
        final danger = remaining < (5 / controller.duration!.inSeconds);
        return ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: remaining,
            minHeight: 4,
            backgroundColor: const Color(0x14000000),
            valueColor: AlwaysStoppedAnimation(
              danger ? AppColors.negative : AppColors.accentOrange,
            ),
          ),
        );
      },
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
      spacing: 6,
      runSpacing: 6,
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
    final isZero = value == 0;
    final positive = value > 0;
    final fg = isZero
        ? AppColors.textSecondary
        : (positive ? AppColors.positive : AppColors.negative);
    final bg = isZero
        ? const Color(0xFFEFE9D8)
        : (positive
            ? AppColors.positive.withValues(alpha: 0.10)
            : AppColors.negative.withValues(alpha: 0.10));
    final sign = positive ? '+' : '';
    final text = isZero ? '$emoji 0$suffix' : '$emoji $sign$value$suffix';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: fg,
        ),
      ),
    );
  }
}
