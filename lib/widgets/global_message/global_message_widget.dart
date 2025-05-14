import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'message_provider.dart';

class GlobalMessageWidget extends StatelessWidget {
  const GlobalMessageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MessageProvider>();
    final message = provider.currentMessage;

    if (message == null) {
      return const SizedBox.shrink();
    }

    // 计算动画偏移量 - 从屏幕顶部外到目标位置
    final bool isLastMessage = provider.queueLength == 0;
    final double startOffset = -100; // 初始位置在屏幕顶部外
    final double endOffset = 20;     // 最终位置在屏幕内顶部

    // 创建动画控制器和动画
    final AnimationController animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: ScaffoldMessenger.of(context),
    );

    final Animation<double> positionAnimation = Tween<double>(
      begin: startOffset,
      end: endOffset,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: isLastMessage ? Curves.easeIn : Curves.easeOut,
      reverseCurve: isLastMessage ? Curves.easeOut : Curves.easeIn,
    ));

    // 控制动画播放
    if (message.isNew) {
      // 新消息开始动画
      animationController.forward();
      // 标记消息为已显示
      WidgetsBinding.instance.addPostFrameCallback((_) {
        provider.markMessageAsShown();
      });
    } else if (isLastMessage) {
      // 最后一条消息反向播放动画
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
        // 使用AnimatedBuilder应用动画
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
                                color: Colors.white.withOpacity(0.2),
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