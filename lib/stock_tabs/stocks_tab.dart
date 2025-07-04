import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../services/stock_service.dart';
import '../screens/stock_details_screen.dart';

class StocksTab extends StatefulWidget {
  const StocksTab({super.key});

  @override
  State<StocksTab> createState() => _StocksTabState();
}

class _StocksTabState extends State<StocksTab> {
  List<Map<String, dynamic>> stocks = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStockDetailsSequentially(); // 🔁 Replaced parallel fetch with sequential
  }

  Future<void> fetchStockDetailsSequentially() async {
    const List<String> popularSymbols = [
      'AAPL', 'MSFT', 'GOOGL', 'AMZN', 'TSLA', 'META', 'NVDA', 'BRK.B', 'JNJ', 'JPM',
      'V', 'PG', 'UNH', 'MA', 'HD', 'KO', 'PEP', 'DIS', 'XOM', 'INTC',
    ];

    List<Map<String, dynamic>> temp = [];

    for (final symbol in popularSymbols) {
      final stock = await StockService.fetchStockInfo(symbol, context);
      if (stock != null) temp.add(stock);

      await Future.delayed(const Duration(milliseconds: 100)); // ⏳ Delay to avoid API 429
    }

    if (!mounted) return;
    setState(() {
      stocks = temp;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencySymbol = Provider.of<CountryProvider>(context).currencySymbol;
    final exchangeRate = Provider.of<CountryProvider>(context).exchangeRate;

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      itemCount: stocks.length,
      itemBuilder: (context, index) {
        final stock = stocks[index];

        final rawPrice = (stock['price'] as num).toDouble();
        final rawPrevClose = (stock['prevClose'] as num).toDouble();

        final price = rawPrice * exchangeRate;
        final prevClose = rawPrevClose * exchangeRate;
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
                  price: price,
                  prevClose: prevClose,
                  logo: stock['logo'],
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
              errorBuilder: (_, __, ___) => CircleAvatar(child: Text(stock['symbol'][0])),
            )
                : CircleAvatar(child: Text(stock['symbol'][0])),
            title: Text(
              stock['name'],
              style: const TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              '$currencySymbol${price.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white),
            ),
            trailing: Icon(Icons.show_chart, color: color),
          ),
        );
      },
    );
  }
}