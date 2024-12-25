import 'package:ReviewPal/features/workspaces/data/models/assignment/assignment.dart';
import 'package:ReviewPal/features/workspaces/domain/entities/channel_entity.dart';

class ChannelModel extends Channel {
  const ChannelModel({
    required super.id,
    required super.name,
    AssignmentModel? super.assignment,
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    return ChannelModel(
      id: json['id'],
      name: json['name'],
      assignment: json['assignment'] != null
          ? AssignmentModel.fromJson(json['assignment'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {'name': name};
    if (assignment != null && assignment is AssignmentModel) {
      data['assignment_data'] = (assignment as AssignmentModel).toJson();
    }
    return data;
  }
}