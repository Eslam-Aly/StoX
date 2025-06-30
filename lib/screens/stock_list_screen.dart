import 'package:flutter/material.dart';
import '../stock_tabs/popular_tab.dart';
import '../stock_tabs/stocks_tab.dart';
import '../stock_tabs/crypto_tab.dart';
import '../stock_tabs/pro_tab.dart';
import '../widgets/background_wrapper.dart';

/// A stateless widget that builds the tabbed stock list interface.
/// Displays four tabs: Popular, Stocks, Crypto, and Pro.
class StockListScreen extends StatelessWidget {
  const StockListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
            color: Colors.black.withOpacity(0.5),
            colorBlendMode: BlendMode.darken, // or BlendMode.srcOver
          ),
        ),
        DefaultTabController(
          length: 4,
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text("StoX"),
              backgroundColor: Colors.transparent,
              elevation: 0,
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'Popular'),
                  Tab(text: 'Stocks'),
                  Tab(text: 'Crypto'),
                  Tab(text: 'Pro'),
                ],
              ),
            ),
            body: const TabBarView(
              children: [
                PopularTab(),
                StocksTab(),
                CryptoTab(),
                ProTab(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}