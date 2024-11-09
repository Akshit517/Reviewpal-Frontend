import 'package:ReviewPal/features/auth/domain/entities/user_entity.dart';

class Channel {
  final String id;
  final String name;
  final Map<User, String> members = {};

  Channel({required this.id, required this.name});
}
