import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;

/// Desktop-only stub for local dev (web/linux). Replace with real FlutterFire config later.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform => const FirebaseOptions(
    apiKey: 'stub',
    appId: 'stub',
    messagingSenderId: 'stub',
    projectId: 'stub',
  );
}
