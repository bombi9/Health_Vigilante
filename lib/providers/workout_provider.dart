import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

import '../core/di/service_locator.dart';
import '../core/storage/secure_storage_service.dart';
import '../models/workout_session.dart';

/// Represents the current phase of the workout flow.
enum WorkoutPhase { configure, running, walking, completed }

/// State management for the Running screens (config + active run).
class WorkoutProvider extends ChangeNotifier {
  final SecureStorageService _storage = sl<SecureStorageService>();
  final Uuid _uuid = const Uuid();

  // ── Configuration State ──────────────────────────────────────────────

  /// Current configuration wizard step (0-indexed).
  int _configStep = 0;
  int get configStep => _configStep;

  /// Running interval duration in seconds. Default: 5 minutes.
  int _runDuration = 300;
  int get runDuration => _runDuration;

  /// Walking interval duration in seconds. Default: 1:30.
  int _walkDuration = 90;
  int get walkDuration => _walkDuration;

  /// Number of run/walk repetitions. Default: 4.
  int _reps = 4;
  int get reps => _reps;

  /// Estimated total session time in seconds.
  int get estimatedTotalSeconds => (_runDuration + _walkDuration) * _reps;

  /// Formatted estimated total time as `MM:SS`.
  String get estimatedTotalFormatted {
    final m = estimatedTotalSeconds ~/ 60;
    final s = estimatedTotalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  // ── Active Run State ─────────────────────────────────────────────────

  WorkoutPhase _phase = WorkoutPhase.configure;
  WorkoutPhase get phase => _phase;

  /// Current rep (1-indexed) during the active run.
  int _currentRep = 0;
  int get currentRep => _currentRep;

  /// Seconds remaining in the current interval.
  int _secondsRemaining = 0;
  int get secondsRemaining => _secondsRemaining;

  /// Total seconds in the current interval (for progress calculation).
  int _intervalTotalSeconds = 0;
  int get intervalTotalSeconds => _intervalTotalSeconds;

  /// Progress of the current interval (0.0 to 1.0).
  double get intervalProgress => _intervalTotalSeconds > 0
      ? 1.0 - (_secondsRemaining / _intervalTotalSeconds)
      : 0.0;

  bool _isPaused = false;
  bool get isPaused => _isPaused;

  bool _isRunning = false;
  bool get isRunning => _isRunning;

  Timer? _timer;

  /// Total elapsed seconds for the entire session.
  int _totalElapsedSeconds = 0;

  // ── Configuration Actions ────────────────────────────────────────────

  void setConfigStep(int step) {
    _configStep = step.clamp(0, 2);
    notifyListeners();
  }

  void nextConfigStep() => setConfigStep(_configStep + 1);
  void prevConfigStep() => setConfigStep(_configStep - 1);

  void setRunDuration(int seconds) {
    _runDuration = seconds.clamp(30, 1800); // 30s to 30min
    notifyListeners();
  }

  void setWalkDuration(int seconds) {
    _walkDuration = seconds.clamp(15, 600); // 15s to 10min
    notifyListeners();
  }

  void incrementReps() {
    _reps = (_reps + 1).clamp(1, 20);
    notifyListeners();
  }

  void decrementReps() {
    _reps = (_reps - 1).clamp(1, 20);
    notifyListeners();
  }

  // ── Active Run Actions ───────────────────────────────────────────────

  /// Starts the workout session.
  void startSession() {
    _isRunning = true;
    _isPaused = false;
    _currentRep = 1;
    _totalElapsedSeconds = 0;
    _startRunningPhase();
    notifyListeners();
  }

  /// Toggles pause/resume.
  void togglePause() {
    if (_isPaused) {
      _resumeTimer();
    } else {
      _pauseTimer();
    }
    _isPaused = !_isPaused;
    notifyListeners();
  }

  /// Ends the session early and saves results.
  Future<void> endSession() async {
    _timer?.cancel();
    _timer = null;

    await _saveCompletedSession();

    _phase = WorkoutPhase.completed;
    _isRunning = false;
    notifyListeners();
  }

  /// Resets to configuration mode.
  void resetToConfig() {
    _timer?.cancel();
    _timer = null;
    _phase = WorkoutPhase.configure;
    _isRunning = false;
    _isPaused = false;
    _currentRep = 0;
    _configStep = 0;
    _totalElapsedSeconds = 0;
    notifyListeners();
  }

  // ── Timer Logic ──────────────────────────────────────────────────────

  void _startRunningPhase() {
    _phase = WorkoutPhase.running;
    _intervalTotalSeconds = _runDuration;
    _secondsRemaining = _runDuration;
    _startTimer();
  }

  void _startWalkingPhase() {
    _phase = WorkoutPhase.walking;
    _intervalTotalSeconds = _walkDuration;
    _secondsRemaining = _walkDuration;
    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_secondsRemaining > 0) {
        _secondsRemaining--;
        _totalElapsedSeconds++;
        notifyListeners();
      } else {
        _onIntervalComplete();
      }
    });
  }

  void _pauseTimer() => _timer?.cancel();

  void _resumeTimer() => _startTimer();

  void _onIntervalComplete() {
    _timer?.cancel();

    if (_phase == WorkoutPhase.running) {
      // After running → walk phase.
      _startWalkingPhase();
    } else if (_phase == WorkoutPhase.walking) {
      // After walking → next rep or finish.
      if (_currentRep < _reps) {
        _currentRep++;
        _startRunningPhase();
      } else {
        // All reps completed.
        endSession();
      }
    }
  }

  Future<void> _saveCompletedSession() async {
    final session = WorkoutSession(
      id: _uuid.v4(),
      date: DateTime.now(),
      runDurationSeconds: _runDuration,
      walkDurationSeconds: _walkDuration,
      reps: _reps,
      totalDurationSeconds: _totalElapsedSeconds,
      avgHeartRate: 142, // Placeholder — would come from wearable
      paceMinPerKm: '5:30',
      elevationMeters: 120,
    );

    await _storage.saveSession(session);
  }

  /// Formatted countdown string `MM:SS`.
  String get countdownFormatted {
    final m = _secondsRemaining ~/ 60;
    final s = _secondsRemaining % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  /// Formatted run duration string `MM:SS`.
  String get runDurationFormatted {
    final m = _runDuration ~/ 60;
    final s = _runDuration % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  /// Formatted walk duration string `MM:SS`.
  String get walkDurationFormatted {
    final m = _walkDuration ~/ 60;
    final s = _walkDuration % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
