import 'dart:async';
import 'package:flutter/material.dart';

class Message {
  final String text;
  final Duration duration;
  final MessageType type;
  final bool blocking; // 新增：是否显示遮罩层

  Message({
    required this.text,
    this.duration = const Duration(seconds: 3),
    this.type = MessageType.info,
    this.blocking = false, // 默认不显示遮罩
  });
}

enum MessageType { info, success, warning, error }

class MessageProvider extends ChangeNotifier {
  Message? _currentMessage;
  Timer? _timer;

  Message? get currentMessage => _currentMessage;

  set currentMessage(Message? message) {
    _currentMessage = message;
    notifyListeners();
    
    _timer?.cancel();
    if (message != null) {
      _timer = Timer(message.duration, () {
        _currentMessage = null;
        notifyListeners();
      });
    }
  }

  void showMessage(
    String text, {
    Duration duration = const Duration(seconds: 3),
    MessageType type = MessageType.info,
    bool blocking = false, // 新增参数
  }) {
    currentMessage = Message(
      text: text,
      duration: duration,
      type: type,
      blocking: blocking,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}   