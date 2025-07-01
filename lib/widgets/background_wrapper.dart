import 'package:flutter/material.dart';

/// A reusable background wrapper for screens with a full-screen background image.
/// It displays a background image with an optional dark overlay and renders the child widget on top.
class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      // Stack allows layering of widgets; background image at bottom, overlay and child on top
      children: [
        // Background image fills the entire screen
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
        ),
        // Semi-transparent overlay with the child widget
        Positioned.fill(
          child: Container(
            color: Colors.black.withOpacity(0.4), // Optional dark overlay
            child: child,
          ),
        ),
      ],
    );
  }
}