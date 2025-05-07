# PChat
这是一个使用 Flutter 构建的跨平台聊天应用程序，支持 Android、iOS、Linux、Windows 和 Web 平台。以下是项目的详细结构和功能说明。

## 项目结构

```
pchat\
├── android/                     # Android 平台相关配置文件
│   ├── app/
│   │   ├── build.gradle.kts     # Android 应用的 Gradle 构建配置
│   │   └── ...                  # 其他 Android 应用相关文件
│   ├── build.gradle.kts         # Android 项目级别的 Gradle 配置
│   └── settings.gradle.kts      # Android 项目设置
├── ios/                         # iOS 平台相关配置文件
│   ├── Runner/
│   │   ├── Runner-Bridging-Header.h # iOS 项目桥接头文件
│   │   └── ...                  # 其他 iOS 项目相关文件
├── linux/                       # Linux 平台相关配置文件
│   ├── CMakeLists.txt           # Linux 平台 CMake 配置文件
│   ├── flutter/
│   │   └── CMakeLists.txt       # Flutter 插件生成的 CMake 配置
│   └── runner/
│       └── my_application.cc    # Linux 平台应用入口文件
├── windows/                     # Windows 平台相关配置文件
│   ├── CMakeLists.txt           # Windows 平台 CMake 配置文件
│   ├── flutter/
│   │   └── CMakeLists.txt       # Flutter 插件生成的 CMake 配置
│   └── runner/
│       └── main.cpp             # Windows 平台应用入口文件
├── web/                         # Web 平台相关配置文件
│   ├── index.html               # Web 平台入口 HTML 文件
│   └── ...                      # 其他 Web 平台相关文件
├── lib/                         # Flutter 项目核心代码
│   ├── data_storage/            # 数据存储相关代码
│   │   ├── local_storage/       # 本地存储实现
│   │   │   ├── sqflite_storage.dart  # Sqflite 数据库实现
│   │   │   ├── hive_storage.dart     # Hive 数据库实现
│   │   │   └── shared_preferences_storage.dart # SharedPreferences 实现
│   │   ├── remote_storage/      # 远程存储实现
│   │   │   └── firebase_storage.dart # Firebase 存储（已移除）
│   │   └── data_repository.dart # 数据存储统一接口
│   ├── models/                  # 数据模型
│   │   ├── user_model.dart      # 用户模型
│   │   └── message_model.dart   # 消息模型
│   ├── services/                # 服务层代码
│   │   └── api_service.dart     # 模拟 API 服务
│   ├── views/                   # 界面相关代码
│   │   ├── home_screen.dart     # 主界面
│   │   ├── chat_screen.dart     # 聊天界面
│   │   ├── group_chat_screen.dart # 群组聊天界面
│   │   ├── contacts_screen.dart # 联系人界面
│   │   └── settings_screen.dart # 设置界面
│   ├── widgets/                 # 自定义组件
│   │   ├── chat_message_list.dart # 消息列表组件
│   │   ├── message_input_area.dart # 消息输入区域组件
│   │   ├── text_message_widget.dart # 文本消息组件
│   │   ├── image_message_widget.dart # 图片消息组件
│   │   └── file_message_widget.dart # 文件消息组件
│   └── main.dart                # 应用入口文件
├── pubspec.yaml                 # 项目依赖配置文件
├── README.md                    # 项目说明文档
└── ...                          # 其他 Flutter 项目相关文件
```

## 功能特性

- **跨平台支持**：一次开发，支持 Android、iOS、Linux、Windows 和 Web 平台。
- **聊天功能**：支持一对一聊天和群组聊天。
- **数据存储**：
    - 本地存储：支持 Sqflite、Hive 和 SharedPreferences。
    - 远程存储：支持 Firebase（已移除）。
- **自定义组件**：包括消息列表、消息输入区域、文本消息、图片消息和文件消息组件。
- **界面设计**：提供主界面、聊天界面、群组聊天界面、联系人界面和设置界面。

## 快速开始

1. 确保已安装 Flutter 开发环境。
2. 克隆项目到本地：
     ```bash
     git clone https://github.com/OncFuturee/PChat.git
     ```
3. 安装依赖：
     ```bash
     flutter pub get
     ```
4. 运行项目：
     ```bash
     flutter run
     ```

## 贡献

欢迎提交 Issue 和 Pull Request 来改进此项目！

## 许可证

本项目基于 [MIT 许可证](LICENSE) 开源。
