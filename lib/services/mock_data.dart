import 'package:mahallamarket/domain/models/item.dart';

final List<Item> mockItems = <Item>[
  Item(
    id: '1',
    ownerId: 'u1',
    title: 'Bicycle',
    price: 150.0,
    neighborhoodId: 'hood1',
    neighborhoodName: 'Chilonzor',
    createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    imageUrl: 'https://via.placeholder.com/300',
    likesCount: 5,
    chatsCount: 2,
  ),
  Item(
    id: '2',
    ownerId: 'u2',
    title: 'Fridge',
    price: 300.0,
    neighborhoodId: 'hood2',
    neighborhoodName: 'Yakkasaroy',
    createdAt: DateTime.now().subtract(const Duration(days: 1)),
    imageUrl: 'https://via.placeholder.com/300',
    likesCount: 3,
    chatsCount: 1,
  ),
];

void addMockItem({
  required String title,
  required double price,
  required String neighborhood,
  String? imageUrl,
}) {
  mockItems.insert(
    0,
    Item(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      ownerId: 'mock',
      title: title,
      price: price,
      neighborhoodId: 'mock-hood',
      neighborhoodName: neighborhood,
      createdAt: DateTime.now(),
      imageUrl: imageUrl ?? 'https://via.placeholder.com/300',
      likesCount: 0,
      chatsCount: 0,
    ),
  );
}
