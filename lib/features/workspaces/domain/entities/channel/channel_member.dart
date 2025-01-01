
import '../../../../auth/domain/entities/user_entity.dart';

class ChannelMember {
  final int id;
  final User user;
  final String role;

  const ChannelMember({
    required this.id,
    required this.user,
    required this.role,
  });
}