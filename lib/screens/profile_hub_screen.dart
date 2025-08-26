import 'package:flutter/material.dart';

class ProfileHubScreen extends StatelessWidget {
  const ProfileHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Mahalla')),
      body: ListView(
        children: const [
          ListTile(
            leading: CircleAvatar(child: Icon(Icons.person)),
            title: Text('Your Profile'),
            subtitle: Text('Tap settings to edit later'),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.favorite_outline),
            title: Text('Favorites'),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }
}
