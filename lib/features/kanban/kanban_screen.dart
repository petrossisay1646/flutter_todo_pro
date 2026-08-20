import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../data/models/todo_model.dart';
import '../../providers/stats_provider.dart';
import '../../providers/todo_provider.dart';
import '../tasks/widgets/task_editor_sheet.dart';
import 'widgets/kanban_column_widget.dart';

class KanbanScreen extends ConsumerWidget {
  const KanbanScreen({super.key});

  void _openTaskEditor(BuildContext context, WidgetRef ref, [TodoModel? task, String? defaultStatus]) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => TaskEditorSheet(
        task: task,
        defaultStatus: defaultStatus,
        onSave: (newOrUpdated) async {
          if (task == null) {
            await ref.read(todoListProvider.notifier).createTodo(newOrUpdated);
          } else {
            await ref.read(todoListProvider.notifier).updateTodo(newOrUpdated);
          }
          ref.read(statsProvider.notifier).loadStats();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todos = ref.watch(todoListProvider).todos;

    final todoTasks = todos.where((t) => !t.completed && (t.status == 'todo' || t.status.isEmpty)).toList();
    final inProgressTasks = todos.where((t) => !t.completed && t.status == 'in-progress').toList();
    final completedTasks = todos.where((t) => t.completed || t.status == 'completed').toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kanban Board', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          children: [
            KanbanColumnWidget(
              title: 'To Do',
              statusKey: 'todo',
              indicatorColor: AppColors.primary,
              tasks: todoTasks,
              onEditTask: (task) => _openTaskEditor(context, ref, task),
              onMoveTask: (taskId, newStatus) async {
                await ref.read(todoListProvider.notifier).updateStatus(taskId, newStatus);
                ref.read(statsProvider.notifier).loadStats();
              },
              onAddTask: (status) => _openTaskEditor(context, ref, null, status),
            ),
            KanbanColumnWidget(
              title: 'In Progress',
              statusKey: 'in-progress',
              indicatorColor: AppColors.warning,
              tasks: inProgressTasks,
              onEditTask: (task) => _openTaskEditor(context, ref, task),
              onMoveTask: (taskId, newStatus) async {
                await ref.read(todoListProvider.notifier).updateStatus(taskId, newStatus);
                ref.read(statsProvider.notifier).loadStats();
              },
              onAddTask: (status) => _openTaskEditor(context, ref, null, status),
            ),
            KanbanColumnWidget(
              title: 'Completed',
              statusKey: 'completed',
              indicatorColor: AppColors.success,
              tasks: completedTasks,
              onEditTask: (task) => _openTaskEditor(context, ref, task),
              onMoveTask: (taskId, newStatus) async {
                await ref.read(todoListProvider.notifier).updateStatus(taskId, newStatus);
                ref.read(statsProvider.notifier).loadStats();
              },
              onAddTask: (status) => _openTaskEditor(context, ref, null, status),
            ),
          ],
        ),
      ),
    );
  }
}
