import 'package:flutter/material.dart';
import '../widgets/chat_message_list.dart';
import '../data_storage/data_repository.dart';
import '../widgets/message_input_area.dart';

class ChatScreen extends StatefulWidget {
  int chatIndex;

  ChatScreen({super.key, this.chatIndex = 0});

  @override
  _ChatScreenState createState() {
    return _ChatScreenState();
  }
}

class _ChatScreenState extends State<ChatScreen> {
  final DataRepository _dataRepository = DataRepository(); // 使用工厂方法
  List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    try {
      final messages = await _dataRepository.getMessages(
        widget.chatIndex.toString(),
      );
      setState(() {
        _messages = messages;
      });
    } catch (e) {
      print('Error loading messages: $e');
    }
  }

  void _handleSendMessage(
    String content,
    String? filePath,
    String? fileType,
  ) async {
    final timestamp = DateTime.now().toIso8601String();
    if (filePath != null && fileType != null) {
      await _dataRepository.saveFileMessage(
        widget.chatIndex.toString(),
        filePath,
        fileType,
        timestamp,
      );
    } else {
      await _dataRepository.saveTextMessage(
        widget.chatIndex.toString(),
        content,
        timestamp,
      );
    }
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    final int chatIndex = ModalRoute.of(context)!.settings.arguments as int? ?? 0;
    widget.chatIndex = chatIndex; // 更新 chatIndex
    return Scaffold(
      appBar: AppBar(title: Text('Chat ${widget.chatIndex}')),
      body: Column(
        children: [
          Expanded(
            child: ChatMessageList(messages: _messages, isGroupChat: false),
          ),
          MessageInputArea(
            onSend: (content, filePath, fileType, fileBytes) {
              if (fileBytes != null) {
                // 处理 Web 平台的文件数据
                print(
                  'File selected on Web: $fileType, ${fileBytes.length} bytes',
                );
              } else if (filePath != null) {
                // 处理非 Web 平台的文件路径
                print('File selected on non-Web: $fileType, $filePath');
              }
              print('Message content: $content');
            },
          ),
          const SizedBox(height: 10),// 添加间距
        ],
      ),
    );
  }
}
