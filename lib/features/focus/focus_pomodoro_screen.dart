import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/pomodoro_provider.dart';
import '../../providers/stats_provider.dart';
import '../../providers/todo_provider.dart';
import 'widgets/timer_display_widget.dart';

class FocusPomodoroScreen extends ConsumerWidget {
  const FocusPomodoroScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authProvider).user;
    final pomodoroState = ref.watch(pomodoroProvider);
    final todos = ref.watch(todoListProvider).todos;
    final activeTasks = todos.where((t) => !t.completed).toList();

    final workMinutes = user?.pomodoroLength ?? 25;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    String modeLabel = 'FOCUS TIME';
    if (pomodoroState.mode == PomodoroMode.shortBreak) modeLabel = 'SHORT BREAK';
    if (pomodoroState.mode == PomodoroMode.longBreak) modeLabel = 'LONG BREAK';

    final linkedTask = pomodoroState.linkedTaskId != null
        ? todos.cast().firstWhere(
              (t) => t.id == pomodoroState.linkedTaskId,
              orElse: () => null,
            )
        : null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus Pomodoro', style: TextStyle(fontWeight: FontWeight.w800)),
        actions: [
          IconButton(
            icon: Icon(
              pomodoroState.soundEnabled ? Icons.volume_up_outlined : Icons.volume_off_outlined,
            ),
            onPressed: () => ref.read(pomodoroProvider.notifier).toggleSound(),
            tooltip: pomodoroState.soundEnabled ? 'Mute' : 'Unmute',
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              // Tabs: Focus, Short Break, Long Break
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkElevated : const Color(0xFFE9EFF7),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    _ModeTab(
                      label: '🍅 Focus (${workMinutes}m)',
                      isSelected: pomodoroState.mode == PomodoroMode.work,
                      onTap: () => ref
                          .read(pomodoroProvider.notifier)
                          .setMode(PomodoroMode.work, workMinutes: workMinutes),
                    ),
                    _ModeTab(
                      label: '☕ Short (5m)',
                      isSelected: pomodoroState.mode == PomodoroMode.shortBreak,
                      onTap: () => ref
                          .read(pomodoroProvider.notifier)
                          .setMode(PomodoroMode.shortBreak, workMinutes: workMinutes),
                    ),
                    _ModeTab(
                      label: '🌿 Long (15m)',
                      isSelected: pomodoroState.mode == PomodoroMode.longBreak,
                      onTap: () => ref
                          .read(pomodoroProvider.notifier)
                          .setMode(PomodoroMode.longBreak, workMinutes: workMinutes),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Circular Timer Display
              TimerDisplayWidget(
                formattedTime: pomodoroState.formattedTime,
                progress: pomodoroState.progress,
                modeLabel: modeLabel,
              ),
              const SizedBox(height: 32),

              // Controls (Start/Pause, Reset)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: pomodoroState.isRunning ? AppColors.danger : AppColors.primary,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                    onPressed: () => ref
                        .read(pomodoroProvider.notifier)
                        .toggleTimer(workMinutes: workMinutes),
                    icon: Icon(
                      pomodoroState.isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                      size: 26,
                    ),
                    label: Text(
                      pomodoroState.isRunning ? 'PAUSE' : 'START',
                      style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 14),
                  IconButton.outlined(
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: () => ref
                        .read(pomodoroProvider.notifier)
                        .resetTimer(workMinutes: workMinutes),
                    tooltip: 'Reset Timer',
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Link task to focus session
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
                    const Row(
                      children: [
                        Icon(Icons.gps_fixed_rounded, size: 16, color: AppColors.primary),
                        SizedBox(width: 6),
                        Text(
                          'Link Task to Focus Session',
                          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      initialValue: pomodoroState.linkedTaskId,
                      isExpanded: true,
                      hint: const Text('Select a task to focus on...'),
                      items: [
                        const DropdownMenuItem(value: null, child: Text('-- No Linked Task --')),
                        ...activeTasks.map(
                          (t) => DropdownMenuItem(
                            value: t.id,
                            child: Text(
                              t.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                      onChanged: (id) => ref.read(pomodoroProvider.notifier).linkTask(id),
                    ),
                    if (linkedTask != null) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.darkElevated : const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    linkedTask.title,
                                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                                  ),
                                  Text(
                                    linkedTask.category,
                                    style: const TextStyle(fontSize: 11, color: AppColors.textMutedLight),
                                  ),
                                ],
                              ),
                            ),
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.success,
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              ),
                              onPressed: () async {
                                await ref.read(todoListProvider.notifier).toggleTodo(linkedTask.id);
                                ref.read(pomodoroProvider.notifier).linkTask(null);
                                ref.read(statsProvider.notifier).loadStats();
                              },
                              icon: const Icon(Icons.check, size: 16),
                              label: const Text('Complete', style: TextStyle(fontSize: 12)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Sessions counter card
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkCard : AppColors.lightCard,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.local_fire_department_rounded, color: AppColors.streakOrange, size: 22),
                    const SizedBox(width: 8),
                    const Text(
                      "Today's Focus Sessions: ",
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${pomodoroState.completedSessions}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.streakOrange),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => ref.read(pomodoroProvider.notifier).resetSessions(),
                      child: const Text('Reset', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ModeTab extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ModeTab({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.darkCard : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            ),
          ),
        ),
      ),
    );
  }
}
