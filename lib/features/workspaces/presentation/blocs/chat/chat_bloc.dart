import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/error/failures.dart';
import '../../../domain/entities/message/message.dart';
import '../../../domain/usecases/chat/chat_usecase.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatUsecase chatUsecase;

  ChatBloc({
    required this.chatUsecase,
  }) : super(ChatInitialState()) {
    on<ChatConnectEvent>((event, emit) async {
      final result = await chatUsecase.getChannelMessages(
          event.workspaceId, event.categoryId, event.channelId);
      result.fold(
        (failure) => emit(ChatErrorState(error: failure.message)),
        (messages) => emit(ChatLoadedState(messages: messages)),
      );
      await emit.forEach<Either<Failure, Message>>(
        chatUsecase.connectToChat(
            event.workspaceId, event.categoryId, event.channelId),
        onData: (either) {
          return either.fold(
            (failure) => ChatErrorState(error: failure.message),
            (message) => ChatUpdatedState(message: message),
          );
        },
        onError: (error, stackTrace) {
          return ChatErrorState(error: error.toString());
        },
      );
    });

    on<UpdateChatEvent>((event, emit) async {
      // Handle sending a message
      final result = await chatUsecase.sendMessage(event.message);
      emit(result.fold(
        (failure) => ChatErrorState(error: failure.message),
        (_) => ChatSentState(),
      ));
    });
  }
}
