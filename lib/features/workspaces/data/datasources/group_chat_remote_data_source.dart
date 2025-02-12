import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
  Future<void> sendFile(String filePath, String fileName);
}

class GroupChatRemoteDataSourceImpl implements GroupChatRemoteDataSource {
  WebSocketChannel? _channel;
  final TokenHttpClient client;

  GroupChatRemoteDataSourceImpl({required this.client});

  @override
  Future<List<MessageModel>> getChannelMessages(
      String workspaceId, int categoryId, String channelId) async {
    final response = await client.get(
        '${AppConstants.baseUrl}/api/workspace/$workspaceId/categories/$categoryId/channels/$channelId/chat/');
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
      _channel = WebSocketChannel.connect(
        Uri.parse(
            'ws://10.81.34.27:8000/ws/group-chat/$workspaceId::$categoryId::$channelId/?token=$token'),
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
  Future<void> sendMessage(String message) async {
    try {
      _channel!.sink.add(json.encode({"message": message}));
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<void> sendFile(String filePath, String fileName) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      final base64File = base64Encode(bytes);

      final header = {
        'file_name': fileName,
      };

      final headerJson = json.encode(header);
      final headerBytes = utf8.encode(headerJson);
      final headerLength = headerBytes.length;
      final headerLengthBytes = ByteData(4)..setInt32(0, headerLength);

      final message =
          'B${base64Encode(headerLengthBytes.buffer.asUint8List())}${base64Encode(headerBytes)}$base64File';

      _channel!.sink.add(message);
    } catch (e) {
      throw ServerException();
    }
  }
}
