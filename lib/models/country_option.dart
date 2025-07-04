/// country_option.dart
/// Defines the CountryOption model and a list of supported countries for use in currency and exchange selection.
class CountryOption {
  final String name;
  final String flagUrl;
  final String currencyCode;
  final String exchangeCode;
  final String currencySymbol;

  const CountryOption({
    required this.name,
    required this.flagUrl,
    required this.currencyCode,
    required this.exchangeCode,
    required this.currencySymbol,
  });
}

const List<CountryOption> countryOptions = [
  CountryOption(
    name: 'United States',
    flagUrl: 'https://flagcdn.com/w320/us.png',
    currencyCode: 'USD',
    currencySymbol: '\$',
    exchangeCode: 'US',
  ),
  CountryOption(
    name: 'Germany',
    flagUrl: 'https://flagcdn.com/w320/de.png',
    currencyCode: 'EUR',
    currencySymbol: '€',
    exchangeCode: 'FSX',
  ),
  CountryOption(
    name: 'United Kingdom',
    flagUrl: 'https://flagcdn.com/w320/gb.png',
    currencyCode: 'GBP',
    currencySymbol: '£',
    exchangeCode: 'LSE',
  ),
  CountryOption(
    name: 'France',
    flagUrl: 'https://flagcdn.com/w320/fr.png',
    currencyCode: 'EUR',
    currencySymbol: '€',
    exchangeCode: 'EPA',
  ),
  CountryOption(
    name: 'Japan',
    flagUrl: 'https://flagcdn.com/w320/jp.png',
    currencyCode: 'JPY',
    currencySymbol: '¥',
    exchangeCode: 'TSE',
  ),
  CountryOption(
    name: 'Canada',
    flagUrl: 'https://flagcdn.com/w320/ca.png',
    currencyCode: 'CAD',
    currencySymbol: '\$',
    exchangeCode: 'TSX',
  ),
  CountryOption(
    name: 'Australia',
    flagUrl: 'https://flagcdn.com/w320/au.png',
    currencyCode: 'AUD',
    currencySymbol: '\$',
    exchangeCode: 'ASX',
  ),
  CountryOption(
    name: 'India',
    flagUrl: 'https://flagcdn.com/w320/in.png',
    currencyCode: 'INR',
    currencySymbol: '₹',
    exchangeCode: 'NSE',
  ),
  CountryOption(
    name: 'China',
    flagUrl: 'https://flagcdn.com/w320/cn.png',
    currencyCode: 'CNY',
    currencySymbol: '¥',
    exchangeCode: 'SSE',
  ),
  CountryOption(
    name: 'Brazil',
    flagUrl: 'https://flagcdn.com/w320/br.png',
    currencyCode: 'BRL',
    currencySymbol: 'R\$',
    exchangeCode: 'B3',
  ),
  CountryOption(
    name: 'South Korea',
    flagUrl: 'https://flagcdn.com/w320/kr.png',
    currencyCode: 'KRW',
    currencySymbol: '₩',
    exchangeCode: 'KRX',
  ),
  CountryOption(
    name: 'South Africa',
    flagUrl: 'https://flagcdn.com/w320/za.png',
    currencyCode: 'ZAR',
    currencySymbol: 'R',
    exchangeCode: 'JSE',
  ),
  CountryOption(
    name: 'Switzerland',
    flagUrl: 'https://flagcdn.com/w320/ch.png',
    currencyCode: 'CHF',
    currencySymbol: 'Fr',
    exchangeCode: 'SIX',
  ),
  CountryOption(
    name: 'Russia',
    flagUrl: 'https://flagcdn.com/w320/ru.png',
    currencyCode: 'RUB',
    currencySymbol: '₽',
    exchangeCode: 'MOEX',
  ),
  CountryOption(
    name: 'Saudi Arabia',
    flagUrl: 'https://flagcdn.com/w320/sa.png',
    currencyCode: 'SAR',
    currencySymbol: 'ر.س',
    exchangeCode: 'TADAWUL',
  ),
];