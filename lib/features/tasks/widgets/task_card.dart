import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../data/models/todo_model.dart';

class TaskCard extends StatelessWidget {
  final TodoModel task;
  final VoidCallback onToggle;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final void Function(int subtaskIndex)? onToggleSubtask;
  final bool isSelected;
  final bool isSelectionMode;
  final ValueChanged<bool?>? onSelectionChanged;

  const TaskCard({
    super.key,
    required this.task,
    required this.onToggle,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
    this.onToggleSubtask,
    this.isSelected = false,
    this.isSelectionMode = false,
    this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isOverdue = DateFormatter.isOverdue(task.dueDate, task.completed);

    Color priorityBg;
    Color priorityText;
    switch (task.priority) {
      case 'urgent':
        priorityBg = AppColors.urgentBg;
        priorityText = AppColors.urgentText;
        break;
      case 'high':
        priorityBg = AppColors.highBg;
        priorityText = AppColors.highText;
        break;
      case 'low':
        priorityBg = AppColors.lowBg;
        priorityText = AppColors.lowText;
        break;
      default:
        priorityBg = AppColors.mediumBg;
        priorityText = AppColors.mediumText;
    }

    return Dismissible(
      key: Key(task.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: AppColors.danger,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white, size: 24),
      ),
      confirmDismiss: (_) async {
        final result = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Task?'),
            content: Text('Are you sure you want to delete "${task.title}"?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger),
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Delete'),
              ),
            ],
          ),
        );
        return result ?? false;
      },
      onDismissed: (_) => onDelete(),
      child: InkWell(
        onTap: isSelectionMode ? () => onSelectionChanged?.call(!isSelected) : onTap,
        onLongPress: () => onSelectionChanged?.call(!isSelected),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary.withValues(alpha: 0.08)
                : (isDark ? AppColors.darkCard : AppColors.lightCard),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (task.pinned
                      ? AppColors.primary.withValues(alpha: 0.5)
                      : (isDark ? AppColors.borderDark : AppColors.borderLight)),
              width: task.pinned || isSelected ? 1.5 : 1,
            ),
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Row 1: Checkbox, Title, Pin, More Actions
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isSelectionMode)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: SizedBox(
                        width: 24,
                        height: 24,
                        child: Checkbox(
                          value: isSelected,
                          onChanged: onSelectionChanged,
                        ),
                      ),
                    )
                  else
                    InkWell(
                      onTap: onToggle,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        width: 24,
                        height: 24,
                        margin: const EdgeInsets.only(right: 10, top: 1),
                        decoration: BoxDecoration(
                          color: task.completed ? AppColors.primary : Colors.transparent,
                          borderRadius: BorderRadius.circular(7),
                          border: Border.all(
                            color: task.completed ? AppColors.primary : AppColors.borderLight,
                            width: 1.5,
                          ),
                        ),
                        child: task.completed
                            ? const Icon(Icons.check, size: 16, color: Colors.white)
                            : null,
                      ),
                    ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            if (task.pinned) ...[
                              const Icon(Icons.push_pin, size: 14, color: AppColors.primary),
                              const SizedBox(width: 4),
                            ],
                            Expanded(
                              child: Text(
                                task.title,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  decoration: task.completed ? TextDecoration.lineThrough : null,
                                  color: task.completed
                                      ? (isDark ? AppColors.textMutedDark : AppColors.textMutedLight)
                                      : (isDark ? AppColors.textMainDark : AppColors.textMainLight),
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (task.description.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            task.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  // Priority Badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: priorityBg,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      task.priority.toUpperCase(),
                      style: TextStyle(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w800,
                        color: priorityText,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),
                ],
              ),

              // Subtasks Progress (if any)
              if (task.subtasks.isNotEmpty) ...[
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkElevated : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isDark ? AppColors.borderDark : const Color(0xFFEDF2F7),
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.checklist_rounded, size: 14, color: AppColors.textMutedLight),
                              const SizedBox(width: 4),
                              Text(
                                '${task.completedSubtasksCount} of ${task.subtasks.length} steps',
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.textMutedLight,
                                ),
                              ),
                            ],
                          ),
                          Text(
                            '${(task.subtasksProgress * 100).toInt()}%',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: task.subtasksProgress,
                          minHeight: 4.5,
                          backgroundColor: isDark ? AppColors.borderDark : const Color(0xFFE2E8F0),
                          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.success),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              // Meta Tags & Due Date Footer
              const SizedBox(height: 10),
              Row(
                children: [
                  // Category Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkElevated : const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      task.category,
                      style: TextStyle(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.textMutedDark : const Color(0xFF475569),
                      ),
                    ),
                  ),
                  if (task.dueDate != null) ...[
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 12,
                          color: isOverdue ? AppColors.danger : AppColors.textMutedLight,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          isOverdue
                              ? 'Overdue (${DateFormatter.formatShort(task.dueDate)})'
                              : 'Due ${DateFormatter.formatShort(task.dueDate)}',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isOverdue ? FontWeight.w700 : FontWeight.w500,
                            color: isOverdue ? AppColors.danger : AppColors.textMutedLight,
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (task.estimatedMinutes > 0) ...[
                    const SizedBox(width: 8),
                    Row(
                      children: [
                        const Icon(Icons.access_time_rounded, size: 12, color: AppColors.textMutedLight),
                        const SizedBox(width: 3),
                        Text(
                          '${task.estimatedMinutes}m',
                          style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight),
                        ),
                      ],
                    ),
                  ],
                  const Spacer(),
                  // Tags (first 2)
                  if (task.tags.isNotEmpty) ...[
                    ...task.tags.take(2).map(
                          (t) => Container(
                            margin: const EdgeInsets.only(left: 4),
                            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '#$t',
                              style: TextStyle(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w600,
                                color: isDark ? const Color(0xFFA59EFF) : AppColors.primary,
                              ),
                            ),
                          ),
                        ),
                    if (task.tags.length > 2)
                      Text(
                        ' +${task.tags.length - 2}',
                        style: const TextStyle(fontSize: 9.5, color: AppColors.textMutedLight),
                      ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
