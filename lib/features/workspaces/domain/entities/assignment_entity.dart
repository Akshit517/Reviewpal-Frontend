import 'package:ReviewPal/features/workspaces/domain/entities/task_entity.dart';

class Assignment {
  final String description;
  final bool forTeams;
  final int totalPoints;
  final List<Task> tasks;

  const Assignment({
    required this.description,
    required this.forTeams,
    required this.totalPoints,
    required this.tasks,
  });
}