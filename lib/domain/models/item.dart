class Item {
  final String id;
  final String ownerId;
  final String title;
  final double price;
  final String neighborhoodId;
  final String neighborhoodName;
  final DateTime createdAt;
  final String? imageUrl;
  final int likesCount;
  final int chatsCount;

  Item({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.price,
    required this.neighborhoodId,
    required this.neighborhoodName,
    required this.createdAt,
    this.imageUrl,
    this.likesCount = 0,
    this.chatsCount = 0,
  });

  Item copyWith({
    String? id,
    String? ownerId,
    String? title,
    double? price,
    String? neighborhoodId,
    String? neighborhoodName,
    DateTime? createdAt,
    String? imageUrl,
    int? likesCount,
    int? chatsCount,
  }) {
    return Item(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      price: price ?? this.price,
      neighborhoodId: neighborhoodId ?? this.neighborhoodId,
      neighborhoodName: neighborhoodName ?? this.neighborhoodName,
      createdAt: createdAt ?? this.createdAt,
      imageUrl: imageUrl ?? this.imageUrl,
      likesCount: likesCount ?? this.likesCount,
      chatsCount: chatsCount ?? this.chatsCount,
    );
  }

  Map<String, dynamic> toMap() => {
    'ownerId': ownerId,
    'title': title,
    'price': price,
    'neighborhoodId': neighborhoodId,
    'neighborhoodName': neighborhoodName,
    'createdAt': createdAt.toIso8601String(),
    'imageUrl': imageUrl,
    'likesCount': likesCount,
    'chatsCount': chatsCount,
  };

  static Item fromMap(String id, Map<String, dynamic> m) => Item(
    id: id,
    ownerId: (m['ownerId'] ?? '') as String,
    title: (m['title'] ?? '') as String,
    price: (m['price'] ?? 0).toDouble(),
    neighborhoodId: (m['neighborhoodId'] ?? '') as String,
    neighborhoodName: (m['neighborhoodName'] ?? '') as String,
    createdAt: DateTime.tryParse(m['createdAt'] ?? '') ?? DateTime.now(),
    imageUrl: m['imageUrl'] as String?,
    likesCount: (m['likesCount'] ?? 0) as int,
    chatsCount: (m['chatsCount'] ?? 0) as int,
  );
}
