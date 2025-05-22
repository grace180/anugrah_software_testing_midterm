import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';

class AuthService {
  final String baseUrl = 'https://dummyjson.com/auth';

  Future<User> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return User(username: data['username'], token: data['token']);
    } else {
      throw Exception('Failed to login: ${response.statusCode}');
    }
  }

  Future<void> logout() async {
    await Future.delayed(Duration(seconds: 1));
  }
}