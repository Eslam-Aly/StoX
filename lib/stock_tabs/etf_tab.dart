import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../services/stock_service.dart';
import '../screens/stock_details_screen.dart';

class EtfTab extends StatefulWidget {
  const EtfTab({super.key});

  @override
  State<EtfTab> createState() => _EtfTabState();
}

class _EtfTabState extends State<EtfTab> {
  final List<String> symbols = [
    'SPY', 'QQQ', 'DIA', 'VTI', 'IWM', 'XLK', 'XLF', 'ARKK', 'VOO', 'EFA',
    'EEM', 'TLT', 'XLE', 'XLY', 'XLI', 'XLC', 'XLV', 'XLU', 'XLB', 'VNQ',
  ];

  List<Map<String, dynamic>> stocks = [];
  bool isLoading = true;
  String? _lastCurrencyCode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final currentCurrencyCode = Provider.of<CountryProvider>(context).selectedCountry.currencyCode;

    if (_lastCurrencyCode != currentCurrencyCode) {
      _lastCurrencyCode = currentCurrencyCode;
      fetchStockDataSequentially(); // 🔁 Re-fetch with delay
    }
  }

  Future<void> fetchStockDataSequentially() async {
    setState(() => isLoading = true);
    List<Map<String, dynamic>> temp = [];

    try {
      for (final symbol in symbols) {
        final stock = await StockService.fetchStockInfo(symbol, context);
        if (stock != null) temp.add(stock);
        await Future.delayed(const Duration(milliseconds: 100)); // ⏳ Delay
      }

      if (!mounted) return;

      setState(() {
        stocks = temp;
        isLoading = false;
      });
    } catch (e) {
      print('❌ Error fetching ETF data: $e');
      if (!mounted) return;
      setState(() => isLoading = false);
    }
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
        final price = (stock['price'] as num).toDouble() * exchangeRate;
        final prevClose = (stock['prevClose'] as num).toDouble() * exchangeRate;
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