import 'dart:ffi';

import 'package:ReviewPal/features/workspaces/domain/entities/channel_entity.dart';

class Task {
    final String id;
    final String task;
    final String dueAt;

    Task({
        required this.id,
        required this.task,
        required this.dueAt
    });
}

class Assignment {
    final Channel channelId;
    final String description;
    final String forTeams;
    final Int maxPoints;    
    final String createdAt;
    final List<Task> tasks;

    Assignment({
        required this.channelId,
        required this.description,
        required this.forTeams,
        required this.maxPoints,
        required this.createdAt,
        required this.tasks
    });    
}