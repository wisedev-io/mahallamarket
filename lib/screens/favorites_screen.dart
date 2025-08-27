import 'package:flutter/material.dart';
import 'package:mahallamarket/services/mock_data.dart';
import 'package:mahallamarket/services/mock_state.dart';
import 'item_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favItems = mockItems.where((it) => mockState.isFavorite(it.id)).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: favItems.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final item = favItems[i];
          return ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: Colors.black12,
                width: 64, height: 64,
                child: item.imageUrl==null? const Icon(Icons.image): Image.network(item.imageUrl!, fit: BoxFit.cover),
              ),
            ),
            title: Text(item.title, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(item.neighborhood),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(Icons.favorite, color: Colors.orange.shade700),
                const SizedBox(height: 6),
                Text(money(item.price), style: const TextStyle(fontWeight: FontWeight.w700)),
              ],
            ),
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_)=> ItemDetailScreen(item: item))),
          );
        },
      ),
    );
  }
}
