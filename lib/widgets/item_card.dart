// Widget for displaying an item
import 'package:flutter/material.dart';
import 'package:mahallamarket/models/item.dart';

class ItemCard extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;

  const ItemCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: item.imageUrl != null
            ? Image.network(item.imageUrl!, width: 50, height: 50, fit: BoxFit.cover)
            : const Icon(Icons.image),
        title: Text(item.title),
        subtitle: Text('\$${item.price.toStringAsFixed(2)}'),
        onTap: onTap,
      ),
    );
  }
}