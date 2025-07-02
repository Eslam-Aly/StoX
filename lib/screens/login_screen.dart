/// login_screen.dart
/// Allows users to log in using email or username and a password.
/// On successful login, the user is redirected to the home screen.

import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'signup_screen.dart';
import '../widgets/background_wrapper.dart';
import 'stock_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailOrUsernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String _message = '';

  /// Handles user login logic
  Future<void> _login() async {
    final userInput = _emailOrUsernameController.text.trim();
    final password = _passwordController.text.trim();

    final success = await AuthService.login(userInput, password);

    setState(() {
      _message = success ? 'Login successful!' : 'Invalid credentials.';
    });

    if (success) {
      // Navigate to main app screen after login
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Prevent back navigation
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Log In'),
        actions: [
          // Button to switch to signup screen
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const SignupScreen()),
              );
            },
            child: const Text('Sign Up', style: TextStyle(color: Colors.blue)),
          )
        ],
      ),
      body: BackgroundWrapper(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo
                Image.asset('assets/images/logo.png', height: 100),
                const SizedBox(height: 40),

                // Login form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email or Username input
                      TextFormField(
                        controller: _emailOrUsernameController,
                        decoration: const InputDecoration(labelText: 'Email or Username'),
                      ),
                      const SizedBox(height: 16),
                      // Password input
                      TextFormField(
                        controller: _passwordController,
                        decoration: const InputDecoration(labelText: 'Password'),
                        obscureText: true,
                      ),
                      const SizedBox(height: 32),
                      // Login button
                      ElevatedButton(
                        onPressed: _login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                        ),
                        child: const Text('Log In'),
                      ),
                      const SizedBox(height: 20),
                      // Display error or success message
                      Text(_message, style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 10),
                      // Signup redirect link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => const SignupScreen()),
                              );
                            },
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                color: Colors.blue,
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}