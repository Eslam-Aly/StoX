/// This widget displays a scrollable list of popular stocks in a tab.
/// It fetches stock info using the StockService and navigates to the StockDetailsScreen on tap.

import 'package:flutter/material.dart';
import '../services/stock_service.dart';
import '../screens/stock_details_screen.dart';

/// A stateful widget that fetches and displays a list of popular stocks
class PopularTab extends StatefulWidget {
  const PopularTab({super.key});

  @override
  State<PopularTab> createState() => _PopularTabState();
}

class _PopularTabState extends State<PopularTab> {
  // List of hardcoded popular stock symbols to display
  final List<String> symbols = [
    'AAPL', 'GOOG', 'MSFT', 'TSLA', 'AMZN', 'NVDA', 'META', 'NFLX',
    'BABA', 'BA', 'ORCL', 'INTC', 'PYPL', 'DIS', 'V', 'JPM', 'IBM', 'PEP', 'KO', 'MCD',
  ];

  // This will hold the stock data for each fetched symbol
  List<Map<String, dynamic>> stocks = [];

  // Indicates whether the data is still being fetched
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Fetch stock data when the widget is initialized
    fetchStockData();
  }

  /// Fetches stock data for each symbol in the predefined list.
  /// Uses parallel requests for better performance.
  Future<void> fetchStockData() async {
    try {
      // Fire all requests in parallel
      final futures = symbols.map((symbol) => StockService.fetchStockInfo(symbol)).toList();
      final results = await Future.wait(futures);

      // Filter out null results
      final fetched = results.whereType<Map<String, dynamic>>().toList();

      if (!mounted) return;

      setState(() {
        stocks = fetched;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching stock data: $e');
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show a loading spinner while data is being fetched
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Render the list of stocks
    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];
        final price = (stock['price'] as num).toDouble();
        final prevClose = (stock['prevClose'] as num).toDouble();
        final diff = price - prevClose;

        // Choose color based on price difference
        final color = diff > 0 ? Colors.green : (diff < 0 ? Colors.red : Colors.white);

        return GestureDetector(
          // Navigate to stock details screen on tap
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StockDetailsScreen(
                  stockSymbol: stock['symbol'],
                  stockName: stock['name'],
                ),
              ),
            );
          },
          child: ListTile(
            // Company logo or fallback
            leading: (stock['logo'] != null && stock['logo'].isNotEmpty)
                ? Image.network(
                    stock['logo'],
                    width: 50,
                    height: 50,
                    errorBuilder: (_, __, ___) =>
                        CircleAvatar(child: Text(stock['symbol'][0])),
                  )
                : CircleAvatar(child: Text(stock['symbol'][0])),

            // Stock name and current price
            title: Text(
              stock['name'],
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              '\$${stock['price']}',
              style: const TextStyle(color: Colors.white),
            ),

            // Price trend indicator
            trailing: Icon(Icons.show_chart, color: color),
          ),
        );
      },
    );
  }
}