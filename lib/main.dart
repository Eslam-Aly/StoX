import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart' as launcher;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StoX',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const StockListScreen(),
    const NewsScreen(),
    const PlaceholderWidget(label: 'Portfolio'),
    const PlaceholderWidget(label: 'Account'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            label: '',
          ),
        ],
      ),
    );
  }
}

class StockListScreen extends StatefulWidget {
  const StockListScreen({super.key});
  @override
  _StockListScreenState createState() => _StockListScreenState();
}

class _StockListScreenState extends State<StockListScreen> {
  final List<String> symbols = [
    'AAPL', 'GOOG', 'MSFT', 'TSLA', 'AMZN', 'NVDA', 'META', 'NFLX', 'BABA', 'BA',
    'ORCL', 'INTC', 'PYPL', 'DIS', 'V', 'JPM', 'IBM', 'PEP', 'KO', 'MCD',
  ];
  List<Map<String, dynamic>> stocks = [];
  bool isLoading = true;
  final String apiKey = 'd1dhgehr01qn1ojnmdcgd1dhgehr01qn1ojnmdd0'; // <-- Put your Finnhub API key here!

  @override
  void initState() {
    super.initState();
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    List<Map<String, dynamic>> fetchedStocks = [];
    for (String symbol in symbols) {
      // Get price and previous close
      final quoteUrl = Uri.parse('https://finnhub.io/api/v1/quote?symbol=$symbol&token=$apiKey');
      final quoteResponse = await http.get(quoteUrl);

      // Get logo & name
      final profileUrl = Uri.parse('https://finnhub.io/api/v1/stock/profile2?symbol=$symbol&token=$apiKey');
      final profileResponse = await http.get(profileUrl);

      if (quoteResponse.statusCode == 200 && profileResponse.statusCode == 200) {
        final quoteData = json.decode(quoteResponse.body);
        final profileData = json.decode(profileResponse.body);
        fetchedStocks.add({
          'symbol': symbol,
          'price': quoteData['c'] ?? 0.0,
          'prevClose': quoteData['pc'] ?? 0.0,
          'logo': profileData['logo'] ?? '',
          'name': profileData['name'] ?? symbol,
        });
      }
      await Future.delayed(const Duration(milliseconds: 100));
    }
    setState(() {
      stocks = fetchedStocks;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('StoX'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: DefaultTabController(
        length: 4,
        child: Column(
          children: [
            const TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Colors.white,
              tabs: [
                Tab(text: 'Popular'),
                Tab(text: 'Stocks'),
                Tab(text: 'Crypto'),
                Tab(text: 'Pro'),
              ],
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                itemCount: stocks.length,
                itemBuilder: (context, index) {
                  final stock = stocks[index];
                  final price = (stock['price'] as num).toDouble();
                  final prevClose = (stock['prevClose'] as num).toDouble();
                  final priceDiff = price - prevClose;
                  Color symbolColor;
                  if (priceDiff > 0) {
                    symbolColor = Colors.green;
                  } else if (priceDiff < 0) {
                    symbolColor = Colors.red;
                  } else {
                    symbolColor = Colors.white;
                  }
                  return ListTile(
                    leading: (stock['logo'] != null &&
                        (stock['logo'] as String).isNotEmpty)
                        ? Image.network(
                      stock['logo'],
                      width: 60,
                      height: 60,
                      errorBuilder: (context, error, stackTrace) =>
                          CircleAvatar(child: Text(stock['symbol'][0])),
                    )
                        : CircleAvatar(child: Text(stock['symbol'][0])),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(stock['name'],
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 2, horizontal: 8),
                          child: Text(
                            '\$${stock['price'].toString()}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w500,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                    trailing: Icon(
                      Icons.show_chart,
                      color: symbolColor,
                      size: 28,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlaceholderWidget extends StatelessWidget {
  final String label;
  const PlaceholderWidget({super.key, required this.label});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        label,
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }
}


class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});
  @override
  State<NewsScreen> createState() => _NewsScreenState();
}
class NewsDetailScreen extends StatelessWidget {
  final Map<String, dynamic> article;
  const NewsDetailScreen({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(article['source'] ?? 'Detail'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (article['image'] != null && article['image'] != "")
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  article['image'],
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.article, size: 90),
                ),
              ),
            const SizedBox(height: 20),
            Text(
              article['headline'] ?? "",
              style: const TextStyle(
                  fontSize: 22, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Source: ${article['source'] ?? ""}",
              style: const TextStyle(color: Colors.grey, fontSize: 16),
            ),
            const SizedBox(height: 16),
            Text(
              article['summary'] ?? "",
              style: const TextStyle(fontSize: 17, color: Colors.white),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              ),
              onPressed: () {
                if (article['url'] != null) {
                  launchUrl(Uri.parse(article['url']));
                }
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
class _NewsScreenState extends State<NewsScreen> {
  List<dynamic> news = [];
  bool isLoading = true;
  final String apiKey = 'd1dhgehr01qn1ojnmdcgd1dhgehr01qn1ojnmdd0';

  @override
  void initState() {
    super.initState();
    fetchNews();
  }

  Future<void> fetchNews() async {
    final url = Uri.parse('https://finnhub.io/api/v1/news?category=general&token=$apiKey');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      setState(() {
        news = json.decode(response.body);
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("News"),
        backgroundColor: Colors.black,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: news.length,
        itemBuilder: (context, index) {
          final article = news[index];
          return ListTile(
            leading: article['image'] != null
                ? Image.network(
              article['image'],
              width: 80,
              errorBuilder: (_, __, ___) => const Icon(Icons.article),
            )
                : const Icon(Icons.article),
            title: Text(
              article['headline'] ?? 'No title',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              article['source'] ?? '',
              style: const TextStyle(color: Colors.grey),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NewsDetailScreen(article: article),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Future<void> launchUrl(Uri url) async {
  if (await launcher.canLaunchUrl(url)) {
    await launcher.launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}