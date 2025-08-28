import 'package:flutter/material.dart';
import 'package:mahallamarket/domain/models/item.dart';
import 'package:mahallamarket/di/repositories.dart';
import 'package:mahallamarket/services/favorites_store.dart';
import 'post_edit_screen.dart';

class ItemDetailScreen extends StatefulWidget {
  final Item item;
  const ItemDetailScreen({super.key, required this.item});

  @override
  State<ItemDetailScreen> createState() => _ItemDetailScreenState();
}

class _ItemDetailScreenState extends State<ItemDetailScreen> {
  final _msgCtrl = TextEditingController();

  @override
  void dispose() {
    _msgCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final isMine = item.ownerId == 'me';
    final fav = favoritesStore.isFavorite(item.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        actions: [
          IconButton(
            onPressed: () async {
              final nowFav = favoritesStore.toggle(item.id);
              await Repositories.items.like(item.id, nowFav);
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(nowFav ? 'Added to favorites' : 'Removed from favorites')),
              );
              setState((){});
            },
            icon: Icon(fav ? Icons.favorite : Icons.favorite_border),
          ),
          if (isMine)
            IconButton(
              onPressed: () async {
                final updated = await Navigator.push<Item?>(
                  context,
                  MaterialPageRoute(builder: (_) => PostEditScreen(existing: item)),
                );
                if (updated != null && mounted) {
                  setState(() { widget.item == updated; });
                }
              },
              icon: const Icon(Icons.edit),
              tooltip: 'Edit',
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          AspectRatio(
            aspectRatio: 16/9,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(12),
                image: item.imageUrl != null
                    ? DecorationImage(image: NetworkImage(item.imageUrl!), fit: BoxFit.cover)
                    : null,
              ),
              child: item.imageUrl == null
                  ? const Center(child: Icon(Icons.image, size: 64, color: Colors.white70))
                  : null,
            ),
          ),
          const SizedBox(height: 16),
          Text(item.title, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text(money(item.price), style: Theme.of(context).textTheme.titleLarge!.copyWith(color: Colors.orange)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.place_outlined, size: 18),
              const SizedBox(width: 4),
              Text(item.neighborhoodName),
              const SizedBox(width: 12),
              const Icon(Icons.schedule, size: 18),
              const SizedBox(width: 4),
              Text('${timeAgo(item.createdAt)} ago'),
            ],
          ),
          const SizedBox(height: 16),
          ListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: const Text('Seller'),
            subtitle: Text(item.ownerId),
            trailing: const Icon(Icons.chevron_right),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _msgCtrl,
                  decoration: const InputDecoration(
                    hintText: 'Write a message…',
                    border: OutlineInputBorder(),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              FilledButton(
                onPressed: () async {
                  final text = _msgCtrl.text.trim();
                  if (text.isEmpty) return;
                  _msgCtrl.clear();
                  // Mock-send
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Sent: $text (mock)')),
                  );
                },
                child: const Text('Send'),
              )
            ],
          ),
        ),
      ),
    );
  }
}

String money(num v) => '${v.toStringAsFixed(0)} soʻm';
String timeAgo(DateTime dt) {
  final s = DateTime.now().difference(dt).inSeconds;
  if (s < 60) return '${s}s';
  final m = s ~/ 60;
  if (m < 60) return '${m}m';
  final h = m ~/ 60;
  if (h < 24) return '${h}h';
  final d = h ~/ 24;
  return '${d}d';
}
