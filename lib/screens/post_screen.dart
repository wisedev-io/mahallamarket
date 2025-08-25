import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mahallamarket/services/firestore_service.dart';
import 'package:mahallamarket/services/auth_service.dart';
import 'package:mahallamarket/services/storage_service.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final _fs = FirestoreService();
  final _auth = AuthService();
  final _storage = StorageService();
  final _title = TextEditingController();
  final _price = TextEditingController();
  File? _image;
  bool _saving = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final x = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (x != null) setState(() => _image = File(x.path));
  }

  Future<void> _submit() async {
    final user = _auth.currentUser;
    if (user == null) return;
    final title = _title.text.trim();
    final price = double.tryParse(_price.text.trim()) ?? 0;
    if (title.isEmpty || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Title and price required')));
      return;
    }
    setState(() => _saving = true);
    try {
      final pos = await Geolocator.getCurrentPosition();
      String? url;
      if (_image != null) {
        url = await _storage.uploadItemImage(uid: user.uid, file: _image!);
      }
      await _fs.addItem(
        title: title,
        price: price,
        imageUrl: url,
        latitude: pos.latitude,
        longitude: pos.longitude,
        userId: user.uid,
      );
      if (mounted) Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Post an item')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: _title, decoration: const InputDecoration(labelText: 'Title')),
            const SizedBox(height: 8),
            TextField(controller: _price, decoration: const InputDecoration(labelText: 'Price'), keyboardType: TextInputType.number),
            const SizedBox(height: 12),
            Row(
              children: [
                ElevatedButton.icon(onPressed: _pickImage, icon: const Icon(Icons.image), label: const Text('Add image')),
                const SizedBox(width: 12),
                if (_image != null) Text(_image!.path.split('/').last),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saving ? null : _submit,
                child: _saving ? const CircularProgressIndicator() : const Text('Publish'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
