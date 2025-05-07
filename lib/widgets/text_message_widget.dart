import 'package:flutter/material.dart';

// 文本消息组件
// 用于显示文本消息的组件
class TextMessageWidget extends StatelessWidget {
  final String content;

  const TextMessageWidget({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: const TextStyle(fontSize: 16, color: Colors.black),
    );
  }
}
