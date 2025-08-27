import 'package:flutter/material.dart';
import 'package:mahallamarket/app_dev.dart';
import 'package:mahallamarket/services/location_provider_factory.dart';
import 'package:mahallamarket/services/location_provider.dart';
import 'package:mahallamarket/debug_error_overlay.dart';

late final LocationProvider locationProvider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  installErrorOverlay(); // <-- show errors on screen
  locationProvider = getLocationProvider();
  runApp(const AppDev());
}
