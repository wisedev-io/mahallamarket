import 'package:mahallamarket/core/latlng.dart';
import 'package:mahallamarket/domain/models/item.dart';

abstract class ItemsRepository {
  Future<String> add(Item itemDraft);
  Future<void> update(Item item);            // <-- added
  Future<void> like(String itemId, bool value);
  Stream<List<Item>> watchFeed({
    required LatLng center,
    required double radiusKm,
    String? query,
  });
}
