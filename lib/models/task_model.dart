// lib/models/task_model.dart

/// Model Task untuk mewakili data dari API
class Task {
  final int userId;
  final int id;
  String title;
  bool completed;

  Task({
    required this.userId,
    required this.id,
    required this.title,
    required this.completed,
  });

  /// Factory constructor untuk parsing JSON ke objek Task
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      userId: json['userId'] as int,
      id: json['id'] as int,
      title: json['title'] as String,
      completed: json['completed'] as bool,
    );
  }

  /// Convert Task menjadi JSON (untuk POST/PUT)
  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'id': id,
      'title': title,
      'completed': completed,
    };
  }

   /// Method copyWith
  /// Memudahkan membuat salinan Task sambil mengubah field tertentu saja.
  Task copyWith({
    int? userId,
    int? id,
    String? title,
    bool? completed,
  }) {
    return Task(
      userId: userId ?? this.userId,
      id: id ?? this.id,
      title: title ?? this.title,
      completed: completed ?? this.completed,
    );
  }
}
