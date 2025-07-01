/// country_option.dart
/// Defines the CountryOption model and a list of supported countries for use in currency and exchange selection.
class CountryOption {
  final String name;
  final String flagUrl;
  final String currencyCode;
  final String exchangeCode;

  const CountryOption({
    required this.name,
    required this.flagUrl,
    required this.currencyCode,
    required this.exchangeCode,
  });
}

const List<CountryOption> countryOptions = [
  CountryOption(
    name: 'United States',
    flagUrl: 'https://flagcdn.com/w320/us.png',
    currencyCode: 'USD',
    exchangeCode: 'US',
  ),
  CountryOption(
    name: 'Germany',
    flagUrl: 'https://flagcdn.com/w320/de.png',
    currencyCode: 'EUR',
    exchangeCode: 'FSX',
  ),
  CountryOption(
    name: 'United Kingdom',
    flagUrl: 'https://flagcdn.com/w320/gb.png',
    currencyCode: 'GBP',
    exchangeCode: 'LSE',
  ),
  CountryOption(
    name: 'France',
    flagUrl: 'https://flagcdn.com/w320/fr.png',
    currencyCode: 'EUR',
    exchangeCode: 'EPA',
  ),
  CountryOption(
    name: 'Japan',
    flagUrl: 'https://flagcdn.com/w320/jp.png',
    currencyCode: 'JPY',
    exchangeCode: 'TSE',
  ),
  CountryOption(
    name: 'Canada',
    flagUrl: 'https://flagcdn.com/w320/ca.png',
    currencyCode: 'CAD',
    exchangeCode: 'TSX',
  ),
  CountryOption(
    name: 'Australia',
    flagUrl: 'https://flagcdn.com/w320/au.png',
    currencyCode: 'AUD',
    exchangeCode: 'ASX',
  ),
  CountryOption(
    name: 'India',
    flagUrl: 'https://flagcdn.com/w320/in.png',
    currencyCode: 'INR',
    exchangeCode: 'NSE',
  ),
  CountryOption(
    name: 'China',
    flagUrl: 'https://flagcdn.com/w320/cn.png',
    currencyCode: 'CNY',
    exchangeCode: 'SSE',
  ),
  CountryOption(
    name: 'Brazil',
    flagUrl: 'https://flagcdn.com/w320/br.png',
    currencyCode: 'BRL',
    exchangeCode: 'B3',
  ),
  CountryOption(
    name: 'South Korea',
    flagUrl: 'https://flagcdn.com/w320/kr.png',
    currencyCode: 'KRW',
    exchangeCode: 'KRX',
  ),
  CountryOption(
    name: 'South Africa',
    flagUrl: 'https://flagcdn.com/w320/za.png',
    currencyCode: 'ZAR',
    exchangeCode: 'JSE',
  ),
  CountryOption(
    name: 'Switzerland',
    flagUrl: 'https://flagcdn.com/w320/ch.png',
    currencyCode: 'CHF',
    exchangeCode: 'SIX',
  ),
  CountryOption(
    name: 'Russia',
    flagUrl: 'https://flagcdn.com/w320/ru.png',
    currencyCode: 'RUB',
    exchangeCode: 'MOEX',
  ),
  CountryOption(
    name: 'Saudi Arabia',
    flagUrl: 'https://flagcdn.com/w320/sa.png',
    currencyCode: 'SAR',
    exchangeCode: 'TADAWUL',
  ),
];