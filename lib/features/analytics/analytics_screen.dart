import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/stats_provider.dart';
import '../../providers/todo_provider.dart';
import 'widgets/weekly_bar_chart_widget.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final stats = ref.watch(statsProvider).stats;
    final todos = ref.watch(todoListProvider).todos;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dailyGoal = user?.dailyGoal ?? 5;
    final now = DateTime.now();
    final startOfToday = DateTime(now.year, now.month, now.day);
    final completedToday = todos.where((t) {
      if (!t.completed || t.completedAt == null) return false;
      return t.completedAt!.isAfter(startOfToday);
    }).length;

    final goalPercent = (completedToday / dailyGoal).clamp(0.0, 1.0);

    final urgentCount = todos.where((t) => !t.completed && t.priority == 'urgent').length;
    final highCount = todos.where((t) => !t.completed && t.priority == 'high').length;
    final medCount = todos.where((t) => !t.completed && t.priority == 'medium').length;
    final lowCount = todos.where((t) => !t.completed && t.priority == 'low').length;
    final activeTotal = (stats.active > 0 ? stats.active : 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics & Streaks', style: TextStyle(fontWeight: FontWeight.w800)),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => ref.read(statsProvider.notifier).loadStats(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Daily Target Card & Streak Grid
                Row(
                  children: [
                    // Daily Goal Card
                    Expanded(
                      flex: 6,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.lightCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'DAILY TARGET',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.primary, letterSpacing: 1.2),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                SizedBox(
                                  width: 44,
                                  height: 44,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        value: goalPercent,
                                        backgroundColor: isDark ? AppColors.darkElevated : const Color(0xFFE2E8F0),
                                        valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                                        strokeWidth: 4.5,
                                      ),
                                      Text(
                                        '${(goalPercent * 100).toInt()}%',
                                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '$completedToday of $dailyGoal Done',
                                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                      ),
                                      Text(
                                        completedToday >= dailyGoal ? 'Goal reached!' : '${dailyGoal - completedToday} tasks left',
                                        style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    // Streak Card
                    Expanded(
                      flex: 4,
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkCard : AppColors.lightCard,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'STREAK',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.streakOrange, letterSpacing: 1.2),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Text('🔥', style: TextStyle(fontSize: 22)),
                                const SizedBox(width: 4),
                                Text(
                                  '${stats.streak}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.streakOrange,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Text(
                                  'days',
                                  style: TextStyle(fontSize: 11, color: AppColors.textMutedLight),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),

                // 7-Day Completion Trend Chart
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '7-Day Completion Trend',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                              ),
                              Text(
                                'Tasks finished in the past week',
                                style: TextStyle(fontSize: 11.5, color: AppColors.textMutedLight),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.check_circle, size: 12, color: AppColors.success),
                                const SizedBox(width: 4),
                                Text(
                                  '${stats.last7Days.fold(0, (acc, d) => acc + d.count)} this week',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      WeeklyBarChartWidget(last7Days: stats.last7Days),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Priority Breakdown
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkCard : AppColors.lightCard,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Active Tasks by Priority',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 14),
                      _PriorityBarRow(label: '🔴 Urgent', count: urgentCount, total: activeTotal, color: AppColors.danger),
                      const SizedBox(height: 8),
                      _PriorityBarRow(label: '🟠 High', count: highCount, total: activeTotal, color: AppColors.streakOrange),
                      const SizedBox(height: 8),
                      _PriorityBarRow(label: '🟡 Medium', count: medCount, total: activeTotal, color: AppColors.warning),
                      const SizedBox(height: 8),
                      _PriorityBarRow(label: '🟢 Low', count: lowCount, total: activeTotal, color: AppColors.success),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Category Breakdown
                if (stats.categories.isNotEmpty) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isDark ? AppColors.darkCard : AppColors.lightCard,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tasks by Category',
                          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 12),
                        ...stats.categories.entries.map((entry) {
                          final percent = stats.total > 0 ? (entry.value / stats.total) : 0.0;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(entry.key, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                                    Text('${entry.value} tasks (${(percent * 100).toInt()}%)', style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight)),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(4),
                                  child: LinearProgressIndicator(
                                    value: percent,
                                    minHeight: 5,
                                    backgroundColor: isDark ? AppColors.darkElevated : const Color(0xFFE2E8F0),
                                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PriorityBarRow extends StatelessWidget {
  final String label;
  final int count;
  final int total;
  final Color color;

  const _PriorityBarRow({
    required this.label,
    required this.count,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percent = total > 0 ? (count / total).clamp(0.0, 1.0) : 0.0;

    return Row(
      children: [
        SizedBox(
          width: 80,
          child: Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent,
              minHeight: 6,
              backgroundColor: isDark ? AppColors.darkElevated : const Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 25,
          child: Text(
            '$count',
            textAlign: TextAlign.right,
            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12),
          ),
        ),
      ],
    );
  }
}
