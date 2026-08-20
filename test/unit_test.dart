import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todo_pro/core/constants/api_constants.dart';
import 'package:flutter_todo_pro/core/constants/app_colors.dart';
import 'package:flutter_todo_pro/core/utils/date_formatter.dart';
import 'package:flutter_todo_pro/data/models/subtask_model.dart';
import 'package:flutter_todo_pro/data/models/todo_model.dart';
import 'package:flutter_todo_pro/data/models/todo_stats_model.dart';
import 'package:flutter_todo_pro/data/models/user_model.dart';

void main() {
  group('PetroFlow Core Constants Tests', () {
    test('Production API Base URL is verified HTTPS Render URL', () {
      expect(ApiConstants.defaultBaseUrl, 'https://mern-todo-pro.onrender.com/api');
      expect(ApiConstants.defaultBaseUrl.startsWith('https://'), isTrue);
    });

    test('Brand colors are correctly defined', () {
      expect(AppColors.primary.toARGB32(), isNotNull);
      expect(AppColors.urgentText.toARGB32(), isNotNull);
    });
  });

  group('PetroFlow Models Tests', () {
    test('UserModel JSON serialization & deserialization', () {
      final json = {
        'id': 'user_123',
        'name': 'Petros Sisay',
        'email': 'petros@example.com',
        'dailyGoal': 6,
        'pomodoroLength': 30,
        'avatarColor': '#564CFF',
      };

      final user = UserModel.fromJson(json);
      expect(user.id, 'user_123');
      expect(user.name, 'Petros Sisay');
      expect(user.email, 'petros@example.com');
      expect(user.dailyGoal, 6);
      expect(user.pomodoroLength, 30);

      final outputJson = user.toJson();
      expect(outputJson['id'], 'user_123');
      expect(outputJson['name'], 'Petros Sisay');
    });

    test('SubtaskModel JSON serialization and copyWith', () {
      final subtask = SubtaskModel(id: 'sub_1', title: 'Write unit tests', completed: false);
      expect(subtask.title, 'Write unit tests');
      expect(subtask.completed, isFalse);

      final updated = subtask.copyWith(completed: true);
      expect(updated.completed, isTrue);
      expect(updated.id, 'sub_1');

      final json = updated.toJson();
      expect(json['completed'], isTrue);
      expect(json['title'], 'Write unit tests');
    });

    test('TodoModel JSON serialization & progress calculation', () {
      final todoJson = {
        '_id': 'todo_999',
        'title': 'Deploy PetroFlow',
        'description': 'Release on mobile',
        'completed': false,
        'priority': 'urgent',
        'category': 'Development',
        'status': 'in-progress',
        'pinned': true,
        'tags': ['flutter', 'mobile'],
        'estimatedMinutes': 45,
        'subtasks': [
          {'_id': 's1', 'title': 'Build APK', 'completed': true},
          {'_id': 's2', 'title': 'Test on phone', 'completed': true},
          {'_id': 's3', 'title': 'Publish repo', 'completed': false},
        ],
        'createdAt': '2026-08-20T08:00:00.000Z',
      };

      final todo = TodoModel.fromJson(todoJson);
      expect(todo.id, 'todo_999');
      expect(todo.title, 'Deploy PetroFlow');
      expect(todo.status, 'in-progress');
      expect(todo.pinned, isTrue);
      expect(todo.subtasks.length, 3);
      expect(todo.completedSubtasksCount, 2);
      expect(todo.subtasksProgress, closeTo(0.666, 0.01));
    });

    test('TodoStatsModel JSON parsing with 7-day breakdown', () {
      final statsJson = {
        'total': 15,
        'completed': 10,
        'active': 5,
        'urgentPriority': 2,
        'last7Days': [
          {'label': 'Mon', 'date': '2026-08-18', 'count': 2},
          {'label': 'Tue', 'date': '2026-08-19', 'count': 4},
          {'label': 'Wed', 'date': '2026-08-20', 'count': 4},
        ],
      };

      final stats = TodoStatsModel.fromJson(statsJson);
      expect(stats.total, 15);
      expect(stats.completed, 10);
      expect(stats.active, 5);
      expect(stats.completionRate, closeTo(66.66, 0.01));
      expect(stats.last7Days.length, 3);
      expect(stats.last7Days[0].label, 'Mon');
      expect(stats.last7Days[0].count, 2);
    });
  });

  group('PetroFlow DateFormatter Tests', () {
    test('formatShort handles null correctly', () {
      expect(DateFormatter.formatShort(null), '');
    });

    test('isDueToday checks same day correctly', () {
      final now = DateTime.now();
      expect(DateFormatter.isDueToday(now), isTrue);
    });

    test('isOverdue checks past dates correctly', () {
      final past = DateTime.now().subtract(const Duration(days: 2));
      expect(DateFormatter.isOverdue(past, false), isTrue);
      expect(DateFormatter.isOverdue(past, true), isFalse);
    });
  });
}
