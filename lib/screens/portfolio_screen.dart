import 'package:flutter/material.dart';

/// Stateless widget that represents the user's portfolio screen
/// Currently shows placeholder text centered on the screen
class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.black, // Set background to match app theme
      body: Center(
        child: Text(
          'Portfolio Screen', // Placeholder text for the screen
          style: TextStyle(
            color: Colors.white,         // White text for contrast
            fontSize: 24,                // Large font size
            fontWeight: FontWeight.bold, // Bold text for emphasis
          ),
        ),
      ),
    );
  }
}