/// stock_service.dart
/// Provides methods to fetch and cache stock data using the Finnhub API.
import '../providers/country_provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';


/// Service for fetching stock data from Finnhub API.
class StockService {
  // In-memory cache to store stock data per symbol
  static final Map<String, Map<String, dynamic>> _stockCache = {};

  // Tracks when each symbol was last fetched
  static final Map<String, DateTime> _cacheTimestamps = {};

  // Duration before cached data is considered stale
  static const Duration _cacheDuration = Duration(minutes: 2);
  /// Fetches real-time quote and profile info for a given stock symbol.
  /// Caches results to reduce API calls and improve performance.
  static Future<Map<String, dynamic>?> fetchStockInfo(String symbol, BuildContext context) async {

    final baseUrl = dotenv.env['BASE_URL'];
    final apiKey = dotenv.env['API_KEY'];
    final quoteUrl = Uri.parse('$baseUrl/quote?symbol=$symbol&token=$apiKey');
    final profileUrl = Uri.parse('$baseUrl/stock/profile2?symbol=$symbol&token=$apiKey');
    final now = DateTime.now();
    final lastFetch = _cacheTimestamps[symbol];

    // Return cached data if it exists and is still fresh
    if (_stockCache.containsKey(symbol) &&
        lastFetch != null &&
        now.difference(lastFetch) < _cacheDuration) {
      return _stockCache[symbol];
    }
    try {
      final quoteResponse = await http.get(quoteUrl);
      final profileResponse = await http.get(profileUrl);

      if (quoteResponse.statusCode == 200 && profileResponse.statusCode == 200) {
        final quoteData = json.decode(quoteResponse.body);
        final profileData = json.decode(profileResponse.body);
        final rate = Provider.of<CountryProvider>(context, listen: false).exchangeRate ?? 1.0;
        final stockData = {
          'symbol': symbol,
          'price': (quoteData['c'] ?? 0.0) * rate,
          'prevClose': (quoteData['pc'] ?? 0.0) * rate,
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
}