import 'package:ReviewPal/features/auth/domain/entities/user_entity.dart';
import 'package:ReviewPal/features/workspaces/domain/entities/workspace_entity.dart';

class Category {
  final int id;
  final String name;
  final Workspace workspace;
  final List<User> members;

  Category(this.members,
      {required this.id, required this.name, required this.workspace});
}
