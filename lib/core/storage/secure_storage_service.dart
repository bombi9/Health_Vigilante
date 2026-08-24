import 'dart:typed_data';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/daily_history.dart';
import '../../models/habit.dart';
import '../../models/workout_session.dart';
import 'encryption_key_manager.dart';

/// Central encrypted storage repository.
///
/// All sensitive user data (habits, workout sessions, daily history)
/// is persisted in AES-256-encrypted Hive boxes. The UI layer
/// interacts **only** through this service — never with Hive directly.
class SecureStorageService {
  SecureStorageService({EncryptionKeyManager? keyManager})
      : _keyManager = keyManager ?? EncryptionKeyManager();

  final EncryptionKeyManager _keyManager;

  static const String _habitsBoxName = 'habits_box';
  static const String _sessionsBoxName = 'sessions_box';
  static const String _historyBoxName = 'history_box';

  late final Box<Habit> _habitsBox;
  late final Box<WorkoutSession> _sessionsBox;
  late final Box<DailyHistory> _historyBox;

  bool _isInitialized = false;

  /// Initialises Hive, registers adapters, and opens encrypted boxes.
  ///
  /// Must be called once before any other method. Typically invoked
  /// from [ServiceLocator.init] during app startup.
  Future<void> init() async {
    if (_isInitialized) return;

    final appDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDir.path);

    // Register Hive type adapters.
    if (!Hive.isAdapterRegistered(HabitAdapter().typeId)) {
      Hive.registerAdapter(HabitAdapter());
    }
    if (!Hive.isAdapterRegistered(WorkoutSessionAdapter().typeId)) {
      Hive.registerAdapter(WorkoutSessionAdapter());
    }
    if (!Hive.isAdapterRegistered(DailyHistoryAdapter().typeId)) {
      Hive.registerAdapter(DailyHistoryAdapter());
    }

    // Retrieve or generate the AES-256 key.
    final Uint8List encryptionKey = await _keyManager.getOrCreateKey();
    final cipher = HiveAesCipher(encryptionKey);

    // Open encrypted boxes.
    _habitsBox = await Hive.openBox<Habit>(
      _habitsBoxName,
      encryptionCipher: cipher,
    );
    _sessionsBox = await Hive.openBox<WorkoutSession>(
      _sessionsBoxName,
      encryptionCipher: cipher,
    );
    _historyBox = await Hive.openBox<DailyHistory>(
      _historyBoxName,
      encryptionCipher: cipher,
    );

    _isInitialized = true;
  }

  // ── Habits ──────────────────────────────────────────────────────────

  /// Returns all stored habits.
  List<Habit> getHabits() => _habitsBox.values.toList();

  /// Saves or updates a habit (keyed by [Habit.id]).
  Future<void> saveHabit(Habit habit) async {
    await _habitsBox.put(habit.id, habit);
  }

  /// Deletes a habit by its [id].
  Future<void> deleteHabit(String id) async {
    await _habitsBox.delete(id);
  }

  // ── Workout Sessions ─────────────────────────────────────────────────

  /// Returns all workout sessions, newest first.
  List<WorkoutSession> getSessions() {
    final sessions = _sessionsBox.values.toList();
    sessions.sort((a, b) => b.date.compareTo(a.date));
    return sessions;
  }

  /// Saves a completed workout session.
  Future<void> saveSession(WorkoutSession session) async {
    await _sessionsBox.put(session.id, session);
  }

  /// Deletes a session by its [id].
  Future<void> deleteSession(String id) async {
    await _sessionsBox.delete(id);
  }

  // ── Daily History ────────────────────────────────────────────────────

  /// Returns the [DailyHistory] for the given [date], or `null`.
  DailyHistory? getHistory(DateTime date) {
    final key = _dateKey(date);
    return _historyBox.get(key);
  }

  /// Returns all daily history entries, newest first.
  List<DailyHistory> getAllHistory() {
    final entries = _historyBox.values.toList();
    entries.sort((a, b) => b.date.compareTo(a.date));
    return entries;
  }

  /// Saves or updates a daily history entry.
  Future<void> saveHistory(DailyHistory history) async {
    final key = _dateKey(history.date);
    await _historyBox.put(key, history);
  }

  // ── Cleanup ──────────────────────────────────────────────────────────

  /// Closes all open boxes. Call during app disposal if needed.
  Future<void> close() async {
    await _habitsBox.close();
    await _sessionsBox.close();
    await _historyBox.close();
  }

  /// Formats a [DateTime] as `yyyy-MM-dd` for use as a Hive key.
  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
