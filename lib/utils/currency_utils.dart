// lib/utils/currency_utils.dart

import 'package:intl/intl.dart';

String formatPrice(double price, String currencyCode) {
  // Uses the intl package to format the price with currency symbol
  final format = NumberFormat.currency(locale: 'en_US', name: currencyCode);
  return format.format(price);
}