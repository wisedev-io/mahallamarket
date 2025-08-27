import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool dnd = false;

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      const _Header('Notification settings'),
      SwitchListTile(
        title: const Text('Notifications'),
        value: !dnd,
        onChanged: (v) => setState(()=> dnd = !v),
      ),
      SwitchListTile(
        title: const Text('Do not disturb'),
        value: dnd,
        onChanged: (v) => setState(()=> dnd = v),
      ),

      const _Header('User settings'),
      const _NavTile('Manage account'),
      const _NavTile('Followed users'),
      const _NavTile('Manage blocked users'),
      const _NavTile('Manage hidden users'),
      const ListTile(
        title: Text('Video auto-play'),
        trailing: Text('Always on', style: TextStyle(color: Colors.orange)),
      ),
      const _NavTile('Move listings to another neighborhood'),
      const _NavTile('Chats'),
      const _NavTile('Other settings'),

      const _Header('Other'),
      const _NavTile('What\'s new?'),
      const _NavTile('Change country'),
      const ListTile(
        title: Text('Language settings'),
        trailing: Text('English', style: TextStyle(color: Colors.orange)),
      ),
      ListTile(
        title: const Text('Delete cache'),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cache cleared (mock)')),
        ),
      ),
      const ListTile(
        title: Text('Version'),
        trailing: Text('25.34.1(253401)', style: TextStyle(color: Colors.orange)),
        subtitle: Text('Latest version: 25.34.1'),
      ),
      ListTile(
        title: const Text('Log out'),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Logged out (mock)')),
        ),
      ),
      ListTile(
        title: const Text('Delete account'),
        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account deleted (mock)')),
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView.separated(
        itemCount: tiles.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (_, i) => tiles[i],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final String text;
  const _Header(this.text);
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
    child: Text(text, style: Theme.of(context).textTheme.titleSmall),
  );
}

class _NavTile extends StatelessWidget {
  final String text;
  const _NavTile(this.text);
  @override
  Widget build(BuildContext context) => ListTile(
    title: Text(text),
    trailing: const Icon(Icons.chevron_right),
    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$text (mock)')),
    ),
  );
}
