import 'package:hive/hive.dart';

part 'daily_history.g.dart';

/// Aggregated daily summary shown on the History screen.
@HiveType(typeId: 2)
class DailyHistory extends HiveObject {
  DailyHistory({
    required this.date,
    required this.dayScore,
    required this.totalRunningMinutes,
    required this.currentStreak,
    this.isPersonalBest = false,
    this.sessionIds = const [],
    this.avgHeartRate,
    this.paceMinPerKm,
    this.elevationMeters,
  });

  @HiveField(0)
  final DateTime date;

  /// Score out of 10 for the day.
  @HiveField(1)
  final int dayScore;

  /// Total running time across all sessions (in minutes).
  @HiveField(2)
  final int totalRunningMinutes;

  /// Number of consecutive active days.
  @HiveField(3)
  final int currentStreak;

  /// Whether the current streak is a personal best.
  @HiveField(4)
  final bool isPersonalBest;

  /// IDs of [WorkoutSession] entries for this day.
  @HiveField(5)
  final List<String> sessionIds;

  /// Average heart rate across sessions (optional).
  @HiveField(6)
  final int? avgHeartRate;

  /// Representative pace (optional).
  @HiveField(7)
  final String? paceMinPerKm;

  /// Total elevation gain (optional).
  @HiveField(8)
  final int? elevationMeters;

  /// Returns a human-readable performance label.
  String get performanceLabel {
    if (dayScore >= 9) return 'Outstanding';
    if (dayScore >= 7) return 'Excellent Performance';
    if (dayScore >= 5) return 'Good Effort';
    if (dayScore >= 3) return 'Keep Going';
    return 'Rest Day';
  }
}
