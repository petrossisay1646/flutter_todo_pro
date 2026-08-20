import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/todo_model.dart';
import '../data/repositories/todo_repository.dart';
import 'storage_provider.dart';

class TodoFilter {
  final String search;
  final String status; // 'all' | 'active' | 'todo' | 'in-progress' | 'completed'
  final String priority; // 'all' | 'urgent' | 'high' | 'medium' | 'low'
  final String category;
  final String tag;
  final String dueFilter; // 'all' | 'today' | 'week' | 'overdue'
  final String sortBy; // 'smart' | 'dueDate' | 'priority' | 'title' | 'createdAt'

  const TodoFilter({
    this.search = '',
    this.status = 'all',
    this.priority = 'all',
    this.category = 'all',
    this.tag = 'all',
    this.dueFilter = 'all',
    this.sortBy = 'smart',
  });

  TodoFilter copyWith({
    String? search,
    String? status,
    String? priority,
    String? category,
    String? tag,
    String? dueFilter,
    String? sortBy,
  }) {
    return TodoFilter(
      search: search ?? this.search,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      tag: tag ?? this.tag,
      dueFilter: dueFilter ?? this.dueFilter,
      sortBy: sortBy ?? this.sortBy,
    );
  }
}

final todoFilterProvider = StateProvider<TodoFilter>((ref) => const TodoFilter());

final selectedTodoIdsProvider = StateProvider<Set<String>>((ref) => {});

class TodoListState {
  final List<TodoModel> todos;
  final bool isLoading;
  final String? errorMessage;

  TodoListState({
    this.todos = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  TodoListState copyWith({
    List<TodoModel>? todos,
    bool? isLoading,
    String? errorMessage,
  }) {
    return TodoListState(
      todos: todos ?? this.todos,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class TodoListNotifier extends StateNotifier<TodoListState> {
  final TodoRepository _repo;
  final Ref _ref;

  TodoListNotifier(this._repo, this._ref) : super(TodoListState(isLoading: true)) {
    loadTodos();
  }

  Future<void> loadTodos() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final filter = _ref.read(todoFilterProvider);
      final list = await _repo.getTodos(
        search: filter.search,
        status: filter.status,
        priority: filter.priority,
        category: filter.category,
        tag: filter.tag,
        dueFilter: filter.dueFilter,
        sortBy: filter.sortBy,
      );
      state = state.copyWith(todos: list, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  Future<bool> createTodo(TodoModel todo) async {
    try {
      final created = await _repo.createTodo(todo);
      state = state.copyWith(todos: [created, ...state.todos]);
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateTodo(TodoModel todo) async {
    try {
      final updated = await _repo.updateTodo(todo);
      state = state.copyWith(
        todos: state.todos.map((t) => t.id == updated.id ? updated : t).toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> toggleTodo(String id) async {
    try {
      final updated = await _repo.toggleTodo(id);
      state = state.copyWith(
        todos: state.todos.map((t) => t.id == updated.id ? updated : t).toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateStatus(String id, String status) async {
    try {
      final target = state.todos.firstWhere((t) => t.id == id);
      final updated = await _repo.updateTodo(target.copyWith(
        status: status,
        completed: status == 'completed',
        completedAt: status == 'completed' ? DateTime.now() : null,
      ));
      state = state.copyWith(
        todos: state.todos.map((t) => t.id == updated.id ? updated : t).toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> updateSubtasks(String id, List<Map<String, dynamic>> subtasks) async {
    try {
      final updated = await _repo.updateSubtasks(id, subtasks);
      state = state.copyWith(
        todos: state.todos.map((t) => t.id == updated.id ? updated : t).toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> deleteTodo(String id) async {
    try {
      await _repo.deleteTodo(id);
      state = state.copyWith(
        todos: state.todos.where((t) => t.id != id).toList(),
      );
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> bulkDelete(List<String> ids) async {
    try {
      await _repo.bulkDelete(ids);
      state = state.copyWith(
        todos: state.todos.where((t) => !ids.contains(t.id)).toList(),
      );
      _ref.read(selectedTodoIdsProvider.notifier).state = {};
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }

  Future<bool> bulkUpdate({
    required List<String> ids,
    bool? completed,
    String? status,
    String? priority,
    String? category,
  }) async {
    try {
      await _repo.bulkUpdate(
        ids: ids,
        completed: completed,
        status: status,
        priority: priority,
        category: category,
      );
      await loadTodos();
      _ref.read(selectedTodoIdsProvider.notifier).state = {};
      return true;
    } catch (e) {
      state = state.copyWith(errorMessage: e.toString());
      return false;
    }
  }
}

final todoListProvider = StateNotifierProvider<TodoListNotifier, TodoListState>((ref) {
  final repo = ref.watch(todoRepositoryProvider);
  return TodoListNotifier(repo, ref);
});
