import 'package:shared_preferences/shared_preferences.dart';

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
