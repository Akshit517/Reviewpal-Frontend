import '../../../../auth/data/models/user_model.dart';
import '../../../domain/entities/workspace_entity.dart';

class WorkspaceModel extends Workspace {
  final Map<UserModel, String> memberStatus;

  WorkspaceModel({
    required String id,
    required String name,
    required String image,
    required this.memberStatus,
  }) : super(id: id, name: name, icon: image, memberStatus: memberStatus);

  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    Map<UserModel, String> members = {
      for (var member in json['members'])
        UserModel.fromJson(member['user']): member['role'],
    };

    return WorkspaceModel(
      id: json['id'],
      name: json['name'],
      image: json['icon'],
      memberStatus: members,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'members': memberStatus.entries
          .map((entry) => {
                'user': entry.key.toJson(),
                'role': entry.value,
              })
          .toList(),
    };
  }
}
