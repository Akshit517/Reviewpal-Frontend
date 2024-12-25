
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