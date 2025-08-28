class FavoritesStore {
  final Set<String> _ids = {};
  bool isFavorite(String id) => _ids.contains(id);
  /// returns new state (true = now favorite)
  bool toggle(String id) {
    if (_ids.contains(id)) { _ids.remove(id); return false; }
    _ids.add(id); return true;
  }
}
final favoritesStore = FavoritesStore();
