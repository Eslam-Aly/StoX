import 'package:flutter/material.dart';
import 'screens/home_page.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

// Entry point of the StoX application
void main() {
  runApp(const MyApp());
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
        '/': (context) => const HomePage(),
        '/home': (context) => const HomePage(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
      },
    );
  }
}