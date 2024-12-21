
import 'package:ReviewPal/features/workspaces/data/models/assignment/task.dart';

import '../../../domain/entities/assignment_entity.dart';

class AssignmentModel extends Assignment {
  const AssignmentModel({
    required super.description,
    required super.forTeams,
    required super.totalPoints,
    required List<TaskModel> super.tasks,
  });

  // From JSON
  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      description: json['description'],
      forTeams: json['for_teams'],
      totalPoints: json['total_points'],
      tasks: List<TaskModel>.from(
        json['tasks'].map((task) => TaskModel.fromJson(task)),
      ),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'for_teams': forTeams,
      'total_points': totalPoints,
      'tasks': tasks.map((task) => (task as TaskModel).toJson()).toList(),
    };
  }

  Assignment toEntity() {
    return Assignment(
      description: description,
      forTeams: false, //for teams missing impl
      tasks: tasks,
      totalPoints: totalPoints,
    );
  }
}