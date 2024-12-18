import '../../../auth/domain/entities/user_entity.dart';

class WorkspaceMember {
  final int id;
  final User user;
  final String role;

  const WorkspaceMember({
    required this.id,
    required this.user,
    required this.role,
  });
}