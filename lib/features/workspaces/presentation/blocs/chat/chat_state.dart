part of 'chat_bloc.dart';

sealed class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object> get props => [];
}

class ChatInitialState extends ChatState {}

class ChatLoadedState extends ChatState {
  final List<Message> messages;

  const ChatLoadedState({required this.messages});
}

class ChatSentState extends ChatState {}

class ChatUpdatedState extends ChatState {
  final Message message;

  const ChatUpdatedState({required this.message});
}

class ChatErrorState extends ChatState {
  final String error;

  const ChatErrorState({required this.error});
}
