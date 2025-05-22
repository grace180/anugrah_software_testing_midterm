import 'package:flutter/material.dart';
import 'package:anugrah_software_testing/model/authService.dart';
import 'package:anugrah_software_testing/model/user.dart';
class AuthViewModel extends ChangeNotifier {
  final AuthService authService;
  User? currentUser;
  bool isLoading = false;
  String? errorMessage;

  AuthViewModel({required this.authService});

  // Panggil notifyListeners() setiap ada perubahan agar UI bisa update
  String? validateUsername(String username) {
    if (username.isEmpty) return 'Username cannot be empty';
    if (username.length > 20) return 'Username cannot exceed 20 characters';
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username)) {
      return 'Username can only contain alphanumeric characters';
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) return 'Password cannot be empty';
    if (password.length < 6) return 'Password must be at least 6 characters';
    if (password.length > 50) return 'Password cannot exceed 50 characters';
    return null;
  }

  Future<void> login(String username, String password) async {
    try {
      final usernameError = validateUsername(username);
      final passwordError = validatePassword(password);

      if (usernameError != null) {
        errorMessage = usernameError;
        notifyListeners();
        return;
      }

      if (passwordError != null) {
        errorMessage = passwordError;
        notifyListeners();
        return;
      }

      isLoading = true;
      errorMessage = null;
      notifyListeners();

      currentUser = await authService.login(
        username: username,
        password: password,
        expiresInMins: 30,
      );
    } catch (e) {
      errorMessage = 'Invalid credentials';
      debugPrint('Login error: ${e.toString()}');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCurrentUser() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      currentUser = await authService.getCurrentUser();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshToken() async {
    try {
      isLoading = true;
      errorMessage = null;
      notifyListeners();

      currentUser = await authService.refreshToken(expiresInMins: 30);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await authService.logout();
    currentUser = null;
    notifyListeners();
  }
}
