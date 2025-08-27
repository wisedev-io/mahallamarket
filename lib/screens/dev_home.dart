import 'package:flutter/material.dart';
import 'package:mahallamarket/services/location_provider_factory.dart';
import 'package:mahallamarket/services/location_provider.dart';
import 'package:mahallamarket/services/mock_data.dart';
import 'dev_item_detail.dart';
import 'dev_chat_thread.dart';

class DevHome extends StatefulWidget {
  const DevHome({super.key});
  @override
  State<DevHome> createState() => _DevHomeState();
}

class _DevHomeState extends State<DevHome> {
  final lp = getLocationProvider();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dev Home (no backend)')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          FutureBuilder<({double lat, double lng})>(
            future: lp.getCurrentPosition(),
            builder: (context, snap) {
              Widget w;
              if (snap.connectionState != ConnectionState.done) {
                w = const Text('Loading fake location…');
              } else if (snap.hasError) {
                w = Text('Error: ${snap.error}', style: const TextStyle(color: Colors.red));
              } else {
                final p = snap.data!;
                w = Text('Fake location: ${p.lat}, ${p.lng}');
              }
              return Padding(padding: const EdgeInsets.only(bottom: 12), child: w);
            },
          ),
          const Text('Items nearby (mock)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...mockItems.asMap().entries.map((e) {
            final i = e.key; final it = e.value;
            return Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.shopping_bag)),
                title: Text(it.title),
                subtitle: Text(money(it.price)),
                trailing: IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () => Navigator.push(context, MaterialPageRoute(
                    builder: (_) => DevItemDetail(itemIndex: i),
                  )).then((_) => setState((){})),
                ),
              ),
            );
          }),
          const SizedBox(height: 16),
          const Text('Chats (mock)', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ...mockChats.asMap().entries.map((e) {
            final i = e.key; final c = e.value;
            final last = c.messages.isNotEmpty ? c.messages.last.text : 'Start chatting';
            return Card(
              child: ListTile(
                leading: const CircleAvatar(child: Icon(Icons.person)),
                title: Text(c.peerName),
                subtitle: Text(last, maxLines: 1, overflow: TextOverflow.ellipsis),
                onTap: () => Navigator.push(context, MaterialPageRoute(
                  builder: (_) => DevChatThread(chatIndex: i),
                )).then((_) => setState((){})),
              ),
            );
          })
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() => mockItems.add(MockItem('New Item ${mockItems.length+1}', 10 + mockItems.length.toDouble())));
        },
        icon: const Icon(Icons.add),
        label: const Text('Add item'),
      ),
    );
  }
}
