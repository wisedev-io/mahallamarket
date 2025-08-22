import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mahallamarket/models/item.dart';
import 'package:mahallamarket/services/firestore_service.dart';
import 'package:mahallamarket/services/auth_service.dart';
import 'package:mahallamarket/widgets/item_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  final AuthService _authService = AuthService();
  Position? _currentPosition;
  List<Item> _items = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      // Hardcode coordinates for web testing
      _currentPosition = Position(
        latitude: 37.7749,
        longitude: -122.4194,
        timestamp: DateTime.now(),
        accuracy: 1.0,
        altitude: 0.0,
        heading: 0.0,
        speed: 0.0,
        speedAccuracy: 0.0,
        altitudeAccuracy: 0.0,
        headingAccuracy: 0.0,
      );
      await _loadItems();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error getting location: $e')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadItems() async {
    if (_currentPosition == null) return;
    
    try {
      final items = await _firestoreService.getItemsWithinRadius(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        6.0, // 6-km radius
      );
      setState(() {
        _items = items;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading items: $e')));
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _refreshItems() async {
    setState(() {
      _isLoading = true;
    });
    await _loadItems();
  }

  void _logout() async {
    await _authService.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MahallaMarket'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshItems,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () async {
              await Navigator.pushNamed(context, '/post');
              // Refresh items when returning from post screen
              _refreshItems();
            },
          ),
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text('Logout'),
                onTap: _logout,
              ),
            ],
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Loading nearby items...'),
                ],
              ),
            )
          : _items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.shopping_bag_outlined, size: 64, color: Colors.grey),
                      const SizedBox(height: 16),
                      const Text('No items found nearby', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      const SizedBox(height: 8),
                      const Text('Be the first to post something!', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.pushNamed(context, '/post');
                          _refreshItems();
                        },
                        icon: const Icon(Icons.add),
                        label: const Text('Post First Item'),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _refreshItems,
                  child: ListView.builder(
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      return ItemCard(
                        item: _items[index],
                        onTap: () => Navigator.pushNamed(context, '/chat'),
                      );
                    },
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.pushNamed(context, '/post');
          _refreshItems();
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}