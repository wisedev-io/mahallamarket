import 'package:flutter/material.dart';
import 'package:mahallamarket/services/mock_data.dart';
import 'package:mahallamarket/services/mock_state.dart';
import 'package:mahallamarket/widgets/feed_item_tile.dart';
import 'package:mahallamarket/screens/new_item_sheet.dart';
import 'package:mahallamarket/screens/favorites_screen.dart';
import 'package:mahallamarket/screens/manage_neighborhood_screen.dart';

class HomeFeedScreen extends StatefulWidget {
  const HomeFeedScreen({super.key});

  @override
  State<HomeFeedScreen> createState() => _HomeFeedScreenState();
}

class _HomeFeedScreenState extends State<HomeFeedScreen> {
  String query = '';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = mockItems.where((e) {
      if (query.isEmpty) return true;
      final q = query.toLowerCase();
      return e.title.toLowerCase().contains(q) || e.neighborhood.toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            const SizedBox(width: 8),
            // neighborhood button (dropdown look)
            TextButton.icon(
              style: TextButton.styleFrom(foregroundColor: theme.colorScheme.onBackground),
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (_)=> const ManageNeighborhoodScreen()));
                setState((){}); // refresh title if changed
              },
              icon: const Icon(Icons.arrow_drop_down),
              label: Text(mockState.neighborhoodName, style: theme.textTheme.titleMedium),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.favorite_outline),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_)=> const FavoritesScreen()))
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                final result = await showSearch<String?>(
                  context: context,
                  delegate: _FeedSearchDelegate(initial: query),
                );
                if (result != null) setState(() => query = result);
              },
            ),
          ],
        ),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) => FeedItemTile(item: items[i]),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          final added = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            builder: (_) => const NewItemSheet(),
          );
          if (added == true) setState(() {});
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _FeedSearchDelegate extends SearchDelegate<String?> {
  _FeedSearchDelegate({String initial = ''}) {
    query = initial;
  }

  @override
  List<Widget>? buildActions(BuildContext context) => [
        if (query.isNotEmpty)
          IconButton(onPressed: () => query = '', icon: const Icon(Icons.clear)),
      ];

  @override
  Widget? buildLeading(BuildContext context) =>
      IconButton(onPressed: () => close(context, null), icon: const Icon(Icons.arrow_back));

  @override
  Widget buildResults(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () => close(context, query),
        child: Text('Search "$query"'),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = mockItems
        .where((e) => e.title.toLowerCase().contains(query.toLowerCase()))
        .take(5)
        .toList();
    if (suggestions.isEmpty) return const SizedBox.shrink();
    return ListView(
      children: suggestions
          .map((e) => ListTile(
                title: Text(e.title),
                subtitle: Text(e.neighborhood),
                onTap: () => close(context, e.title),
              ))
          .toList(),
    );
  }
}
