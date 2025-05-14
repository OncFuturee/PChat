import 'package:flutter/material.dart';
import '../widgets/chat_message_list.dart';
import '../data_storage/data_repository.dart';
import '../widgets/message_input_area.dart';

class GroupChatScreen extends StatefulWidget {
  int groupIndex;

  GroupChatScreen({super.key, this.groupIndex = 0});

  @override
  _GroupChatScreenState createState() {
    return _GroupChatScreenState();
  }
}

class _GroupChatScreenState extends State<GroupChatScreen> {
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
        'group_${widget.groupIndex}',
      );
      setState(() {
        _messages = messages;
      });
    } catch (e) {
      print('Error loading group messages: $e');
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
        'group_${widget.groupIndex}',
        filePath,
        fileType,
        timestamp,
      );
    } else {
      await _dataRepository.saveTextMessage(
        'group_${widget.groupIndex}',
        content,
        timestamp,
      );
    }
    _loadMessages();
  }

  @override
  Widget build(BuildContext context) {
    final int groupIndex = ModalRoute.of(context)!.settings.arguments as int? ?? 0;
    widget.groupIndex = groupIndex; // 更新 groupIndex
    return Scaffold(
      appBar: AppBar(title: Text('Group ${widget.groupIndex + 1}')),
      body: Column(
        children: [
          Expanded(
            child: ChatMessageList(messages: _messages, isGroupChat: true),
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
        ],
      ),
    );
  }
}
