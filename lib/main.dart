import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:pchat/widgets/global_message/message_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:flutter/foundation.dart';
import 'views/home_screen.dart';
import 'package:provider/provider.dart';
import 'widgets/global_message/app_wrapper.dart';
import 'views/chat_screen.dart';
import 'views/group_chat_screen.dart';
import 'config/app_config.dart'; // 全局配置

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
        // 提供 MessageProvider
        ChangeNotifierProvider(create: (context) => MessageProvider()),
        // 全局配置
        Provider(create: (context) => AppConfig()),
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
        //路由表定义
        routes: {
          //'/': (context) => const HomeScreen(),
          '/groupChatScreen': (context) => GroupChatScreen(),
          '/chatScreen': (context) => ChatScreen(),
        },
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
