import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import 'package:mahallamarket/models/item.dart';
import 'package:mahallamarket/models/message.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ---------- Items ----------
  Future<void> addItem({
    required String title,
    required double price,
    required String? imageUrl,
    required double latitude,
    required double longitude,
    required String userId,
  }) async {
    // geoflutterfire_plus uses GeoFirePoint(GeoPoint(...)) then .data for {geohash, geopoint}
    final geo = GeoFirePoint(GeoPoint(latitude, longitude));
    await _firestore.collection('items').add({
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'userId': userId,
      'position': geo.data,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  /// Stream items within a radius in KM around [latitude, longitude]
  Stream<List<Item>> itemsNear({
    required double latitude,
    required double longitude,
    double radiusKm = 6,
  }) {
    final col = _firestore.collection('items');

    // In our schema, the geopoint lives at data['position']['geopoint']
    return GeoCollectionReference(col)
        .subscribeWithin(
          center: GeoFirePoint(GeoPoint(latitude, longitude)),
          radiusInKm: radiusKm,
          field: 'position',
          geopointFrom: (data) =>
              (data['position'] as Map<String, dynamic>)['geopoint'] as GeoPoint,
          strictMode: true,
        )
        .map((docs) => docs.map((snap) => Item.fromDoc(snap)).toList());
  }

  Stream<List<Item>> myItems(String uid) {
    return _firestore
        .collection('items')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Item.fromDoc(d)).toList());
  }

  // ---------- Chat ----------
  String conversationIdFor(String a, String b) {
    final ids = [a, b]..sort();
    return '${ids[0]}_${ids[1]}';
  }

  Future<void> ensureConversation(String uid1, String uid2) async {
    final cid = conversationIdFor(uid1, uid2);
    final ref = _firestore.collection('conversations').doc(cid);
    await ref.set({
      'participants': [uid1, uid2],
      'lastMessage': FieldValue.delete(),
      'lastTs': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String text,
  }) async {
    final cid = conversationIdFor(senderId, receiverId);
    final convoRef = _firestore.collection('conversations').doc(cid);
    await ensureConversation(senderId, receiverId);
    final msgRef = convoRef.collection('messages').doc();
    await _firestore.runTransaction((tx) async {
      tx.set(msgRef, {
        'senderId': senderId,
        'receiverId': receiverId,
        'text': text,
        'ts': FieldValue.serverTimestamp(),
      });
      tx.set(convoRef, {
        'lastMessage': text,
        'lastTs': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }

  Stream<List<Message>> streamMessages(String uid1, String uid2, {int limit = 50}) {
    final cid = conversationIdFor(uid1, uid2);
    return _firestore
        .collection('conversations').doc(cid)
        .collection('messages')
        .orderBy('ts', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map((d) => Message.fromDoc(d)).toList());
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamConversations(String uid) {
    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: uid)
        .orderBy('lastTs', descending: true)
        .snapshots();
  }
}
