import 'package:flutter/material.dart';
import 'package:mahallamarket/screens/favorites_screen.dart';
import 'package:mahallamarket/screens/settings_screen.dart';

class ProfileDevScreen extends StatelessWidget {
  const ProfileDevScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Mahalla'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> const SettingsScreen())),
          ),
        ],
      ),
      body: ListView(
        children: [
          const ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('Liampayne'),
            subtitle: Text('Profile settings (mock)'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.favorite_outline),
            title: const Text('Favorites'),
            trailing: const Icon(Icons.chevron_right),
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> const FavoritesScreen())),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.map_outlined),
            title: const Text('Manage neighborhood'),
            trailing: const Icon(Icons.chevron_right),
            onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (_)=> const SettingsScreen())),
          ),
        ],
      ),
    );
  }
}
