import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart'; // 添加导入
import 'package:pchat/widgets/global_message/message_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // 添加导入
import 'package:flutter/foundation.dart'; // 添加导入
import 'views/home_screen.dart';
import 'package:provider/provider.dart';
import 'widgets/global_message/app_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 Hive
  await Hive.initFlutter();

  // 初始化 sqflite_common_ffi，仅在非 Web 平台上
  if (!kIsWeb) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi; // 设置 databaseFactory
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MessageProvider()),
      ],
      child: const ChatApp(),
    ),
  );
}

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppWrapper(
      child:MaterialApp(
      title: 'Chat App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Stack(
        clipBehavior: Clip.none, // 确保超出范围的组件不会被裁剪
        children: [
          const HomeScreen(), // 主页面
        ],
      ),
    ),
    );
  }
}
