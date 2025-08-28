import 'package:mahallamarket/core/latlng.dart';

abstract class LocationProvider {
  /// Return current location or null if not available/denied.
  Future<LatLng?> get();
}
