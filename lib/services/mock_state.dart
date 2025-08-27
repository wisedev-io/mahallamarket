/// Simple in-memory state for dev mode (no backend).
class MockState {
  /// Item IDs the user favorited.
  final Set<String> favorites = {};

  /// Whether user verified neighborhood (unlocks chat).
  bool neighborhoodVerified = false;

  /// Selected neighborhood name (header).
  String neighborhoodName = '공동';

  /// Radius in km for neighborhood (UI only in dev).
  double neighborhoodRadiusKm = 12;

  bool isFavorite(String id) => favorites.contains(id);

  /// Toggles favorite and returns new state.
  bool toggleFavorite(String id) {
    if (favorites.contains(id)) {
      favorites.remove(id);
      return false;
    } else {
      favorites.add(id);
      return true;
    }
  }
}

final mockState = MockState();
