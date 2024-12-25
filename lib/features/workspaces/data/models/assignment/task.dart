import '../../../domain/entities/task_entity.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.title,
    required super.description,
    required super.dueDate,
  });

  // From JSON
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      title: json['task'],
      description: json['description'] ?? '',
      dueDate: DateTime.parse(json['due_date']),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'task': title,
      'description': description,
      'due_date': dueDate,
    };
  }
}
