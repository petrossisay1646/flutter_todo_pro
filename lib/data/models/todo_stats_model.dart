class DayStatModel {
  final String label;
  final String date;
  final int count;

  DayStatModel({
    required this.label,
    required this.date,
    required this.count,
  });

  factory DayStatModel.fromJson(Map<String, dynamic> json) {
    return DayStatModel(
      label: json['label'] ?? '',
      date: json['date'] ?? '',
      count: json['count'] is int ? json['count'] : (int.tryParse('${json['count']}') ?? 0),
    );
  }
}

class TodoStatsModel {
  final int total;
  final int completed;
  final int active;
  final int inProgress;
  final int overdue;
  final int highPriority;
  final int urgentPriority;
  final int streak;
  final int totalEstimated;
  final int totalActual;
  final Map<String, int> categories;
  final Map<String, int> tags;
  final List<DayStatModel> last7Days;

  TodoStatsModel({
    this.total = 0,
    this.completed = 0,
    this.active = 0,
    this.inProgress = 0,
    this.overdue = 0,
    this.highPriority = 0,
    this.urgentPriority = 0,
    this.streak = 0,
    this.totalEstimated = 0,
    this.totalActual = 0,
    this.categories = const {},
    this.tags = const {},
    this.last7Days = const [],
  });

  factory TodoStatsModel.fromJson(Map<String, dynamic> json) {
    final catMap = <String, int>{};
    if (json['categories'] is Map) {
      (json['categories'] as Map).forEach((k, v) {
        catMap[k.toString()] = v is int ? v : (int.tryParse('$v') ?? 0);
      });
    }

    final tagMap = <String, int>{};
    if (json['tags'] is Map) {
      (json['tags'] as Map).forEach((k, v) {
        tagMap[k.toString()] = v is int ? v : (int.tryParse('$v') ?? 0);
      });
    }

    final days = <DayStatModel>[];
    if (json['last7Days'] is List) {
      for (final item in json['last7Days'] as List) {
        if (item is Map<String, dynamic>) {
          days.add(DayStatModel.fromJson(item));
        }
      }
    }

    return TodoStatsModel(
      total: json['total'] is int ? json['total'] : (int.tryParse('${json['total']}') ?? 0),
      completed: json['completed'] is int ? json['completed'] : (int.tryParse('${json['completed']}') ?? 0),
      active: json['active'] is int ? json['active'] : (int.tryParse('${json['active']}') ?? 0),
      inProgress: json['inProgress'] is int ? json['inProgress'] : (int.tryParse('${json['inProgress']}') ?? 0),
      overdue: json['overdue'] is int ? json['overdue'] : (int.tryParse('${json['overdue']}') ?? 0),
      highPriority: json['highPriority'] is int ? json['highPriority'] : (int.tryParse('${json['highPriority']}') ?? 0),
      urgentPriority: json['urgentPriority'] is int ? json['urgentPriority'] : (int.tryParse('${json['urgentPriority']}') ?? 0),
      streak: json['streak'] is int ? json['streak'] : (int.tryParse('${json['streak']}') ?? 0),
      totalEstimated: json['totalEstimated'] is int ? json['totalEstimated'] : (int.tryParse('${json['totalEstimated']}') ?? 0),
      totalActual: json['totalActual'] is int ? json['totalActual'] : (int.tryParse('${json['totalActual']}') ?? 0),
      categories: catMap,
      tags: tagMap,
      last7Days: days,
    );
  }

  double get completionRate => total > 0 ? (completed / total) * 100 : 0.0;
}
