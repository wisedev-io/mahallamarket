import 'package:flutter/material.dart';
import 'package:mahallamarket/services/mock_state.dart';

class ManageNeighborhoodScreen extends StatefulWidget {
  const ManageNeighborhoodScreen({super.key});

  @override
  State<ManageNeighborhoodScreen> createState() => _ManageNeighborhoodScreenState();
}

class _ManageNeighborhoodScreenState extends State<ManageNeighborhoodScreen> {
  @override
  Widget build(BuildContext context) {
    final radius = mockState.neighborhoodRadiusKm;
    return Scaffold(
      appBar: AppBar(title: const Text('Manage neighborhood')),
      body: Column(
        children: [
          // Map placeholder
          Expanded(
            child: Stack(
              children: [
                Container(
                  color: Colors.grey.shade200,
                  alignment: Alignment.center,
                  child: const Text('Map (dev placeholder)'),
                ),
                Positioned(
                  bottom: 24, left: 16, right: 16,
                  child: Material(
                    elevation: 2,
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(child: Text('My neighborhood', style: Theme.of(context).textTheme.titleMedium)),
                              TextButton(
                                onPressed: () {},
                                child: const Text('?'),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: FilledButton(
                                  onPressed: () {},
                                  child: Text(mockState.neighborhoodName),
                                ),
                              ),
                              const SizedBox(width: 8),
                              OutlinedButton(onPressed: (){}, child: const Text('+')),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: const [
                              Text('Narrower'),
                              Spacer(),
                              Text('Wider'),
                            ],
                          ),
                          Slider(
                            value: radius,
                            min: 5, max: 20,
                            divisions: 15,
                            label: '${radius.toStringAsFixed(0)} km',
                            onChanged: (v) => setState(()=> mockState.neighborhoodRadiusKm = v),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
