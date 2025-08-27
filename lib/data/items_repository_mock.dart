import 'dart:async';
import 'package:mahallamarket/core/latlng.dart';
import 'package:mahallamarket/domain/models/item.dart';
import 'package:mahallamarket/domain/repos/items_repository.dart';
import 'package:mahallamarket/services/mock_data.dart' as md;
import 'package:mahallamarket/services/mock_state.dart';

class ItemsRepositoryMock implements ItemsRepository {
  final _ctrl = StreamController<List<Item>>.broadcast();

  ItemsRepositoryMock() {
    _emit();
  }

  Item _fromMock(md.MockItem m) => Item(
    id: m.id,
    ownerId: 'mock-user',
    title: m.title,
    price: m.price,
    neighborhoodId: 'mock-hood',
    neighborhoodName: m.neighborhood,
    createdAt: m.postedAt,
    imageUrl: m.imageUrl,
    likesCount: m.likes,
    chatsCount: m.chats,
  );

  void _emit() {
    final items = md.mockItems.map(_fromMock).toList();
    _ctrl.add(items);
  }

  @override
  Stream<List<Item>> watchFeed({required LatLng center, required double radiusKm, String? query}) {
    return _ctrl.stream.map((list) {
      if (query == null || query.isEmpty) return list;
      final q = query.toLowerCase();
      return list.where((e) =>
        e.title.toLowerCase().contains(q) ||
        e.neighborhoodName.toLowerCase().contains(q)
      ).toList();
    });
  }

  @override
  Future<String> add(Item itemDraft) async {
    md.addMockItem(
      title: itemDraft.title,
      price: itemDraft.price,
      neighborhood: itemDraft.neighborhoodName.isEmpty ? '공동' : itemDraft.neighborhoodName,
    );
    _emit();
    return md.mockItems.first.id;
  }

  @override
  Future<void> like(String itemId, bool value) async {
    if (value) {
      mockState.favorites.add(itemId);
    } else {
      mockState.favorites.remove(itemId);
    }
    final idx = md.mockItems.indexWhere((e) => e.id == itemId);
    if (idx >= 0) {
      final it = md.mockItems[idx];
      md.mockItems[idx] = md.MockItem(
        id: it.id,
        title: it.title,
        neighborhood: it.neighborhood,
        postedAt: it.postedAt,
        price: it.price,
        imageUrl: it.imageUrl,
        likes: (it.likes + (value ? 1 : -1)).clamp(0, 1<<30),
        chats: it.chats,
      );
    }
    _emit();
  }
}
