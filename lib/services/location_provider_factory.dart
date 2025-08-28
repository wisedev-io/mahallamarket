import 'package:mahallamarket/services/location_provider.dart';
import 'package:mahallamarket/services/location_provider_fake.dart';
import 'package:mahallamarket/services/location_provider_real.dart';

final bool _useFake =
  const String.fromEnvironment('USE_FAKE_LOCATION', defaultValue: 'false') == 'true';

LocationProvider? _cached;

LocationProvider getLocationProvider() {
  _cached ??= _useFake ? LocationProviderFake() : LocationProviderReal();
  return _cached!;
}
