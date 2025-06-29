/// This service handles all news-related API requests using the Finnhub API.
/// It provides methods to fetch general category news articles.
import 'dart:convert';
import 'package:http/http.dart' as http;

class NewsService {
  /// API key used to authenticate requests to the Finnhub API.
  static const String _apiKey = 'd1dhgehr01qn1ojnmdcgd1dhgehr01qn1ojnmdd0'; // Replace with your actual API key

  /// Fetches general category news articles from Finnhub API
  static Future<List<dynamic>> fetchNews() async {
    // Construct the API endpoint URL for fetching general news.
    final url = Uri.parse('https://finnhub.io/api/v1/news?category=general&token=$_apiKey');
    // Perform a GET request to the news endpoint.
    final response = await http.get(url);

    if (response.statusCode == 200) {
      // Decode the JSON response and return the list of news articles.
      return json.decode(response.body);
    } else {
      // Throw an exception if the request fails.
      throw Exception('Failed to load news');
    }
  }
}