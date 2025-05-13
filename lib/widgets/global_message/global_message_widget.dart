import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'message_provider.dart';

class GlobalMessageWidget extends StatelessWidget {
  const GlobalMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final message = context.watch<MessageProvider>().currentMessage;

    if (message == null) {
      return const SizedBox.shrink();
    }

    return Stack(
      children: [
        // 根据blocking参数决定是否显示遮罩层
        if (message.blocking)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {}, // 空实现，拦截点击事件
              behavior: HitTestBehavior.opaque,
              child: Container(
                color: Colors.transparent, // 透明背景
              ),
            ),
          ),
        // 消息框居中显示
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          top: message == null ? -100 : 160,
          left: 0,
          right: 0,
          child: Center(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _getMessageColor(message.type),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _getMessageIcon(message.type),
                      const SizedBox(width: 12),
                      Flexible(
                        child: Text(
                          message.text,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          context.read<MessageProvider>().currentMessage = null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Color _getMessageColor(MessageType type) {
    switch (type) {
      case MessageType.info:
        return Colors.blue;
      case MessageType.success:
        return Colors.green;
      case MessageType.warning:
        return Colors.orange;
      case MessageType.error:
        return Colors.red;
    }
  }

  Widget _getMessageIcon(MessageType type) {
    switch (type) {
      case MessageType.info:
        return const Icon(Icons.info_outline, color: Colors.white, size: 24);
      case MessageType.success:
        return const Icon(Icons.check_circle_outline, color: Colors.white, size: 24);
      case MessageType.warning:
        return const Icon(Icons.warning, color: Colors.white, size: 24);
      case MessageType.error:
        return const Icon(Icons.error_outline, color: Colors.white, size: 24);
    }
  }
}