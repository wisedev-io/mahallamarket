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

  const Item({
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
}
