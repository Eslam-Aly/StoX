import 'package:flutter/material.dart';
import '../screens/stock_details_screen.dart';

class GlobalSearchOverlay extends StatelessWidget {
  final List<Map<String, dynamic>> allAssets;
  final String query;
  final void Function() onClose;

  const GlobalSearchOverlay({
    super.key,
    required this.allAssets,
    required this.query,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final filtered = allAssets.where((item) {
      final symbol = item['symbol']?.toString().toLowerCase() ?? '';
      final name = item['name']?.toString().toLowerCase() ?? '';
      return symbol.contains(query.toLowerCase()) || name.contains(query.toLowerCase());
    }).toList();

    return Material(
      color: Colors.black.withOpacity(0.95),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 48, left: 16, right: 16, bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'Search results for "$query"',
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: onClose,
                )
              ],
            ),
          ),
          const Divider(color: Colors.grey),
          Expanded(
            child: filtered.isEmpty
                ? const Center(child: Text('No results found', style: TextStyle(color: Colors.white)))
                : ListView.builder(
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final item = filtered[index];
                final name = item['name'] ?? item['symbol'];
                final symbol = item['symbol'];
                final price = (item['price'] as num?)?.toDouble();
                final prevClose = (item['prevClose'] as num?)?.toDouble();
                final logo = item['logo'] ?? '';

                return ListTile(
                  onTap: () {
                    onClose();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StockDetailsScreen(
                          stockSymbol: symbol,
                          stockName: name,
                          price: price,
                          prevClose: prevClose,
                          logo: logo,
                        ),
                      ),
                    );
                  },
                  title: Text(name, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(symbol, style: const TextStyle(color: Colors.grey)),
                  trailing: Text(
                    price != null ? price.toStringAsFixed(2) : '-',
                    style: const TextStyle(color: Colors.white),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}