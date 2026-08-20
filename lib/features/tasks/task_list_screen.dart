import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/todo_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/stats_provider.dart';
import '../../providers/todo_provider.dart';
import '../../shared/widgets/empty_state_widget.dart';
import '../../shared/widgets/loading_indicator.dart';
import 'widgets/bulk_action_bar.dart';
import 'widgets/stat_summary_row.dart';
import 'widgets/tag_chip_list.dart';
import 'widgets/task_card.dart';
import 'widgets/task_editor_sheet.dart';
import 'widgets/task_filter_bar.dart';

class TaskListScreen extends ConsumerStatefulWidget {
  const TaskListScreen({super.key});

  @override
  ConsumerState<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends ConsumerState<TaskListScreen> {
  final _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _openTaskEditor([TodoModel? task]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskEditorSheet(
        task: task,
        onSave: (newOrUpdated) async {
          if (task == null) {
            await ref.read(todoListProvider.notifier).createTodo(newOrUpdated);
            ref.read(statsProvider.notifier).loadStats();
          } else {
            await ref.read(todoListProvider.notifier).updateTodo(newOrUpdated);
            ref.read(statsProvider.notifier).loadStats();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authProvider).user;
    final todoState = ref.watch(todoListProvider);
    final statsState = ref.watch(statsProvider);
    final currentFilter = ref.watch(todoFilterProvider);
    final selectedIds = ref.watch(selectedTodoIdsProvider);
    final isSelectionMode = selectedIds.isNotEmpty;

    final tagsList = statsState.stats.tags.keys.toList()..sort();
    final categoriesList = statsState.stats.categories.keys.toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Search tasks or tags...',
                  border: InputBorder.none,
                ),
                onChanged: (val) {
                  ref.read(todoFilterProvider.notifier).state =
                      currentFilter.copyWith(search: val);
                  ref.read(todoListProvider.notifier).loadTodos();
                },
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Good day, ${user?.name.split(' ').first ?? 'there'} 👋',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                  ),
                  if (statsState.stats.streak > 0)
                    Text(
                      '🔥 ${statsState.stats.streak} day streak',
                      style: const TextStyle(fontSize: 11.5, color: AppColors.streakOrange, fontWeight: FontWeight.w700),
                    ),
                ],
              ),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                if (_isSearching) {
                  _searchController.clear();
                  ref.read(todoFilterProvider.notifier).state =
                      currentFilter.copyWith(search: '');
                  ref.read(todoListProvider.notifier).loadTodos();
                }
                _isSearching = !_isSearching;
              });
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'Sort by',
            onSelected: (val) {
              ref.read(todoFilterProvider.notifier).state =
                  currentFilter.copyWith(sortBy: val);
              ref.read(todoListProvider.notifier).loadTodos();
            },
            itemBuilder: (ctx) => [
              const PopupMenuItem(value: 'smart', child: Text('📌 Smart (Pinned First)')),
              const PopupMenuItem(value: 'dueDate', child: Text('📅 Due Date')),
              const PopupMenuItem(value: 'priority', child: Text('🔥 Priority')),
              const PopupMenuItem(value: 'title', child: Text('🔤 Alphabetical')),
              const PopupMenuItem(value: 'createdAt', child: Text('⏱️ Newest First')),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              await Future.wait([
                ref.read(todoListProvider.notifier).loadTodos(),
                ref.read(statsProvider.notifier).loadStats(),
              ]);
            },
            child: ListView(
              padding: const EdgeInsets.only(bottom: 90),
              children: [
                const SizedBox(height: 8),

                // Stat Summary Cards Row
                StatSummaryRow(
                  stats: statsState.stats,
                  onTotalTap: () {
                    ref.read(todoFilterProvider.notifier).state =
                        currentFilter.copyWith(status: 'all', dueFilter: 'all');
                    ref.read(todoListProvider.notifier).loadTodos();
                  },
                  onCompletedTap: () {
                    ref.read(todoFilterProvider.notifier).state =
                        currentFilter.copyWith(status: 'completed', dueFilter: 'all');
                    ref.read(todoListProvider.notifier).loadTodos();
                  },
                  onActiveTap: () {
                    ref.read(todoFilterProvider.notifier).state =
                        currentFilter.copyWith(status: 'active', dueFilter: 'all');
                    ref.read(todoListProvider.notifier).loadTodos();
                  },
                  onOverdueTap: () {
                    ref.read(todoFilterProvider.notifier).state =
                        currentFilter.copyWith(dueFilter: 'overdue');
                    ref.read(todoListProvider.notifier).loadTodos();
                  },
                ),
                const SizedBox(height: 14),

                // Filter Bar (All, Active, Completed, Today, Overdue, Urgent)
                TaskFilterBar(
                  filter: currentFilter,
                  categories: categoriesList,
                  onFilterChanged: (newFilter) {
                    ref.read(todoFilterProvider.notifier).state = newFilter;
                    ref.read(todoListProvider.notifier).loadTodos();
                  },
                ),
                const SizedBox(height: 10),

                // Tag Chips
                if (tagsList.isNotEmpty) ...[
                  TagChipList(
                    tags: tagsList,
                    selectedTag: currentFilter.tag,
                    onTagSelected: (tag) {
                      ref.read(todoFilterProvider.notifier).state =
                          currentFilter.copyWith(tag: tag);
                      ref.read(todoListProvider.notifier).loadTodos();
                    },
                  ),
                  const SizedBox(height: 12),
                ],

                // Task List Content
                if (todoState.isLoading && todoState.todos.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: LoadingIndicator(message: 'Loading tasks...'),
                  )
                else if (todoState.todos.isEmpty)
                  EmptyStateWidget(
                    icon: Icons.checklist_rounded,
                    title: 'No tasks found',
                    description: 'Try adjusting your filters or create your next task.',
                    actionText: 'Create Task',
                    onAction: () => _openTaskEditor(),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: todoState.todos.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      final task = todoState.todos[index];
                      final isSelected = selectedIds.contains(task.id);

                      return TaskCard(
                        task: task,
                        isSelected: isSelected,
                        isSelectionMode: isSelectionMode,
                        onSelectionChanged: (checked) {
                          final current = Set<String>.from(selectedIds);
                          if (checked == true) {
                            current.add(task.id);
                          } else {
                            current.remove(task.id);
                          }
                          ref.read(selectedTodoIdsProvider.notifier).state = current;
                        },
                        onToggle: () async {
                          await ref.read(todoListProvider.notifier).toggleTodo(task.id);
                          ref.read(statsProvider.notifier).loadStats();
                        },
                        onTap: () => _openTaskEditor(task),
                        onEdit: () => _openTaskEditor(task),
                        onDelete: () async {
                          await ref.read(todoListProvider.notifier).deleteTodo(task.id);
                          ref.read(statsProvider.notifier).loadStats();
                        },
                      );
                    },
                  ),
              ],
            ),
          ),

          // Floating Bulk Action Bar
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: BulkActionBar(
              selectedCount: selectedIds.length,
              onClear: () {
                ref.read(selectedTodoIdsProvider.notifier).state = {};
              },
              onBulkComplete: (completed) async {
                await ref.read(todoListProvider.notifier).bulkUpdate(
                      ids: selectedIds.toList(),
                      completed: completed,
                      status: completed ? 'completed' : 'todo',
                    );
                ref.read(statsProvider.notifier).loadStats();
              },
              onBulkDelete: () async {
                await ref.read(todoListProvider.notifier).bulkDelete(selectedIds.toList());
                ref.read(statsProvider.notifier).loadStats();
              },
              onBulkPriority: (priority) async {
                await ref.read(todoListProvider.notifier).bulkUpdate(
                      ids: selectedIds.toList(),
                      priority: priority,
                    );
                ref.read(statsProvider.notifier).loadStats();
              },
            ),
          ),
        ],
      ),
      floatingActionButton: isSelectionMode
          ? null
          : FloatingActionButton(
              onPressed: () => _openTaskEditor(),
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.add, color: Colors.white),
            ),
    );
  }
}
