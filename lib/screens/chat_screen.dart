import 'package:flutter/material.dart';
import 'package:mahallamarket/services/auth_service.dart';
import 'package:mahallamarket/services/firestore_service.dart';
import 'package:mahallamarket/models/message.dart';

class ChatScreen extends StatefulWidget {
  final String? peerId; // pass via Navigator args
  final String? peerName;
  const ChatScreen({super.key, this.peerId, this.peerName});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = AuthService();
  final _fs = FirestoreService();
  final _ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final peerId = widget.peerId ?? args?['peerId'] as String?;
    final peerName = widget.peerName ?? args?['peerName'] as String? ?? 'Chat';

    final me = _auth.currentUser;
    if (me == null || peerId == null) {
      return Scaffold(appBar: AppBar(title: const Text('Chat')), body: const Center(child: Text('Missing peer')));
    }

    final stream = _fs.streamMessages(me.uid, peerId);

    return Scaffold(
      appBar: AppBar(title: Text(peerName)),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<List<Message>>(
              stream: stream,
              builder: (context, snap) {
                final msgs = snap.data ?? [];
                if (msgs.isEmpty) return const Center(child: Text('Say hello!'));
                return ListView.builder(
                  reverse: true,
                  itemCount: msgs.length,
                  itemBuilder: (context, i) {
                    final m = msgs[i];
                    final isMe = m.senderId == me.uid;
                    return Align(
                      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isMe ? Colors.orange.shade100 : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(m.text),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: const InputDecoration(hintText: 'Message...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () async {
                    final text = _ctrl.text.trim();
                    if (text.isEmpty) return;
                    _ctrl.clear();
                    await _fs.sendMessage(senderId: me.uid, receiverId: peerId, text: text);
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
