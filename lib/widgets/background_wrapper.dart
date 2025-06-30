import 'package:flutter/material.dart';

/// A reusable background wrapper for screens with a full-screen background image.
class BackgroundWrapper extends StatelessWidget {
  final Widget child;

  const BackgroundWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
        ),
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