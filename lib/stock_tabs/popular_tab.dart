import 'package:flutter/material.dart';
import '../services/stock_service.dart';

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
    fetchStockData(); // Start fetching data when widget initializes
  }

  /// Fetches stock data for each symbol in the list
  Future<void> fetchStockData() async {
    List<Map<String, dynamic>> fetched = [];

    for (String symbol in symbols) {
      final stock = await StockService.fetchStockInfo(symbol); // Fetch data from the API
      if (stock != null) fetched.add(stock); // Only add if data is not null
      await Future.delayed(const Duration(milliseconds: 100)); // Avoid API rate limit
    }

    // Prevent state update if the widget was disposed during async call
    if (!mounted) return;

    // Update UI with the fetched data
    setState(() {
      stocks = fetched;
      isLoading = false;
    });
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

        return ListTile(
          // If logo exists, show it; otherwise, show a circle with the first letter of the symbol
          leading: (stock['logo'] != null && stock['logo'].isNotEmpty)
              ? Image.network(
            stock['logo'],
            width: 50,
            height: 50,
            errorBuilder: (_, __, ___) =>
                CircleAvatar(child: Text(stock['symbol'][0])),
          )
              : CircleAvatar(child: Text(stock['symbol'][0])),

          // Company name
          title: Text(
            stock['name'],
            style: const TextStyle(color: Colors.white),
          ),

          // Current stock price
          subtitle: Text(
            '\$${stock['price']}',
            style: const TextStyle(color: Colors.white),
          ),

          // Trend icon colored based on price movement
          trailing: Icon(Icons.show_chart, color: color),
        );
      },
    );
  }
}