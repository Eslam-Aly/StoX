import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service for fetching cryptocurrency data from Finnhub API.
class CryptoService {
  static const String _apiKey = 'd1dhgehr01qn1ojnmdcgd1dhgehr01qn1ojnmdd0';

  // In-memory cache
  static final Map<String, Map<String, dynamic>> _cache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheDuration = Duration(minutes: 2);

  /// Fetches price info for a given crypto symbol (format: BINANCE:BTCUSDT).
  static Future<Map<String, dynamic>?> fetchCryptoInfo(String symbol) async {
    final now = DateTime.now();

    // Check if data is cached and still valid
    if (_cache.containsKey(symbol) &&
        _cacheTimestamps.containsKey(symbol) &&
        now.difference(_cacheTimestamps[symbol]!) < _cacheDuration) {
      return _cache[symbol];
    }

    final quoteUrl = Uri.parse('https://finnhub.io/api/v1/quote?symbol=$symbol&token=$_apiKey');

    try {
      final response = await http.get(quoteUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final result = {
          'symbol': symbol,
          'price': data['c'] ?? 0.0,
          'prevClose': data['pc'] ?? 0.0,
        };

        // Cache result
        _cache[symbol] = result;
        _cacheTimestamps[symbol] = now;

        return result;
      } else {
        print('Error fetching $symbol: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Exception fetching $symbol: $e');
      return null;
    }
  }
}