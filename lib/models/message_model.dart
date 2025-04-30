class MessageModel {
  final String id;
  final String senderId;
  final String content;
  final DateTime timestamp;

  MessageModel({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
  });
}
