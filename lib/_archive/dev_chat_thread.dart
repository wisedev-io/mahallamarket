import 'package:flutter/material.dart';
import 'package:mahallamarket/services/mock_data.dart';

class DevChatThread extends StatefulWidget {
  final int chatIndex;
  const DevChatThread({super.key, required this.chatIndex});

  @override
  State<DevChatThread> createState() => _DevChatThreadState();
}

class _DevChatThreadState extends State<DevChatThread> {
  final ctrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chat = mockChats[widget.chatIndex];
    return Scaffold(
      appBar: AppBar(title: Text('Chat with ${chat.peerName} (mock)')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: chat.messages.length,
              itemBuilder: (_, i) {
                final m = chat.messages[i];
                final mine = m.from == 'me';
                return Align(
                  alignment: mine ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: mine ? Colors.orange.shade200 : Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(m.text),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(child: TextField(controller: ctrl, decoration: const InputDecoration(hintText: 'Message...'))),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: () {
                    final t = ctrl.text.trim();
                    if (t.isEmpty) return;
                    chat.messages.add(MockMessage('me', t));
                    ctrl.clear();
                    setState(() {});
                  },
                  child: const Text('Send'),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
