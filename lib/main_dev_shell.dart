import 'package:flutter/material.dart';
import 'package:mahallamarket/services/location_provider_factory.dart';
import 'package:mahallamarket/services/location_provider.dart';
import 'package:mahallamarket/main.dart' as app;

// runs App() WITHOUT Firebase initialization
late final LocationProvider locationProvider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  locationProvider = getLocationProvider();
  runApp(const app.App());
}
