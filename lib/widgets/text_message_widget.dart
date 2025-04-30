import 'package:flutter/material.dart';

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
