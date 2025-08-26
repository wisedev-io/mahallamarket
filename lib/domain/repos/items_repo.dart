import '../../models/item.dart';

abstract class ItemsRepo {
  Stream<List<Item>> feedNear({
    required double latitude,
    required double longitude,
    double radiusKm,
  });

  Future<void> postItem({
    required String title,
    required double price,
    required String? imageUrl,
    required double latitude,
    required double longitude,
    required String userId,
    String? neighborhoodName,
  });

  Stream<List<Item>> myItems(String uid);
}
