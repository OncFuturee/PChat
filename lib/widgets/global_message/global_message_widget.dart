import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'message_provider.dart';

class GlobalMessageWidget extends StatefulWidget {

  const GlobalMessageWidget({super.key});

  @override
  State<GlobalMessageWidget> createState() => _GlobalMessageWidgetState();
}

class _GlobalMessageWidgetState extends State<GlobalMessageWidget>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> positionAnimation;

  @override
  void initState() {
    super.initState();
    
    // 初始化动画控制器
    animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this, // 使用当前 State 作为 vsync
    );
    
    // 初始化动画
    positionAnimation = Tween<double>(
      begin: -100, // 屏幕顶部外
      end: 20,     // 目标位置
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    ));
  }

  @override
  void dispose() {
    animationController.dispose(); // 释放资源
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<MessageProvider>(context, listen: true);
    final message = provider.currentMessage;

    if (message == null) {
      return const SizedBox.shrink();
    }

    // 控制动画播放
    if (message.shouldShow) {
      animationController.forward();
    } else if(!message.shouldShow && animationController.isCompleted) {
      animationController.reverse();
    }

    return Stack(
      children: [
        if (message.blocking)
          Positioned.fill(
            child: GestureDetector(
              onTap: () {},
              behavior: HitTestBehavior.opaque,
              child: Container(color: Colors.transparent),
            ),
          ),
        AnimatedBuilder(
          animation: positionAnimation,
          builder: (context, child) {
            return Positioned(
              top: positionAnimation.value,
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
                              context.read<MessageProvider>().closeCurrentMessage();
                            },
                          ),
                          if (provider.queueLength > 0)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.white.withAlpha(100),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '${provider.queueLength}',
                                style: const TextStyle(color: Colors.white, fontSize: 12),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
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