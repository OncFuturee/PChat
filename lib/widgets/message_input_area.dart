import 'package:flutter/material.dart';
import 'dart:io' show File; // 用于非 Web 平台的文件操作
import 'package:flutter/foundation.dart'; // 用于判断平台
import 'package:file_picker/file_picker.dart'; // 多平台文件选择器

// 消息输入区域组件
// 用于输入消息和选择文件的组件
class MessageInputArea extends StatefulWidget {
  final Function(String content, String? filePath, String? fileType, Uint8List? fileBytes) onSend;

  const MessageInputArea({super.key, required this.onSend});

  @override
  _MessageInputAreaState createState() => _MessageInputAreaState();
}

class _MessageInputAreaState extends State<MessageInputArea> {
  final TextEditingController _controller = TextEditingController();
  String? _selectedFilePath;
  String? _selectedFileType;
  Uint8List? _selectedFileBytes; // 用于 Web 平台的文件数据

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles();
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _selectedFilePath = kIsWeb ? null : file.path; // Web 平台没有路径
          _selectedFileType = file.extension;
          _selectedFileBytes = file.bytes; // Web 平台使用 bytes
        });
      }
    } catch (e) {
      print('Error picking file: $e'); // 打印错误日志
    }
  }

  void _clearFileSelection() {
    setState(() {
      _selectedFilePath = null;
      _selectedFileType = null;
      _selectedFileBytes = null;
    });
  }

  void _sendMessage() {
    final content = _controller.text.trim();
    if (content.isEmpty && _selectedFilePath == null && _selectedFileBytes == null) return;

    widget.onSend(content, _selectedFilePath, _selectedFileType, _selectedFileBytes);
    _controller.clear();
    _clearFileSelection();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_selectedFilePath != null || _selectedFileBytes != null)
          Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                if (_selectedFileType == 'jpg' ||
                    _selectedFileType == 'jpeg' ||
                    _selectedFileType == 'png')
                  kIsWeb
                      ? Image.memory(
                          _selectedFileBytes!,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : Image.file(
                          File(_selectedFilePath!),
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                else
                  const Icon(Icons.insert_drive_file, size: 50, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _selectedFilePath?.split('/').last ?? 'Selected File',
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.red),
                  onPressed: _clearFileSelection,
                ),
              ],
            ),
          ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.attach_file),
              onPressed: _pickFile,
            ),
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  hintText: 'Type a message...',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ],
    );
  }
}
