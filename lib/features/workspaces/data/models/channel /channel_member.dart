import '../../../../auth/data/models/user_model.dart';
import '../../../domain/entities/channel/channel_member.dart';

class ChannelMemberModel extends ChannelMember {
  const ChannelMemberModel({
    required super.id,
    required UserModel super.user,
    required super.role,
  });

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
