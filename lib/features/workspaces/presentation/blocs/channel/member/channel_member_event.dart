part of 'channel_member_bloc.dart';

sealed class ChannelMemberEvent extends Equatable {
  const ChannelMemberEvent();

  @override
  List<Object> get props => [];
}

class GetChannelMembersEvent extends ChannelMemberEvent {
  final String workspaceId;
  final int categoryId;
  final String channelId;

  const GetChannelMembersEvent({required this.workspaceId, required this.categoryId, required this.channelId});
}
class AddChannelMemberEvent extends ChannelMemberEvent {
  final String workspaceId;
  final int categoryId;
  final String channelId;
  final String userEmail;
  final String role;

  const AddChannelMemberEvent({required this.role,required this.userEmail, required this.workspaceId, required this.categoryId, required this.channelId});
}

class RemoveChannelMemberEvent extends ChannelMemberEvent {
  final String workspaceId;
  final int categoryId;
  final String channelId;
  final String userEmail;

  const RemoveChannelMemberEvent({required this.userEmail, required this.workspaceId, required this.categoryId, required this.channelId});
}

class UpdateChannelMemberEvent extends ChannelMemberEvent {
  final String workspaceId;
  final int categoryId;
  final String channelId;
  final String userEmail;
  final String role;
  const UpdateChannelMemberEvent({required this.userEmail, required this.role, required this.workspaceId, required this.categoryId, required this.channelId});
}
