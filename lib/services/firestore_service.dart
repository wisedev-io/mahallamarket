import 'dart:io';
import 'dart:math'; // Added for cos and pi
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:mahallamarket/models/item.dart';
import 'package:mahallamarket/models/message.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> addItem({
    required String title,
    required double price,
    required String? imageUrl,
    required double latitude,
    required double longitude,
    required String userId,
  }) async {
    try {
      await _firestore.collection('items').add({
        'title': title,
        'price': price,
        'imageUrl': imageUrl,
        'latitude': latitude,
        'longitude': longitude,
        'userId': userId,
      });
    } catch (e) {
      throw Exception('Error adding item: $e');
    }
  }

  Future<String?> uploadImage(File image) async {
    try {
      final ref = _storage.ref().child('items/${DateTime.now().toIso8601String()}');
      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      throw Exception('Error uploading image: $e');
    }
  }

  Future<List<Item>> getItemsWithinRadius(double latitude, double longitude, double radiusKm) async {
    try {
      // Simple bounding box for 6-km radius (approximate)
      const double kmPerDegree = 111.0;
      final double latDelta = radiusKm / kmPerDegree;
      final double lonDelta = radiusKm / (kmPerDegree * cos(latitude * pi / 180));

      final snapshot = await _firestore.collection('items')
          .where('latitude', isGreaterThan: latitude - latDelta)
          .where('latitude', isLessThan: latitude + latDelta)
          .where('longitude', isGreaterThan: longitude - lonDelta)
          .where('longitude', isLessThan: longitude + lonDelta)
          .get();

      return snapshot.docs.map((doc) => Item.fromMap(doc.data(), doc.id)).toList();
    } catch (e) {
      throw Exception('Error fetching items: $e');
    }
  }

  Future<void> sendMessage(String senderId, String receiverId, String text) async {
    try {
      await _firestore.collection('messages').add({
        'senderId': senderId,
        'receiverId': receiverId,
        'text': text,
        'timestamp': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      throw Exception('Error sending message: $e');
    }
  }

  Stream<List<Message>> getMessages(String userId1, String userId2) {
    return _firestore
        .collection('messages')
        .where('senderId', whereIn: [userId1, userId2])
        .where('receiverId', whereIn: [userId1, userId2])
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => Message.fromMap(doc.data(), doc.id)).toList());
  }
}