/// auth_service.dart
/// A simple local authentication service that stores user data in a JSON file.
/// Supports sign-up and login functionality using local file storage.

import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import '../models/user_model.dart';

class AuthService {
  /// Returns the file that stores user data
  static Future<File> _getUserFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/user_data.json');
  }

  /// Reads and parses all user records from the local JSON file
  static Future<List<User>> _readUsers() async {
    final file = await _getUserFile();

    // If the file does not exist, create it with an empty users list
    if (!(await file.exists())) {
      await file.writeAsString(jsonEncode({'users': []}));
    }

    final content = await file.readAsString();
    final data = jsonDecode(content);

    // Convert the list of user maps into List<User>
    return (data['users'] as List)
        .map((userJson) => User.fromJson(userJson))
        .toList();
  }

  /// Writes the updated list of users to the local JSON file
  static Future<void> _writeUsers(List<User> users) async {
    final file = await _getUserFile();
    final data = {
      'users': users.map((user) => user.toJson()).toList(),
    };
    await file.writeAsString(jsonEncode(data));
  }

  /// Signs up a new user if no email or username conflict exists
  static Future<bool> signup(User newUser) async {
    final users = await _readUsers();

    // Check if the email or username already exists
    final exists = users.any((user) =>
        user.email == newUser.email || user.username == newUser.username);
    if (exists) return false;

    users.add(newUser);
    await _writeUsers(users);
    return true;
  }

  /// Logs in a user by matching email/username and password
  static Future<bool> login(String emailOrUsername, String password) async {
    final users = await _readUsers();

    // Match either username or email and check password
    return users.any((user) =>
        (user.email == emailOrUsername || user.username == emailOrUsername) &&
        user.password == password);
  }
}
