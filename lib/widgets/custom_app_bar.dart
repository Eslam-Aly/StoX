import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/country_option.dart';
import '../providers/country_provider.dart';
import '../services/stock_service.dart';
import '../services/crypto_service.dart';
import '../screens/stock_details_screen.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 180);
}

class _CustomAppBarState extends State<CustomAppBar> {
  bool _isSearching = false;
  bool _isSearchMode = false;
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  void _onSearchTextChanged(String query) async {
    if (query.isEmpty) {
      setState(
              () => _searchResults.clear()
      );
      return;
    }

    final contextRef = context;

    // Full map of symbol => name
    final Map<String, String> symbolToName = {
      'AAPL': 'Apple Inc',
      'MSFT': 'Microsoft Corp',
      'GOOGL': 'Alphabet Inc',
      'AMZN': 'Amazon.com Inc',
      'TSLA': 'Tesla Inc',
      'META': 'Meta Platforms Inc',
      'NVDA': 'NVIDIA Corp',
      'BRK.B': 'Berkshire Hathaway Inc',
      'JNJ': 'Johnson & Johnson',
      'JPM': 'JPMorgan Chase & Co',
      'V': 'Visa Inc',
      'PG': 'Procter & Gamble',
      'UNH': 'UnitedHealth Group',
      'MA': 'Mastercard Inc',
      'HD': 'Home Depot',
      'KO': 'Coca-Cola',
      'PEP': 'PepsiCo',
      'DIS': 'Walt Disney',
      'XOM': 'Exxon Mobil',
      'INTC': 'Intel Corp',
      'SPY': 'S&P 500 ETF',
      'QQQ': 'Nasdaq 100 ETF',
      'DIA': 'Dow Jones ETF',
      'VTI': 'Total Stock Market ETF',
      'IWM': 'Russell 2000 ETF',
      'XLK': 'Technology ETF',
      'XLF': 'Financial ETF',
      'ARKK': 'ARK Innovation ETF',
      'VOO': 'Vanguard S&P 500',
      'EFA': 'EAFE ETF',
      'EEM': 'Emerging Markets ETF',
      'TLT': '20+ Year Treasury',
      'XLE': 'Energy ETF',
      'XLY': 'Consumer Discretionary ETF',
      'XLI': 'Industrial ETF',
      'XLC': 'Communication ETF',
      'XLV': 'Health Care ETF',
      'XLU': 'Utilities ETF',
      'XLB': 'Materials ETF',
      'VNQ': 'Real Estate ETF',
      'BINANCE:BTCUSDT': 'Bitcoin',
      'BINANCE:ETHUSDT': 'Ethereum',
      'BINANCE:DOGEUSDT': 'Dogecoin',
      'BINANCE:SOLUSDT': 'Solana',
      'BINANCE:ADAUSDT': 'Cardano',
      'BINANCE:XRPUSDT': 'Ripple',
      'BINANCE:MATICUSDT': 'Polygon',
      'BINANCE:LTCUSDT': 'Litecoin',
      'BINANCE:BCHUSDT': 'Bitcoin Cash',
      'BINANCE:AVAXUSDT': 'Avalanche',
      'BINANCE:DOTUSDT': 'Polkadot',
      'BINANCE:LINKUSDT': 'Chainlink',
      'BINANCE:TRXUSDT': 'TRON',
      'BINANCE:XLMUSDT': 'Stellar',
      'BINANCE:ATOMUSDT': 'Cosmos',
      'BINANCE:NEARUSDT': 'NEAR Protocol',
      'BINANCE:APEUSDT': 'ApeCoin',
      'BINANCE:UNIUSDT': 'Uniswap',
      'BINANCE:SANDUSDT': 'The Sandbox',
      'BINANCE:FILUSDT': 'Filecoin',
    };

    final lowerQuery = query.toLowerCase();
    final results = <Map<String, dynamic>>[];

    for (final entry in symbolToName.entries) {
      final symbol = entry.key;
      final name = entry.value;

      // Search ONLY by name
      if (!name.toLowerCase().contains(lowerQuery)) continue;

      final isCrypto = symbol.startsWith('BINANCE:');
      final result = isCrypto
          ? await CryptoService.fetchCryptoInfo(symbol, contextRef)
          : await StockService.fetchStockInfo(symbol, contextRef);

      if (result != null) {
        result['name'] = name; // override name for consistency
        results.add(result);
      }

      if (results.length >= 5) break;
    }

    setState(() => _searchResults = results);
  }

  void _navigateToDetails(Map<String, dynamic> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StockDetailsScreen(
          stockSymbol: item['symbol'],
          stockName: item['name'] ?? item['symbol'],
          price: (item['price'] as num?)?.toDouble(),
          prevClose: (item['prevClose'] as num?)?.toDouble(),
          logo: item['logo'] ?? '',
        ),
      ),
    );
    setState(() {
      _isSearching = false;
      _searchController.clear();
      _searchResults.clear();
    });
  }

  Widget _buildCountryDropdown(CountryProvider countryProvider) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 240),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<CountryOption>(
          value: countryProvider.selectedCountry,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
          dropdownColor: Colors.black87,
          onChanged: (value) {
            if (value != null) {
              countryProvider.updateCountry(value);
            }
          },
          selectedItemBuilder: (_) => countryOptions.map((country) => Row(
            children: [
              Image.network(
                country.flagUrl,
                width: 24,
                height: 16,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Icon(Icons.flag, color: Colors.white),
              ),
              const SizedBox(width: 8),
              Text('${country.name} (${country.currencyCode})', style: const TextStyle(color: Colors.white)),

            ],
          )).toList(),
          items: countryOptions.map((country) => DropdownMenuItem(
            value: country,
            child: Row(
              children: [
                Image.network(country.flagUrl, width: 28, height: 20,
                    errorBuilder: (_, __, ___) => const Icon(Icons.flag)),
                const SizedBox(width: 10),
                Text(country.name, style: const TextStyle(color: Colors.white)),
                const SizedBox(width: 5),
                Text('(${country.currencyCode})', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          )).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final countryProvider = Provider.of<CountryProvider>(context);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            title: _isSearching
                ? Expanded(
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: TextField(
                  controller: _searchController,
                  autofocus: true,
                  onChanged: _onSearchTextChanged,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Search stock, ETF, crypto...',
                    hintStyle: TextStyle(color: Colors.white60),
                    border: InputBorder.none,
                  ),
                ),
              ),
            )
                : Image.asset('assets/images/logo.png', height: 40),
            backgroundColor: Colors.transparent,
            elevation: 0,
            actions: [
              if (!_isSearching) _buildCountryDropdown(countryProvider),
              IconButton(
                icon: Icon(_isSearching ? Icons.close : Icons.search, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _isSearchMode = !_isSearchMode;
                    _isSearching = !_isSearching;
                    _searchController.clear();
                    _searchResults.clear();
                  });
                },
              ),
            ],
          ),
      
          // 🔍 Only show search results if search mode is active
          if (_isSearchMode && _searchResults.isNotEmpty)
            SizedBox(
              height: 300, // or MediaQuery.of(context).size.height * 0.4
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(8),
                color: Colors.black87,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: _searchResults.length,
                  separatorBuilder: (_, __) =>
                  const Divider(color: Colors.white24, height: 1),
                  itemBuilder: (_, index) {
                    final item = _searchResults[index];
                    return ListTile(
                      title: Text(
                        item['name'] ?? item['symbol'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        item['symbol'],
                        style: const TextStyle(color: Colors.white70),
                      ),
                      onTap: () => _navigateToDetails(item),
                    );
                  },
                ),
              ),
            ),
        ],
      ),
    );
  }
}