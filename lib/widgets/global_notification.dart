import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:collection'; // 添加导入

class GlobalNotification extends StatefulWidget {
  final int maxNotifications; // 同时显示的最大通知数

  const GlobalNotification({super.key, this.maxNotifications = 1});

  @override
  _GlobalNotificationState createState() => _GlobalNotificationState();

  // 静态变量，用于全局访问 GlobalKey
  static final GlobalKey<_GlobalNotificationState> globalKey =
      GlobalKey<_GlobalNotificationState>();

  // 静态方法，用于显示通知
  static void show(BuildContext context, String message) {
    final _GlobalNotificationState? state = globalKey.currentState;
    if (state != null) {
      state.addMessage(message);
    } else {
      print('GlobalNotification state is null. Ensure it is properly initialized.');
    }
  }
}

class _GlobalNotificationState extends State<GlobalNotification> {
  final Queue<String> _messageQueue = Queue<String>(); // 消息队列
  final List<String> _activeMessages = []; // 当前正在显示的消息
  final Duration _displayDuration = const Duration(seconds: 3); // 每条消息显示时间

  void addMessage(String message) {
    setState(() {
      _messageQueue.add(message);
    });
    _processQueue();
  }

  void _processQueue() {
    if (_activeMessages.length < widget.maxNotifications &&
        _messageQueue.isNotEmpty) {
      final message = _messageQueue.removeFirst();
      setState(() {
        _activeMessages.add(message);
      });

      // 定时移除消息
      Timer(_displayDuration, () {
        setState(() {
          _activeMessages.remove(message);
        });
        _processQueue(); // 继续处理队列
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 10, // 避开状态栏
      left: 10,
      right: 10,
      child: Column(
        children: _activeMessages.map((message) {
          return _buildAnimatedNotification(message);
        }).toList(),
      ),
    );
  }

  Widget _buildAnimatedNotification(String message) {
    return AnimatedOpacity(
      opacity: _activeMessages.contains(message) ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 300), // 淡入淡出动画时长
      child: _buildNotification(message),
    );
  }

  Widget _buildNotification(String message) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(10),
      constraints: BoxConstraints(
        minHeight: 20, // 设置最小高度，确保至少为字体的行高
        maxWidth: MediaQuery.of(context).size.width * 0.6, // 最大宽度为页面的 60%
      ),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 74, 169, 247),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14, // 调整字体大小
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () {
              setState(() {
                _activeMessages.remove(message);
              });
              _processQueue(); // 继续处理队列
            },
          ),
        ],
      ),
    );
  }
}
