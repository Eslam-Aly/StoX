/// news_screen.dart
/// Displays a list of general news headlines from the Finnhub API.
/// Users can tap an article to view a detailed summary and launch the full article in a browser.

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../services/news_service.dart';
import '../widgets/background_wrapper.dart';
import '../widgets/custom_app_bar.dart';
import '../models/country_option.dart';


/// StatefulWidget responsible for showing the list of news.
class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  // List to hold fetched news articles
  List<dynamic> news = [];
  // Loading indicator flag
  bool isLoading = true;

  /// Loads news articles on init
  @override
  void initState() {
    super.initState();
    loadNews();
  }

  /// Fetches news from the API
  Future<void> loadNews() async {
    try {
      final fetchedNews = await NewsService.fetchNews();
      setState(() {
        news = fetchedNews;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  /// Renders background and either loading spinner or news list
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Background image
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: BackgroundWrapper(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    itemCount: news.length,
                    itemBuilder: (context, index) {
                      final article = news[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // News image
                            if (article['image'] != null && article['image'].isNotEmpty)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  article['image'],
                                  width: 100,
                                  height: 70,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.article, color: Colors.white),
                                ),
                              )
                            else
                              const SizedBox(width: 100, height: 70),
                            const SizedBox(width: 12),
                            // News text info
                            Expanded(
                              child: InkWell(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => NewsDetailScreen(article: article)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      article['headline'] ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      article['source'] ?? '',
                                      style: const TextStyle(color: Colors.grey),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }
}

/// Detail screen for a specific news article.
class NewsDetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;
  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(article['source'] ?? 'Detail')),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // News image
            if (article['image'] != null && article['image'] != "")
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(article['image'], height: 200, fit: BoxFit.cover),
              ),
            const SizedBox(height: 20),
            // Headline
            Text(article['headline'] ?? "", style: const TextStyle(fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            // Source
            Text("Source: ${article['source'] ?? ""}", style: const TextStyle(color: Colors.grey, fontSize: 16)),
            const SizedBox(height: 16),
            // Summary
            Text(article['summary'] ?? "", style: const TextStyle(fontSize: 17, color: Colors.white)),
            const SizedBox(height: 32),
            // Open article in external browser
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.deepPurple, foregroundColor: Colors.white),
              onPressed: () async {
                final Uri url = Uri.parse(article['url']);
                if (await canLaunchUrl(url)) await launchUrl(url);
              },
              icon: const Icon(Icons.open_in_new),
              label: const Text("Read Full Article"),
            ),
          ],
        ),
      ),
    );
  }
}