import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahallamarket/core/latlng.dart';
import 'package:mahallamarket/domain/models/item.dart';
import 'package:mahallamarket/domain/repos/items_repository.dart';

class ItemsRepositoryFirebase implements ItemsRepository {
  final CollectionReference<Map<String, dynamic>> _col =
      FirebaseFirestore.instance.collection('items');

  @override
  Future<String> add(Item item) async {
    final data = {
      'ownerId': item.ownerId,
      'title': item.title,
      'price': item.price,
      'neighborhoodId': item.neighborhoodId,
      'neighborhoodName': item.neighborhoodName,
      'createdAt': item.createdAt,
      'imageUrl': item.imageUrl,
      'likesCount': item.likesCount,
      'chatsCount': item.chatsCount,
    };
    final doc = await _col.add(data);
    return doc.id;
  }

  @override
  Future<void> update(Item item) async {
    final data = {
      'ownerId': item.ownerId,
      'title': item.title,
      'price': item.price,
      'neighborhoodId': item.neighborhoodId,
      'neighborhoodName': item.neighborhoodName,
      'imageUrl': item.imageUrl,
    };
    await _col.doc(item.id).update(data).catchError((_) async {
      await _col.doc(item.id).set({
        ...data,
        'createdAt': item.createdAt,
        'likesCount': item.likesCount,
        'chatsCount': item.chatsCount,
      });
    });
  }

  @override
  Future<void> like(String itemId, bool value) async {
    final doc = _col.doc(itemId);
    return FirebaseFirestore.instance.runTransaction((tx) async {
      final snap = await tx.get(doc);
      final current = (snap.data()?['likesCount'] ?? 0) as int;
      final next = current + (value ? 1 : -1);
      tx.update(doc, {'likesCount': next < 0 ? 0 : next});
    });
  }

  @override
  Stream<List<Item>> watchFeed({
    required LatLng center,
    required double radiusKm,
    String? query,
  }) {
    Query<Map<String, dynamic>> q =
        _col.orderBy('createdAt', descending: true).limit(100);

    final base = q.snapshots().map((s) => s.docs.map(_fromDoc).toList());

    if (query == null || query.trim().isEmpty) return base;

    final lower = query.toLowerCase();
    return base.map((items) =>
        items.where((e) => e.title.toLowerCase().contains(lower)).toList());
  }

  Item _fromDoc(QueryDocumentSnapshot<Map<String, dynamic>> d) {
    final m = d.data();
    return Item(
      id: d.id,
      ownerId: (m['ownerId'] ?? '') as String,
      title: (m['title'] ?? '') as String,
      price: (m['price'] ?? 0).toDouble(),
      neighborhoodId: (m['neighborhoodId'] ?? '') as String,
      neighborhoodName: (m['neighborhoodName'] ?? '') as String,
      createdAt: (m['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      imageUrl: (m['imageUrl'] as String?)?.isEmpty == true ? null : m['imageUrl'] as String?,
      likesCount: (m['likesCount'] ?? 0) as int,
      chatsCount: (m['chatsCount'] ?? 0) as int,
    );
  }
}
