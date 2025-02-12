class Message {
  final int id;
  final String senderName;
  final String senderEmail;
  final String content;
  final String channelId;

  Message({
    required this.id,
    required this.senderName,
    required this.senderEmail,
    required this.content,
    required this.channelId,
  });
}
