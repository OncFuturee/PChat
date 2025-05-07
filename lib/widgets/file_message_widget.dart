import 'package:flutter/material.dart';

// 文件消息组件
// 用于显示文件消息的组件
class FileMessageWidget extends StatelessWidget {
  final String fileName;
  final String filePath;

  const FileMessageWidget({super.key, required this.fileName, required this.filePath});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.insert_drive_file, color: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            fileName,
            style: const TextStyle(fontSize: 16, color: Colors.black),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
