
enum MessageType { text, file }

class ChatMessage {
  final String sender;
  final String content;
  final String? messageId;
  final DateTime timestamp;
  final MessageType type;
  final String? fileName;  
  final String? fileUrl; 

  ChatMessage({
    required this.sender,
    required this.content,
    this.messageId,
    required this.timestamp,
    required this.type,
    this.fileName,
    this.fileUrl,
  });
}

class Message {
  final int id;
  final int senderId;
  final String senderName;
  final String? textContent;
  final String? file;
  final DateTime createdAt;
  final String channelId;

  Message({
    required this.id,
    required this.senderId,
    required this.senderName,
    this.textContent,
    this.file,
    required this.createdAt,
    required this.channelId,
  });
}