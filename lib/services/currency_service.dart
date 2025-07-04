import 'dart:convert';
import 'package:http/http.dart' as http;

class CurrencyService {
  static Future<double> getUsdTo(String targetCurrency) async {
    // 💡 Skip API call if same currency
    if (targetCurrency.toUpperCase() == 'USD') {
      print("⚠️ Skipping API call — USD to USD is 1.0");
      return 1.0;
    }

    final url = Uri.parse('https://api.frankfurter.app/latest?from=USD&to=$targetCurrency');
    print("🔁 Fetching rate: $url");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print("📦 Response body: $data");

        final rates = data['rates'];
        if (rates == null || !rates.containsKey(targetCurrency)) {
          throw Exception('Missing rate for $targetCurrency');
        }

        final rate = (rates[targetCurrency] as num?)?.toDouble() ?? 1.0;
        print("💱 Rate for USD to $targetCurrency: $rate");
        return rate;
      } else {
        print("❌ HTTP error: ${response.statusCode}");
        throw Exception('Failed to fetch exchange rate');
      }
    } catch (e) {
      print("❌ Exception caught in getUsdTo: $e");
      throw Exception('Failed to fetch exchange rate');
    }
  }
}