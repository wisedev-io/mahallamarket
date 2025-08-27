import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mahallamarket/core/latlng.dart';
import 'package:mahallamarket/di/repositories.dart';
import 'package:mahallamarket/domain/models/item.dart';
import 'package:mahallamarket/services/mock_state.dart';
import 'package:mahallamarket/services/mock_data.dart' show MockItem;
import 'item_detail_screen.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});
  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final TextEditingController _searchCtrl = TextEditingController();
  StreamSubscription? _sub;
  List<Item> _items = const [];
  bool _loading = true;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _listen();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _listen() async {
    setState(() => _loading = true);

    // Simple, reliable fallback center (Tashkent) so we don't depend on platform APIs here.
    // You can replace with real location later.
    final pos = const LatLng(41.3111, 69.2797);
    final radiusKm = mockState.neighborhoodRadiusKm;

    _sub?.cancel();
    _sub = Repositories.items
        .watchFeed(center: pos, radiusKm: radiusKm, query: _query)
        .listen((data) {
      setState(() {
        _items = data;
        _loading = false;
      });
    });
  }

  void _onSearchChanged(String v) {
    _query = v.trim();
    _listen();
  }

  Future<void> _addMockItem() async {
    final now = DateTime.now().toIso8601String().substring(11, 19);
    await Repositories.items.add(Item(
      id: 'tmp',
      ownerId: 'me',
      title: 'New post $now',
      price: 10000,
      neighborhoodId: 'mock-hood',
      neighborhoodName: mockState.neighborhoodName,
      createdAt: DateTime.now(),
      imageUrl: null,
      likesCount: 0,
      chatsCount: 0,
    ));
    if (mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Added mock post')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.place, size: 18),
            const SizedBox(width: 6),
            Text(mockState.neighborhoodName,
                style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () async {
              await showModalBottomSheet(
                context: context,
                useSafeArea: true,
                isScrollControlled: true,
                builder: (ctx) => Padding(
                  padding: EdgeInsets.only(
                    left: 16,
                    right: 16,
                    top: 16,
                    bottom: 16 + MediaQuery.of(ctx).viewInsets.bottom,
                  ),
                  child: TextField(
                    controller: _searchCtrl,
                    autofocus: true,
                    decoration: const InputDecoration(
                      hintText: 'Search items…',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                    ),
                    onSubmitted: (v) {
                      Navigator.pop(ctx);
                      _onSearchChanged(v);
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('No items found'))
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 96),
                  itemCount: _items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (ctx, i) {
                    final it = _items[i];
                    return _FeedTile(item: it);
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMockItem,
        backgroundColor: cs.primary,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _FeedTile extends StatelessWidget {
  final Item item;
  const _FeedTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ItemDetailScreen(
            item: MockItem(
              id: item.id,
              title: item.title,
              neighborhood: item.neighborhoodName,
              postedAt: item.createdAt,
              price: item.price,
              imageUrl: item.imageUrl,
              likes: item.likesCount,
              chats: item.chatsCount,
            ),
          ),
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: cs.outlineVariant),
        ),
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: item.imageUrl == null
                    ? Container(
                        color: cs.surfaceContainerHighest,
                        child: const Icon(Icons.image),
                      )
                    : Image.network(item.imageUrl!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: DefaultTextStyle(
                style: Theme.of(context).textTheme.bodyMedium!,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 2),
                    Text('${item.neighborhoodName} · ${_timeAgo(item.createdAt)}'),
                    const SizedBox(height: 4),
                    Text(_money(item.price),
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.favorite, size: 16),
                        const SizedBox(width: 4),
                        Text('${item.likesCount}'),
                        const SizedBox(width: 12),
                        const Icon(Icons.chat_bubble, size: 16),
                        const SizedBox(width: 4),
                        Text('${item.chatsCount}'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static String _money(num v) => '${v.toStringAsFixed(0)} soʻm';
  static String _timeAgo(DateTime dt) {
    final s = DateTime.now().difference(dt).inSeconds;
    if (s < 60) return '${s}s';
    final m = s ~/ 60;
    if (m < 60) return '${m}m';
    final h = m ~/ 60;
    if (h < 24) return '${h}h';
    final d = h ~/ 24;
    return '${d}d';
  }
}
