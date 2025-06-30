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
  /// Fetches a list of all stock symbols with basic info
  static Future<List<Map<String, dynamic>>> fetchAllStocks() async {
    final url = Uri.parse('https://finnhub.io/api/v1/stock/symbol?exchange=US&token=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);

      return data
          .where((item) => item['symbol'] != null && item['description'] != null)
          .map<Map<String, dynamic>>((item) => {
        'symbol': item['symbol'],
        'name': item['description'],
      })
          .toList();
    } else {
      throw Exception('Failed to load all stocks');
    }
  }
}