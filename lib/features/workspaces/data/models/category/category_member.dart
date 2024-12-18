import '../../../../auth/data/models/user_model.dart';
import '../../../domain/entities/category_member.dart';

class CategoryMemberModel extends CategoryMember {
  const CategoryMemberModel({
    required int id,
    required UserModel user,
    required String role,
  }) : super(id: id, user: user, role: role);

  // From JSON
  factory CategoryMemberModel.fromJson(Map<String, dynamic> json) {
    return CategoryMemberModel(
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
