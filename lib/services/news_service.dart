import 'dart:convert';
import 'package:http/http.dart' as http;

/// Service class responsible for fetching and caching news articles from the Finnhub API.
class NewsService {
  static const String _apiKey = 'd1dhgehr01qn1ojnmdcgd1dhgehr01qn1ojnmdd0';

  // In-memory cache and timestamp
  static List<dynamic>? _cachedNews;
  static DateTime? _lastFetched;
  static const Duration _cacheDuration = Duration(minutes: 2);

  /// Fetches general news from the Finnhub API or returns cached data if fresh.
  static Future<List<dynamic>> fetchNews() async {
    final now = DateTime.now();

    if (_cachedNews != null &&
        _lastFetched != null &&
        now.difference(_lastFetched!) < _cacheDuration) {
      return _cachedNews!;
    }

    final url = Uri.parse('https://finnhub.io/api/v1/news?category=general&token=$_apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      _cachedNews = json.decode(response.body);
      _lastFetched = now;
      return _cachedNews!;
    } else {
      throw Exception('Failed to load news');
    }
  }
}