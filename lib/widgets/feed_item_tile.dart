import 'package:flutter/material.dart';
import 'package:mahallamarket/services/mock_data.dart';
import 'package:mahallamarket/services/mock_state.dart';
import 'package:mahallamarket/screens/item_detail_screen.dart';

class FeedItemTile extends StatelessWidget {
  final MockItem item;
  const FeedItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final fav = mockState.isFavorite(item.id);

    return InkWell(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_)=> ItemDetailScreen(item: item))),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                color: theme.colorScheme.surfaceVariant,
                width: 72,
                height: 72,
                child: item.imageUrl == null
                    ? const Icon(Icons.image, size: 28, color: Colors.grey)
                    : Image.network(item.imageUrl!, fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            // text block
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.neighborhood} · ${timeAgo(item.postedAt)}',
                    style: theme.textTheme.bodySmall?.copyWith(color: theme.hintColor),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    money(item.price),
                    style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // actions and stats
            Column(
              children: [
                IconButton(
                  icon: Icon(fav ? Icons.favorite : Icons.favorite_border, color: fav ? Colors.orange : null),
                  onPressed: () {
                    final nowFav = mockState.toggleFavorite(item.id);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(nowFav ? 'Added to favorites' : 'Removed from favorites')),
                    );
                  },
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.forum_outlined, size: 16),
                    const SizedBox(width: 2),
                    Text('${item.chats}', style: theme.textTheme.bodySmall),
                    const SizedBox(width: 8),
                    const Icon(Icons.favorite_border, size: 16),
                    const SizedBox(width: 2),
                    Text('${item.likes}', style: theme.textTheme.bodySmall),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
