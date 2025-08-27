import 'package:flutter/material.dart';
import 'package:mahallamarket/services/mock_data.dart';

class DevItemDetail extends StatefulWidget {
  final int itemIndex;
  const DevItemDetail({super.key, required this.itemIndex});

  @override
  State<DevItemDetail> createState() => _DevItemDetailState();
}

class _DevItemDetailState extends State<DevItemDetail> {
  late TextEditingController _title;
  late TextEditingController _price;

  @override
  void initState() {
    super.initState();
    final it = mockItems[widget.itemIndex];
    _title = TextEditingController(text: it.title);
    _price = TextEditingController(text: it.price.toStringAsFixed(2));
  }

  @override
  Widget build(BuildContext context) {
    final it = mockItems[widget.itemIndex];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Item detail (mock)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: () {
              mockItems.removeAt(widget.itemIndex);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: 8),
          TextField(controller: _price, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () {
              it.title = _title.text.trim().isEmpty ? it.title : _title.text.trim();
              final p = double.tryParse(_price.text.trim());
              if (p != null) it.price = p;
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved (mock)')));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
