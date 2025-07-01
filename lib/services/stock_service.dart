/// stock_service.dart
/// Provides methods to fetch and cache stock data using the Finnhub API.

import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for fetching stock data from Finnhub API.
class StockService {
  // Finnhub API Key
  static const String _apiKey = 'd1dhgehr01qn1ojnmdcgd1dhgehr01qn1ojnmdd0';

  // In-memory cache to store stock data per symbol
  static final Map<String, Map<String, dynamic>> _stockCache = {};

  // Tracks when each symbol was last fetched
  static final Map<String, DateTime> _cacheTimestamps = {};

  // Duration before cached data is considered stale
  static const Duration _cacheDuration = Duration(minutes: 2);

  /// Fetches real-time quote and profile info for a given stock symbol.
  /// Caches results to reduce API calls and improve performance.
  static Future<Map<String, dynamic>?> fetchStockInfo(String symbol) async {
    final now = DateTime.now();
    final lastFetch = _cacheTimestamps[symbol];

    // Return cached data if it exists and is still fresh
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

        // Save to cache
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

  /// Fetches a predefined list of popular US stocks using fetchStockInfo for each symbol.
  static Future<List<Map<String, dynamic>>> fetchAllStocks() async {
    final popularSymbols = ['AAPL', 'MSFT', 'GOOGL', 'AMZN', 'META', 'TSLA', 'NVDA', 'NFLX', 'AMD', 'INTC'];

    final List<Map<String, dynamic>> detailedStocks = [];

    // Fetch detailed info for each popular stock symbol
    for (final symbol in popularSymbols) {
      final stock = await fetchStockInfo(symbol);
      if (stock != null) {
        detailedStocks.add(stock);
      }
    }

    return detailedStocks;
  }
}