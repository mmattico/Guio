import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveUserID(int usuarioId) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setInt('usuarioId', usuarioId);
}

Future<int?> getUserID() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getInt('usuarioId');
}

Future<void> saveUserFirstName(String userFistName) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userFistName', userFistName);
}

Future<String?> getUserFirstName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userFistName');
}

Future<void> saveUserLastName(String userLastName) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userLastName', userLastName);
}

Future<String?> getUserLastName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userLastName');
}

Future<void> saveUserEmail(String userEmail) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userEmail', userEmail);
}

Future<String?> getUserEmail() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userEmail');
}

Future<void> saveUserPhone(String userPhone) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userPhone', userPhone);
}

Future<String?> getUserPhone() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userPhone');
}

Future<void> saveUserDNI(String userDNI) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('userDNI', userDNI);
}

Future<String?> getUserDNI() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('userDNI');
}

Future<void> saveUsername(String username) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('username', username);
}

Future<String?> getUsername() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('username');
}

Future<void> saveUserAccessibility(bool userAccessibility) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('userAccessibility', userAccessibility);
}

Future<bool?> getUserAccessibility() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('userAccessibility');
}

Future<void> saveGraphCode(String graphCode) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('graphCode', graphCode);
}

Future<String?> getGraphCode() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('graphCode');
}

Future<void> saveGraphName(String graphName) async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('graphName', graphName);
}

Future<String?> getGraphName() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('graphName');
}

Future<void> deleteUserSession() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('usuarioId');
  await prefs.remove('userFistName');
  await prefs.remove('userLastName');
  await prefs.remove('userEmail');
  await prefs.remove('userPhone');
  await prefs.remove('userDNI');
  await prefs.remove('username');
  await prefs.remove('userAccessibility');
  await prefs.remove('graphCode');
  await prefs.remove('graphName');
}
