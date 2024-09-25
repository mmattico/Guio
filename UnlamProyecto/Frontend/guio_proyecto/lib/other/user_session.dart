class UserSession {
  static final UserSession _instance = UserSession._internal();

  String? username;
  bool? userAccessibility;

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();
}
