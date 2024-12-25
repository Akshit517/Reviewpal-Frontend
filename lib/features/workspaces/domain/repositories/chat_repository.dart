
import 'dart:io';

import '../entities/message.dart';

abstract class ChatRepository {
  Future<void> connectToChannel(String workspaceId, String categoryId, String channelId);
  Future<void> disconnectFromChannel();
  Stream<ChatMessage> get messageStream;
  Future<void> sendMessage(String message);
  Future<void> sendFile(File file);
}