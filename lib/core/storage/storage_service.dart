import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String keyToken = 'todo_token';
  static const String keyUser = 'todo_user_json';
  static const String keyTheme = 'todo_theme_mode';
  static const String keyCustomBaseUrl = 'todo_custom_api_url';
  static const String keyPomodorosToday = 'todo_pomodoros_today';
  static const String keyCachedTodos = 'todo_cached_tasks_json';
  static const String keyCachedStats = 'todo_cached_stats_json';

  final SharedPreferences _prefs;

  StorageService(this._prefs);

  static Future<StorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return StorageService(prefs);
  }

  // Token Management
  Future<bool> setToken(String token) => _prefs.setString(keyToken, token);
  String? getToken() => _prefs.getString(keyToken);
  Future<bool> clearToken() => _prefs.remove(keyToken);

  // User Profile
  Future<bool> setUserJson(String jsonStr) => _prefs.setString(keyUser, jsonStr);
  String? getUserJson() => _prefs.getString(keyUser);
  Future<bool> clearUser() => _prefs.remove(keyUser);

  // Theme (light / dark / system)
  Future<bool> setThemeMode(String mode) => _prefs.setString(keyTheme, mode);
  String getThemeMode() => _prefs.getString(keyTheme) ?? 'system';

  // Custom API URL (allows switching between Render cloud & Localhost emulator)
  Future<bool> setCustomApiUrl(String url) => _prefs.setString(keyCustomBaseUrl, url);
  String? getCustomApiUrl() => _prefs.getString(keyCustomBaseUrl);

  // Focus / Pomodoro Count
  Future<bool> setPomodorosToday(int count) => _prefs.setInt(keyPomodorosToday, count);
  int getPomodorosToday() => _prefs.getInt(keyPomodorosToday) ?? 0;

  // Offline Cached Tasks
  Future<bool> setCachedTodos(String json) => _prefs.setString(keyCachedTodos, json);
  String? getCachedTodos() => _prefs.getString(keyCachedTodos);

  // Offline Cached Stats
  Future<bool> setCachedStats(String json) => _prefs.setString(keyCachedStats, json);
  String? getCachedStats() => _prefs.getString(keyCachedStats);

  // Clear Session
  Future<void> clearSession() async {
    await clearToken();
    await clearUser();
  }
}
