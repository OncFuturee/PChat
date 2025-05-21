import 'package:flutter/material.dart';
import 'global_message_widget.dart';

class AppWrapper extends StatelessWidget {
  final Widget child;

  const AppWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      // 使用LTR作为默认文本方向
      textDirection: TextDirection.ltr,
      child: Material(
        child: Stack(
          children: [
            child,
            Positioned.fill(
              child: GlobalMessageWidget(),
            ),
          ],
        ),
      ),
    );
  }
}    