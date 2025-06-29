import 'package:flutter/material.dart';

/// A stateless widget representing the Crypto tab content
/// Currently displays a placeholder message
class CryptoTab extends StatelessWidget {
  const CryptoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Crypto Tab (Coming Soon)', // Placeholder message
        style: TextStyle(
          color: Colors.white,      // Text color set to white
          fontSize: 20,             // Font size set to 20
        ),
      ),
    );
  }
}