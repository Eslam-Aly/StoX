/// CustomAppBar is a reusable AppBar widget for the StoX app.
/// It includes the app logo, a country/currency selector, search icon, and menu icon.

import 'package:flutter/material.dart';
import '../models/country_option.dart'; // Adjust path as needed

/// Reusable AppBar with StoX logo, search, currency, and menu icons
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // Currently selected country and currency
  final CountryOption selectedCountry;

  // Callback when the country/currency is changed
  final ValueChanged<CountryOption> onCountryChanged;

  /// Creates a CustomAppBar with the selected country and a callback for changes
  const CustomAppBar({
    super.key,
    required this.selectedCountry,
    required this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      // App title/logo
      title: Image.asset(
        'assets/images/logo.png',
        height: 40,
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [
        // Dropdown for selecting country/currency
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 220),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<CountryOption>(
              value: selectedCountry,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
              dropdownColor: Colors.black87,
              underline: const SizedBox(),
              onChanged: (value) {
                if (value != null) onCountryChanged(value);
              },
              selectedItemBuilder: (BuildContext context) {
                return countryOptions.map<Widget>((CountryOption country) {
                  return Row(
                    children: [
                      Image.network(
                        country.flagUrl,
                        width: 24,
                        height: 16,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => const Icon(Icons.flag, color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${country.name} (${country.currencyCode})',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  );
                }).toList();
              },
              items: countryOptions.map<DropdownMenuItem<CountryOption>>((CountryOption country) {
                return DropdownMenuItem<CountryOption>(
                  value: country,
                  child: Row(
                    children: [
                      Image.network(
                        country.flagUrl,
                        width: 28,
                        height: 20,
                        errorBuilder: (_, __, ___) => const Icon(Icons.flag),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        country.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '(${country.currencyCode})',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        // Search button
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // Add search action here
          },
        ),
        // Menu button

      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}