import 'package:flutter/foundation.dart';
import 'local_storage/sqflite_storage.dart';
import 'local_storage/hive_storage.dart';

abstract class DataRepository {
  Future<void> saveTextMessage(String chatId, String content, String timestamp);
  Future<void> saveFileMessage(String chatId, String filePath, String fileType, String timestamp);
  Future<List<Map<String, dynamic>>> getMessages(String chatId);

  factory DataRepository() {
    if (kIsWeb) {
      return _HiveDataRepository(HiveStorage());
    } else {
      return _SqfliteDataRepository(SqfliteStorage());
    }
  }
}

class _SqfliteDataRepository implements DataRepository {
  final SqfliteStorage _sqfliteStorage;

  _SqfliteDataRepository(this._sqfliteStorage);

  @override
  Future<void> saveTextMessage(String chatId, String content, String timestamp) async {
    await _sqfliteStorage.saveTextMessage(chatId, content, timestamp);
  }

  @override
  Future<void> saveFileMessage(String chatId, String filePath, String fileType, String timestamp) async {
    await _sqfliteStorage.saveFileMessage(chatId, filePath, fileType, timestamp);
  }

  @override
  Future<List<Map<String, dynamic>>> getMessages(String chatId) async {
    return await _sqfliteStorage.getMessages(chatId);
  }
}

class _HiveDataRepository implements DataRepository {
  final HiveStorage _hiveStorage;

  _HiveDataRepository(this._hiveStorage);

  @override
  Future<void> saveTextMessage(String chatId, String content, String timestamp) async {
    await _hiveStorage.saveMessage(chatId, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'chatId': chatId,
      'content': content,
      'type': 'text',
      'timestamp': timestamp,
    });
  }

  @override
  Future<void> saveFileMessage(String chatId, String filePath, String fileType, String timestamp) async {
    await _hiveStorage.saveMessage(chatId, {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'chatId': chatId,
      'content': filePath,
      'type': fileType,
      'timestamp': timestamp,
    });
  }

  @override
  Future<List<Map<String, dynamic>>> getMessages(String chatId) async {
    return await _hiveStorage.getMessages(chatId);
  }
}
