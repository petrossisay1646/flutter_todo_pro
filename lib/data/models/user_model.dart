class UserModel {
  final String id;
  final String name;
  final String email;
  final int dailyGoal;
  final int pomodoroLength;
  final String avatarColor;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.dailyGoal = 5,
    this.pomodoroLength = 25,
    this.avatarColor = '#564CFF',
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? json['_id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      dailyGoal: json['dailyGoal'] is int ? json['dailyGoal'] : (int.tryParse('${json['dailyGoal']}') ?? 5),
      pomodoroLength: json['pomodoroLength'] is int ? json['pomodoroLength'] : (int.tryParse('${json['pomodoroLength']}') ?? 25),
      avatarColor: json['avatarColor'] ?? '#564CFF',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'dailyGoal': dailyGoal,
      'pomodoroLength': pomodoroLength,
      'avatarColor': avatarColor,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    int? dailyGoal,
    int? pomodoroLength,
    String? avatarColor,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      pomodoroLength: pomodoroLength ?? this.pomodoroLength,
      avatarColor: avatarColor ?? this.avatarColor,
    );
  }
}
