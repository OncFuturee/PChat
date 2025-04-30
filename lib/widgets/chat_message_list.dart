import 'package:flutter/material.dart';
import 'text_message_widget.dart';
import 'image_message_widget.dart';
import 'file_message_widget.dart';

class ChatMessageList extends StatelessWidget {
  final List<Map<String, dynamic>> messages; // 消息列表
  final bool isGroupChat; // 是否为群组聊天

  const ChatMessageList({
    super.key,
    required this.messages,
    this.isGroupChat = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        final isMe = message['isMe'] as bool? ?? false; // 确保 isMe 有默认值
        final senderName = message['senderName'] as String? ?? 'Me';
        final content = message['content'] as String;
        final timestamp = message['timestamp'] as String? ?? '12:00 PM';
        final type = message['type'] as String;

        Widget messageWidget;
        if (type == 'text') {
          messageWidget = TextMessageWidget(content: content);
        } else if (type == 'image') {
          messageWidget = ImageMessageWidget(imagePath: content);
        } else {
          messageWidget = FileMessageWidget(fileName: content.split('/').last, filePath: content);
        }

        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isMe)
                CircleAvatar(
                  child: Text(senderName[0]),
                ),
              if (isMe)
                const SizedBox(width: 40),
              Flexible(
                child: Column(
                  crossAxisAlignment:
                      isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isMe)
                          Text(
                            senderName,
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        if (!isMe) const SizedBox(width: 5),
                        Text(
                          timestamp,
                          style: const TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        if (isMe) const SizedBox(width: 5),
                        if (isMe)
                          const Text(
                            'Me',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: isMe ? Colors.blue[100] : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: messageWidget,
                    ),
                  ],
                ),
              ),
              if (isMe)
                CircleAvatar(
                  child: Text(senderName[0]),
                ),
            ],
          ),
        );
      },
    );
  }
}
