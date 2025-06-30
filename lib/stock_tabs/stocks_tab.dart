import 'package:flutter/material.dart';
import '../services/stock_service.dart';

/// A stateful widget that displays a list of stock data by fetching
/// all available symbols and their details from the Finnhub API.
class StocksTab extends StatefulWidget {
  const StocksTab({super.key});

  @override
  State<StocksTab> createState() => _StocksTabState();
}

class _StocksTabState extends State<StocksTab> {
  // Stores the detailed stock data to be displayed in the UI
  List<Map<String, dynamic>> stocks = [];

  // Indicates whether the data is still being loaded
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    // Start fetching data when the widget is first created
    fetchStockDetailsForAll();
  }

  /// Fetches the first 100 stock symbols and their corresponding info.
  /// Fetches the first N stock symbols and their corresponding info concurrently.
  /// Fetches selected stock symbols and their info using parallel API calls
  Future<void> fetchStockDetailsForAll() async {
    try {
      // Hardcoded list of popular stock symbols
      const List<String> popularSymbols = [
        'AAPL',
        'MSFT',
        'GOOGL',
        'AMZN',
        'TSLA',
        'META',
        'NVDA',
        'BRK.B',
        'JNJ',
        'JPM',
        'V',
        'PG',
        'UNH',
        'MA',
        'HD',
        'KO',
        'PEP',
        'DIS',
        'XOM',
        'INTC',
      ];

      // Fetch stock info in parallel
      final detailedStocks = await Future.wait(
        popularSymbols.map((symbol) async {
          try {
            final info = await StockService.fetchStockInfo(symbol);
            return info;
          } catch (e) {
            print('⚠️ Error fetching $symbol: $e');
            return null;
          }
        }),
      );

      if (!mounted) return;

      setState(() {
        stocks = detailedStocks.whereType<Map<String, dynamic>>().toList();
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching stocks: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading spinner while data is being fetched
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Build the list view of stock items
    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];

        // Parse and calculate the difference between current price and previous close
        final price = (stock['price'] as num).toDouble();
        final prevClose = (stock['prevClose'] as num).toDouble();
        final diff = price - prevClose;

        // Set the color based on whether the price went up or down
        final color = diff > 0 ? Colors.green : (diff < 0 ? Colors.red : Colors.white);

        return ListTile(
          // If logo is available, show it, otherwise show the first letter of the symbol
          leading: (stock['logo'] != null && stock['logo'].isNotEmpty)
              ? Image.network(
                  stock['logo'],
                  width: 50,
                  height: 50,
                  errorBuilder: (_, __, ___) => CircleAvatar(child: Text(stock['symbol'][0])),
                )
              : CircleAvatar(child: Text(stock['symbol'][0])),

          // Display the company name
          title: Text(
            stock['name'],
            style: const TextStyle(color: Colors.white),
          ),

          // Display the current stock price
          subtitle: Text(
            '\$${stock['price']}',
            style: const TextStyle(color: Colors.white),
          ),

          // Show an icon indicating price trend
          trailing: Icon(Icons.show_chart, color: color),
        );
      },
    );
  }
}