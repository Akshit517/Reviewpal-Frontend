import '../../../domain/entities/task_entity.dart';

class TaskModel extends Task {
  const TaskModel({
    required String title,
    required String description,
    required DateTime dueDate,
    required int points,
  }) : super(
          title: title,
          description: description,
          dueDate: dueDate,
          points: points,
        );

  // From JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json['task'],
      description: json['description'],
      dueDate: DateTime.parse(json['due_date']),
      points: json['points'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'task': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'points': points,
    };
  }
}
