import 'package:shared_preferences/shared_preferences.dart';

class UserSession {
  static final UserSession _instance = UserSession._internal();

  String? username;
  int? usuarioID;
  bool? userAccessibility;

  factory UserSession() {
    return _instance;
  }

  UserSession._internal();
}



Future<void> saveUserID(int usuarioId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('usuarioId', usuarioId);
}

Future<int?> getUserID() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('usuarioId');
}

Future<void> deleteUserID() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('usuarioId');
}
