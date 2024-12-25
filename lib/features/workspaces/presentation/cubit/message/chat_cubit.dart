import 'dart:async';
import 'dart:io';

import 'package:ReviewPal/features/workspaces/presentation/cubit/message/chat_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/repositories/chat_repository.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  StreamSubscription? _messageSubscription;

  ChatCubit(this._chatRepository) : super(ChatInitial());

  Future<void> connectToChannel(String workspaceId, String categoryId, String channelId) async {
    try {
      emit(ChatConnecting());
      await _chatRepository.connectToChannel(workspaceId, categoryId, channelId);
      emit(ChatConnected());
      
      // Listen to messages
      _messageSubscription = _chatRepository.messageStream.listen(
        (message) {
          // Handle message (you might want to create another state for messages)
          print('Received message: ${message.content}');
        },
        onError: (error) {
          emit(ChatError(error.toString()));
        },
      );
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  Future<void> disconnectFromChannel() async {
    try {
      await _messageSubscription?.cancel();
      _messageSubscription = null;
      await _chatRepository.disconnectFromChannel();
      emit(ChatDisconnected());
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }

  @override
  Future<void> close() async {
    await disconnectFromChannel();
    return super.close();
  }

  Future<void> sendFile(File file) async {
    try {
      await _chatRepository.sendFile(file);
    } catch (e) {
      emit(ChatError(e.toString()));
    }
  }
}