import '../../../auth/domain/entities/user_entity.dart';

class CategoryMember {
  final int id;
  final User user;
  final String role;

  const CategoryMember({
    required this.id,
    required this.user,
    required this.role,
  });
}