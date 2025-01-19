import 'package:ReviewPal/features/workspaces/data/models/channel%20/team.dart';

import '../../../../auth/data/models/user_model.dart';
import '../../../domain/entities/channel/channel_member.dart';

class ChannelMemberModel extends ChannelMember {
  const ChannelMemberModel(
      {required super.id,
      required UserModel super.user,
      required super.role,
      super.team});

  // From JSON
  factory ChannelMemberModel.fromJson(Map<String, dynamic> json) {
    return ChannelMemberModel(
      id: json['id'],
      user: UserModel.fromJson(json['user']),
      role: json['role'],
      team: json['team'] == null ? null : TeamModel.fromJson(json['team']),
    );
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': (user as UserModel).toJson(),
      'role': role,
      'team': team
    };
  }
}
