abstract class ChatState {
  const ChatState();
}

class ChatInitial extends ChatState {}
class ChatConnecting extends ChatState {}
class ChatConnected extends ChatState {}
class ChatDisconnected extends ChatState {}
class ChatError extends ChatState {
  final String message;
  ChatError(this.message);
}