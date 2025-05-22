import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';
class AuthService {
  static const String _baseUrl = 'https://dummyjson.com/auth';
  User? _currentUser;

  Future<User> login({
    required String username,
    required String password,
    int expiresInMins = 30,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': expiresInMins,
      }),
    );

    if (response.statusCode == 200) {
      _currentUser = User.fromJson(jsonDecode(response.body));
      return _currentUser!;
    } else {
      throw Exception('Login failed: ${response.statusCode}');
    }
  }

  Future<User> getCurrentUser() async {
    if (_currentUser == null || _currentUser?.token == null) {
      throw Exception('Not authenticated');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/me'),
      headers: {'Authorization': 'Bearer ${_currentUser!.token}'},
    );

    if (response.statusCode == 200) {
      _currentUser = User.fromJson(jsonDecode(response.body));
      return _currentUser!;
    } else {
      throw Exception('Failed to fetch user: ${response.statusCode}');
    }
  }

  Future<User> refreshToken({int expiresInMins = 30}) async {
    if (_currentUser == null || _currentUser?.refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final response = await http.post(
      Uri.parse('$_baseUrl/refresh'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'refreshToken': _currentUser!.refreshToken,
        'expiresInMins': expiresInMins,
      }),
    );

    if (response.statusCode == 200) {
      _currentUser = User.fromJson(jsonDecode(response.body));
      return _currentUser!;
    } else {
      throw Exception('Token refresh failed: ${response.statusCode}');
    }
  }

  Future<void> logout() async {
    _currentUser = null;
  }
}