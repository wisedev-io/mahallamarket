import 'package:flutter/material.dart';
import 'package:mahallamarket/services/mock_state.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verification')),
      body: Column(
        children: [
          // Map placeholder
          Expanded(
            child: Container(
              color: Colors.grey.shade200,
              alignment: Alignment.center,
              child: const Text('Map preview (dev placeholder)'),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.04),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text('Please allow location permissions.'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: FilledButton(
              onPressed: () {
                mockState.neighborhoodVerified = true;
                Navigator.pop(context);
              },
              child: const Text('Verify now (mock)'),
            ),
          ),
        ],
      ),
    );
  }
}
