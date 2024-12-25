// lib/data/repositories/chat_repository_impl.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../../domain/entities/message.dart';
import '../../domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  WebSocketChannel? _channel;
  final _messageController = StreamController<ChatMessage>.broadcast();
  
  @override
  Future<void> connectToChannel(String workspaceId, String categoryId, String channelId) async {
    await disconnectFromChannel();


    final wsUrl = 'ws://your-backend/ws/chat/${workspaceId}_${categoryId}_$channelId/';
    _channel = WebSocketChannel.connect(Uri.parse(wsUrl));
    
    // Listen to incoming messages
    _channel?.stream.listen(
      (data) {
        final message = _parseMessage(data);
        if (message != null) {
          _messageController.add(message);
        }
      },
      onError: (error) {
        print('WebSocket error: $error');
        disconnectFromChannel();
      },
      onDone: () {
        print('WebSocket connection closed');
        disconnectFromChannel();
      },
    );
  }

  @override
  Future<void> disconnectFromChannel() async {
    await _channel?.sink.close();
    _channel = null;
  }

  @override
  Stream<ChatMessage> get messageStream => _messageController.stream;

  @override
  Future<void> sendMessage(String message) async {
    if (_channel == null) {
      throw Exception('Not connected to any channel');
    }
    
    final messageData = {
      'message': message,
    };
    _channel?.sink.add(jsonEncode(messageData));
  }

  @override
  Future<void> sendFile(File file) async {
    if (_channel == null) {
      throw Exception('Not connected to any channel');
    }

    // Read file as bytes
    final bytes = await file.readAsBytes();
    final base64Data = base64Encode(bytes);
    
    // Create header with file info
    final header = {
      'file_name': file.path.split('/').last,
    };
    
    final headerJson = jsonEncode(header);
    final headerBytes = utf8.encode(headerJson);
    final headerBase64 = base64Encode(headerBytes);
    
    final headerLength = headerBytes.length;
    final lengthBytes = ByteData(4)..setInt32(0, headerLength, Endian.big);
    final lengthBase64 = base64Encode(lengthBytes.buffer.asUint8List());
    
    final message = 'B' + lengthBase64 + headerBase64 + base64Data;
    
    _channel?.sink.add(message);
  }

  ChatMessage? _parseMessage(dynamic data) {
    try {
      final Map<String, dynamic> messageData = jsonDecode(data);
      
      if (messageData.containsKey('file_name')) {
        // This is a file message
        return ChatMessage(
          sender: messageData['sender'],
          content: 'Sent a file: ${messageData['file_name']}',
          messageId: messageData['message_id'],
          timestamp: DateTime.now(),
          type: MessageType.file,
          fileName: messageData['file_name'],
        );
      } else {
        // Regular text message
        return ChatMessage(
          sender: messageData['sender'],
          content: messageData['content'],
          messageId: messageData['message_id'],
          timestamp: DateTime.now(),
          type: MessageType.text,
        );
      }
    } catch (e) {
      print('Error parsing message: $e');
      return null;
    }
  }
}