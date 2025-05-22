import 'package:anugrah_software_testing/model/user.dart';
import 'package:anugrah_software_testing/model/authService.dart';

class AuthViewModel {
  final AuthService authService;
  User? user;
  bool isLoading = false;
  String? errorMessage;

  AuthViewModel({required this.authService});

  String? validateUsername(String username) {
    if (username.isEmpty) return 'Username cannot be empty';
    return null;
  }

  String? validatePassword(String password) {
    if (password.isEmpty) return 'Password cannot be empty';
    if (password.length < 6) return 'Password must be at least 6 characters';
    return null;
  }

  Future<void> login(String username, String password) async {
    try {
      isLoading = true;
      errorMessage = null;
      user = await authService.login(username, password);
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      isLoading = false;
    }
  }

  Future<void> logout() async {
    await authService.logout();
    user = null;
  }
}