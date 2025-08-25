import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mahallamarket/models/item.dart';
import 'package:mahallamarket/services/firestore_service.dart';
import 'package:mahallamarket/services/auth_service.dart';
import 'package:mahallamarket/widgets/item_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _fs = FirestoreService();
  final _auth = AuthService();
  Stream<List<Item>>? _stream;
  Position? _pos;
  bool _loading = false;
  final _radiusKm = 6.0;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    setState(() => _loading = true);
    try {
      bool svc = await Geolocator.isLocationServiceEnabled();
      if (!svc) {
        await Geolocator.openLocationSettings();
      }
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever) return;

      _pos = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      if (_pos != null) {
        _stream = _fs.itemsNear(latitude: _pos!.latitude, longitude: _pos!.longitude, radiusKm: _radiusKm);
        setState(() {});
      }
    } finally {
      setState(() => _loading = false);
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
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _stream == null
              ? const Center(child: Text('Location permission required.'))
              : StreamBuilder<List<Item>>(
                  stream: _stream,
                  builder: (context, snap) {
                    if (snap.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final items = snap.data ?? [];
                    if (items.isEmpty) {
                      return const Center(child: Text('No items near you yet.'));
                    }
                    return ListView.builder(
                      itemCount: items.length,
                      itemBuilder: (context, i) => ItemCard(
                        item: items[i],
                        onTap: () {
                          // TODO: Navigate to details or seller chat
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
