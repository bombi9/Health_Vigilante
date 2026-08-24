import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../models/habit.dart';
import '../../../widgets/glass_panel.dart';

/// A single habit tile with glassmorphism styling and animated completion.
///
/// Matches the prototype's completed/pending states with the active
/// glow border for completed items and the subtle hover for pending ones.
class HabitTile extends StatelessWidget {
  const HabitTile({
    super.key,
    required this.habit,
    required this.onToggle,
    required this.onDelete,
  });

  final Habit habit;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Dismissible(
      key: ValueKey(habit.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDelete(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: AppColors.errorContainer.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: AppColors.error),
      ),
      child: GestureDetector(
        onTap: onToggle,
        child: GlassPanel(
          borderRadius: 16,
          padding: const EdgeInsets.all(16),
          isActive: habit.isCompleted,
          child: Stack(
            children: [
              Row(
                children: [
                  // Check circle.
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: habit.isCompleted
                          ? AppColors.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: habit.isCompleted
                            ? AppColors.primary
                            : AppColors.outlineVariant,
                        width: 2,
                      ),
                      boxShadow: habit.isCompleted
                          ? [
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.4),
                                blurRadius: 15,
                              ),
                            ]
                          : null,
                    ),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 200),
                      opacity: habit.isCompleted ? 1.0 : 0.0,
                      child: const Icon(
                        Icons.check,
                        color: AppColors.onPrimary,
                        size: 24,
                      ),
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Title and schedule.
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          habit.title,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: habit.isCompleted
                                ? AppColors.primary
                                : AppColors.onSurface,
                            letterSpacing: 0.3,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              habit.recurrence.contains('only')
                                  ? Icons.event
                                  : Icons.schedule,
                              size: 14,
                              color: habit.isCompleted
                                  ? AppColors.primary
                                  : AppColors.onSurfaceVariant,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${habit.scheduledTime} • ${habit.recurrence}',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: habit.isCompleted
                                    ? AppColors.primary
                                    : AppColors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Active indicator bar on the right edge.
              if (habit.isCompleted)
                Positioned(
                  top: 0,
                  bottom: 0,
                  right: -16, // extends to the panel edge
                  child: Container(
                    width: 3,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(2),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.8),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
