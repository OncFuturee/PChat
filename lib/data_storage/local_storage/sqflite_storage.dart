import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class SqfliteStorage {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    return openDatabase(
      join(dbPath, 'pchat.db'),
      onCreate: (db, version) async {
        // 确保表结构正确
        await db.execute(
          'CREATE TABLE IF NOT EXISTS messages('
          'id TEXT PRIMARY KEY, '
          'chatId TEXT, '
          'content TEXT, '
          'type TEXT, '
          'timestamp TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> saveMessage(String chatId, Map<String, dynamic> message) async {
    try {
      final db = await database;
      await db.insert(
        'messages',
        message,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error saving message: $e'); // 打印错误日志
    }
  }

  Future<void> saveTextMessage(String chatId, String content, String timestamp) async {
    try {
      final db = await database;
      await db.insert(
        'messages',
        {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'chatId': chatId,
          'content': content,
          'type': 'text',
          'timestamp': timestamp,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error saving text message: $e'); // 打印错误日志
    }
  }

  Future<void> saveFileMessage(String chatId, String filePath, String fileType, String timestamp) async {
    try {
      final db = await database;
      await db.insert(
        'messages',
        {
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'chatId': chatId,
          'content': filePath,
          'type': fileType,
          'timestamp': timestamp,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      print('Error saving file message: $e'); // 打印错误日志
    }
  }

  Future<List<Map<String, dynamic>>> getMessages(String chatId) async {
    try {
      final db = await database;
      return await db.query(
        'messages',
        where: 'chatId = ?',
        whereArgs: [chatId],
        orderBy: 'timestamp ASC',
      );
    } catch (e) {
      print('Error fetching messages: $e'); // 打印错误日志
      return [];
    }
  }
}
