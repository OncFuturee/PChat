import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:collection';

class Message {
  final String text;
  final Duration duration;
  final MessageType type;
  final bool blocking; // 是否显示遮罩层
  bool shouldShow; // 是否显示消息

  Message({
    required this.text,
    this.duration = const Duration(seconds: 2), // 默认2秒
    this.type = MessageType.info, // 默认信息类型
    this.blocking = false, // 默认不显示遮罩
    this.shouldShow = true, // 默认显示消息
  });
}

enum MessageType { info, success, warning, error }

class MessageProvider extends ChangeNotifier {
  final Queue<Message> _messageQueue = Queue<Message>();
  Message? _currentMessage;
  Timer? _timer;

  Message? get currentMessage => _currentMessage;
  
  // 获取队列中的消息数量
  int get queueLength => _messageQueue.length;

  // 添加消息到队列
  void addMessage(Message message) {
    _messageQueue.add(message);
    // 如果当前没有显示消息，则开始处理队列
    if (_timer?.isActive != true) {
      _showNextMessage();
      return;
    }
    notifyListeners();
  }

  // 快捷方法：显示普通消息
  void showInfo(String text, {Duration? duration, bool blocking = false}) {
    addMessage(Message(
      text: text,
      duration: duration ?? const Duration(seconds: 3),
      type: MessageType.info,
      blocking: blocking,
    ));
  }

  // 快捷方法：显示成功消息
  void showSuccess(String text, {Duration? duration, bool blocking = false}) {
    addMessage(Message(
      text: text,
      duration: duration ?? const Duration(seconds: 3),
      type: MessageType.success,
      blocking: blocking,
    ));
  }

  // 快捷方法：显示警告消息
  void showWarning(String text, {Duration? duration, bool blocking = false}) {
    addMessage(Message(
      text: text,
      duration: duration ?? const Duration(seconds: 3),
      type: MessageType.warning,
      blocking: blocking,
    ));
  }

  // 快捷方法：显示错误消息
  void showError(String text, {Duration? duration, bool blocking = false}) {
    addMessage(Message(
      text: text,
      duration: duration ?? const Duration(seconds: 3),
      type: MessageType.error,
      blocking: blocking,
    ));
  }

  // 显示队列中的下一条消息
  void _showNextMessage() {
    // 如果没有消息，直接返回
    if (_messageQueue.isEmpty) {
      notifyListeners();
      return;
    }
    
    _currentMessage = _messageQueue.removeFirst();
    notifyListeners();
    
    _timer = Timer(_currentMessage!.duration, () {
      // 当前消息显示时间结束，处理下一条
      _currentMessage?.shouldShow = false; // 设置当前消息不显示
      _showNextMessage();
    });
  }

  // 手动关闭当前消息
  void closeCurrentMessage() {
    _timer?.cancel();
    _currentMessage?.shouldShow = false; // 设置当前消息不显示
    _showNextMessage();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}