import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserService {
  static const String _apiUrl = 'https://randomuser.me/api/';

  static Future<User> fetchRandomUser() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl)).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final userData = jsonData['results'][0];
        return User.fromJson(userData);
      } else {
        throw Exception('Failed to load user');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  static Future<List<User>> fetchMultipleUsers(int count) async {
    try {
      final response = await http.get(Uri.parse('$_apiUrl?results=$count')).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> users = jsonData['results'];
        return users.map((user) => User.fromJson(user)).toList();
      } else {
        throw Exception('Failed to load users');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
