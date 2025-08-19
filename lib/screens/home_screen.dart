import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mahallamarket/models/item.dart';
import 'package:mahallamarket/services/firestore_service.dart';
import 'package:mahallamarket/widgets/item_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirestoreService _firestoreService = FirestoreService();
  Position? _currentPosition;
  List<Item> _items = [];

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
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error loading items: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MahallaMarket'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.pushNamed(context, '/post'),
          ),
        ],
      ),
      body: _items.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _items.length,
              itemBuilder: (context, index) {
                return ItemCard(
                  item: _items[index],
                  onTap: () => Navigator.pushNamed(context, '/chat'),
                );
              },
            ),
    );
  }
}