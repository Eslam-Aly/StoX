/// user_model.dart
/// Defines the User model and provides JSON serialization methods for local persistence and transfer.
class User {
  final String username;
  final String email;
  final String password;

  User({
    required this.username,
    required this.email,
    required this.password,
  });

  // Convert a User object into a Map (for saving as JSON)
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'email': email,
      'password': password,
    };
  }

  // Convert a Map (from JSON) into a User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      email: json['email'],
      password: json['password'],
    );
  }
}