import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/todo_model.dart';

class KanbanColumnWidget extends StatelessWidget {
  final String title;
  final String statusKey;
  final Color indicatorColor;
  final List<TodoModel> tasks;
  final void Function(TodoModel task) onEditTask;
  final void Function(String taskId, String newStatus) onMoveTask;
  final void Function(String statusKey) onAddTask;

  const KanbanColumnWidget({
    super.key,
    required this.title,
    required this.statusKey,
    required this.indicatorColor,
    required this.tasks,
    required this.onEditTask,
    required this.onMoveTask,
    required this.onAddTask,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 290,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkElevated : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Column Header
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: indicatorColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: indicatorColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${tasks.length}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: indicatorColor,
                  ),
                ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add, size: 18),
                onPressed: () => onAddTask(statusKey),
                tooltip: 'Add to $title',
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Cards list
          Expanded(
            child: tasks.isEmpty
                ? Center(
                    child: Text(
                      'No tasks in $title',
                      style: const TextStyle(fontSize: 12, color: AppColors.textMutedLight),
                    ),
                  )
                : ListView.separated(
                    itemCount: tasks.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      return _KanbanCard(
                        task: task,
                        currentStatus: statusKey,
                        onTap: () => onEditTask(task),
                        onMove: (newStatus) => onMoveTask(task.id, newStatus),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _KanbanCard extends StatelessWidget {
  final TodoModel task;
  final String currentStatus;
  final VoidCallback onTap;
  final ValueChanged<String> onMove;

  const _KanbanCard({
    required this.task,
    required this.currentStatus,
    required this.onTap,
    required this.onMove,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color prioColor = AppColors.warning;
    if (task.priority == 'urgent') prioColor = AppColors.danger;
    if (task.priority == 'high') prioColor = AppColors.streakOrange;
    if (task.priority == 'low') prioColor = AppColors.success;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: task.pinned
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
            width: task.pinned ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: prioColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    task.priority.toUpperCase(),
                    style: TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: prioColor,
                    ),
                  ),
                ),
                if (task.pinned)
                  const Icon(Icons.push_pin, size: 12, color: AppColors.primary),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              task.title,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13.5),
            ),
            if (task.description.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 11.5, color: AppColors.textMutedLight),
              ),
            ],
            const SizedBox(height: 10),

            // Footer with stage shift buttons
            Row(
              children: [
                if (task.dueDate != null) ...[
                  Icon(Icons.calendar_today, size: 11, color: AppColors.textMutedLight),
                  const SizedBox(width: 3),
                  Text(
                    DateFormatter.formatShort(task.dueDate),
                    style: const TextStyle(fontSize: 10.5, color: AppColors.textMutedLight),
                  ),
                ],
                const Spacer(),
                if (currentStatus != 'todo')
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 14),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Move Left',
                    onPressed: () => onMove(currentStatus == 'completed' ? 'in-progress' : 'todo'),
                  ),
                const SizedBox(width: 6),
                if (currentStatus != 'completed')
                  IconButton(
                    icon: const Icon(Icons.arrow_forward, size: 14),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    tooltip: 'Move Right',
                    onPressed: () => onMove(currentStatus == 'todo' ? 'in-progress' : 'completed'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
