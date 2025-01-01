class User {
  final int id;
  final String username;
  final String email;
  final String profilePic;
  final String? authType;

  User(
      {required this.id,
      required this.username,
      required this.email,
      required this.profilePic,
      required this.authType});
}
