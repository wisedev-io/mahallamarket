import 'package:flutter/material.dart';
import 'package:mahallamarket/app_dev.dart';
import 'package:mahallamarket/services/location_provider_factory.dart';
import 'package:mahallamarket/services/location_provider.dart';
import 'package:mahallamarket/di/repositories.dart';

late final LocationProvider locationProvider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  locationProvider = getLocationProvider();
  await Repositories.init();
  runApp(const AppDev());
}
