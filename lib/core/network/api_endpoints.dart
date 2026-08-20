class ApiEndpoints {
  // Health
  static const String health = '/health';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String me = '/auth/me';
  static const String profile = '/auth/profile';
  static const String changePassword = '/auth/change-password';

  // Todos & Stats
  static const String todos = '/todos';
  static const String statsSummary = '/todos/stats/summary';
  static const String bulkDelete = '/todos/bulk-delete';
  static const String bulkUpdate = '/todos/bulk-update';
  static const String exportTasks = '/todos/export';
  static const String importTasks = '/todos/import';

  static String todoById(String id) => '/todos/$id';
  static String toggleTodo(String id) => '/todos/$id/toggle';
  static String updateSubtasks(String id) => '/todos/$id/subtasks';
}
