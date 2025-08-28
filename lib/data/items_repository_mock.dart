import 'dart:async';
import 'package:mahallamarket/core/latlng.dart';
import 'package:mahallamarket/domain/models/item.dart';
import 'package:mahallamarket/domain/repos/items_repository.dart';
import 'package:mahallamarket/services/mock_data.dart';

class ItemsRepositoryMock implements ItemsRepository {
  final _ctrl = StreamController<List<Item>>.broadcast();
  final List<Item> _store = [];
  Timer? _tick;

  ItemsRepositoryMock() {
    for (final raw in mockItems) {
      if (raw is Item) {
        _store.add(raw);
        continue;
      }
      final m = raw as dynamic; // tolerate legacy MockItem fields
      final id = (m.id ?? DateTime.now().millisecondsSinceEpoch.toString()).toString();
      final ownerId = (m.ownerId ?? 'mock-user').toString();
      final title = (m.title ?? 'Untitled').toString();
      final priceNum = (m.price ?? 0);
      final price = priceNum is num ? priceNum.toDouble() : 0.0;
      final neighborhoodId = (m.neighborhoodId ?? 'mock-hood').toString();
      final neighborhoodName =
          (m.neighborhoodName ?? m.neighborhood ?? 'Mock Neighborhood').toString();
      final createdAt = (m.createdAt ?? m.postedAt ?? DateTime.now()) as DateTime;
      final imageUrl = (m.imageUrl as String?)?.isEmpty == true ? null : m.imageUrl as String?;
      final likesCount = ((m.likesCount ?? m.likes ?? 0) as num).toInt();
      final chatsCount = ((m.chatsCount ?? m.chats ?? 0) as num).toInt();

      _store.add(Item(
        id: id,
        ownerId: ownerId,
        title: title,
        price: price,
        neighborhoodId: neighborhoodId,
        neighborhoodName: neighborhoodName,
        createdAt: createdAt,
        imageUrl: imageUrl,
        likesCount: likesCount,
        chatsCount: chatsCount,
      ));
    }

    // emit periodic change to prove stream is live
    _tick = Timer.periodic(const Duration(seconds: 20), (_) {
      if (_store.isEmpty) return;
      _store[0] = _store[0].copyWith(likesCount: _store[0].likesCount + 1);
      _emit();
    });
  }

  void _emit() => _ctrl.add(List.unmodifiable(_store));

  @override
  Future<String> add(Item item) async {
    final id = DateTime.now().millisecondsSinceEpoch.toString();
    _store.insert(0, item.copyWith(id: id, ownerId: item.ownerId.isEmpty ? 'me' : item.ownerId));
    _emit();
    return id;
  }

  @override
  Future<void> update(Item item) async {
    final idx = _store.indexWhere((e) => e.id == item.id);
    if (idx == -1) return;
    _store[idx] = _store[idx].copyWith(
      title: item.title,
      price: item.price,
      neighborhoodId: item.neighborhoodId,
      neighborhoodName: item.neighborhoodName,
      imageUrl: item.imageUrl,
    );
    _emit();
  }

  @override
  Future<void> like(String itemId, bool value) async {
    final i = _store.indexWhere((e) => e.id == itemId);
    if (i == -1) return;
    final cur = _store[i];
    final next = cur.likesCount + (value ? 1 : -1);
    _store[i] = cur.copyWith(likesCount: next < 0 ? 0 : next);
    _emit();
  }

  @override
  Stream<List<Item>> watchFeed({
    required LatLng center,
    required double radiusKm,
    String? query,
  }) {
    Future.microtask(_emit); // push initial snapshot
    return _ctrl.stream.map((items) {
      if (query == null || query.trim().isEmpty) return items;
      final q = query.toLowerCase();
      return items.where((e) => e.title.toLowerCase().contains(q)).toList();
    });
  }

  void dispose() {
    _tick?.cancel();
    _ctrl.close();
  }
}
