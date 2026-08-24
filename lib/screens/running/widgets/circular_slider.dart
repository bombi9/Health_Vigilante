import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

/// Interactive circular slider for setting time durations.
///
/// Renders a circular arc with a draggable thumb. The user drags
/// around the circle to set the value in seconds.
class CircularSlider extends StatefulWidget {
  const CircularSlider({
    super.key,
    required this.value,
    required this.maxValue,
    required this.onChanged,
    this.size = 240,
    this.strokeWidth = 12,
    this.progressColor = AppColors.primary,
    this.trackColor,
    this.label = 'MIN : SEC',
  });

  /// Current value in seconds.
  final int value;

  /// Maximum value in seconds (defines full circle).
  final int maxValue;

  /// Called when the user drags the thumb.
  final ValueChanged<int> onChanged;

  final double size;
  final double strokeWidth;
  final Color progressColor;
  final Color? trackColor;
  final String label;

  @override
  State<CircularSlider> createState() => _CircularSliderState();
}

class _CircularSliderState extends State<CircularSlider> {
  void _handlePanUpdate(DragUpdateDetails details, BoxConstraints constraints) {
    final center = Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
    final position = details.localPosition;
    final angle = atan2(position.dy - center.dy, position.dx - center.dx);

    // Convert angle to a 0–1 progress value (starting from top).
    var normalised = (angle + pi / 2) / (2 * pi);
    if (normalised < 0) normalised += 1;

    final newValue = (normalised * widget.maxValue).round();
    widget.onChanged(newValue.clamp(0, widget.maxValue));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = widget.value / widget.maxValue;
    final minutes = widget.value ~/ 60;
    final seconds = widget.value % 60;
    final formatted =
        '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return GestureDetector(
            onPanUpdate: (details) =>
                _handlePanUpdate(details, constraints),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Custom painted arcs.
                CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _CircularSliderPainter(
                    progress: progress,
                    strokeWidth: widget.strokeWidth,
                    progressColor: widget.progressColor,
                    trackColor: widget.trackColor ??
                        Colors.white.withValues(alpha: 0.1),
                  ),
                ),

                // Thumb indicator.
                _buildThumb(progress),

                // Center text display.
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      formatted,
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontSize: 48,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.label,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: widget.progressColor,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildThumb(double progress) {
    final angle = progress * 2 * pi - pi / 2;
    final radius = (widget.size - widget.strokeWidth) / 2;
    final center = widget.size / 2;
    final thumbX = center + radius * cos(angle);
    final thumbY = center + radius * sin(angle);

    return Positioned(
      left: thumbX - 12,
      top: thumbY - 12,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.progressColor.withValues(alpha: 0.5),
              blurRadius: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class _CircularSliderPainter extends CustomPainter {
  _CircularSliderPainter({
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
    final rect = Rect.fromCircle(center: center, radius: radius);

    // Track.
    final trackPaint = Paint()
      ..color = trackColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    // Progress arc.
    final progressPaint = Paint()
      ..color = progressColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -pi / 2, // start from top
      2 * pi * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CircularSliderPainter oldDelegate) =>
      oldDelegate.progress != progress;
}
