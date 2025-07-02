/// This widget displays a scrollable list of popular ETFs in a tab.
/// It fetches ETF info using the StockService and navigates to the StockDetailsScreen on tap.

import 'package:flutter/material.dart';
import '../services/stock_service.dart';
import '../screens/stock_details_screen.dart';

/// A stateful widget that fetches and displays a list of popular ETFs
class EtfTab extends StatefulWidget {
  const EtfTab({super.key});

  @override
  State<EtfTab> createState() => _EtfTabState();
}

class _EtfTabState extends State<EtfTab> {
  // List of hardcoded popular ETF symbols to display
  final List<String> symbols = [
    'SPY', 'QQQ', 'DIA', 'VTI', 'IWM', 'XLK', 'XLF', 'ARKK', 'VOO', 'EFA',
    'EEM', 'TLT', 'XLE', 'XLY', 'XLI', 'XLC', 'XLV', 'XLU', 'XLB', 'VNQ',
  ];

  // This will hold the stock data for each fetched symbol
  List<Map<String, dynamic>> stocks = [];

  // Indicates whether the data is still being fetched
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStockData();
  }

  /// Fetches stock data for each symbol in the predefined list.
  /// Uses parallel requests for better performance.
  Future<void> fetchStockData() async {
    try {
      final futures = symbols.map((symbol) => StockService.fetchStockInfo(symbol)).toList();
      final results = await Future.wait(futures);

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
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];
        final price = (stock['price'] as num).toDouble();
        final prevClose = (stock['prevClose'] as num).toDouble();
        final diff = price - prevClose;

        final color = diff > 0 ? Colors.green : (diff < 0 ? Colors.red : Colors.white);

        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StockDetailsScreen(
                  stockSymbol: stock['symbol'],
                  stockName: stock['name'],
                  price: stock['price'],
                  prevClose: stock['prevClose'],
                  logo: stock['logo'], // pass empty or skip if not available
                ),
              ),
            );
          },
          child: ListTile(
            leading: (stock['logo'] != null && stock['logo'].isNotEmpty)
                ? Image.network(
              stock['logo'],
              width: 50,
              height: 50,
              errorBuilder: (_, __, ___) =>
                  CircleAvatar(child: Text(stock['symbol'][0])),
            )
                : CircleAvatar(child: Text(stock['symbol'][0])),

            title: Text(
              stock['name'],
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              '\$${price.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white),
            ),

            trailing: Icon(Icons.show_chart, color: color),
          ),
        );
      },
    );
  }
}