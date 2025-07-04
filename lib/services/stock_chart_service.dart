/// stock_chart_service.dart
/// Provides functionality to fetch historical candlestick (OHLC) chart data
/// for a specific stock symbol using the Finnhub API.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';


class StockChartService {
  /// Fetches candlestick data for the given stock symbol and resolution.
  /// Returns a list of timestamp-price pairs for chart plotting.
  static Future<List<Map<String, dynamic>>> fetchCandleData({
    required String symbol,
    String resolution = 'D',
  }) async {
    // Generate UNIX timestamps for the last 30 days
    final int toTs = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final int fromTs = DateTime.now().subtract(const Duration(days: 30)).millisecondsSinceEpoch ~/ 1000;
    final baseUrl = dotenv.env['BASE_URL'];
    final apiKey = dotenv.env['API_KEY'];
    // Build the request URL
    final url = Uri.parse(
      '$baseUrl/stock/candle?symbol=$symbol&resolution=$resolution&from=$fromTs&to=$toTs&token=$apiKey',
    );

    // Debugging logs
    print('[DEBUG] symbol=$symbol');
    print('[DEBUG] resolution=$resolution');
    print('[DEBUG] from=$fromTs to=$toTs');
    print('[DEBUG] token=$apiKey');
    print('[DEBUG] Request URL: $url');

    try {
      // Send HTTP GET request
      final response = await http.get(url);

      // If successful, parse JSON and return timestamp-price pairs
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['s'] == 'ok') {
          final timestamps = data['t'] as List<dynamic>;
          final prices = data['c'] as List<dynamic>;
          return List.generate(prices.length, (i) => {
            'timestamp': timestamps[i],
            'price': prices[i],
          });
        } else {
          print('[DEBUG] API returned status: ${data['s']}');
        }
      } else {
        print('[DEBUG] Response status: ${response.statusCode}');
      }
    } catch (e) {
      print('[DEBUG] Exception fetching candle data: $e');
    }

    // Return empty list if request fails
    return [];
  }
}