import 'package:flutter/material.dart';
import '../stock_tabs/popular_tab.dart';
import '../stock_tabs/stocks_tab.dart';
import '../stock_tabs/crypto_tab.dart';
import '../stock_tabs/pro_tab.dart';
import '../widgets/background_wrapper.dart';

/// stock_list_screen.dart
/// This screen displays a tabbed interface for navigating between different categories of stocks:
/// Popular, Stocks, Crypto, and Pro. It uses a transparent background layered over a darkened image.

/// A stateless widget that builds the tabbed stock list interface.
/// Displays four tabs: Popular, Stocks, Crypto, and Pro.
class StockListScreen extends StatelessWidget {
  const StockListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Fullscreen darkened background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.5),
            colorBlendMode: BlendMode.darken, // Dark overlay
          ),
        ),
        DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: [
                // Tab navigation bar
                const TabBar(
                  tabs: [
                    Tab(text: 'Popular'),
                    Tab(text: 'Stocks'),
                    Tab(text: 'Crypto'),
                    Tab(text: 'Pro'),
                  ],
                ),
                // Tab content display
                const Expanded(
                  child: TabBarView(
                    children: [
                      PopularTab(),
                      StocksTab(),
                      CryptoTab(),
                      ProTab(),
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
}