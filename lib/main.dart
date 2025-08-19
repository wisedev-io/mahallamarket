import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';
import 'screens/post_screen.dart';
import 'screens/chat_screen.dart';
import 'services/auth_service.dart';
void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: Text('Hello')))));
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully');
  } catch (e) {
    print('Firebase initialization failed: $e');
  }
  runApp(const MahallaMarketApp());
}

class MahallaMarketApp extends StatelessWidget {
  const MahallaMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MahallaMarket',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
      home: Builder(
        builder: (context) {
          try {
            final user = AuthService().currentUser;
            print('Current user: ${user?.uid ?? 'None'}');
            return user != null ? const HomeScreen() : const LoginScreen();
          } catch (e) {
            print('Error checking user: $e');
            return const LoginScreen();
          }
        },
      ),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(),
        '/post': (context) => const PostScreen(),
        '/chat': (context) => const ChatScreen(),
      },
    );
  }
}