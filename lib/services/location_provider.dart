/// Minimal location interface used by the app.
abstract class LocationProvider {
  Future<({double lat, double lng})> getCurrentPosition();
}
