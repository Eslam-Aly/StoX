import 'package:flutter/material.dart';

/// A stateless widget representing the "Pro" tab for premium users.
/// Currently displays a placeholder message indicating premium features.
class ProTab extends StatelessWidget {
  const ProTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Pro Features (Premium Access)', // Placeholder message
        style: TextStyle(
          color: Colors.white, // Text color set to white for contrast
          fontSize: 20,        // Font size for visibility
        ),
      ),
    );
  }
}