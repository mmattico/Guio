import 'package:flutter/material.dart';
import 'package:guio_proyecto/other/user_session.dart';
import 'package:guio_proyecto/pages/change_password.dart';
import 'location_selection.dart';
import 'signup.dart';
import 'home_page.dart';
import 'password_recovery.dart';
//import 'home_page_accesible.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isValidatingInfo = false;
  String usuarioOEmail = '';
  String contrasenia = '';
  String errorUsuarioOEmailMessage = "";
  String errorContraseniaMessage = "";
  bool passwordReset = false;

  Future<void> _getUserByEmail(String email) async{
    var url;
    url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/users/get-email/$email');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("Response.body en _getUserByEmail: ${response.body}");
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      if(jsonMap["contraseÃ±a"] == contrasenia) {
        errorContraseniaMessage = "";
        saveUserID(jsonMap["usuarioID"]);
        saveUserFirstName(jsonMap["nombre"]);
        saveUserLastName(jsonMap["apellido"]);
        saveUserEmail(jsonMap["email"]);
        saveUserPhone(jsonMap["telefono"]);
        saveUserDNI(jsonMap["dni"]);
        saveUsername(jsonMap["usuario"]);
        saveUserAccessibility(jsonMap["accesibilidadDefault"]);
        passwordReset = jsonMap["contraseÃ±aReseteada"];
      } else {
        errorContraseniaMessage = "La contraseña ingresada es incorrecta";
      }
      errorUsuarioOEmailMessage = "";
    } else {
      errorUsuarioOEmailMessage = "El email ingresado no esta registrado";
    }
  }

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
        passwordReset = jsonMap["contraseÃ±aReseteada"];
        saveUserID(jsonMap["usuarioID"]);
        errorContraseniaMessage = "";
      } else {
        errorContraseniaMessage = "La contraseña ingresada es incorrecta";
      }
      errorUsuarioOEmailMessage = "";
    } else {
      errorUsuarioOEmailMessage = "El usuario ingresado no esta registrado";
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: SingleChildScrollView(
            child: Column(
            children: [
              const SizedBox(height: 30),
              _header(context),
              const SizedBox(height: 50),
              _inputField(context),
              const SizedBox(height: 35),
              _buttonLogin(context),
              const SizedBox(height: 20),
              _forgotPassword(context),
              const SizedBox(height: 30),
              _signup(context),
            ],
          ),
        ),
      ),),),
    );
  }

  _header(context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "¡Bienvenido Nuevamente!",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Text("Inicia sesión en tu cuenta",
          style: TextStyle(fontSize: 18),),
        ],
    );
  }

  _inputField(context) {
    return Padding(
        padding: const EdgeInsets.all(1.0),
        child: Form(
          key: _formKey,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  hintText: "Nombre de usuario o Email",
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
                usuarioOEmail = value;

                if(errorUsuarioOEmailMessage == "") {
                  return null;
                } else {
                  return errorUsuarioOEmailMessage;
                }
              },
            ),
            const SizedBox(height: 15),
            TextFormField(
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
          ],
        )
        )
    );
  }

  _buttonLogin(context) {
    return SizedBox(
        //width: 250,
        width: double.infinity,
        height: 55,
        child: ElevatedButton(
      onPressed: _isValidatingInfo? null : () async {
        setState(() {
          _isValidatingInfo = true; // Deshabilita el botón
        });

        _formKey.currentState!.validate();

        try {
          if(RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(usuarioOEmail)) {
            await _getUserByEmail(usuarioOEmail);
          } else {
            await _getUserByUsername(usuarioOEmail);
          }
        } finally {
          setState(() {
            _isValidatingInfo = false; // Habilita el botón de nuevo
          });
        }

        if (_formKey.currentState!.validate()) {
          if(passwordReset){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePassword()),);
          } else {
            Navigator.push(context, MaterialPageRoute(builder: (context) => LocationSelection()),);
          }
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        backgroundColor: _isValidatingInfo
            ? const Color.fromRGBO(17, 116, 186, 0.25) // Cambia el color del botón cuando está deshabilitado
            : const Color.fromRGBO(17, 116, 186, 1),
      ),
      child: const Text(
        "Iniciar Sesión",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),),
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PasswordRecovery())
        );
      },
      child: const Text("¿Haz olvidado la contraseña?",
        style: TextStyle(color: Color.fromRGBO(17, 116, 186, 1)),
      ),
    );
  }

  _signup(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("¿No tienes cuenta?"),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SignupPage()),);
            },
            child: const Text("Registrate", style: TextStyle(color: Color.fromRGBO(17, 116, 186, 1)),)
        )
      ],
    );
  }
}

