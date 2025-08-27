import 'package:geolocator/geolocator.dart';
import 'location_provider.dart';

class RealLocationProvider implements LocationProvider {
  @override
  Future<({double lat, double lng})> getCurrentPosition() async {
    LocationPermission perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return (lat: pos.latitude, lng: pos.longitude);
  }
}
