import 'dart:convert';
import 'package:http/http.dart' as http;

class User {
  final String nombre;
  final String apellido;
  final String dni;
  final String email;
  final String telefono;
  final String permisos;
  final String usuario;
  final String password;
  final bool accesibilidadDefault;
  final bool contraseniaReseteada;

  User({
    required this.nombre,
    required this.apellido,
    required this.dni,
    required this.email,
    required this.telefono,
    required this.permisos,
    required this.usuario,
    required this.password,
    required this.accesibilidadDefault,
    required this.contraseniaReseteada,
  });

  Map<String, dynamic> toJson() {
    return {
      // El primer parametro hay que modificarlo en un futuro
      'grafo': {"grafoID":1},
      'nombre': nombre,
      'apellido': apellido,
      'dni': dni,
      'email': email,
      'telefono': telefono,
      'permisos': permisos,
      'usuario': usuario,
      'contraseña': password,
      'accesibilidadDefault': accesibilidadDefault,
      'contraseñaReseteada': contraseniaReseteada,
    };
  }
}

/*
Map<String, dynamic> toJson() {
    return {
      // El primer parametro hay que modificarlo en un futuro
      'grafo': {"grafoID":1},
      'nombre': nombre,
      'apellido': apellido,
      'dni': dni,
      'email': email,
      'telefono': telefono,
      'permisos': permisos,
      'usuario': usuario,
      'contraseña': password,
      'accesibilidadDefault': accesibilidadDefault,
      'contraseñaReseteada': contraseniaReseteada,
    };
  }
}
*/

Future<http.Response> createUser(User user) async {
  final url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/users');
  final headers = {"Content-Type": "application/json"};
  print("Json final: ${user.toJson()}");
  final body = jsonEncode(user.toJson());

  return await http.post(url, headers: headers, body: body);
}