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
  Future<void> fetchStockDetailsForAll() async {
    try {
      // Fetch a list of all stock symbols from the US exchange
      final allSymbols = await StockService.fetchAllStocks();

      // Limit to the first 100 stocks to reduce API load
      final first100 = allSymbols.take(100).toList();

      List<Map<String, dynamic>> detailedStocks = [];

      // Fetch detailed info for each of the 100 stocks
      for (final stock in first100) {
        final symbol = stock['symbol'];
        final info = await StockService.fetchStockInfo(symbol);

        // Add the stock info to the list if the API call was successful
        if (info != null) {
          detailedStocks.add(info);
        }

        // Delay each request slightly to avoid hitting rate limits
        await Future.delayed(const Duration(milliseconds: 100));
      }

      // Only update state if the widget is still in the widget tree
      if (!mounted) return;

      // Save the fetched data and update the loading state
      setState(() {
        stocks = detailedStocks;
        isLoading = false;
      });
    } catch (e) {
      // If the widget was removed during the async operation, exit early
      if (!mounted) return;

      // Set loading to false and show an error message
      setState(() {
        isLoading = false;
      });
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