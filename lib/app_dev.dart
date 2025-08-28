import 'package:flutter/material.dart';
import 'package:mahallamarket/screens/home_feed_screen.dart';
import 'package:mahallamarket/screens/chat_list_screen.dart';
import 'package:mahallamarket/screens/profile_hub_screen.dart';

class AppDev extends StatefulWidget {
  const AppDev({super.key});
  @override
  State<AppDev> createState() => _AppDevState();
}

class _AppDevState extends State<AppDev> {
  int _tab = 0;
  final _pages = const [HomeFeedScreen(), ChatListScreen(), ProfileHubScreen()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.orange),
      home: Scaffold(
        body: _pages[_tab],
        bottomNavigationBar: NavigationBar(
          selectedIndex: _tab,
          onDestinationSelected: (i) => setState(() => _tab = i),
          destinations: const [
            NavigationDestination(icon: Icon(Icons.home_outlined), selectedIcon: Icon(Icons.home), label: 'Home'),
            NavigationDestination(icon: Icon(Icons.chat_bubble_outline), selectedIcon: Icon(Icons.chat_bubble), label: 'Chats'),
            NavigationDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: 'My'),
          ],
        ),
      ),
    );
  }
}
