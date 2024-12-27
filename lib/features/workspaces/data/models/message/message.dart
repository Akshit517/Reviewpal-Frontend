import '../../../domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    required super.id,
    required super.senderId,
    required super.senderName,
    required super.textContent,
    super.file,
    required super.createdAt,
    required super.channelId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int,
      senderId: json['sender'] as int,
      senderName: json['sender_name'] as String,
      textContent: json['text_content'] as String,
      file: json['file'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      channelId: json['channel'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender': senderId,
      'sender_name': senderName,
      'text_content': textContent,
      'file': file,
      'created_at': createdAt.toIso8601String(),
      'channel': channelId,
    };
  }

  static List<MessageModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MessageModel.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> toJsonList(List<MessageModel> messages) {
    return messages.map((message) => message.toJson()).toList();
  }
}
