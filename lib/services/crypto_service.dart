/// crypto_service.dart
/// Service for fetching real-time cryptocurrency data (e.g., BTCUSDT) from Finnhub API.
/// Implements simple in-memory caching to reduce redundant network calls.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

/// Service for fetching cryptocurrency data from Finnhub API.
class CryptoService {
  // Finnhub API key
  static const String _apiKey = 'd1dhgehr01qn1ojnmdcgd1dhgehr01qn1ojnmdd0';

  // In-memory cache for storing fetched crypto data
  static final Map<String, Map<String, dynamic>> _cache = {};

  // Timestamps for when each crypto's data was last fetched
  static final Map<String, DateTime> _cacheTimestamps = {};

  // Duration before the cache is considered stale
  static const Duration _cacheDuration = Duration(minutes: 2);

  /// Fetches current price and previous close for the given crypto symbol.
  /// Symbol format: BINANCE:BTCUSDT, BINANCE:ETHUSDT, etc.
  static Future<Map<String, dynamic>?> fetchCryptoInfo(String symbol) async {
    final now = DateTime.now();

    // Return cached data if available and still fresh
    if (_cache.containsKey(symbol) &&
        _cacheTimestamps.containsKey(symbol) &&
        now.difference(_cacheTimestamps[symbol]!) < _cacheDuration) {
      return _cache[symbol];
    }

    // Construct the API URL for fetching quote data
    final quoteUrl = Uri.parse('https://finnhub.io/api/v1/quote?symbol=$symbol&token=$_apiKey');

    try {
      // Perform the HTTP GET request
      final response = await http.get(quoteUrl);

      if (response.statusCode == 200) {
        // Decode the JSON response
        final data = json.decode(response.body);

        // Prepare formatted result
        final result = {
          'symbol': symbol,
          'price': data['c'] ?? 0.0,
          'prevClose': data['pc'] ?? 0.0,
        };

        // Store result in cache
        _cache[symbol] = result;
        _cacheTimestamps[symbol] = now;

        return result;
      } else {
        // Log error if response status is not OK
        print('Error fetching $symbol: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      // Log exception during HTTP request or JSON parsing
      print('Exception fetching $symbol: $e');
      return null;
    }
  }
}
  IconData getCryptoIcon(String symbol) {
    switch (symbol.toUpperCase()) {
      case 'BTC':
        return Icons.currency_bitcoin;
      case 'ETH':
        return Icons.auto_graph;
      case 'DOGE':
        return Icons.pets;
      case 'SOL':
        return Icons.flash_on;
      case 'ADA':
        return Icons.circle;
      case 'XRP':
        return Icons.waves;
      case 'MATIC':
        return Icons.polymer;
      case 'LTC':
        return Icons.light_mode;
      case 'BCH':
        return Icons.account_balance_wallet;
      default:
        return Icons.token;
    }
  }
