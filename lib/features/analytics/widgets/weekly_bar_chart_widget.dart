import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../data/models/todo_stats_model.dart';

class WeeklyBarChartWidget extends StatelessWidget {
  final List<DayStatModel> last7Days;

  const WeeklyBarChartWidget({super.key, required this.last7Days});

  @override
  Widget build(BuildContext context) {
    if (last7Days.isEmpty) {
      return const SizedBox(
        height: 140,
        child: Center(
          child: Text('No weekly activity data yet.', style: TextStyle(color: AppColors.textMutedLight)),
        ),
      );
    }

    final maxCount = last7Days.map((d) => d.count).reduce((a, b) => a > b ? a : b);
    final ceiling = maxCount > 0 ? maxCount : 1;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 160,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: last7Days.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          final isToday = idx == last7Days.length - 1;
          final fillPercent = (item.count / ceiling).clamp(0.08, 1.0);

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '${item.count}',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: isToday ? AppColors.primary : AppColors.textMutedLight,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    height: 100 * fillPercent,
                    decoration: BoxDecoration(
                      color: isToday
                          ? AppColors.primary
                          : (isDark ? AppColors.primaryDark : AppColors.primaryLight),
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
                      color: isToday ? (isDark ? Colors.white : AppColors.textMainLight) : AppColors.textMutedLight,
                    ),
                  ),
                  if (isToday)
                    Container(
                      width: 4,
                      height: 4,
                      margin: const EdgeInsets.only(top: 2),
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
