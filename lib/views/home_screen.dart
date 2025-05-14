import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_screen.dart';
import 'group_chat_screen.dart';
import '../widgets/global_message/message_provider.dart';

// 主页面
// 用于显示聊天列表和聊天界面
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

// 主页面状态类
// 用于管理聊天列表和聊天界面的状态
class _HomeScreenState extends State<HomeScreen> {
  int? _selectedChatIndex; // 当前选中的对话索引
  bool _isGroupChat = false; // 是否为群组聊天
  bool _isDrawerOpen = false; // 控制侧滑页面的状态

  @override
  Widget build(BuildContext context) {
    final isWideScreen = MediaQuery.of(context).size.width > 800;

    return Stack(
      children: [
        Scaffold(
          // 移除默认状态栏
          body: isWideScreen
              ? Row(
                  children: [
                    // 左侧对话项列表
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          _buildTopStatusBar(context),
                          Expanded(child: _buildChatList()),
                        ],
                      ),
                    ),
                    // 右侧聊天界面
                    Expanded(
                      flex: 2,
                      child: _selectedChatIndex == null
                          ? const Center(
                              child: Text(
                                'Select a conversation',
                                style: TextStyle(fontSize: 18, color: Colors.grey),
                              ),
                            )
                          : _isGroupChat
                              ? GroupChatScreen(groupIndex: _selectedChatIndex!)
                              : ChatScreen(chatIndex: _selectedChatIndex!),
                    ),
                  ],
                )
              : Column(
                  children: [
                    _buildTopStatusBar(context),
                    Expanded(child: _buildChatList()),
                  ],
                ),
        ),
        if (_isDrawerOpen)
          GestureDetector(
            onTap: () => setState(() => _isDrawerOpen = false),
            child: Container(
              color: Colors.black.withOpacity(0.5), // 灰色蒙版
            ),
          ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: _isDrawerOpen ? 0 : -MediaQuery.of(context).size.width * 0.8,
          top: 0,
          bottom: 0,
          child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            color: Colors.white,
            child: Stack(
              children: [
                // 背景图片
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Image.asset(
                    'assets/images/user_card_background.png', // 替换为实际图片路径
                    fit: BoxFit.cover,
                  ),
                ),
                // 圆角卡片和功能列表
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.3 - 16, // 覆盖高度等于圆角半径
                  left: 0,
                  right: 0,
                  child: Material( // 添加 Material 小部件
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '功能列表',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          ListTile(
                            leading: const Icon(Icons.person),
                            title: const Text('个人资料'),
                            onTap: () {
                              // 个人资料逻辑
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.settings),
                            title: const Text('设置'),
                            onTap: () {
                              // 设置逻辑
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.logout),
                            title: const Text('退出登录'),
                            onTap: () {
                              // 退出登录逻辑
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // 顶部透明状态栏
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'User Info',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => setState(() => _isDrawerOpen = false),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTopStatusBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      color: Colors.blue[50],
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 用户信息区
          GestureDetector(
            onTap: () => setState(() => _isDrawerOpen = true),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage("https://avatars.githubusercontent.com/u/95522832?s=400&u=4457fc9da4f1c1e05120d8712cc40c695dbece16&v=4")
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'OncFuturee',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: const [
                        Icon(
                          Icons.circle,
                          size: 10,
                          color: Colors.green,
                        ),
                        SizedBox(width: 5),
                        Text(
                          '在线',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          // 工具区
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'scan') {
                
                context.read<MessageProvider>().showSuccess('扫描功能未实现');
              } else if (value == 'add_friend') {
                context.read<MessageProvider>().showError('添加好友功能未实现');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'scan',
                child: Text('扫一扫'),
              ),
              const PopupMenuItem(
                value: 'add_friend',
                child: Text('添加好友'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildChatList() {
    return ListView.builder(
      itemCount: 15, // 假设前 10 项为个人对话，后 5 项为群组对话
      itemBuilder: (context, index) {
        final isGroup = index >= 10; // 前 10 项为个人对话，后 5 项为群组对话
        return ListTile(
          leading: CircleAvatar(
            child: Text(isGroup ? 'G${index - 10 + 1}' : '${index + 1}'),
          ),
          title: Text(isGroup ? 'Group ${index - 10 + 1}' : 'Chat $index'),
          subtitle: Text(isGroup ? 'Last group message...' : 'Last message...'),
          onTap: () {
            if (MediaQuery.of(context).size.width > 800) {
              // 宽屏模式下更新选中的对话
              setState(() {
                _selectedChatIndex = index;
                _isGroupChat = isGroup;
              });
            } else {
              // 小屏幕模式下跳转到聊天界面
              Navigator.pushNamed(
                context,
                isGroup ? '/groupChatScreen' : '/chatScreen',
                arguments: isGroup ? index - 10 : index,
              );
            }
          },
        );
      },
    );
  }
}
