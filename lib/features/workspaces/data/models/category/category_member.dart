import '../../../../auth/data/models/user_model.dart';
import '../../../domain/entities/category_member.dart';

class CategoryMemberModel extends CategoryMember {
  const CategoryMemberModel({
    required super.id,
    required UserModel super.user,
    required super.role,
  });

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
