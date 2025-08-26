import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
import '../../domain/repos/items_repo.dart';
import '../../models/item.dart';

class FirebaseItemsRepo implements ItemsRepo {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Stream<List<Item>> feedNear({
    required double latitude,
    required double longitude,
    double radiusKm = 6,
  }) {
    final col = _db.collection('items');
    return GeoCollectionReference(col)
        .subscribeWithin(
          center: GeoFirePoint(GeoPoint(latitude, longitude)),
          radiusInKm: radiusKm,
          field: 'position',
          geopointFrom: (data) =>
              (data['position'] as Map<String, dynamic>)['geopoint'] as GeoPoint,
          strictMode: true,
        )
        .map((snaps) => snaps.map((d) => Item.fromDoc(d)).toList())
        .map((list) => list
          ..sort((a, b) => (b.createdAt ?? DateTime(0))
              .compareTo(a.createdAt ?? DateTime(0))));
  }

  @override
  Future<void> postItem({
    required String title,
    required double price,
    required String? imageUrl,
    required double latitude,
    required double longitude,
    required String userId,
    String? neighborhoodName,
  }) async {
    final geo = GeoFirePoint(GeoPoint(latitude, longitude));
    await _db.collection('items').add({
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'userId': userId,
      'position': geo.data, // {geohash, geopoint}
      'neighborhoodName': neighborhoodName,
      'likesCount': 0,
      'chatsCount': 0,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<Item>> myItems(String uid) {
    return _db
        .collection('items')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs.map((d) => Item.fromDoc(d)).toList());
  }
}
