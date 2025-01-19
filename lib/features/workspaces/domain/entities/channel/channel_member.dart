import '../../../../auth/domain/entities/user_entity.dart';
import 'team.dart';

class ChannelMember {
  final int id;
  final User user;
  final Team? team;
  final String role;

  const ChannelMember(
      {required this.id, required this.user, required this.role, this.team});
}
