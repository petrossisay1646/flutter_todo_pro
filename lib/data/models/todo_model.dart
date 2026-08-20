import 'subtask_model.dart';

class TodoModel {
  final String id;
  final String title;
  final String description;
  final bool completed;
  final String status; // 'todo' | 'in-progress' | 'completed'
  final String priority; // 'urgent' | 'high' | 'medium' | 'low'
  final String category;
  final List<String> tags;
  final bool pinned;
  final int estimatedMinutes;
  final int actualMinutes;
  final List<SubtaskModel> subtasks;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final DateTime? createdAt;

  TodoModel({
    required this.id,
    required this.title,
    this.description = '',
    this.completed = false,
    this.status = 'todo',
    this.priority = 'medium',
    this.category = 'General',
    this.tags = const [],
    this.pinned = false,
    this.estimatedMinutes = 0,
    this.actualMinutes = 0,
    this.subtasks = const [],
    this.dueDate,
    this.completedAt,
    this.createdAt,
  });

  factory TodoModel.fromJson(Map<String, dynamic> json) {
    return TodoModel(
      id: json['_id'] ?? json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      completed: json['completed'] == true,
      status: json['status'] ?? (json['completed'] == true ? 'completed' : 'todo'),
      priority: json['priority'] ?? 'medium',
      category: json['category'] ?? 'General',
      tags: (json['tags'] as List?)?.map((t) => t.toString()).toList() ?? [],
      pinned: json['pinned'] == true,
      estimatedMinutes: json['estimatedMinutes'] is int
          ? json['estimatedMinutes']
          : (int.tryParse('${json['estimatedMinutes']}') ?? 0),
      actualMinutes: json['actualMinutes'] is int
          ? json['actualMinutes']
          : (int.tryParse('${json['actualMinutes']}') ?? 0),
      subtasks: (json['subtasks'] as List?)
              ?.map((s) => SubtaskModel.fromJson(s as Map<String, dynamic>))
              .toList() ??
          [],
      dueDate: json['dueDate'] != null ? DateTime.tryParse(json['dueDate']) : null,
      completedAt: json['completedAt'] != null ? DateTime.tryParse(json['completedAt']) : null,
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'completed': completed,
      'status': status,
      'priority': priority,
      'category': category,
      'tags': tags,
      'pinned': pinned,
      'estimatedMinutes': estimatedMinutes,
      'actualMinutes': actualMinutes,
      'subtasks': subtasks.map((s) => s.toJson()).toList(),
      'dueDate': dueDate?.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
    };
  }

  int get completedSubtasksCount => subtasks.where((s) => s.completed).length;

  double get subtasksProgress {
    if (subtasks.isEmpty) return 0.0;
    return completedSubtasksCount / subtasks.length;
  }

  TodoModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? completed,
    String? status,
    String? priority,
    String? category,
    List<String>? tags,
    bool? pinned,
    int? estimatedMinutes,
    int? actualMinutes,
    List<SubtaskModel>? subtasks,
    DateTime? dueDate,
    DateTime? completedAt,
    DateTime? createdAt,
  }) {
    return TodoModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      status: status ?? this.status,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      tags: tags ?? this.tags,
      pinned: pinned ?? this.pinned,
      estimatedMinutes: estimatedMinutes ?? this.estimatedMinutes,
      actualMinutes: actualMinutes ?? this.actualMinutes,
      subtasks: subtasks ?? this.subtasks,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
