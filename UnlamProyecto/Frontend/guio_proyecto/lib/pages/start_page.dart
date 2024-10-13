import 'package:flutter/material.dart';
import 'package:guio_proyecto/other/text_to_voice.dart';
import 'login.dart';
import 'signup.dart';
import 'auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'location_selection.dart';
import 'package:guio_proyecto/other/user_session.dart';
import 'package:guio_proyecto/pages/change_password.dart';
import 'package:flutter_tts/flutter_tts.dart';


bool _isEmailRegistrado = false;
bool passwordReset = false;

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  _StartPageState createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  final FlutterTts _flutterTts = FlutterTts();
  bool _isVoiceEnabled = true;

  @override
  void initState() {
    super.initState();
    _speak();
  }

  Future<void> _speak() async {
    if (_isVoiceEnabled) {
      await _flutterTts.setLanguage("es-AR");
      await _flutterTts.setPitch(1.0);
      await _flutterTts.speak("Bienvenido a GUIO. Por favor identificarse con correo electrónico o google para comenzar a navegar!");
    }
  }

  void _toggleVoice() {
    setState(() {
      _isVoiceEnabled = !_isVoiceEnabled;
    });
    if (_isVoiceEnabled) {
      _speak();
    }
  }

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = AuthService();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60), // Ajusta la altura según necesites
        child: Container(
          padding: const EdgeInsets.only(top: 8), // Ajusta el padding superior
          color: Colors.white, // Asegúrate de que el color coincida
          child: AppBar(
            backgroundColor: Colors.transparent, // Hacemos que el fondo sea transparente
            elevation: 0, // Sin sombra
            actions: [
              Padding(
                padding: const EdgeInsets.only(top: 10), // Ajusta el padding superior del icono
                child: IconButton(
                  icon: Icon(
                    _isVoiceEnabled ? Icons.volume_up : Icons.volume_off,
                    color: _isVoiceEnabled ? Color.fromRGBO(17, 116, 186, 1) : Colors.grey,
                    size: 40,
                  ),
                  onPressed: _toggleVoice,
                ),
              ),
            ],
          ),
        ),
      ),
        backgroundColor: Colors.white, // Color de fondo del Scaffold
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 40, 20, 90),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset("assets/images/logo_GUIO_2.png"),
                ),
                const SizedBox(height: 16),
                const Text("GUÍO",
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                      color: Color.fromRGBO(17, 116, 186, 1),
                      fontFamily: 'RobotoBlack',

                    )
                ),
                Spacer(),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(width: 10),
                    Flexible(
                      child: ElevatedButton(
                        onPressed: () {
                          detenerReproduccion();
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          backgroundColor: const Color.fromRGBO(17, 116, 186, 1),
                          minimumSize: const Size(0, 65),  // Ancho flexible, alto fijo (70 px)
                        ),
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(Icons.email_outlined, color: Colors.white, size: 27.0),
                              SizedBox(width: 20),
                              Expanded(
                                child: Text(
                                  "Acceder con correo \nelectrónico",
                                  style: TextStyle(fontSize: 18, color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Flexible(
                      child: ElevatedButton(
                          onPressed: () async {
                            detenerReproduccion();
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
                          },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 2),
                          backgroundColor: const Color.fromRGBO(230, 230, 230, 1),
                          minimumSize: const Size(0, 65),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image.asset(
                                'assets/images/google_icon.png',
                                width: 28.0,
                                height: 28.0,
                              ),
                              const SizedBox(width: 20),
                              const Expanded(
                                child: Text(
                                  "Acceder con Google",
                                  style: TextStyle(fontSize: 18, color: Colors.black), //Color.fromRGBO(219, 68, 55, 1)),
                                  overflow: TextOverflow.ellipsis,

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    /*SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: IconButton(
                        icon: const Icon(FontAwesomeIcons.google, size: 30),
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
                    ),*/
                  ],
                ),
              ],
            ),
          ),
        ),
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