class MockState {
  final Set<String> favorites = {};
  bool neighborhoodVerified = false;
  String neighborhoodName = '공동';
  double neighborhoodRadiusKm = 12;

  bool isFavorite(String itemId) => favorites.contains(itemId);

  /// Toggle favorite and return the new state (true = now favorited)
  bool toggleFavorite(String itemId) {
    if (favorites.contains(itemId)) {
      favorites.remove(itemId);
      return false;
    } else {
      favorites.add(itemId);
      return true;
    }
  }
}

final mockState = MockState();
