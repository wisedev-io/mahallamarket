import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mahallamarket/di/repositories.dart';
import 'package:mahallamarket/domain/models/item.dart';
import 'package:mahallamarket/services/favorites_store.dart';
import 'package:mahallamarket/core/latlng.dart';
import 'item_detail_screen.dart';

class MyScreen extends StatefulWidget {
  const MyScreen({super.key});
  @override
  State<MyScreen> createState() => _MyScreenState();
}

class _MyScreenState extends State<MyScreen> {
  StreamSubscription? _sub;
  List<Item> _all = [];

  @override
  void initState() {
    super.initState();
    _sub = Repositories.items
        .watchFeed(center: Repositories.tashkent, radiusKm: 20, query: null)
        .listen((e) => setState(() => _all = e));
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final favs = _all.where((i) => favoritesStore.isFavorite(i.id)).toList();
    final mine = _all.where((i) => i.ownerId == 'me').toList();

    return Scaffold(
      appBar: AppBar(title: const Text('My Mahalla')),
      body: ListView(
        children: [
          const ListTile(title: Text('Favorites')),
          if (favs.isEmpty) const ListTile(title: Text('No favorites yet'))
          else ...favs.map((i) => ListTile(
            title: Text(i.title), subtitle: Text('${i.neighborhoodName} • ${money(i.price)}'),
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ItemDetailScreen(item: i))),
          )),
          const Divider(),
          const ListTile(title: Text('My posts')),
          if (mine.isEmpty) const ListTile(title: Text('No posts yet'))
          else ...mine.map((i) => ListTile(
            title: Text(i.title), subtitle: Text('${i.neighborhoodName} • ${money(i.price)}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (_)=>ItemDetailScreen(item: i))),
          )),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

String money(num v) => '${v.toStringAsFixed(0)} soʻm';
