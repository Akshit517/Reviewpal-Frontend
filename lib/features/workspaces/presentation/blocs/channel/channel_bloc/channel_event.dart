part of 'channel_bloc.dart';

sealed class ChannelEvent extends Equatable {
  const ChannelEvent();

  @override
  List<Object> get props => [];
}

class GetChannelsEvent extends ChannelEvent {
  final String workspaceId;
  final int categoryId;

  const GetChannelsEvent({required this.workspaceId, required this.categoryId});
}

class CreateChannelEvent extends ChannelEvent {
  final String workspaceId;
  final int categoryId;
  final String name;
  final Assignment assignment;

  const CreateChannelEvent({
    required this.workspaceId,
    required this.categoryId,
    required this.name,
    required this.assignment,
  });
}

class UpdateChannelEvent extends ChannelEvent {
  final String workspaceId;
  final int categoryId;
  final String channelId;
  final String? name;
  final Assignment? assignment;

  const UpdateChannelEvent({
    required this.workspaceId,
    required this.categoryId,
    required this.channelId,
    this.name,
    this.assignment,
  });
}

class DeleteChannelEvent extends ChannelEvent {
  final String workspaceId;
  final int categoryId;
  final String channelId;

  const DeleteChannelEvent({
    required this.workspaceId,
    required this.categoryId,
    required this.channelId,
  });
}
