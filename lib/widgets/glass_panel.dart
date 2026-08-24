import 'dart:ui';

import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';

/// Reusable glassmorphism container matching the prototype's `.glass-panel`.
///
/// Applies a frosted glass effect with backdrop blur, semi-transparent
/// background, and subtle border. Use as a wrapper for card-like content.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.borderRadius = 32,
    this.padding = const EdgeInsets.all(24),
    this.isActive = false,
    this.blurSigma = 12,
  });

  final Widget child;
  final double borderRadius;
  final EdgeInsets padding;

  /// When true, uses the active/highlighted style with primary tint.
  final bool isActive;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.glassActiveBackground
                : AppColors.glassBackground,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: isActive
                  ? AppColors.glassActiveBorder
                  : AppColors.glassBorder,
            ),
            boxShadow: const [
              BoxShadow(
                color: AppColors.glassShadow,
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
