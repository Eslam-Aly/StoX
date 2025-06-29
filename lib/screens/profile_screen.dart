import 'package:flutter/material.dart';

/// Stateless widget that represents the user profile screen
/// Currently displays a centered placeholder text
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black, // Background matches app's dark theme
      body: Center(
        child: Text(
          'Profile Screen', // Placeholder content for user profile UI
          style: TextStyle(
            color: Colors.white,         // White text for visibility
            fontSize: 24,                // Large, readable font
            fontWeight: FontWeight.bold, // Bold styling for emphasis
          ),
        ),
      ),
    );
  }
}
