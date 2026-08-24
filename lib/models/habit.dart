import 'package:hive/hive.dart';

part 'habit.g.dart';

/// Represents a single habit/routine entry.
///
/// Habits can be recurring (daily, weekly) or one-off events.
@HiveType(typeId: 0)
class Habit extends HiveObject {
  Habit({
    required this.id,
    required this.title,
    required this.scheduledTime,
    required this.recurrence,
    this.isCompleted = false,
    this.completedAt,
  });

  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  /// Human-readable scheduled time, e.g. "7:00 AM".
  @HiveField(2)
  final String scheduledTime;

  /// Recurrence label, e.g. "Daily", "Mon, Wed, Fri", "Jan 25th only".
  @HiveField(3)
  final String recurrence;

  @HiveField(4)
  bool isCompleted;

  @HiveField(5)
  DateTime? completedAt;

  /// Returns a copy with the given fields replaced.
  Habit copyWith({
    String? id,
    String? title,
    String? scheduledTime,
    String? recurrence,
    bool? isCompleted,
    DateTime? completedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      scheduledTime: scheduledTime ?? this.scheduledTime,
      recurrence: recurrence ?? this.recurrence,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}
