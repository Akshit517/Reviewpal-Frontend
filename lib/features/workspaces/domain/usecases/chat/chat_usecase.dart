import 'package:ReviewPal/features/workspaces/domain/repositories/chat_repository.dart';
import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../entities/message/message.dart';

class ChatUsecase {
  final ChatRepository repository;

  ChatUsecase({required this.repository});

  Stream<Either<Failure, Message>> connectToChat(
      String workspaceId, int categoryId, String channelId) {
    return repository.connectToChat(workspaceId, categoryId, channelId);
  }

  Future<Either<Failure, List<Message>>> getChannelMessages(
      String workspaceId, int categoryId, String channelId) {
    return repository.getChannelMessages(workspaceId, categoryId, channelId);
  }

  Future<Either<Failure, void>> sendMessage(String message) {
    return repository.sendMessage(message);
  }

  // Future<Either<Failure, void>> sendFile(String filePath, String fileName) {
  //   return repository.sendFile(filePath, fileName);
  // }
}
