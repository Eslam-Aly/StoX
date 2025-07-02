import 'package:flutter/material.dart';

class PortfolioProvider extends ChangeNotifier {
  final List<Map<String, dynamic>> _portfolio = [];

  List<Map<String, dynamic>> get portfolio => _portfolio;

  void addStock(Map<String, dynamic> stock) {
    _portfolio.add(stock);
    notifyListeners();
  }

  void removeStock(String stockName) {
    _portfolio.removeWhere((item) => item['name'] == stockName);
    notifyListeners();
  }
}