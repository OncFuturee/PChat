import 'package:hive/hive.dart';

class HiveStorage {
  static const String _boxName = 'messages';

  Future<void> saveMessage(String chatId, Map<String, dynamic> message) async {
    final box = await Hive.openBox<Map>(_boxName);
    final key = '${chatId}_${DateTime.now().millisecondsSinceEpoch}';
    await box.put(key, message);
  }

  Future<List<Map<String, dynamic>>> getMessages(String chatId) async {
    final box = await Hive.openBox<Map>(_boxName);
    return box.values
        .where((message) => message['chatId'] == chatId)
        .map((message) => Map<String, dynamic>.from(message))
        .toList();
  }
}
