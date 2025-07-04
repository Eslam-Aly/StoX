import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/crypto_service.dart';
import '../screens/stock_details_screen.dart';
import '../providers/country_provider.dart';

class CryptoTab extends StatefulWidget {
  const CryptoTab({super.key});

  @override
  State<CryptoTab> createState() => _CryptoTabState();
}

class _CryptoTabState extends State<CryptoTab> {
  static const List<String> symbols = [
    'BINANCE:BTCUSDT',
    'BINANCE:ETHUSDT',
    'BINANCE:DOGEUSDT',
    'BINANCE:SOLUSDT',
    'BINANCE:ADAUSDT',
    'BINANCE:XRPUSDT',
    'BINANCE:MATICUSDT',
    'BINANCE:LTCUSDT',
    'BINANCE:BCHUSDT',
    'BINANCE:AVAXUSDT',
    'BINANCE:DOTUSDT',
    'BINANCE:LINKUSDT',
    'BINANCE:TRXUSDT',
    'BINANCE:XLMUSDT',
    'BINANCE:ATOMUSDT',
    'BINANCE:NEARUSDT',
    'BINANCE:APEUSDT',
    'BINANCE:UNIUSDT',
    'BINANCE:SANDUSDT',
    'BINANCE:FILUSDT',
  ];

  List<Map<String, dynamic>> cryptoList = [];
  bool isLoading = true;
  String? lastCurrencyCode;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => loadCryptoDataSequentially());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final currentCurrencyCode = Provider.of<CountryProvider>(context).selectedCountry.currencyCode;

    if (lastCurrencyCode != null && currentCurrencyCode != lastCurrencyCode) {
      setState(() {
        isLoading = true;
        cryptoList.clear();
      });
      loadCryptoDataSequentially();
    }
    lastCurrencyCode = currentCurrencyCode;
  }

  Future<void> loadCryptoDataSequentially() async {
    List<Map<String, dynamic>> tempList = [];

    for (String symbol in symbols) {
      final crypto = await CryptoService.fetchCryptoInfo(symbol, context);
      if (crypto != null) {
        tempList.add(crypto);
      }
      await Future.delayed(const Duration(milliseconds: 100)); // ⏳ Delay
    }

    if (!mounted) return;
    setState(() {
      cryptoList = tempList;
      isLoading = false;
    });
  }

  Widget _buildPriceChangeText(double price, double prevClose, String symbol) {
    final change = price - prevClose;
    final isGain = change >= 0;
    final color = isGain ? Colors.green : Colors.red;
    final sign = isGain ? '+' : '-';
    final percentage = (change.abs() / prevClose * 100).toStringAsFixed(2);

    return Text(
      '$sign$symbol${change.abs().toStringAsFixed(2)} ($percentage%)',
      style: TextStyle(color: color, fontWeight: FontWeight.bold),
    );
  }

  final Map<String, IconData> _cryptoIcons = {
    'BTC': Icons.currency_bitcoin,
    'ETH': Icons.token,
    'DOGE': Icons.pets,
    'SOL': Icons.flash_on,
    'ADA': Icons.adjust,
    'XRP': Icons.waves,
    'MATIC': Icons.hexagon,
    'LTC': Icons.light,
    'BCH': Icons.account_balance_wallet,
    'AVAX': Icons.ac_unit,
    'DOT': Icons.blur_on,
    'LINK': Icons.link,
    'TRX': Icons.electrical_services,
    'XLM': Icons.star,
    'ATOM': Icons.public,
    'NEAR': Icons.landscape,
    'APE': Icons.android,
    'UNI': Icons.auto_awesome,
    'SAND': Icons.terrain,
    'FIL': Icons.file_present,
  };

  IconData _getCryptoIcon(String symbol) {
    for (final entry in _cryptoIcons.entries) {
      if (symbol.contains(entry.key)) return entry.value;
    }
    return Icons.monetization_on;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CountryProvider>(
      builder: (context, countryProvider, _) {
        final currencySymbol = countryProvider.currencySymbol;

        if (isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        return ListView.builder(
          itemCount: cryptoList.length,
          itemBuilder: (context, index) {
            final crypto = cryptoList[index];
            final rawSymbol = crypto['symbol'];
            final displaySymbol = rawSymbol.replaceFirst('BINANCE:', '').replaceAll('USDT', '');
            final price = (crypto['price'] as num).toDouble();
            final prevClose = (crypto['prevClose'] as num).toDouble();

            return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => StockDetailsScreen(
                      stockSymbol: rawSymbol,
                      stockName: displaySymbol,
                      price: price,
                      prevClose: prevClose,
                      logo: crypto['logo'],
                    ),
                  ),
                );
              },
              child: ListTile(
                leading: Icon(
                  _getCryptoIcon(displaySymbol),
                  color: Colors.amber,
                  size: 32,
                ),
                title: Text(
                  displaySymbol,
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  '$currencySymbol${price.toStringAsFixed(2)}',
                  style: const TextStyle(color: Colors.white),
                ),
                trailing: _buildPriceChangeText(price, prevClose, currencySymbol),
              ),
            );
          },
        );
      },
    );
  }
}