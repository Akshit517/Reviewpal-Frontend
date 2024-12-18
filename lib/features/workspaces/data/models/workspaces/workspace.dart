import 'package:ReviewPal/features/auth/data/models/user_model.dart';

import '../../../domain/entities/workspace_entity.dart';

class WorkspaceModel extends Workspace {
  const WorkspaceModel({
    required String id,
    required String name,
    required String icon,
    required UserModel owner,
  }) : super(id: id, name: name, icon: icon, owner: owner);

  // From JSON
  factory WorkspaceModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceModel(
      id: json['id'],
      name: json['name'],
      icon: json['icon'],
      owner: UserModel.fromJson(json['owner']),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'owner': (owner as UserModel).toJson(),
    };
  }
}