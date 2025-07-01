import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for fetching stock data from Finnhub API.
class StockService {
  static const String _apiKey = 'd1dhgehr01qn1ojnmdcgd1dhgehr01qn1ojnmdd0';

  static final Map<String, Map<String, dynamic>> _stockCache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheDuration = Duration(minutes: 2);

  static Future<Map<String, dynamic>?> fetchStockInfo(String symbol) async {
    final now = DateTime.now();
    final lastFetch = _cacheTimestamps[symbol];

    // Use cached data if within duration
    if (_stockCache.containsKey(symbol) &&
        lastFetch != null &&
        now.difference(lastFetch) < _cacheDuration) {
      return _stockCache[symbol];
    }

    final quoteUrl = Uri.parse('https://finnhub.io/api/v1/quote?symbol=$symbol&token=$_apiKey');
    final profileUrl = Uri.parse('https://finnhub.io/api/v1/stock/profile2?symbol=$symbol&token=$_apiKey');

    try {
      final quoteResponse = await http.get(quoteUrl);
      final profileResponse = await http.get(profileUrl);

      if (quoteResponse.statusCode == 200 && profileResponse.statusCode == 200) {
        final quoteData = json.decode(quoteResponse.body);
        final profileData = json.decode(profileResponse.body);

        final stockData = {
          'symbol': symbol,
          'price': quoteData['c'] ?? 0.0,
          'prevClose': quoteData['pc'] ?? 0.0,
          'logo': profileData['logo'] ?? '',
          'name': profileData['name'] ?? symbol,
        };

        _stockCache[symbol] = stockData;
        _cacheTimestamps[symbol] = now;

        return stockData;
      } else {
        print('Error fetching $symbol data: ${quoteResponse.statusCode}, ${profileResponse.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception for $symbol: $e');
      return null;
    }
  }
  /// Fetches a list of top US stocks with detailed info using fetchStockInfo.
  static Future<List<Map<String, dynamic>>> fetchAllStocks() async {
    final popularSymbols = ['AAPL', 'MSFT', 'GOOGL', 'AMZN', 'META', 'TSLA', 'NVDA', 'NFLX', 'AMD', 'INTC'];

    final List<Map<String, dynamic>> detailedStocks = [];

    for (final symbol in popularSymbols) {
      final stock = await fetchStockInfo(symbol);
      if (stock != null) {
        detailedStocks.add(stock);
      }
    }

    return detailedStocks;
  }
  /// Fetches historical candle/price data for a stock symbol.
  static Future<List<Map<String, dynamic>>> fetchCandleData({
    required String symbol,
    String resolution = '30',
    required int from,
    required int to,
  }) async {
    final url = Uri.parse(
      'https://finnhub.io/api/v1/stock/candle?symbol=$symbol&resolution=$resolution&from=$from&to=$to&token=$_apiKey',
    );

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['s'] == 'ok') {
          final timestamps = data['t'] as List<dynamic>;
          final prices = data['c'] as List<dynamic>;
          return List.generate(prices.length, (i) {
            return {
              'timestamp': timestamps[i],
              'price': prices[i],
            };
          });
        }
      }
      return [];
    } catch (e) {
      print('Error fetching candle data for $symbol: $e');
      return [];
    }
  }
}