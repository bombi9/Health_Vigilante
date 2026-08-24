import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../core/di/service_locator.dart';
import '../core/storage/secure_storage_service.dart';
import '../models/habit.dart';

/// State management for the Habits screen.
///
/// Loads habits from encrypted storage on initialisation and
/// persists every mutation back to the [SecureStorageService].
class HabitsProvider extends ChangeNotifier {
  HabitsProvider() {
    _loadHabits();
  }

  final SecureStorageService _storage = sl<SecureStorageService>();
  final Uuid _uuid = const Uuid();

  List<Habit> _habits = [];

  /// Unmodifiable view of all habits.
  List<Habit> get habits => List.unmodifiable(_habits);

  /// Habits that have been completed.
  List<Habit> get completedHabits =>
      _habits.where((h) => h.isCompleted).toList();

  /// Habits still pending.
  List<Habit> get pendingHabits =>
      _habits.where((h) => !h.isCompleted).toList();

  /// Completion percentage for progress indicators.
  double get completionRate =>
      _habits.isEmpty ? 0 : completedHabits.length / _habits.length;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  // ── Actions ──────────────────────────────────────────────────────────

  Future<void> _loadHabits() async {
    _habits = _storage.getHabits();

    // Seed sample data on first launch for demonstration.
    if (_habits.isEmpty) {
      await _seedSampleHabits();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Toggles the completion state of a habit.
  Future<void> toggleHabit(String id) async {
    final index = _habits.indexWhere((h) => h.id == id);
    if (index == -1) return;

    final habit = _habits[index];
    final updated = habit.copyWith(
      isCompleted: !habit.isCompleted,
      completedAt: !habit.isCompleted ? DateTime.now() : null,
    );

    _habits[index] = updated;
    await _storage.saveHabit(updated);
    notifyListeners();
  }

  /// Adds a new habit.
  Future<void> addHabit({
    required String title,
    required String scheduledTime,
    required String recurrence,
  }) async {
    final habit = Habit(
      id: _uuid.v4(),
      title: title,
      scheduledTime: scheduledTime,
      recurrence: recurrence,
    );

    _habits.add(habit);
    await _storage.saveHabit(habit);
    notifyListeners();
  }

  /// Removes a habit.
  Future<void> deleteHabit(String id) async {
    _habits.removeWhere((h) => h.id == id);
    await _storage.deleteHabit(id);
    notifyListeners();
  }

  /// Reloads habits from storage.
  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    await _loadHabits();
  }

  // ── Seed Data ────────────────────────────────────────────────────────

  Future<void> _seedSampleHabits() async {
    final samples = [
      Habit(
        id: _uuid.v4(),
        title: 'Morning Yoga',
        scheduledTime: '7:00 AM',
        recurrence: 'Daily',
        isCompleted: true,
        completedAt: DateTime.now(),
      ),
      Habit(
        id: _uuid.v4(),
        title: 'Weight Training',
        scheduledTime: '6:00 PM',
        recurrence: 'Mon, Wed, Fri',
      ),
      Habit(
        id: _uuid.v4(),
        title: 'Prepare Presentation',
        scheduledTime: '2:00 PM',
        recurrence: 'Jan 25th only',
      ),
    ];

    for (final habit in samples) {
      await _storage.saveHabit(habit);
    }
    _habits = samples;
  }
}
