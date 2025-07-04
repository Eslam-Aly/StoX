import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/country_provider.dart';
import '../models/country_option.dart';

class CountryDetector {
  static Future<void> detectAndSetCountry(BuildContext context) async {
    try {
      print('Starting country detection...');
      final position = await _determinePosition();
      print('Got position: ${position.latitude}, ${position.longitude}');

      final placemarks = await placemarkFromCoordinates(
          position.latitude, position.longitude);

      final countryName = placemarks.first.country;
      print('Detected country from GPS: $countryName');

      final matchedCountry = countryOptions.firstWhere(
            (country) => country.name.toLowerCase() == countryName?.toLowerCase(),
        orElse: () => countryOptions.first,
      );

      Provider.of<CountryProvider>(context, listen: false)
          .updateCountry(matchedCountry);
      print("Country updated to: ${matchedCountry.name}");
    } catch (e) {
      print('Country detection failed: $e');
    }
  }

  static Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }
}