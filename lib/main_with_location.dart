import 'package:flutter/material.dart';
import 'package:mahallamarket/services/location_provider_factory.dart';
import 'package:mahallamarket/services/location_provider.dart';
import 'package:mahallamarket/main.dart' as app;

late final LocationProvider locationProvider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  locationProvider = getLocationProvider();
  // Call the project’s original main(), which initializes Firebase and runs App().
  await app.main();
}
