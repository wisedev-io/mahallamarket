import 'package:mahallamarket/core/latlng.dart';
import 'package:mahallamarket/services/location_provider.dart';

class LocationProviderFake implements LocationProvider {
  static const String _latStr = String.fromEnvironment('FAKE_LAT', defaultValue: '41.3111');
  static const String _lngStr = String.fromEnvironment('FAKE_LNG', defaultValue: '69.2797');

  @override
  Future<LatLng?> get() async {
    final lat = double.tryParse(_latStr) ?? 41.3111;
    final lng = double.tryParse(_lngStr) ?? 69.2797;
    return LatLng(lat, lng);
  }
}
