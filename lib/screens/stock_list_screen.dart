import 'package:flutter/material.dart';
import '../stock_tabs/popular_tab.dart';
import '../stock_tabs/stocks_tab.dart';
import '../stock_tabs/crypto_tab.dart';
import '../stock_tabs/pro_tab.dart';

/// A stateless widget that builds the tabbed stock list interface.
/// Displays four tabs: Popular, Stocks, Crypto, and Pro.
class StockListScreen extends StatelessWidget {
  const StockListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('StoX'), // App title in the top bar
          bottom: const TabBar(
            labelColor: Colors.white,           // Color of selected tab
            unselectedLabelColor: Colors.grey,  // Color of unselected tabs
            indicatorColor: Colors.white,       // Underline indicator color
            tabs: [
              Tab(text: 'Popular'), // Tab 1
              Tab(text: 'Stocks'),  // Tab 2
              Tab(text: 'Crypto'),  // Tab 3
              Tab(text: 'Pro'),     // Tab 4
            ],
          ),
        ),
        backgroundColor: Colors.black, // Background color of the screen
        body: const TabBarView(
          // Content widgets corresponding to each tab
          children: [
            PopularTab(), // Displays popular stocks
            StocksTab(),  // Displays list of all stocks
            CryptoTab(),  // Placeholder or actual crypto screen
            ProTab(),     // Placeholder or premium screen
          ],
        ),
      ),
    );
  }
}