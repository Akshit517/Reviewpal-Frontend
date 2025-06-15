import 'dart:convert';

import 'package:ReviewPal/core/constants/constants.dart';
import 'package:ReviewPal/core/infrastructure/http/token_http_client.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../../../core/error/exceptions.dart';
import '../models/message/message.dart';

abstract class GroupChatRemoteDataSource {
  Future<List<MessageModel>> getChannelMessages(
      String workspaceId, int categoryId, String channelId);

  Stream<MessageModel> connectToChat(
      String workspaceId, int categoryId, String channelId, String token);
  Future<void> sendMessage(String message);
  Future<void> disconnectChat();
}

class GroupChatRemoteDataSourceImpl implements GroupChatRemoteDataSource {
  WebSocketChannel? _channel;
  final TokenHttpClient client;

  GroupChatRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MessageModel>> getChannelMessages(
      String workspaceId, int categoryId, String channelId) async {
    final response = await client.get(
        '${AppConstants.baseUrl}api/workspaces/$workspaceId/categories/$categoryId/channels/$channelId/chat/');
    if (response.statusCode == 200) {
      final List<dynamic> jsonList = json.decode(response.body);
      return MessageModel.fromJsonList(jsonList);
    } else if (response.statusCode == 401) {
      throw UnAuthorizedException();
    } else {
      throw ServerException();
    }
  }

  @override
  Stream<MessageModel> connectToChat(
      String workspaceId, int categoryId, String channelId, String token) {
    try {
      disconnectChat();
      _channel = WebSocketChannel.connect(
        Uri.parse(
            '${AppConstants.webSocketUrl}ws/group-chat/${workspaceId}_${categoryId}_$channelId/?token=$token'),
      );
      return _channel!.stream.map((message) {
        final decoded = json.decode(message);
        return MessageModel.fromJson(decoded);
      });
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> disconnectChat() async {
    try {
      _channel?.sink.close();
      _channel = null;
      return Future.value();
    } catch (e) {
      if (e is! WebSocketChannelException) {
        throw ServerException();
      }
    }
  }

  @override
  Future<void> sendMessage(String message) async {
    try {
      _channel!.sink.add(json.encode({"content": message}));
    } catch (e) {
      throw ServerException();
    }
  }
}
