/// This service handles all stock-related API requests using the Finnhub API.
/// It includes methods to fetch individual stock data and retrieve a full list of available stocks.

import 'dart:convert';
import 'package:http/http.dart' as http;

class StockService {
  /// API key used to authenticate requests to the Finnhub API.
  static const String _apiKey = 'd1dhgehr01qn1ojnmdcgd1dhgehr01qn1ojnmdd0';

  /// Fetches current price and profile info for a specific stock symbol.
  /// Returns a map containing symbol, price, previous close, logo, and name.
  static Future<Map<String, dynamic>?> fetchStockInfo(String symbol) async {
    // URL to get the current stock quote.
    final quoteUrl = Uri.parse('https://finnhub.io/api/v1/quote?symbol=$symbol&token=$_apiKey');
    // URL to get the company's profile information.
    final profileUrl = Uri.parse('https://finnhub.io/api/v1/stock/profile2?symbol=$symbol&token=$_apiKey');

    try {
      // Perform GET request for quote data.
      final quoteResponse = await http.get(quoteUrl);
      // Perform GET request for profile data.
      final profileResponse = await http.get(profileUrl);

      if (quoteResponse.statusCode == 200 && profileResponse.statusCode == 200) {
        final quoteData = json.decode(quoteResponse.body);
        final profileData = json.decode(profileResponse.body);

        // Combine and return the quote and profile data.
        return {
          'symbol': symbol,
          'price': quoteData['c'] ?? 0.0,
          'prevClose': quoteData['pc'] ?? 0.0,
          'logo': profileData['logo'] ?? '',
          'name': profileData['name'] ?? symbol,
        };
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  /// Fetches a list of all stocks available on the US exchange from Finnhub API.
  /// Returns a list of maps containing symbol and company name.
  static Future<List<Map<String, dynamic>>> fetchAllStocks() async {
    // URL to get all US exchange listed stock symbols.
    final url = Uri.parse('https://finnhub.io/api/v1/stock/symbol?exchange=US&token=$_apiKey');
    // Perform GET request for the stock symbol list.
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Decode the JSON response.
      final List<dynamic> data = json.decode(response.body);
      // Filter and map each item to include only symbol and description.
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