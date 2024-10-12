import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';
import 'auth_service.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'location_selection.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:guio_proyecto/other/user_session.dart';
import 'package:guio_proyecto/pages/change_password.dart';

bool _isEmailRegistrado = false;
bool passwordReset = false;

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    return Scaffold(
      backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /* Image.network(
                'https://cdn.logo.com/hotlink-ok/logo-social.png', //Reemplazar con Icon de GUIO
                height: 150,
              ),*/
                SizedBox(
                  height: 180,
                  width: 180,
                  child: Image.asset("assets/images/logo_GUIO_2.png"),
                ),
                const SizedBox(height: 10),
                const Text("Guío",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Color.fromRGBO(17, 116, 186, 1))
                ),
                const SizedBox(height: 100),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child:ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => LoginPage()),);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: const Color.fromRGBO(17, 116, 186, 1),
                        ),
                        child: const Text(
                          "Iniciar Sesión",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child:ElevatedButton(
                        onPressed: () {
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context) => const SignupPage()),);
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: Colors.white,
                          overlayColor: Colors.blue,
                        ),
                        child: const Text(
                          "Registrate",
                          style: TextStyle(fontSize: 20, color: Color.fromRGBO(17, 116, 186, 1)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: IconButton(
                        icon: Icon(FontAwesomeIcons.google, size: 30),
                        onPressed: () async {
                          User? user = await _authService.signInWithGoogle();
                          _authService.signOut();
                          if (user != null) {
                            await _validateEmail(user.email.toString());
                            if(_isEmailRegistrado){
                              await _getUserByEmail(user.email.toString());
                              if(passwordReset){
                                Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) => const ChangePassword()),
                                      (Route<dynamic> route) => false,
                                );
                              } else {
                                Navigator.pushAndRemoveUntil(context,
                                  MaterialPageRoute(builder: (context) => LocationSelection()),
                                      (Route<dynamic> route) => false,
                                );
                              }
                            }else{
                              Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(builder: (context) => SignupPage(selectedEmail: user.email.toString(), selectedUsuario: user.displayName.toString())),
                                    (Route<dynamic> route) => false,);
                            }
                          }
                        }
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
    );
  }

  Future<void> _getUserByEmail(String email) async{
    var url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/users/get-email/$email');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      print("Response.body en _getUserByEmail: ${response.body}");
      Map<String, dynamic> jsonMap = jsonDecode(response.body);
      await saveUserID(jsonMap["usuarioID"]);
      await saveUserFirstName(jsonMap["nombre"]);
      await saveUserLastName(jsonMap["apellido"]);
      await saveUserEmail(jsonMap["email"]);
      await saveUserPhone(jsonMap["telefono"]);
      await saveUserDNI(jsonMap["dni"]);
      await saveUsername(jsonMap["usuario"]);
      await saveUserAccessibility(jsonMap["accesibilidadDefault"]);
      passwordReset = jsonMap["contraseÃ±aReseteada"];
    }
  }


  Future<void> _validateEmail(String email) async {
    var url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net',
        '/api/users/validar-correo', {'EMAIL': email});
    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print("Retorno email $responseData");
      if (!responseData) {
        _isEmailRegistrado = false;
      } else {
        _isEmailRegistrado = true;
      }
    }
  }
}