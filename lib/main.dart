import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/post_screen.dart';
import 'screens/chat_screen.dart';
import 'services/auth_service.dart';
import 'services/notification_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Background handler only for mobile
  if (kIsWeb) return;
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Only set up FCM + local notifications on mobile (not web)
  if (!kIsWeb) {
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    await NotificationService().init();
  }

  runApp(const MahallaMarketApp());
}

class MahallaMarketApp extends StatelessWidget {
  const MahallaMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MahallaMarket',
      theme: ThemeData(primarySwatch: Colors.orange, useMaterial3: true),
      home: Builder(builder: (context) {
        final user = AuthService().currentUser;
        return user != null ? const HomeScreen() : const LoginScreen();
      }),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/post': (context) => const PostScreen(),
        '/chat': (context) => const ChatScreen(),
      },
    );
  }
}
