import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'package:provider/provider.dart';
import 'providers/portfolio_provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/country_provider.dart';
import 'models/country_option.dart';
import 'package:geolocator/geolocator.dart';


// Entry point of the StoX application
Future<void> main() async {
  //This line is crucial for any async before runApp
  WidgetsFlutterBinding.ensureInitialized();
  //Load environment variables
  await dotenv.load();
  //Run the app
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PortfolioProvider()),
        ChangeNotifierProvider(
          create: (_) =>CountryProvider(countryOptions.first), // default country
        ),
      ],
      child: const MyApp(),
    ),
  );
}



Future<Position> determinePosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return Future.error('Location permission denied.');
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permission permanently denied.');
  }

  return await Geolocator.getCurrentPosition();
}



// Root widget that sets up the application theme and routes
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StoX',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        textTheme: ThemeData.dark().textTheme.apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        // Custom AppBar styling for consistent dark theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ),
      ),
      // Application routes configuration
      initialRoute: '/login',
      routes: {
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
      },
    );
  }
}