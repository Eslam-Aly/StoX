import 'package:flutter/material.dart';

// Importing the different screen widgets
import 'stock_list_screen.dart';
import 'news_screen.dart';
import 'portfolio_screen.dart';
import 'profile_screen.dart';

import '../widgets/custom_app_bar.dart';
import '../models/country_option.dart';

/// Main HomePage widget that manages bottom navigation and screen switching
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Keeps track of the currently selected index in the BottomNavigationBar
  int _selectedIndex = 0;

  CountryOption _selectedCountry = countryOptions.first;

  void _handleCountryChange(CountryOption newCountry) {
    setState(() {
      _selectedCountry = newCountry;
    });
  }

  // List of widgets corresponding to each tab in the BottomNavigationBar
  final List<Widget> _pages = [
    const StockListScreen(),   // Home screen with stock tabs
    const NewsScreen(),        // Financial news screen
    const PortfolioScreen(),   // User's portfolio and holdings
    const ProfileScreen(),     // User profile/settings
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        selectedCountry: _selectedCountry,
        onCountryChanged: _handleCountryChange,
      ),
      // Display the currently selected screen
      body: _pages[_selectedIndex],

      // Bottom navigation bar for switching between main tabs
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,           // Set background color
        selectedItemColor: Colors.white,         // Selected icon color
        unselectedItemColor: Colors.grey,        // Unselected icon color
        currentIndex: _selectedIndex,            // Active tab index
        onTap: (index) {
          // Update selected index when user taps a tab
          setState(() {
            _selectedIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),     // Home tab icon
            label: '',                            // No label
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.article_outlined),  // News tab icon
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pie_chart_outline), // Portfolio tab icon
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),    // Profile tab icon
            label: '',
          ),
        ],
      ),
    );
  }
}