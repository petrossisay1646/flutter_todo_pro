class SubtaskModel {
  final String? id;
  final String title;
  final bool completed;

  SubtaskModel({
    this.id,
    required this.title,
    this.completed = false,
  });

  factory SubtaskModel.fromJson(Map<String, dynamic> json) {
    return SubtaskModel(
      id: json['_id'] ?? json['id'],
      title: json['title'] ?? '',
      completed: json['completed'] == true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) '_id': id,
      'title': title,
      'completed': completed,
    };
  }

  SubtaskModel copyWith({
    String? id,
    String? title,
    bool? completed,
  }) {
    return SubtaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
