import '../../../../auth/data/models/user_model.dart';
import '../../../domain/entities/workspace_member.dart';

class WorkspaceMemberModel extends WorkspaceMember {
  const WorkspaceMemberModel({
    required int id,
    required UserModel user,
    required String role,
  }) : super(id: id, user: user, role: role);

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