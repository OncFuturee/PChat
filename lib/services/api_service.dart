import '../models/message_model.dart';
import '../models/user_model.dart';

class ApiService {
  static List<UserModel> getContacts() {
    return List.generate(
      10,
      (index) => UserModel(
        id: '$index',
        name: 'User $index',
        avatar: 'https://via.placeholder.com/150',
      ),
    );
  }

  static List<MessageModel> getMessages(String chatId) {
    return List.generate(
      20,
      (index) => MessageModel(
        id: '$index',
        senderId: chatId,
        content: 'Message $index',
        timestamp: DateTime.now().subtract(Duration(minutes: index)),
      ),
    );
  }
}
