import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/workout_provider.dart';
import '../../widgets/ambient_glow.dart';
import 'widgets/metric_card.dart';
import 'widgets/timer_ring.dart';

/// Active workout screen with live countdown timer and metrics.
class ActiveRunScreen extends StatelessWidget {
  const ActiveRunScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<WorkoutProvider>(
      builder: (context, provider, _) {
        // If session completed, show completion view.
        if (provider.phase == WorkoutPhase.completed) {
          return _CompletedView(provider: provider);
        }

        final isRunningPhase = provider.phase == WorkoutPhase.running;

        return Stack(
          children: [
            AmbientGlow(
              size: 500,
              opacity: 0.06,
              color: isRunningPhase
                  ? AppColors.primaryContainer
                  : AppColors.secondary,
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                child: Column(
                  children: [
                    // Phase indicator badge.
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: isRunningPhase
                            ? AppColors.primaryContainer
                            : AppColors.secondaryContainer,
                        borderRadius: BorderRadius.circular(9999),
                        boxShadow: [
                          BoxShadow(
                            color: (isRunningPhase
                                    ? AppColors.primary
                                    : AppColors.secondary)
                                .withValues(alpha: 0.4),
                            blurRadius: 15,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isRunningPhase
                                ? Icons.directions_run
                                : Icons.directions_walk,
                            color: isRunningPhase
                                ? AppColors.onPrimaryContainer
                                : AppColors.onSecondaryContainer,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isRunningPhase
                                ? 'Running Phase'
                                : 'Walking Phase',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: isRunningPhase
                                  ? AppColors.onPrimaryContainer
                                  : AppColors.onSecondaryContainer,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Rep counter.
                    Text(
                      'Rep ${provider.currentRep} of ${provider.reps}',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 32),

                    // Timer ring.
                    TimerRing(
                      progress: provider.intervalProgress,
                      timeText: provider.countdownFormatted,
                      isPulsing: !provider.isPaused,
                    ),
                    const SizedBox(height: 32),

                    // Action buttons.
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Pause / Resume.
                        GestureDetector(
                          onTap: provider.togglePause,
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.glassBackground,
                              border: Border.all(color: AppColors.glassBorder),
                              boxShadow: const [
                                BoxShadow(
                                  color: AppColors.glassShadow,
                                  blurRadius: 20,
                                  offset: Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Icon(
                              provider.isPaused
                                  ? Icons.play_arrow
                                  : Icons.pause,
                              color: AppColors.onSurface,
                              size: 32,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),

                        // End Run.
                        GestureDetector(
                          onTap: () => _confirmEndSession(context, provider),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 32,
                              vertical: 16,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.error,
                              borderRadius: BorderRadius.circular(9999),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.error.withValues(alpha: 0.3),
                                  blurRadius: 12,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              'End Run',
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: AppColors.onError,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Metrics grid.
                    Row(
                      children: [
                        Expanded(
                          child: MetricCard(
                            icon: Icons.speed,
                            value: '5:30',
                            label: 'MIN/KM',
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: MetricCard(
                            icon: Icons.favorite,
                            value: '142',
                            label: 'BPM',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _confirmEndSession(BuildContext context, WorkoutProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text('End Session?'),
        content: const Text(
          'Your progress will be saved. Are you sure you want to end this session?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              provider.endSession();
            },
            child: Text(
              'End Run',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Session Completed View ───────────────────────────────────────────────

class _CompletedView extends StatelessWidget {
  const _CompletedView({required this.provider});
  final WorkoutProvider provider;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryContainer,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.4),
                    blurRadius: 30,
                  ),
                ],
              ),
              child: const Icon(
                Icons.check,
                color: AppColors.onPrimaryContainer,
                size: 48,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Session Complete!',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Great work! Your session has been saved.',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: provider.resetToConfig,
                child: const Text('Back to Configuration'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
