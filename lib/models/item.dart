// Item data model
class Item {
  final String id;
  final String title;
  final double price;
  final String? imageUrl;
  final double latitude;
  final double longitude;
  final String userId;

  Item({
    required this.id,
    required this.title,
    required this.price,
    this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.userId,
  });

  factory Item.fromMap(Map<String, dynamic> map, String id) {
    return Item(
      id: id,
      title: map['title'] ?? '',
      price: (map['price'] as num).toDouble(),
      imageUrl: map['imageUrl'],
      latitude: (map['latitude'] as num).toDouble(),
      longitude: (map['longitude'] as num).toDouble(),
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'price': price,
      'imageUrl': imageUrl,
      'latitude': latitude,
      'longitude': longitude,
      'userId': userId,
    };
  }
}