import '../../../domain/entities/message/message.dart';

class MessageModel extends Message {
  MessageModel({
    required super.id,
    required super.senderName,
    required super.senderEmail,
    required super.content,
    // super.file,
    // required super.createdAt,
    required super.channelId,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] as int,
      senderEmail: json['sender_email'] as String,
      senderName: json['sender_name'] as String,
      content: json['content'] as String,
      channelId: json['channel'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_name': senderName,
      'sender_email': senderEmail,
      'content': content,
      // 'file': file,
      // 'created_at': createdAt.toIso8601String(),
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
