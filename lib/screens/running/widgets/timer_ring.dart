import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Animated countdown timer ring with progress arc.
///
/// Displays the remaining time in the center and animates the
/// arc as it counts down, with a pulsing glow border.
class TimerRing extends StatefulWidget {
  const TimerRing({
    super.key,
    required this.progress,
    required this.timeText,
    this.size = 300,
    this.strokeWidth = 4,
    this.phaseLabel = 'Time Remaining',
    this.isPulsing = true,
  });

  /// 0.0 (start) to 1.0 (complete).
  final double progress;

  /// Formatted countdown text, e.g. "02:45".
  final String timeText;

  final double size;
  final double strokeWidth;
  final String phaseLabel;
  final bool isPulsing;

  @override
  State<TimerRing> createState() => _TimerRingState();
}

class _TimerRingState extends State<TimerRing>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _pulseAnimation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    if (widget.isPulsing) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(TimerRing oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPulsing && !_pulseController.isAnimating) {
      _pulseController.repeat(reverse: true);
    } else if (!widget.isPulsing && _pulseController.isAnimating) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: widget.isPulsing
                ? [
                    BoxShadow(
                      color: AppColors.primaryContainer.withValues(
                        alpha: 0.4 * (1 - _pulseAnimation.value / 20),
                      ),
                      blurRadius: _pulseAnimation.value,
                      spreadRadius: _pulseAnimation.value / 4,
                    ),
                  ]
                : null,
          ),
          child: child,
        );
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Arc painter.
          CustomPaint(
            size: Size(widget.size, widget.size),
            painter: _TimerRingPainter(
              progress: widget.progress,
              strokeWidth: widget.strokeWidth,
              progressColor: AppColors.primaryContainer,
              trackColor: Colors.white.withValues(alpha: 0.05),
            ),
          ),

          // Glass background circle.
          Container(
            width: widget.size - widget.strokeWidth * 4,
            height: widget.size - widget.strokeWidth * 4,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.glassBackground,
              border: Border.all(
                color: AppColors.primaryContainer.withValues(alpha: 0.3),
              ),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.glassShadow,
                  blurRadius: 20,
                  offset: Offset(0, 4),
                ),
              ],
            ),
          ),

          // Center text.
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.timeText,
                style: theme.textTheme.displayLarge?.copyWith(
                  fontSize: 64,
                  color: AppColors.primary,
                  letterSpacing: -2,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.phaseLabel,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TimerRingPainter extends CustomPainter {
  _TimerRingPainter({
    required this.progress,
    required this.strokeWidth,
    required this.progressColor,
    required this.trackColor,
  });

  final double progress;
  final double strokeWidth;
  final Color progressColor;
  final Color trackColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Outer track.
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = trackColor
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke,
    );

    // Progress arc.
    final rect = Rect.fromCircle(center: center, radius: radius);
    canvas.drawArc(
      rect,
      -pi / 2,
      2 * pi * progress,
      false,
      Paint()
        ..color = progressColor
        ..strokeWidth = strokeWidth
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _TimerRingPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
