import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/workout_provider.dart';
import '../../widgets/ambient_glow.dart';
import '../../widgets/glass_panel.dart';
import 'widgets/circular_slider.dart';

/// 3-step workout configuration wizard.
///
/// Step 1: Set running duration (circular slider).
/// Step 2: Set walking pauses (circular slider).
/// Step 3: Set number of reps (stepper) + total time summary.
class ConfigureWorkoutScreen extends StatelessWidget {
  const ConfigureWorkoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<WorkoutProvider>(
      builder: (context, provider, _) {
        return Stack(
          children: [
            const AmbientGlow(
              size: 600,
              opacity: 0.04,
              offset: Offset(0, -100),
            ),
            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                child: Column(
                  children: [
                    // Step indicator badge.
                    _StepBadge(step: provider.configStep),
                    const SizedBox(height: 12),

                    // Title.
                    Text(
                      'Configure Workout',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                              ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Set your intervals for the upcoming session.',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 32),

                    // Phase content.
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      transitionBuilder: (child, animation) {
                        return FadeTransition(
                          opacity: animation,
                          child: SlideTransition(
                            position: Tween<Offset>(
                              begin: const Offset(0.1, 0),
                              end: Offset.zero,
                            ).animate(animation),
                            child: child,
                          ),
                        );
                      },
                      child: _buildPhaseContent(context, provider),
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

  Widget _buildPhaseContent(
    BuildContext context,
    WorkoutProvider provider,
  ) {
    switch (provider.configStep) {
      case 0:
        return _RunningDurationPhase(key: const ValueKey(0));
      case 1:
        return _WalkingPausePhase(key: const ValueKey(1));
      case 2:
        return _FinalizePhase(key: const ValueKey(2));
      default:
        return const SizedBox.shrink();
    }
  }
}

// ── Step Indicator Badge ─────────────────────────────────────────────────

class _StepBadge extends StatelessWidget {
  const _StepBadge({required this.step});
  final int step;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(9999),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
      ),
      child: Text(
        'STEP ${step + 1} OF 3',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: AppColors.primary,
              letterSpacing: 1,
            ),
      ),
    );
  }
}

// ── Phase 1: Running Duration ────────────────────────────────────────────

class _RunningDurationPhase extends StatelessWidget {
  const _RunningDurationPhase({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();

    return Column(
      children: [
        GlassPanel(
          child: Column(
            children: [
              const Icon(Icons.timer, color: AppColors.primary, size: 36),
              const SizedBox(height: 8),
              Text(
                'Running Duration',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Drag to set work interval',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              CircularSlider(
                value: provider.runDuration,
                maxValue: 1800, // 30 minutes
                onChanged: provider.setRunDuration,
                progressColor: AppColors.primary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: provider.nextConfigStep,
            style: OutlinedButton.styleFrom(
              backgroundColor: AppColors.surfaceContainerHigh,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Next Step'),
          ),
        ),
      ],
    );
  }
}

// ── Phase 2: Walking Pauses ──────────────────────────────────────────────

class _WalkingPausePhase extends StatelessWidget {
  const _WalkingPausePhase({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();

    return Column(
      children: [
        GlassPanel(
          child: Column(
            children: [
              const Icon(
                Icons.directions_walk,
                color: AppColors.secondary,
                size: 36,
              ),
              const SizedBox(height: 8),
              Text(
                'Walking Pauses',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                'Drag to set rest interval',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              CircularSlider(
                value: provider.walkDuration,
                maxValue: 600, // 10 minutes
                onChanged: provider.setWalkDuration,
                progressColor: AppColors.secondary,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: provider.prevConfigStep,
                child: const Text('Back'),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: OutlinedButton(
                onPressed: provider.nextConfigStep,
                style: OutlinedButton.styleFrom(
                  backgroundColor: AppColors.surfaceContainerHigh,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Next Step'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

// ── Phase 3: Finalize ────────────────────────────────────────────────────

class _FinalizePhase extends StatelessWidget {
  const _FinalizePhase({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<WorkoutProvider>();
    final theme = Theme.of(context);

    return Column(
      children: [
        GlassPanel(
          child: Column(
            children: [
              const Icon(Icons.repeat, color: AppColors.tertiary, size: 36),
              const SizedBox(height: 8),
              Text('Number of Reps', style: theme.textTheme.titleMedium),
              const SizedBox(height: 24),

              // Reps stepper.
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _RoundButton(
                    icon: Icons.remove,
                    onPressed: provider.decrementReps,
                  ),
                  const SizedBox(width: 24),
                  SizedBox(
                    width: 96,
                    child: Column(
                      children: [
                        Text(
                          '${provider.reps}',
                          style: theme.textTheme.displayLarge,
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          'SETS',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: AppColors.tertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 24),
                  _RoundButton(
                    icon: Icons.add,
                    onPressed: provider.incrementReps,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Total time summary.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(top: 24),
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: AppColors.glassBorder,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Text(
                      'Total Session Time',
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Estimated: ${provider.estimatedTotalFormatted}',
                      style: theme.textTheme.headlineLarge?.copyWith(
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            // Back button.
            SizedBox(
              width: 64,
              child: OutlinedButton(
                onPressed: provider.prevConfigStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Icon(Icons.arrow_back),
              ),
            ),
            const SizedBox(width: 16),

            // Start session button.
            Expanded(
              child: ElevatedButton.icon(
                onPressed: provider.startSession,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Start Session'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryContainer,
                  foregroundColor: AppColors.onPrimaryContainer,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 8,
                  shadowColor:
                      AppColors.primaryContainer.withValues(alpha: 0.3),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({required this.icon, required this.onPressed});
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.05),
          border: Border.all(color: AppColors.glassBorder),
        ),
        child: Icon(icon, color: AppColors.onSurface),
      ),
    );
  }
}
