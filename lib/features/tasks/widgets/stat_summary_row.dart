import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/todo_stats_model.dart';

class StatSummaryRow extends StatelessWidget {
  final TodoStatsModel stats;
  final VoidCallback? onTotalTap;
  final VoidCallback? onCompletedTap;
  final VoidCallback? onActiveTap;
  final VoidCallback? onOverdueTap;

  const StatSummaryRow({
    super.key,
    required this.stats,
    this.onTotalTap,
    this.onCompletedTap,
    this.onActiveTap,
    this.onOverdueTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _StatMiniCard(
            label: 'Total Tasks',
            value: '${stats.total}',
            icon: Icons.bar_chart_rounded,
            color: AppColors.primary,
            onTap: onTotalTap,
          ),
          const SizedBox(width: 10),
          _StatMiniCard(
            label: 'Completed',
            value: '${stats.completed}',
            icon: Icons.check_circle_outline_rounded,
            color: AppColors.success,
            onTap: onCompletedTap,
          ),
          const SizedBox(width: 10),
          _StatMiniCard(
            label: 'In Progress',
            value: '${stats.active}',
            icon: Icons.timelapse_rounded,
            color: AppColors.warning,
            onTap: onActiveTap,
          ),
          const SizedBox(width: 10),
          _StatMiniCard(
            label: 'Overdue',
            value: '${stats.overdue}',
            icon: Icons.error_outline_rounded,
            color: AppColors.danger,
            isDanger: stats.overdue > 0,
            onTap: onOverdueTap,
          ),
        ],
      ),
    );
  }
}

class _StatMiniCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final bool isDanger;
  final VoidCallback? onTap;

  const _StatMiniCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.isDanger = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        width: 120,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkCard : AppColors.lightCard,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isDanger
                ? AppColors.danger.withValues(alpha: 0.5)
                : (isDark ? AppColors.borderDark : AppColors.borderLight),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                Icon(icon, size: 16, color: color),
              ],
            ),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: isDanger ? AppColors.danger : (isDark ? AppColors.textMainDark : AppColors.textMainLight),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
