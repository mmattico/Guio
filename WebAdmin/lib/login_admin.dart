import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:guio_web_admin/home_page_web.dart';
import 'package:http/http.dart' as http;

import 'get_tickets.dart';

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

  Future<void> _getUserByUsername(String username) async{
    var url;
    url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/users/get-username/$username');
    print("Url: ${url.toString()}");
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("Response.body en _getUserByUsername: ${response.body}");
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      print("JsonMap: $jsonMap");
      print("JsonMap['contraseña']: ${jsonMap["contraseÃ±a"]}");
      if(jsonMap["contraseÃ±a"] == contrasenia) {
        //saveUserID(jsonMap["usuarioID"]);
        errorContraseniaMessage = "";
      } else {
        errorContraseniaMessage = "La contraseña ingresada es incorrecta";
      }
      if(jsonMap["permisos"] != "ADMIN"){
        errorUsuarioMessage = "El usuario no es administrador";
      } else {
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
        onPressed: _isValidatingInfo? null : () async {
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
            Navigator.push(context, MaterialPageRoute(builder: (context) => TicketListPage()),);
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
        ),),
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
                      Image.network('https://cdn-icons-png.flaticon.com/512/5332/5332306.png', height: 400,),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Inicio de Sesión de Administrador',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 80),

                      // TextFormField con tamaño fijo
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(
                              width: 500,
                              height: 50,
                              child: TextFormField(
                                controller: _userController,
                                decoration: InputDecoration(
                                    hintText: "Nombre de usuario administrador",
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(18),
                                        borderSide: BorderSide.none
                                    ),
                                    fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                                    filled: true,
                                    prefixIcon: const Icon(Icons.person)
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingrese su nombre de usuario o su email';
                                  }
                                  username = value;

                                  if(errorUsuarioMessage == "") {
                                    return null;
                                  } else {
                                    return errorUsuarioMessage;
                                  }
                                },
                              ),
                            ),
                            const SizedBox(height: 15),

                            // Otro TextFormField con tamaño fijo
                            SizedBox(
                              width: 500, // Ancho fijo
                              height: 50, // Alto fijo
                              child: TextFormField(
                                controller: _passwordController,
                                decoration: InputDecoration(
                                  hintText: "Contraseña",
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(18),
                                      borderSide: BorderSide.none),
                                  fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                                  filled: true,
                                  prefixIcon: const Icon(Icons.password),
                                ),
                                obscureText: true,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Por favor, ingrese su contraseña';
                                  }
                                  contrasenia = value;

                                  if(errorContraseniaMessage == "") {
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
                      /*SizedBox(
                        width: 500,
                        height: 55,
                        child:
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TicketListPage()),);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            backgroundColor: const Color.fromRGBO(17, 116, 186, 1),
                          ),
                          child: const Text(
                            "Iniciar Sesión",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),*/
                      const SizedBox(height: 30),
                      TextButton(
                          onPressed: () {
                        // Lógica
                          },
                          child: const Text('Contactarse con soporte', style: TextStyle(color: Color.fromRGBO(17, 116, 186, 1)),))
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
