import 'package:flutter/material.dart';
import '../screens/stock_details_screen.dart';

class StockListItem extends StatelessWidget {
  final Map<String, dynamic> stock;

  const StockListItem({super.key, required this.stock});

  @override
  Widget build(BuildContext context) {
    final price = (stock['price'] as num).toDouble();
    final prevClose = (stock['prevClose'] as num).toDouble();
    final diff = price - prevClose;
    final color = diff > 0 ? Colors.green : (diff < 0 ? Colors.red : Colors.white);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => StockDetailsScreen(
              stockSymbol: stock['symbol'],
              stockName: stock['name'],
            ),
          ),
        );
      },
      child: ListTile(
        leading: (stock['logo'] != null && stock['logo'].isNotEmpty)
            ? Image.network(
          stock['logo'],
          width: 50,
          height: 50,
          errorBuilder: (_, __, ___) => CircleAvatar(child: Text(stock['symbol'][0])),
        )
            : CircleAvatar(child: Text(stock['symbol'][0])),

        title: Text(
          stock['name'],
          style: const TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          '\$${price.toStringAsFixed(2)}',
          style: const TextStyle(color: Colors.white),
        ),
        trailing: Icon(Icons.show_chart, color: color),
      ),
    );
  }
}