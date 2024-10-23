import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:guio_web_admin/home_page_web.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'get_tickets.dart';
import 'other/user_session.dart';
import 'package:mailto/mailto.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _userController = TextEditingController();
  final _passwordController = TextEditingController();
  String username = '';
  String contrasenia = '';
  String errorUsuarioMessage = "";
  String errorContraseniaMessage = "";
  bool _isValidatingInfo = false;
  final _formKey = GlobalKey<FormState>();
  bool isPasswordVisible = false;

  Future<void> _getUserByUsername(String username) async {
    var url;
    url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net',
        '/api/users/get-username/$username');
    print("Url: ${url.toString()}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("Response.body en _getUserByUsername: ${response.body}");
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      print("JsonMap: $jsonMap");
      print("JsonMap['contraseña']: ${jsonMap["contraseÃ±a"]}");
      if (jsonMap["contraseÃ±a"] == contrasenia) {
        //saveUserID(jsonMap["usuarioID"]);
        errorContraseniaMessage = "";
      } else {
        errorContraseniaMessage = "La contraseña ingresada es incorrecta";
      }
      if (jsonMap["permisos"] != "ADMIN") {
        errorUsuarioMessage = "El usuario no es administrador";
      } else {
        await saveUserID(jsonMap["usuarioID"]);
        await saveUserFirstName(jsonMap["nombre"]);
        await saveUserLastName(jsonMap["apellido"]);
        await saveUserEmail(jsonMap["email"]);
        await saveUserPhone(jsonMap["telefono"]);
        await saveUserDNI(jsonMap["dni"]);
        await saveUsername(jsonMap["usuario"]);
        await saveGraphCode(jsonMap["grafoCodigo"]);
        errorUsuarioMessage = "";
      }
    } else {
      errorUsuarioMessage = "El usuario ingresado no esta registrado";
    }
  }

  _buttonLogin(context) {
    return SizedBox(
      width: 500,
      height: 55,
      child: ElevatedButton(
        onPressed: _isValidatingInfo
            ? null
            : () async {
                setState(() {
                  print("validando = ");
                  _isValidatingInfo = true;
                  print("validando ======= ");
                });
                _formKey.currentState!.validate();
                try {
                  print("buscando username");
                  await _getUserByUsername(username);
                  print("finalizo busqueda");
                } finally {
                  setState(() {
                    _isValidatingInfo = false; // Habilita el botón de nuevo
                  });
                }

                if (_formKey.currentState!.validate()) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => WebHomePage()),
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          backgroundColor: _isValidatingInfo
              ? const Color.fromRGBO(17, 116, 186, 0.25)
              : const Color.fromRGBO(17, 116, 186, 1),
        ),
        child: const Text(
          "Iniciar Sesión",
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      /*Image.network(
                        'https://cdn-icons-png.flaticon.com/512/5332/5332306.png',
                        height: 400,
                      ),*/
                      Image.asset('assets/images/logo_GUIO_2.png', height: 450),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/logo_GUIO.png', height: 100, width: 150),
                      const Text(
                        'Inicio de Sesión de Administrador',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 80),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 500,
                              child: TextFormField(
                                controller: _userController,
                                decoration: InputDecoration(
                                  hintText: "Nombre de usuario administrador",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide.none,
                                  ),
                                  fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                                  filled: true,
                                  prefixIcon: const Icon(Icons.person),
                                  errorStyle: const TextStyle(height: 0),
                                  errorMaxLines: 1,
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingrese su nombre de usuario o su email';
                                  }
                                  username = value;

                                  if (errorUsuarioMessage == "") {
                                    return null;
                                  } else {
                                    return errorUsuarioMessage;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 15),
                            SizedBox(
                              width: 500,
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  hintText: "Contraseña",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide.none),
                                  fillColor:
                                      const Color.fromRGBO(65, 105, 225, 0.1),
                                  filled: true,
                                  prefixIcon: const Icon(Icons.password),
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                                      color: Colors.grey[600],  // Color del ícono
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        isPasswordVisible = !isPasswordVisible;
                                      });
                                    },
                                    highlightColor: Colors.transparent,  // Sin efecto de highlight
                                    splashColor: Colors.grey[300],  // Un gris claro visible
                                  ),
                                  errorStyle: const TextStyle(height: 0),
                                  errorMaxLines: 1,
                                ),
                                obscureText: !isPasswordVisible,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingrese su contraseña';
                                  }
                                  contrasenia = value;

                                  if (errorContraseniaMessage == "") {
                                    return null;
                                  } else {
                                    return errorContraseniaMessage;
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),
                      _buttonLogin(context),
                      const SizedBox(height: 30),
                      TextButton(
                          onPressed: () {
                            launchMailto();
                          },
                          child: const Text(
                            'Contactarse con soporte',
                            style: TextStyle(
                                color: Color.fromRGBO(17, 116, 186, 1)),
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


launchMailto() async {
  final mailtoLink = Mailto(
    to: ['contacto.guio@gmail.com'],
  );
  // Convert the Mailto instance into a string.
  // Use either Dart's string interpolation
  // or the toString() method.
  await launch('$mailtoLink');
}