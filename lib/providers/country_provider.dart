// providers/country_provider.dart

import 'package:flutter/material.dart';
import '../models/country_option.dart';
import '../services/currency_service.dart';

class CountryProvider extends ChangeNotifier {
  CountryOption _selectedCountry;
  double _exchangeRate = 1.0; // Default to 1 USD = 1 USD

  CountryProvider(this._selectedCountry) {
    _loadExchangeRate(); // Initial load
  }

  CountryOption get selectedCountry => _selectedCountry;
  double get exchangeRate => _exchangeRate;

  String get currencySymbol => _selectedCountry.currencySymbol;

  void updateCountry(CountryOption newCountry) {
    _selectedCountry = newCountry;
    _loadExchangeRate(); // Update rate whenever country changes
    notifyListeners();
  }

  Future<void> _loadExchangeRate() async {
    try {
      _exchangeRate = await CurrencyService.getUsdTo(_selectedCountry.currencyCode);
      notifyListeners();
    } catch (e) {
      print('Error loading exchange rate: $e');
    }
  }
}