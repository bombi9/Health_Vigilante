import 'package:hive/hive.dart';

part 'workout_session.g.dart';

/// Represents a completed interval-running workout session.
@HiveType(typeId: 1)
class WorkoutSession extends HiveObject {
  WorkoutSession({
    required this.id,
    required this.date,
    required this.runDurationSeconds,
    required this.walkDurationSeconds,
    required this.reps,
    required this.totalDurationSeconds,
    this.avgHeartRate,
    this.paceMinPerKm,
    this.elevationMeters,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime date;

  /// Duration of each running interval in seconds.
  @HiveField(2)
  final int runDurationSeconds;

  /// Duration of each walking interval in seconds.
  @HiveField(3)
  final int walkDurationSeconds;

  /// Number of run/walk repetitions.
  @HiveField(4)
  final int reps;

  /// Total session duration in seconds (actual elapsed time).
  @HiveField(5)
  final int totalDurationSeconds;

  /// Average heart rate in BPM (optional — may come from wearable).
  @HiveField(6)
  final int? avgHeartRate;

  /// Running pace as a formatted string, e.g. "5:30".
  @HiveField(7)
  final String? paceMinPerKm;

  /// Elevation gain in metres (optional).
  @HiveField(8)
  final int? elevationMeters;

  /// Total duration formatted as `MM:SS`.
  String get formattedDuration {
    final minutes = totalDurationSeconds ~/ 60;
    final seconds = totalDurationSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Total running minutes (all reps combined).
  int get totalRunningMinutes => (runDurationSeconds * reps) ~/ 60;
}
