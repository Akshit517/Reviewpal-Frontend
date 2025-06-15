part of 'chat_bloc.dart';

enum ChatStatus { initial, loading, connected, disconnected, failure }

class ChatState extends Equatable {
  final ChatStatus status;
  final List<Message> messages;
  final String? error;

  const ChatState({
    this.status = ChatStatus.initial,
    this.messages = const [],
    this.error,
  });

  ChatState copyWith({
    ChatStatus? status,
    List<Message>? messages,
    String? error,
  }) {
    return ChatState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, messages, error];
}
