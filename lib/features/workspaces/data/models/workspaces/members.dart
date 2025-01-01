import '../../../../auth/data/models/user_model.dart';
import '../../../domain/entities/workspace/workspace_member.dart';

class WorkspaceMemberModel extends WorkspaceMember {
  const WorkspaceMemberModel({
    required super.id,
    required UserModel super.user,
    required super.role,
  });

  // From JSON
  factory WorkspaceMemberModel.fromJson(Map<String, dynamic> json) {
    return WorkspaceMemberModel(
      id: json['id'],
      user: UserModel.fromJson(json['user']),
      role: json['role'],
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': (user as UserModel).toJson(),
      'role': role,
    };
  }
}