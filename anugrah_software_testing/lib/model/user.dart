class User {
  final String username;
  final String? token; // API may return a token

  User({required this.username, this.token});
}
