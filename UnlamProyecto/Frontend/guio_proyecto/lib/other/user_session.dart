class UserSession {
  static final UserSession _instance = UserSession._internal();

  String? username;

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();
}
