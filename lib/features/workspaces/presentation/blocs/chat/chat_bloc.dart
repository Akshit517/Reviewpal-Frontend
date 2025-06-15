import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/message/message.dart';
import '../../../domain/usecases/chat/chat_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatUsecase chatUsecase;
  StreamSubscription<Either<Failure, Message>>? _chatSubscription;

  ChatBloc({
    required this.chatUsecase,
  }) : super(const ChatState()) {
    on<GetPreviousChatEvent>(_onGetPreviousChat);
    on<ConnectChatEvent>(_onConnectChat);
    on<SendMessageEvent>(_onSendMessage);
    on<DisconnectChatEvent>(_onDisconnectChat);
    on<_NewMessageReceived>(_onNewMessageReceived);
    on<_ChatStreamError>(_onChatStreamError);
  }

  Future<void> _onGetPreviousChat(
    GetPreviousChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    emit(state.copyWith(status: ChatStatus.loading, error: null));

    final result = await chatUsecase.getChannelMessages(
      event.workspaceId,
      event.categoryId,
      event.channelId,
    );

    result.fold(
      (failure) => emit(
          state.copyWith(status: ChatStatus.failure, error: failure.message)),
      (messages) {
        emit(state.copyWith(
          status: ChatStatus.initial,
          messages: messages,
        ));

        add(ConnectChatEvent(
          workspaceId: event.workspaceId,
          categoryId: event.categoryId,
          channelId: event.channelId,
        ));
      },
    );
  }

  Future<void> _onConnectChat(
    ConnectChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    await _safeDisconnect();

    try {
      final stream = chatUsecase.connectToChat(
        event.workspaceId,
        event.categoryId,
        event.channelId,
      );

      emit(state.copyWith(status: ChatStatus.connected));

      _chatSubscription = stream.listen(
        (eitherMessage) {
          eitherMessage.fold(
            (failure) => add(_ChatStreamError(error: failure.message)),
            (message) => add(_NewMessageReceived(message: message)),
          );
        },
        onError: (error) {
          add(_ChatStreamError(error: error.toString()));
        },
        onDone: () {
          if (!isClosed) {
            emit(state.copyWith(status: ChatStatus.disconnected));
          }
        },
      );
    } catch (e) {
      emit(state.copyWith(status: ChatStatus.failure, error: e.toString()));
    }
  }

  void _onNewMessageReceived(
      _NewMessageReceived event, Emitter<ChatState> emit) {
    final updatedMessages = List<Message>.from(state.messages)
      ..add(event.message);
    emit(state.copyWith(
      messages: updatedMessages,
      status: ChatStatus.connected,
      error: null,
    ));
  }

  void _onChatStreamError(_ChatStreamError event, Emitter<ChatState> emit) {
    emit(state.copyWith(status: ChatStatus.failure, error: event.error));
  }

  Future<void> _onSendMessage(
    SendMessageEvent event,
    Emitter<ChatState> emit,
  ) async {
    if (state.status != ChatStatus.connected) {
      emit(state.copyWith(
          status: ChatStatus.failure,
          error: "Cannot send message: Not connected to chat."));
      return;
    }

    final result = await chatUsecase.sendMessage(event.message);
    result.fold(
      (failure) {
        emit(state.copyWith(
            status: ChatStatus.failure,
            error: "Failed to send message: ${failure.message}"));
        emit(state.copyWith(status: ChatStatus.connected));
      },
      (_) {},
    );
  }

  Future<void> _onDisconnectChat(
    DisconnectChatEvent event,
    Emitter<ChatState> emit,
  ) async {
    await _safeDisconnect();
    emit(const ChatState(status: ChatStatus.disconnected));
  }

  Future<void> _safeDisconnect() async {
    try {
      await chatUsecase.disconnectChat();
      await _chatSubscription?.cancel();
      _chatSubscription = null;
    } catch (e) {
      debugPrint('Error during chat disconnect teardown: $e');
    }
  }

  @override
  Future<void> close() async {
    await _safeDisconnect();
    await super.close();
  }
}
