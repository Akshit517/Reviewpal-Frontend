part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class ChatConnectEvent extends ChatEvent {
  final String workspaceId;
  final int categoryId;
  final String channelId;

  const ChatConnectEvent({
    required this.workspaceId,
    required this.categoryId,
    required this.channelId,
  });
}

class UpdateChatEvent extends ChatEvent {
  final String message;

  const UpdateChatEvent({required this.message});
}
