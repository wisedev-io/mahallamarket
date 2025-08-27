import 'package:flutter/material.dart';
import 'package:mahallamarket/services/mock_data.dart';

class NewItemSheet extends StatefulWidget {
  const NewItemSheet({super.key});

  @override
  State<NewItemSheet> createState() => _NewItemSheetState();
}

class _NewItemSheetState extends State<NewItemSheet> {
  final title = TextEditingController();
  final price = TextEditingController();
  final neighborhood = TextEditingController(text: '공동');

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: SafeArea(
        child: Material(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Container(
                    width: 48, height: 4,
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.black12, borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                Text('Add new item', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                TextField(controller: title, decoration: const InputDecoration(labelText: 'Title')),
                const SizedBox(height: 8),
                TextField(
                  controller: price,
                  decoration: const InputDecoration(labelText: 'Price (₩)'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 8),
                TextField(controller: neighborhood, decoration: const InputDecoration(labelText: 'Neighborhood')),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    final t = title.text.trim();
                    final p = double.tryParse(price.text.trim());
                    final n = neighborhood.text.trim().isEmpty ? '공동' : neighborhood.text.trim();
                    if (t.isEmpty || p == null) return;
                    addMockItem(title: t, price: p, neighborhood: n);
                    Navigator.pop(context, true);
                  },
                  child: const Text('Add'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
