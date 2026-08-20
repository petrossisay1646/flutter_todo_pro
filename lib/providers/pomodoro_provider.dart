import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/notification_service.dart';
import '../core/storage/storage_service.dart';
import 'storage_provider.dart';

enum PomodoroMode { work, shortBreak, longBreak }

class PomodoroState {
  final PomodoroMode mode;
  final int timeLeftSeconds;
  final bool isRunning;
  final String? linkedTaskId;
  final int completedSessions;
  final bool soundEnabled;

  const PomodoroState({
    this.mode = PomodoroMode.work,
    this.timeLeftSeconds = 25 * 60,
    this.isRunning = false,
    this.linkedTaskId,
    this.completedSessions = 0,
    this.soundEnabled = true,
  });

  PomodoroState copyWith({
    PomodoroMode? mode,
    int? timeLeftSeconds,
    bool? isRunning,
    String? linkedTaskId,
    int? completedSessions,
    bool? soundEnabled,
  }) {
    return PomodoroState(
      mode: mode ?? this.mode,
      timeLeftSeconds: timeLeftSeconds ?? this.timeLeftSeconds,
      isRunning: isRunning ?? this.isRunning,
      linkedTaskId: linkedTaskId ?? this.linkedTaskId,
      completedSessions: completedSessions ?? this.completedSessions,
      soundEnabled: soundEnabled ?? this.soundEnabled,
    );
  }

  int get totalDurationSeconds {
    switch (mode) {
      case PomodoroMode.work:
        return 25 * 60;
      case PomodoroMode.shortBreak:
        return 5 * 60;
      case PomodoroMode.longBreak:
        return 15 * 60;
    }
  }

  double get progress => (totalDurationSeconds - timeLeftSeconds) / totalDurationSeconds;

  String get formattedTime {
    final mins = timeLeftSeconds ~/ 60;
    final secs = timeLeftSeconds % 60;
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }
}

class PomodoroNotifier extends StateNotifier<PomodoroState> {
  final StorageService _storage;
  final NotificationService _notifications;
  Timer? _timer;

  PomodoroNotifier(this._storage, this._notifications)
      : super(PomodoroState(
          completedSessions: _storage.getPomodorosToday(),
        ));

  void setMode(PomodoroMode mode, {int workMinutes = 25}) {
    _timer?.cancel();
    int duration;
    switch (mode) {
      case PomodoroMode.work:
        duration = workMinutes * 60;
        break;
      case PomodoroMode.shortBreak:
        duration = 5 * 60;
        break;
      case PomodoroMode.longBreak:
        duration = 15 * 60;
        break;
    }
    state = state.copyWith(
      mode: mode,
      timeLeftSeconds: duration,
      isRunning: false,
    );
  }

  void toggleTimer({int workMinutes = 25}) {
    if (state.isRunning) {
      pauseTimer();
    } else {
      startTimer(workMinutes: workMinutes);
    }
  }

  void startTimer({int workMinutes = 25}) {
    _timer?.cancel();
    state = state.copyWith(isRunning: true);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeLeftSeconds <= 1) {
        timer.cancel();
        _onTimerComplete(workMinutes);
      } else {
        state = state.copyWith(timeLeftSeconds: state.timeLeftSeconds - 1);
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
    state = state.copyWith(isRunning: false);
  }

  void resetTimer({int workMinutes = 25}) {
    _timer?.cancel();
    setMode(state.mode, workMinutes: workMinutes);
  }

  Future<void> _onTimerComplete(int workMinutes) async {
    if (state.mode == PomodoroMode.work) {
      final newCount = state.completedSessions + 1;
      _storage.setPomodorosToday(newCount);
      final nextMode =
          newCount % 4 == 0 ? PomodoroMode.longBreak : PomodoroMode.shortBreak;

      // Fire notification: focus session done
      if (state.soundEnabled) {
        await _notifications.showPomodoroComplete(
          title: '🍅 Focus session complete!',
          body: newCount % 4 == 0
              ? 'Great work! Time for a long break. You deserve it.'
              : 'Nice! Take a 5-minute break, then keep going.',
        );
      }

      state = state.copyWith(
        completedSessions: newCount,
        isRunning: false,
      );
      setMode(nextMode, workMinutes: workMinutes);
    } else {
      // Fire notification: break done
      if (state.soundEnabled) {
        final isLong = state.mode == PomodoroMode.longBreak;
        await _notifications.showPomodoroComplete(
          title: isLong ? '🌿 Long break over!' : '☕ Break time is up!',
          body: 'Time to focus. Start your next Pomodoro session.',
        );
      }

      setMode(PomodoroMode.work, workMinutes: workMinutes);
    }
  }

  void linkTask(String? taskId) {
    state = state.copyWith(linkedTaskId: taskId);
  }

  void toggleSound() {
    state = state.copyWith(soundEnabled: !state.soundEnabled);
  }

  void resetSessions() {
    _storage.setPomodorosToday(0);
    state = state.copyWith(completedSessions: 0);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

final _notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

final pomodoroProvider =
    StateNotifierProvider<PomodoroNotifier, PomodoroState>((ref) {
  final storage = ref.watch(storageServiceProvider);
  final notifications = ref.watch(_notificationServiceProvider);
  return PomodoroNotifier(storage, notifications);
});
