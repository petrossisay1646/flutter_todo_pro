import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Handles local notifications (sound + alert) for Pomodoro timer events.
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  /// Must be called once at application startup (before any notification is shown).
  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(initSettings);

    // Create the notification channel with sound enabled (required for Android 8+)
    const androidChannel = AndroidNotificationChannel(
      'petroflow_pomodoro_channel',
      'PetroFlow Pomodoro',
      description: 'Audible alerts when a Pomodoro focus or break session ends.',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);

    _initialized = true;
  }

  /// Request Android POST_NOTIFICATIONS permission (Android 13+ / API 33+).
  Future<void> requestPermission() async {
    await _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  /// Show a Pomodoro completion notification with system sound and vibration.
  Future<void> showPomodoroComplete({
    required String title,
    required String body,
  }) async {
    
    // Play immediate audible alert and vibration
    try {
      await SystemSound.play(SystemSoundType.alert);
      await HapticFeedback.heavyImpact();
    } catch (_) {}

    if (!_initialized) await initialize();

    const androidDetails = AndroidNotificationDetails(
      'petroflow_pomodoro_channel',
      'PetroFlow Pomodoro',
      channelDescription: 'Audible alerts when a Pomodoro focus or break session ends.',
      importance: Importance.high,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      ticker: 'PetroFlow',
    );

    const details = NotificationDetails(android: androidDetails);

    await _plugin.show(
      42, // stable notification ID for pomodoro
      title,
      body,
      details,
    );
  }
}
