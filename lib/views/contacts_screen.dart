import 'package:flutter/material.dart';

// 联系人页面
// 用于显示联系人列表
class ContactsScreen extends StatelessWidget {
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(child: Text('${index + 1}')),
            title: Text('Contact $index'),
            subtitle: Text('Status message...'),
          );
        },
      ),
    );
  }
}
