import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/colors.dart';

/// Tiny inline price line, no axis, no labels — for dense lists.
class Sparkline extends StatelessWidget {
  const Sparkline({
    super.key,
    required this.values,
    this.width = 80,
    this.height = 28,
  });

  final List<double> values;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (values.length < 2) {
      return SizedBox(
        width: width,
        height: height,
        child: Center(
          child: Text(
            '—',
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      );
    }
    final color = values.last >= values.first
        ? AppColors.positive
        : AppColors.negative;
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _SparklinePainter(values, color),
      ),
    );
  }
}

class _SparklinePainter extends CustomPainter {
  _SparklinePainter(this.values, this.color);

  final List<double> values;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;
    final fill = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;

    final minV = values.reduce(math.min);
    final maxV = values.reduce(math.max);
    final range = (maxV - minV).abs() < 1e-6 ? 1.0 : maxV - minV;
    final dx = size.width / (values.length - 1);

    final line = Path();
    final area = Path()..moveTo(0, size.height);
    for (var i = 0; i < values.length; i++) {
      final x = i * dx;
      final y = size.height -
          ((values[i] - minV) / range) * (size.height - 2) -
          1;
      if (i == 0) {
        line.moveTo(x, y);
        area.lineTo(x, y);
      } else {
        line.lineTo(x, y);
        area.lineTo(x, y);
      }
    }
    area.lineTo(size.width, size.height);
    area.close();
    canvas.drawPath(area, fill);
    canvas.drawPath(line, stroke);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter old) =>
      old.values != values || old.color != color;
}

/// Bigger chart with axis ticks and price labels — for the trade sheet.
class StockChart extends StatelessWidget {
  const StockChart({
    super.key,
    required this.values,
    this.height = 140,
    this.avgCost,
  });

  final List<double> values;
  final double height;

  /// Optional horizontal line (dashed) for cost basis. Drawn in orange.
  final double? avgCost;

  @override
  Widget build(BuildContext context) {
    if (values.length < 2) {
      return Container(
        height: height,
        decoration: BoxDecoration(
          color: const Color(0xFFF3EEDF),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          'Pas encore d\'historique',
          style: GoogleFonts.inter(
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      );
    }

    final color = values.last >= values.first
        ? AppColors.positive
        : AppColors.negative;

    final minV = values.reduce(math.min);
    final maxV = values.reduce(math.max);

    return SizedBox(
      height: height,
      child: Row(
        children: [
          SizedBox(
            width: 44,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${maxV.toStringAsFixed(0)} €',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  '${minV.toStringAsFixed(0)} €',
                  style: GoogleFonts.inter(
                    fontSize: 10.5,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                color: const Color(0xFFFCF8EF),
                child: CustomPaint(
                  painter: _StockChartPainter(
                    values: values,
                    color: color,
                    avgCost: avgCost,
                  ),
                  size: Size.infinite,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StockChartPainter extends CustomPainter {
  _StockChartPainter({
    required this.values,
    required this.color,
    this.avgCost,
  });

  final List<double> values;
  final Color color;
  final double? avgCost;

  @override
  void paint(Canvas canvas, Size size) {
    final stroke = Paint()
      ..color = color
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    final fill = Paint()
      ..color = color.withValues(alpha: 0.12)
      ..style = PaintingStyle.fill;
    final grid = Paint()
      ..color = const Color(0x141A1A1A)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    final minV = values.reduce(math.min);
    final maxV = values.reduce(math.max);
    final allMin = avgCost != null ? math.min(minV, avgCost!) : minV;
    final allMax = avgCost != null ? math.max(maxV, avgCost!) : maxV;
    final range = (allMax - allMin).abs() < 1e-6 ? 1.0 : allMax - allMin;

    // 3 horizontal grid lines (top, middle, bottom).
    for (var i = 0; i <= 2; i++) {
      final y = i * size.height / 2;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final dx = size.width / (values.length - 1);
    final line = Path();
    final area = Path()..moveTo(0, size.height);
    for (var i = 0; i < values.length; i++) {
      final x = i * dx;
      final y = size.height -
          ((values[i] - allMin) / range) * (size.height - 8) -
          4;
      if (i == 0) {
        line.moveTo(x, y);
        area.lineTo(x, y);
      } else {
        line.lineTo(x, y);
        area.lineTo(x, y);
      }
    }
    area.lineTo(size.width, size.height);
    area.close();
    canvas.drawPath(area, fill);
    canvas.drawPath(line, stroke);

    // Avg cost dashed line.
    if (avgCost != null) {
      final y = size.height -
          ((avgCost! - allMin) / range) * (size.height - 8) -
          4;
      final dashPaint = Paint()
        ..color = AppColors.accentOrange
        ..strokeWidth = 1.0;
      var x = 0.0;
      while (x < size.width) {
        canvas.drawLine(
          Offset(x, y),
          Offset(math.min(x + 6, size.width), y),
          dashPaint,
        );
        x += 12;
      }
      // small label "avg" at the right of the line
      final tp = TextPainter(
        text: TextSpan(
          text: '  ${avgCost!.toStringAsFixed(0)} € (PRU)',
          style: TextStyle(
            color: AppColors.accentOrange,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      tp.paint(canvas, Offset(0, y - tp.height - 1));
    }

    // Last point dot.
    final lastX = (values.length - 1) * dx;
    final lastY = size.height -
        ((values.last - allMin) / range) * (size.height - 8) -
        4;
    canvas.drawCircle(Offset(lastX, lastY), 3, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _StockChartPainter old) =>
      old.values != values || old.avgCost != avgCost || old.color != color;
}
