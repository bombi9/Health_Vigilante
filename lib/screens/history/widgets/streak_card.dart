import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../widgets/glass_panel.dart';

/// Streak counter card with trend indicator.
class StreakCard extends StatelessWidget {
  const StreakCard({
    super.key,
    required this.streak,
    required this.isPersonalBest,
  });

  final int streak;
  final bool isPersonalBest;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GlassPanel(
      borderRadius: 16,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.local_fire_department,
                color: AppColors.onSurfaceVariant,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'CURRENT STREAK',
                style: theme.textTheme.labelMedium,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$streak',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: AppColors.tertiary,
                  shadows: [
                    Shadow(
                      color: AppColors.tertiary.withValues(alpha: 0.4),
                      blurRadius: 20,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 4),
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text(
                  'days',
                  style: theme.textTheme.bodySmall,
                ),
              ),
            ],
          ),
          if (isPersonalBest) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.trending_up,
                  color: AppColors.primary,
                  size: 14,
                ),
                const SizedBox(width: 4),
                Text(
                  'Personal Best',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
