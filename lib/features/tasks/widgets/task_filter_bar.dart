import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/todo_provider.dart';

class TaskFilterBar extends StatelessWidget {
  final TodoFilter filter;
  final ValueChanged<TodoFilter> onFilterChanged;
  final List<String> categories;

  const TaskFilterBar({
    super.key,
    required this.filter,
    required this.onFilterChanged,
    this.categories = const [],
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          // Status Chips
          _FilterChip(
            label: 'All',
            isSelected: filter.status == 'all' && filter.dueFilter == 'all',
            onTap: () => onFilterChanged(filter.copyWith(status: 'all', dueFilter: 'all')),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Active',
            isSelected: filter.status == 'active',
            onTap: () => onFilterChanged(filter.copyWith(status: 'active', dueFilter: 'all')),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: 'Completed',
            isSelected: filter.status == 'completed',
            onTap: () => onFilterChanged(filter.copyWith(status: 'completed', dueFilter: 'all')),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: '📅 Today',
            isSelected: filter.dueFilter == 'today',
            onTap: () => onFilterChanged(filter.copyWith(dueFilter: filter.dueFilter == 'today' ? 'all' : 'today')),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: '⚠️ Overdue',
            isSelected: filter.dueFilter == 'overdue',
            onTap: () => onFilterChanged(filter.copyWith(dueFilter: filter.dueFilter == 'overdue' ? 'all' : 'overdue')),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: '🔴 Urgent',
            isSelected: filter.priority == 'urgent',
            onTap: () => onFilterChanged(filter.copyWith(priority: filter.priority == 'urgent' ? 'all' : 'urgent')),
          ),
          const SizedBox(width: 8),
          _FilterChip(
            label: '🟠 High',
            isSelected: filter.priority == 'high',
            onTap: () => onFilterChanged(filter.copyWith(priority: filter.priority == 'high' ? 'all' : 'high')),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : (isDark ? AppColors.darkCard : AppColors.lightCard),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? Colors.white
                : (isDark ? AppColors.textMainDark : AppColors.textMainLight),
          ),
        ),
      ),
    );
  }
}
