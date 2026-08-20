import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/models/todo_stats_model.dart';
import '../data/repositories/todo_repository.dart';
import 'storage_provider.dart';

class StatsState {
  final TodoStatsModel stats;
  final bool isLoading;
  final String? errorMessage;

  StatsState({
    required this.stats,
    this.isLoading = false,
    this.errorMessage,
  });

  StatsState copyWith({
    TodoStatsModel? stats,
    bool? isLoading,
    String? errorMessage,
  }) {
    return StatsState(
      stats: stats ?? this.stats,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class StatsNotifier extends StateNotifier<StatsState> {
  final TodoRepository _repo;

  StatsNotifier(this._repo) : super(StatsState(stats: TodoStatsModel(), isLoading: true)) {
    loadStats();
  }

  Future<void> loadStats() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final stats = await _repo.getStats();
      state = state.copyWith(stats: stats, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

final statsProvider = StateNotifierProvider<StatsNotifier, StatsState>((ref) {
  final repo = ref.watch(todoRepositoryProvider);
  return StatsNotifier(repo);
});
