import '../../../../auth/data/models/user_model.dart';
import '../../../domain/entities/channel_member.dart';

class ChannelMemberModel extends ChannelMember {
  const ChannelMemberModel({
    required int id,
    required UserModel user,
    required String role,
  }) : super(id: id, user: user, role: role);

  // From JSON
  factory ChannelMemberModel.fromJson(Map<String, dynamic> json) {
    return ChannelMemberModel(
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
