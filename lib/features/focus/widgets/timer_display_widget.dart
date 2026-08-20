import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';

class TimerDisplayWidget extends StatelessWidget {
  final String formattedTime;
  final double progress;
  final String modeLabel;

  const TimerDisplayWidget({
    super.key,
    required this.formattedTime,
    required this.progress,
    required this.modeLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      width: 220,
      height: 220,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(220, 220),
            painter: _CircleTimerPainter(
              progress: progress,
              bgTrackColor: isDark ? AppColors.darkElevated : const Color(0xFFE2E8F0),
              progressColor: AppColors.primary,
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                formattedTime,
                style: const TextStyle(
                  fontSize: 42,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -1,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                modeLabel,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.5,
                  color: AppColors.textMutedLight,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircleTimerPainter extends CustomPainter {
  final double progress;
  final Color bgTrackColor;
  final Color progressColor;

  _CircleTimerPainter({
    required this.progress,
    required this.bgTrackColor,
    required this.progressColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 10;

    // Background track
    final bgPaint = Paint()
      ..color = bgTrackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8;
    canvas.drawCircle(center, radius, bgPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 8;

    final sweepAngle = 2 * pi * progress;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircleTimerPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
