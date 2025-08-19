import 'package:flutter/material.dart';
import 'package:mahallamarket/models/message.dart';
import 'package:mahallamarket/services/firestore_service.dart';
import 'package:mahallamarket/services/auth_service.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  final TextEditingController _messageController = TextEditingController();
  final String _otherUserId = 'dummy_user'; // Replace with actual user ID in production

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: _firestoreService.getMessages(_authService.currentUser!.uid, _otherUserId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final messages = snapshot.data!;
                return ListView.builder(
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    return ListTile(
                      title: Text(message.text),
                      subtitle: Text(message.senderId == _authService.currentUser!.uid ? 'You' : 'Other'),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(labelText: 'Message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    if (_messageController.text.isEmpty) return;
                    try {
                      await _firestoreService.sendMessage(
                        _authService.currentUser!.uid,
                        _otherUserId,
                        _messageController.text,
                      );
                      _messageController.clear();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}