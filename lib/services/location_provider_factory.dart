import 'location_provider.dart';
import 'location_provider_real.dart';
import 'location_provider_fake.dart';

const bool kUseFakeLocation =
    bool.fromEnvironment('USE_FAKE_LOCATION', defaultValue: false);

LocationProvider getLocationProvider() =>
    kUseFakeLocation ? FakeLocationProvider() : RealLocationProvider();
