import 'dart:convert';
import '../../core/network/api_client.dart';
import '../../core/network/api_endpoints.dart';
import '../../core/storage/storage_service.dart';
import '../models/todo_model.dart';
import '../models/todo_stats_model.dart';

class TodoRepository {
  final ApiClient _api;
  final StorageService _storage;

  TodoRepository(this._api, this._storage);

  Future<List<TodoModel>> getTodos({
    String search = '',
    String status = 'all',
    String priority = 'all',
    String category = 'all',
    String tag = 'all',
    String dueFilter = 'all',
    String sortBy = 'smart',
  }) async {
    try {
      final queryParams = <String, dynamic>{};
      if (search.trim().isNotEmpty) queryParams['search'] = search.trim();
      if (status != 'all') queryParams['status'] = status;
      if (priority != 'all') queryParams['priority'] = priority;
      if (category != 'all') queryParams['category'] = category;
      if (tag != 'all') queryParams['tag'] = tag;
      if (dueFilter != 'all') queryParams['dueFilter'] = dueFilter;
      if (sortBy != 'smart') queryParams['sortBy'] = sortBy;

      final response = await _api.get(
        ApiEndpoints.todos,
        queryParameters: queryParams,
      );

      final list = (response.data as List)
          .map((item) => TodoModel.fromJson(item as Map<String, dynamic>))
          .toList();

      // Cache tasks for offline support
      if (search.isEmpty && status == 'all' && priority == 'all') {
        final encoded = jsonEncode(list.map((t) => t.toJson()).toList());
        await _storage.setCachedTodos(encoded);
      }

      return list;
    } catch (e) {
      // Fallback to cached tasks on offline
      final cached = _storage.getCachedTodos();
      if (cached != null) {
        final decoded = jsonDecode(cached) as List;
        return decoded.map((item) => TodoModel.fromJson(item as Map<String, dynamic>)).toList();
      }
      rethrow;
    }
  }

  Future<TodoStatsModel> getStats() async {
    try {
      final response = await _api.get(ApiEndpoints.statsSummary);
      final stats = TodoStatsModel.fromJson(response.data as Map<String, dynamic>);
      await _storage.setCachedStats(jsonEncode(response.data));
      return stats;
    } catch (e) {
      final cached = _storage.getCachedStats();
      if (cached != null) {
        return TodoStatsModel.fromJson(jsonDecode(cached) as Map<String, dynamic>);
      }
      rethrow;
    }
  }

  Future<TodoModel> createTodo(TodoModel todo) async {
    final response = await _api.post(
      ApiEndpoints.todos,
      data: todo.toJson(),
    );
    return TodoModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<TodoModel> updateTodo(TodoModel todo) async {
    final response = await _api.put(
      ApiEndpoints.todoById(todo.id),
      data: todo.toJson(),
    );
    return TodoModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<TodoModel> toggleTodo(String id) async {
    final response = await _api.patch(ApiEndpoints.toggleTodo(id));
    return TodoModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<TodoModel> updateSubtasks(String id, List<Map<String, dynamic>> subtasks) async {
    final response = await _api.patch(
      ApiEndpoints.updateSubtasks(id),
      data: {'subtasks': subtasks},
    );
    return TodoModel.fromJson(response.data as Map<String, dynamic>);
  }

  Future<void> deleteTodo(String id) async {
    await _api.delete(ApiEndpoints.todoById(id));
  }

  Future<int> bulkDelete(List<String> ids) async {
    final response = await _api.post(
      ApiEndpoints.bulkDelete,
      data: {'ids': ids},
    );
    return response.data['count'] ?? ids.length;
  }

  Future<int> bulkUpdate({
    required List<String> ids,
    bool? completed,
    String? status,
    String? priority,
    String? category,
  }) async {
    final updates = <String, dynamic>{};
    if (completed != null) updates['completed'] = completed;
    if (status != null) updates['status'] = status;
    if (priority != null) updates['priority'] = priority;
    if (category != null) updates['category'] = category;

    final response = await _api.post(
      ApiEndpoints.bulkUpdate,
      data: {
        'ids': ids,
        'updates': updates,
      },
    );
    return response.data['count'] ?? ids.length;
  }

  Future<List<Map<String, dynamic>>> exportTasks() async {
    final response = await _api.get(ApiEndpoints.exportTasks);
    return List<Map<String, dynamic>>.from(response.data as List);
  }

  Future<int> importTasks(List<Map<String, dynamic>> tasks) async {
    final response = await _api.post(
      ApiEndpoints.importTasks,
      data: tasks,
    );
    return response.data['count'] ?? tasks.length;
  }
}
