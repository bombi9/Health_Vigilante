import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/history_provider.dart';
import '../../widgets/ambient_glow.dart';
import '../../widgets/glass_panel.dart';
import 'widgets/day_score_card.dart';
import 'widgets/session_detail_card.dart';
import 'widgets/streak_card.dart';

/// History screen showing today's score, metrics, and session details.
class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<HistoryProvider>(
      builder: (context, provider, _) {
        if (provider.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final history = provider.todayHistory;

        return Stack(
          children: [
            const AmbientGlow(
              size: 500,
              opacity: 0.04,
              offset: Offset(100, -50),
            ),
            CustomScrollView(
              slivers: [
                // Header with date.
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Today',
                              style: theme.textTheme.titleMedium,
                            ),
                            Text(
                              DateFormat('MMM d, yyyy').format(DateTime.now()),
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        GlassPanel(
                          borderRadius: 9999,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          child: const Icon(
                            Icons.calendar_month,
                            color: AppColors.onSurface,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (history != null) ...[
                  // Day score card.
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: DayScoreCard(
                        score: history.dayScore,
                        label: history.performanceLabel,
                      ),
                    ),
                  ),

                  // Running time + Streak row.
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                      child: Row(
                        children: [
                          // Running time.
                          Expanded(
                            child: GlassPanel(
                              borderRadius: 16,
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.timer,
                                        color: AppColors.onSurfaceVariant,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        'RUNNING TIME',
                                        style: theme.textTheme.labelMedium,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '${history.totalRunningMinutes}',
                                        style: theme.textTheme.headlineMedium,
                                      ),
                                      const SizedBox(width: 4),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4),
                                        child: Text(
                                          'min',
                                          style: theme.textTheme.bodySmall,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: LinearProgressIndicator(
                                      value: history.totalRunningMinutes / 60,
                                      backgroundColor:
                                          AppColors.surfaceContainerHigh,
                                      valueColor:
                                          const AlwaysStoppedAnimation<Color>(
                                        AppColors.primary,
                                      ),
                                      minHeight: 6,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),

                          // Streak.
                          Expanded(
                            child: StreakCard(
                              streak: history.currentStreak,
                              isPersonalBest: history.isPersonalBest,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Session details section.
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                      child: Text(
                        'Session Details',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 120),
                    sliver: SliverGrid.count(
                      crossAxisCount: 3,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 0.9,
                      children: [
                        SessionDetailCard(
                          label: 'Avg Heart Rate',
                          value: '${history.avgHeartRate ?? '--'}',
                          unit: 'bpm',
                        ),
                        SessionDetailCard(
                          label: 'Pace',
                          value: history.paceMinPerKm ?? '--',
                          unit: '/km',
                        ),
                        SessionDetailCard(
                          label: 'Elevation',
                          value: '${history.elevationMeters ?? '--'}',
                          unit: 'm',
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  // Empty state.
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.history,
                            size: 64,
                            color: AppColors.outlineVariant,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No history yet',
                            style: theme.textTheme.titleMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Complete a workout to see your stats here.',
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}
