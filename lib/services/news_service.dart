/// news_service.dart
/// Handles fetching and caching general news data from the Finnhub API.

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service class responsible for fetching and caching news articles from the Finnhub API.
class NewsService {
  // Cached news articles (in-memory)
  static List<dynamic>? _cachedNews;

  // Timestamp of the last successful fetch
  static DateTime? _lastFetched;

  // Cache validity duration
  static const Duration _cacheDuration = Duration(minutes: 2);

  /// Fetches general news articles from Finnhub or returns cached results if fresh.
  static Future<List<dynamic>> fetchNews() async {
    final now = DateTime.now();
    final apiKey = dotenv.env['API_KEY'];
    final baseUrl = dotenv.env['BASE_URL'];
    // Return cached news if available and still valid
    if (_cachedNews != null &&
        _lastFetched != null &&
        now.difference(_lastFetched!) < _cacheDuration) {
      return _cachedNews!;
    }

    // If not cached or expired, fetch from API
    final url = Uri.parse('$baseUrl/news?category=general&token=$apiKey');
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