import 'package:flutter/foundation.dart';

class PortfolioProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _portfolio = [];

  List<Map<String, dynamic>> get portfolio => _portfolio;

  void addStock(Map<String, dynamic> stock) {
    _portfolio.removeWhere((s) => s['symbol'] == stock['symbol']);
    _portfolio.add({
      ...stock,
      'quantity': stock['quantity'] ?? 1,
    });
    notifyListeners();
  }

  void removeStock(String symbol) {
    _portfolio.removeWhere((stock) => stock['symbol'] == symbol);
    notifyListeners();
  }

  bool contains(String symbol) {
    return _portfolio.any((stock) => stock['symbol'] == symbol);
  }

  double get totalInvestment {
    return _portfolio.fold(0.0, (sum, stock) {
      final price = (stock['price'] as num?)?.toDouble() ?? 0.0;
      final quantity = (stock['quantity'] as num?)?.toDouble() ?? 1.0;
      return sum + (price * quantity);
    });
  }
}

