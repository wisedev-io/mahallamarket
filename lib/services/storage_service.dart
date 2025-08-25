import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<String> uploadItemImage({
    required String uid,
    required File file,
  }) async {
    final name = DateTime.now().millisecondsSinceEpoch.toString();
    final ref = _storage.ref().child('images').child(uid).child('$name.jpg');
    final task = await ref.putFile(file, SettableMetadata(contentType: 'image/jpeg'));
    return task.ref.getDownloadURL();
  }
}
