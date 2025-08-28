import 'package:flutter/material.dart';
import 'package:mahallamarket/domain/models/item.dart';
import 'package:mahallamarket/di/repositories.dart';

class PostEditScreen extends StatefulWidget {
  final Item? existing;
  const PostEditScreen({super.key, this.existing});

  @override
  State<PostEditScreen> createState() => _PostEditScreenState();
}

class _PostEditScreenState extends State<PostEditScreen> {
  final _title = TextEditingController();
  final _price = TextEditingController();
  final _neigh = TextEditingController(text: 'Chilonzor');
  final _image = TextEditingController();

  @override
  void initState() {
    super.initState();
    final e = widget.existing;
    if (e != null) {
      _title.text = e.title;
      _price.text = e.price.toStringAsFixed(0);
      _neigh.text = e.neighborhoodName;
      _image.text = e.imageUrl ?? '';
    }
  }

  @override
  void dispose() {
    _title.dispose();
    _price.dispose();
    _neigh.dispose();
    _image.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final title = _title.text.trim();
    final price = double.tryParse(_price.text.trim()) ?? 0;
    final hood = _neigh.text.trim();
    final img = _image.text.trim().isEmpty ? null : _image.text.trim();

    if (title.isEmpty || price <= 0 || hood.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fill all fields')));
      return;
    }

    if (widget.existing == null) {
      final id = await Repositories.items.add(Item(
        id: 'draft',
        ownerId: 'me',
        title: title,
        price: price,
        neighborhoodId: 'mock-hood',
        neighborhoodName: hood,
        createdAt: DateTime.now(),
        imageUrl: img,
        likesCount: 0,
        chatsCount: 0,
      ));
      if (!mounted) return;
      Navigator.pop(context, id);
    } else {
      final e = widget.existing!;
      await Repositories.items.update(Item(
        id: e.id,
        ownerId: e.ownerId,
        title: title,
        price: price,
        neighborhoodId: e.neighborhoodId,
        neighborhoodName: hood,
        createdAt: e.createdAt,
        imageUrl: img,
        likesCount: e.likesCount,
        chatsCount: e.chatsCount,
      ));
      if (!mounted) return;
      Navigator.pop(context, e);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Post' : 'New Post')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
          const SizedBox(height: 12),
          TextField(controller: _price, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Price')),
          const SizedBox(height: 12),
          TextField(controller: _neigh, decoration: const InputDecoration(labelText: 'Neighborhood')),
          const SizedBox(height: 12),
          TextField(controller: _image, decoration: const InputDecoration(labelText: 'Image URL (optional)')),
          const SizedBox(height: 24),
          FilledButton(onPressed: _save, child: Text(isEdit ? 'Save changes' : 'Add Post')),
        ],
      ),
    );
  }
}
