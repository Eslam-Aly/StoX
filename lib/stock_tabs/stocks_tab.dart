/// Displays a list of popular stocks with live price and trend info.
/// Fetches stock details from the Finnhub API and renders them in a scrollable list.

import 'package:flutter/material.dart';
import '../services/stock_service.dart';
import '../screens/stock_details_screen.dart';

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

  /// Fetches detailed stock info for a predefined list of popular symbols.
  Future<void> fetchStockDetailsForAll() async {
    try {
      // Hardcoded list of popular stock symbols (Top 20)
      const List<String> popularSymbols = [
        'AAPL', 'MSFT', 'GOOGL', 'AMZN', 'TSLA', 'META', 'NVDA', 'BRK.B', 'JNJ', 'JPM',
        'V', 'PG', 'UNH', 'MA', 'HD', 'KO', 'PEP', 'DIS', 'XOM', 'INTC',
      ];

      // Fetch each stock's info in parallel
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

      // Store valid stock responses and stop loading
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
    // Show spinner while loading
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Render list of stock tiles
    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];

        // Calculate price difference and trend color
        final price = (stock['price'] as num).toDouble();
        final prevClose = (stock['prevClose'] as num).toDouble();
        final diff = price - prevClose;
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
            // Logo or fallback avatar
            leading: (stock['logo'] != null && stock['logo'].isNotEmpty)
                ? Image.network(
                    stock['logo'],
                    width: 50,
                    height: 50,
                    errorBuilder: (_, __, ___) => CircleAvatar(child: Text(stock['symbol'][0])),
                  )
                : CircleAvatar(child: Text(stock['symbol'][0])),

            // Company name
            title: Text(
              stock['name'],
              style: const TextStyle(color: Colors.white),
            ),

            // Current price
            subtitle: Text(
              '\$${stock['price']}',
              style: const TextStyle(color: Colors.white),
            ),

            // Trend icon
            trailing: Icon(Icons.show_chart, color: color),
          ),
        );
      },
    );
  }
}