import 'package:flutter/material.dart';
import 'package:mahallamarket/services/location_provider_factory.dart';
import 'package:mahallamarket/services/location_provider.dart';

late final LocationProvider locationProvider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  locationProvider = getLocationProvider();
  runApp(const _SmokeApp());
}

class _SmokeApp extends StatelessWidget {
  const _SmokeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smoke Test',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Smoke Test')),
        body: Center(
          child: FutureBuilder<({double lat, double lng})>(
            future: locationProvider.getCurrentPosition(),
            builder: (context, snap) {
              if (snap.connectionState != ConnectionState.done) {
                return const Text('Loading fake location…');
              }
              if (snap.hasError) {
                return Text('Error: ${snap.error}');
              }
              final p = snap.data!;
              return Text('Hello! Fake lat=${p.lat}, lng=${p.lng}');
            },
          ),
        ),
      ),
    );
  }
}
