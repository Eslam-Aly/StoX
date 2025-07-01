/// portfolio_screen.dart
/// Displays the user's wallet balance, total investment, and a list of owned assets
/// such as stocks or cryptocurrencies. Each asset shows its name, value, and trend.

import 'package:flutter/material.dart';

class PortfolioScreen extends StatefulWidget {
  const PortfolioScreen({super.key});

  @override
  State<PortfolioScreen> createState() => _PortfolioScreenState();
}

class _PortfolioScreenState extends State<PortfolioScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image with dark overlay
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.15),
            colorBlendMode: BlendMode.darken,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: const Text("StoX", style: TextStyle(fontWeight: FontWeight.bold)),
            actions: const [
              Icon(Icons.search),
              SizedBox(width: 10),
              Icon(Icons.more_vert),
              SizedBox(width: 10),
            ],
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Wallet balance
                const Text("Wallet", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                const Text("\$1,000", style: TextStyle(color: Colors.white, fontSize: 16)),
                const SizedBox(height: 16),

                // Total investment
                const Text("Total Investment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                const Text("\$10,000", style: TextStyle(color: Colors.white, fontSize: 16)),
                const Divider(color: Colors.white54, height: 32),

                // Asset list
                Expanded(
                  child: ListView(
                    children: [
                      _buildAssetRow("Bitcoin", "\$3,500", "-1053.7 (-1.23%)", Icons.trending_down, Colors.red),
                      _buildAssetRow("Gold", "\$2,500", "+1053.7 (+1.23%)", Icons.trending_up, Colors.green),
                      _buildAssetRow("Ethereum", "\$3,000", "-1053.7 (-1.23%)", Icons.trending_down, Colors.red),
                      _buildAssetRow("NVIDIA", "\$1,000", "-1053.7 (-1.23%)", Icons.trending_down, Colors.red),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Helper widget to display an asset with price and change indicator.
  Widget _buildAssetRow(String name, String amount, String change, IconData trendIcon, Color trendColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          // Asset name and value
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(amount, style: const TextStyle(color: Colors.white)),
                const SizedBox(height: 2),
                Text(change, style: TextStyle(color: trendColor, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // Icon for visualization
          Icon(Icons.pie_chart, color: Colors.white, size: 40),
        ],
      ),
    );
  }
}