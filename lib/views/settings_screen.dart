import 'package:flutter/material.dart';

// 设置页面
// 用于显示应用的设置选项
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: const Center(
        child: Text('Settings Page'),
      ),
    );
  }
}
