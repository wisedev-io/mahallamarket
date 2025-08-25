import 'package:cloud_firestore/cloud_firestore.dart';

class Item {
  final String id;
  final String title;
  final double price;
  final String? imageUrl;
  final double latitude;
  final double longitude;
  final String userId;
  final String? geohash;
  final DateTime createdAt;

  Item({
    required this.id,
    required this.title,
    required this.price,
    this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.userId,
    this.geohash,
    required this.createdAt,
  });

  factory Item.fromDoc(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>? ?? {};
    final pos = data['position'] as Map<String, dynamic>?;
    final gp = pos?['geopoint'] as GeoPoint?;
    final ts = data['createdAt'];

    DateTime _toDt(dynamic v) {
      if (v == null) return DateTime.fromMillisecondsSinceEpoch(0);
      if (v is Timestamp) return v.toDate();
      if (v is String) return DateTime.tryParse(v) ?? DateTime.fromMillisecondsSinceEpoch(0);
      if (v is DateTime) return v;
      return DateTime.fromMillisecondsSinceEpoch(0);
    }

    return Item(
      id: doc.id,
      title: (data['title'] ?? '') as String,
      price: (data['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: data['imageUrl'] as String?,
      latitude: gp?.latitude ?? (data['latitude'] as num?)?.toDouble() ?? 0,
      longitude: gp?.longitude ?? (data['longitude'] as num?)?.toDouble() ?? 0,
      userId: (data['userId'] ?? '') as String,
      geohash: (pos?['geohash'] as String?),
      createdAt: _toDt(ts),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'userId': userId,
      'position': {
        'geohash': geohash,
        'geopoint': GeoPoint(latitude, longitude),
      },
      'createdAt': createdAt,
    };
  }
}
