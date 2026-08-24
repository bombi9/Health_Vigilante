import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// A decorative radial gradient positioned behind content to create
/// the ambient background lighting effect from the prototype.
class AmbientGlow extends StatelessWidget {
  const AmbientGlow({
    super.key,
    this.color,
    this.size = 400,
    this.opacity = 0.05,
    this.alignment = Alignment.topCenter,
    this.offset = Offset.zero,
  });

  final Color? color;
  final double size;
  final double opacity;
  final Alignment alignment;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final glowColor = color ?? AppColors.primary;

    return Positioned.fill(
      child: IgnorePointer(
        child: Align(
          alignment: alignment,
          child: Transform.translate(
            offset: offset,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    glowColor.withValues(alpha: opacity),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
