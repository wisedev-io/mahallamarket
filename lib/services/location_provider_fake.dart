import 'location_provider.dart';

class FakeLocationProvider implements LocationProvider {
  static const String _latEnv = String.fromEnvironment('FAKE_LAT', defaultValue: '');
  static const String _lngEnv = String.fromEnvironment('FAKE_LNG', defaultValue: '');

  static const double _defaultLat = 41.3111; // Tashkent-ish
  static const double _defaultLng = 69.2797;

  @override
  Future<({double lat, double lng})> getCurrentPosition() async {
    final lat = double.tryParse(_latEnv) ?? _defaultLat;
    final lng = double.tryParse(_lngEnv) ?? _defaultLng;
    return (lat: lat, lng: lng);
  }
}
