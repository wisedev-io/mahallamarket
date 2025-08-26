import '../../domain/repos/items_repo.dart';
import '../../models/item.dart';

class ApiItemsRepo implements ItemsRepo {
  @override
  Stream<List<Item>> feedNear({required double latitude, required double longitude, double radiusKm = 6}) {
    // TODO: call your REST/GraphQL later
    return const Stream.empty();
  }

  @override
  Future<void> postItem({
    required String title,
    required double price,
    required String? imageUrl,
    required double latitude,
    required double longitude,
    required String userId,
    String? neighborhoodName,
  }) async {
    throw UnimplementedError('Implement API call later');
  }

  @override
  Stream<List<Item>> myItems(String uid) => const Stream.empty();
}
