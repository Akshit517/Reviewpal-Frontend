
import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entities/message/message.dart';

abstract class ChatRepository {
  Stream<Either<Failure, Message>> connectToChat(
    String workspaceId,
    int categoryId,
    String channelId
  );
  Future<Either<Failure, void>> sendMessage(String message);
  Future<Either<Failure, void>> sendFile(String filePath, String fileName);

  Future<Either<Failure, List<Message>>> getChannelMessages(String workspaceId, int categoryId, String channelId);
}