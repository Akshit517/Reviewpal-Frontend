import 'package:ReviewPal/features/auth/domain/entities/user_entity.dart';

class Workspace {
  final String id;
  final String name;
  final String icon;
  final Map<User, String> memberStatus;

  Workspace(
      {required this.id,
      required this.name,
      required this.icon,
      required this.memberStatus});
}
