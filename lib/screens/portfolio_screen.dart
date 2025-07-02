import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/portfolio_provider.dart';
import '../widgets/stock_list_item.dart';

class PortfolioScreen extends StatelessWidget {
  const PortfolioScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final portfolio = Provider.of<PortfolioProvider>(context).portfolio;

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
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Total investment
                const Text("Total Investment", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                const SizedBox(height: 4),
                const Text("\$10,000", style: TextStyle(color: Colors.white, fontSize: 16)),
                const Divider(color: Colors.white54, height: 32),

                // Dynamic asset list
                Expanded(
                  child: portfolio.isEmpty
                      ? const Center(
                    child: Text(
                      "Your portfolio is empty.",
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  )
                      : ListView.builder(
                    itemCount: portfolio.length,
                    itemBuilder: (context, index) {
                      final stock = portfolio[index];
                      return StockListItem(stock: stock);
                    },
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
