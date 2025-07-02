import 'package:flutter/material.dart';
import '../screens/stock_details_screen.dart';

class StockListItem extends StatelessWidget {
  final Map<String, dynamic> stock;

  const StockListItem({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final price = (stock['price'] is num) ? (stock['price'] as num).toDouble() : 0.0;
    final prevClose = (stock['prevClose'] is num) ? (stock['prevClose'] as num).toDouble() : 0.0;
    final diff = price - prevClose;
    final color = diff > 0 ? Colors.green : (diff < 0 ? Colors.red : Colors.white);
    final quantity = (stock['quantity'] as num?)?.toDouble() ?? 1.0;
    final total = price * quantity;

    final logo = stock['logo'];
    final symbol = stock['symbol'] ?? '?';
    final name = stock['name'] ?? 'Unknown';

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StockDetailsScreen(
              stockSymbol: stock['symbol'],
              stockName: stock['name'],
              price: (stock['price'] as num?)?.toDouble(),
              prevClose: (stock['prevClose'] as num?)?.toDouble(),
              logo: stock['logo'],
            ),
          ),
        );
      },
      child: ListTile(
        leading: (logo != null && logo is String && logo.isNotEmpty)
            ? Image.network(
          logo,
          width: 50,
          height: 50,
          errorBuilder: (_, __, ___) => CircleAvatar(child: Text(symbol[0])),
        )
            : CircleAvatar(child: Text(symbol[0])),

        title: Text(
          name,
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          '${quantity.toStringAsFixed(0)} × \$${price.toStringAsFixed(2)} = \$${total.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.white),
        ),
        trailing: Icon(Icons.show_chart, color: color),
      ),
    );
  }
}