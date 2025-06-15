part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();

  @override
  List<Object> get props => [];
}

class GetPreviousChatEvent extends ChatEvent {
  final String workspaceId;
  final int categoryId;
  final String channelId;

  const GetPreviousChatEvent({
    required this.workspaceId,
    required this.categoryId,
    required this.channelId,
  });
}

class ConnectChatEvent extends ChatEvent {
  final String workspaceId;
  final int categoryId;
  final String channelId;

  const ConnectChatEvent({
    required this.workspaceId,
    required this.categoryId,
    required this.channelId,
  });
}

class SendMessageEvent extends ChatEvent {
  final String message;

  const SendMessageEvent({required this.message});
}

class DisconnectChatEvent extends ChatEvent {}

class _NewMessageReceived extends ChatEvent {
  final Message message;

  const _NewMessageReceived({required this.message});
}

class _ChatStreamError extends ChatEvent {
  final String error;

  const _ChatStreamError({required this.error});
}
