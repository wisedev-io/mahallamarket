import 'package:mahallamarket/core/latlng.dart';
import 'package:mahallamarket/domain/models/item.dart';

abstract class ItemsRepository {
  Stream<List<Item>> watchFeed({required LatLng center, required double radiusKm, String? query});
  Future<String> add(Item itemDraft);
  Future<void> like(String itemId, bool value);
}
