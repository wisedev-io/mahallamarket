import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mahallamarket/core/latlng.dart';
import 'package:mahallamarket/di/repositories.dart';
import 'package:mahallamarket/domain/models/item.dart';
import 'package:mahallamarket/services/location_provider_factory.dart';
import 'item_detail_screen.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});
  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  final _searchCtrl = TextEditingController();
  StreamSubscription? _sub;
  List<Item> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _wire();
  }

  Future<void> _wire() async {
    final fake = const String.fromEnvironment('USE_FAKE_LOCATION', defaultValue: 'false') == 'true';
    LatLng center;
    if (fake) {
      final lat = double.tryParse(const String.fromEnvironment('FAKE_LAT', defaultValue: '41.3111')) ?? 41.3111;
      final lng = double.tryParse(const String.fromEnvironment('FAKE_LNG', defaultValue: '69.2797')) ?? 69.2797;
      center = LatLng(lat, lng);
    } else {
      final pos = await getLocationProvider().get() ??
          Repositories.tashkent;
      center = LatLng(pos.lat, pos.lng);
    }

    _sub?.cancel();
    _sub = Repositories.items
        .watchFeed(center: center, radiusKm: 20, query: null)
        .listen((data) {
          setState(() { _items = data; _loading = false; });
        });
  }

  @override
  void dispose() {
    _sub?.cancel();
    _searchCtrl.dispose();
    super.dispose();
  }

  void _onSearch(String q) {
    _sub?.cancel();
    _sub = Repositories.items
        .watchFeed(center: Repositories.tashkent, radiusKm: 20, query: q)
        .listen((data) => setState(() => _items = data));
  }

  Future<void> _addMock() async {
    await Repositories.items.add(Item(
      id: 'draft',
      ownerId: 'me',
      title: 'New post',
      price: 123000,
      neighborhoodId: 'mock-hood',
      neighborhoodName: 'Chilonzor',
      createdAt: DateTime.now(),
      imageUrl: null,
      likesCount: 0,
      chatsCount: 0,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final topBar = SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
        child: Row(
          children: [
            const Icon(Icons.place_outlined, size: 20),
            const SizedBox(width: 6),
            const Text('Chilonzor', style: TextStyle(fontWeight: FontWeight.w600)),
            const Spacer(),
            IconButton(
              onPressed: () => _onSearch(_searchCtrl.text.trim()),
              icon: const Icon(Icons.search),
            ),
          ],
        ),
      ),
    );

    final search = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: _searchCtrl,
        onSubmitted: _onSearch,
        decoration: const InputDecoration(
          hintText: 'Search items…',
          prefixIcon: Icon(Icons.search),
          border: OutlineInputBorder(),
          isDense: true,
        ),
      ),
    );

    final body = _loading
        ? const Center(child: CircularProgressIndicator())
        : _items.isEmpty
            ? const Center(child: Text('No posts in your neighborhood yet'))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                itemCount: _items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (ctx, i) => _FeedTile(item: _items[i]),
              );

    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          topBar,
          search,
          const SizedBox(height: 8),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addMock,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _FeedTile extends StatelessWidget {
  final Item item;
  const _FeedTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ItemDetailScreen(item: item)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 90, height: 90,
                  child: item.imageUrl == null
                      ? Container(color: Colors.grey.shade300, child: const Icon(Icons.image))
                      : Image.network(item.imageUrl!, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    Text('${item.neighborhoodName} · ${timeAgo(item.createdAt)} ago',
                      style: TextStyle(color: Theme.of(context).hintColor)),
                    const SizedBox(height: 6),
                    Text(money(item.price), style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w600)),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.favorite_border, size: 16),
                        const SizedBox(width: 4),
                        Text('${item.likesCount}'),
                        const SizedBox(width: 12),
                        const Icon(Icons.chat_bubble_outline, size: 16),
                        const SizedBox(width: 4),
                        Text('${item.chatsCount}'),
                      ],
                    ),
                  ],
                ),
              ),
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
