import 'package:flutter/material.dart';
import 'dart:io';

// 图片消息组件
// 用于显示图片消息的组件
class ImageMessageWidget extends StatelessWidget {
  final String imagePath;

  const ImageMessageWidget({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Image.file(
      File(imagePath),
      width: 150,
      height: 150,
      fit: BoxFit.cover,
    );
  }
}
