import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mahallamarket/core/latlng.dart';
import 'package:mahallamarket/domain/models/item.dart';
import 'package:mahallamarket/domain/repos/items_repository.dart';

class ItemsRepositoryFirebase implements ItemsRepository {
  final _db = FirebaseFirestore.instance;

  @override
  Stream<List<Item>> watchFeed({required LatLng center, required double radiusKm, String? query}) {
    final q = _db.collection('items')
      .orderBy('createdAt', descending: true)
      .limit(50);
    return q.snapshots().map((snap) =>
      snap.docs.map((d) => Item.fromMap(d.id, d.data())).toList()
    );
  }

  @override
  Future<String> add(Item itemDraft) async {
    final doc = await _db.collection('items').add(itemDraft.toMap());
    return doc.id;
  }

  @override
  Future<void> like(String itemId, bool value) async {
    await _db.runTransaction((tx) async {
      final ref = _db.collection('items').doc(itemId);
      final snap = await tx.get(ref);
      final current = (snap.data()?['likesCount'] ?? 0) as int;
      tx.update(ref, {'likesCount': (current + (value ? 1 : -1)).clamp(0, 1<<30)});
    });
  }
}
