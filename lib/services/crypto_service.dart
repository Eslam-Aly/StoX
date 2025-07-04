/// crypto_service.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';

class CryptoService {
  // 🧠 In-memory cache
  static final Map<String, Map<String, dynamic>> _cache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};

  /// Fetches real-time crypto data from Finnhub (e.g., BINANCE:BTCUSDT)
  static Future<Map<String, dynamic>?> fetchCryptoInfo(
      String symbol,
      BuildContext context,
      ) async {
    final now = DateTime.now();

    // ✅ Use cache if not older than 2 minutes
    if (_cache.containsKey(symbol) &&
        _cacheTimestamps.containsKey(symbol) &&
        now.difference(_cacheTimestamps[symbol]!).inMinutes < 2) {
      return _cache[symbol];
    }

    final apiKey = dotenv.env['API_KEY'];
    final baseUrl = dotenv.env['BASE_URL'];
    final quoteUrl = Uri.parse('$baseUrl/quote?symbol=$symbol&token=$apiKey');

    try {
      final response = await http.get(quoteUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rate = Provider.of<CountryProvider>(context, listen: false).exchangeRate ?? 1.0;

        final result = {
          'symbol': symbol,
          'price': (data['c'] as num?)?.toDouble() ?? 0.0 * rate,
          'prevClose': (data['pc'] as num?)?.toDouble() ?? 0.0 * rate,
        };

        // 💾 Store in cache
        _cache[symbol] = result;
        _cacheTimestamps[symbol] = now;

        return result;
      } else {
        print('❌ Error fetching $symbol: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('💥 Exception fetching $symbol: $e');
      return null;
    }
  }
}

// Bonus: Optional icon mapping
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