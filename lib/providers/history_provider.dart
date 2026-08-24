import 'package:flutter/foundation.dart';

import '../core/di/service_locator.dart';
import '../core/storage/secure_storage_service.dart';
import '../models/daily_history.dart';
import '../models/workout_session.dart';

/// State management for the History screen.
///
/// Loads and aggregates data from encrypted storage.
class HistoryProvider extends ChangeNotifier {
  HistoryProvider() {
    _loadData();
  }

  final SecureStorageService _storage = sl<SecureStorageService>();

  DailyHistory? _todayHistory;
  DailyHistory? get todayHistory => _todayHistory;

  List<DailyHistory> _allHistory = [];
  List<DailyHistory> get allHistory => List.unmodifiable(_allHistory);

  List<WorkoutSession> _recentSessions = [];
  List<WorkoutSession> get recentSessions => List.unmodifiable(_recentSessions);

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  Future<void> _loadData() async {
    _allHistory = _storage.getAllHistory();
    _recentSessions = _storage.getSessions();

    final now = DateTime.now();
    _todayHistory = _storage.getHistory(now);

    // If no history exists for today, create a sample for demonstration.
    if (_todayHistory == null && _allHistory.isEmpty) {
      await _seedSampleHistory();
    }

    _isLoading = false;
    notifyListeners();
  }

  /// Refreshes data from storage (call after a workout completes).
  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    await _loadData();
  }

  /// Returns the most recent session, or `null`.
  WorkoutSession? get latestSession =>
      _recentSessions.isNotEmpty ? _recentSessions.first : null;

  Future<void> _seedSampleHistory() async {
    final now = DateTime.now();
    _todayHistory = DailyHistory(
      date: now,
      dayScore: 8,
      totalRunningMinutes: 45,
      currentStreak: 12,
      isPersonalBest: true,
      avgHeartRate: 142,
      paceMinPerKm: "5'30\"",
      elevationMeters: 120,
    );
    await _storage.saveHistory(_todayHistory!);
    _allHistory = [_todayHistory!];
  }
}
