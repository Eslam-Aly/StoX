import 'package:flutter/material.dart';
import '../models/country_option.dart'; // Adjust path as needed

/// Reusable AppBar with StoX logo, search, currency, and menu icons
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final CountryOption selectedCountry;
  final ValueChanged<CountryOption> onCountryChanged;

  const CustomAppBar({
    super.key,
    required this.selectedCountry,
    required this.onCountryChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text(
        'StoX',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.white,
          fontSize: 26,
        ),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      actions: [

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
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // Add search action here
          },
        ),
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Add menu action here
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}