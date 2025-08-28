import 'package:mahallamarket/core/latlng.dart';
import 'package:mahallamarket/domain/repos/items_repository.dart';
import 'package:mahallamarket/data/items_repository_mock.dart';
import 'package:mahallamarket/data/items_repository_firebase.dart';

class Repositories {
  static final bool noBackend =
      const String.fromEnvironment('NO_BACKEND', defaultValue: 'true') == 'true';

  static final ItemsRepository items = noBackend
      ? ItemsRepositoryMock()
      : ItemsRepositoryFirebase();

  // simple helper for center fallback if needed
  static const LatLng tashkent = LatLng(41.3111, 69.2797);
}
