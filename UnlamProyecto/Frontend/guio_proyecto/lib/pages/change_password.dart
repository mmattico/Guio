import 'package:flutter/material.dart';
import 'package:guio_proyecto/other/button_back.dart';
import 'package:guio_proyecto/pages/home_page.dart';
import 'package:guio_proyecto/other/user_session.dart';
import 'package:guio_proyecto/pages/start_page.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'location_selection.dart';

class ChangePassword extends StatefulWidget {
  const ChangePassword({super.key});

  @override
  _ChangePasswordState createState() =>
      _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String password = '';
  String passwordConfirm = '';

  @override
  Widget build(BuildContext context) {
    return DoubleBackToExit(
        child: Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(22,70,22,50),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20.0),
                    // Título
                    const Text(
                      "Cambio de contraseña",
                      style: TextStyle(
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    // Subtítulo
                    Text(
                      "Por favor, establezca una nueva contraseña",
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 45.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: "Nueva Contraseña",
                        labelStyle: const TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none
                        ),
                        fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese una contraseña';
                        }
                        if (value.length <10) {
                          return 'La contraseña debe tener un mínimo de 10 caracteres';
                        }
                        password = value;
                        return null;
                      },
                    ),
                    const SizedBox(height: 20.0),
                    TextFormField(
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      decoration: InputDecoration(
                        labelText: "Confirmar Contraseña",
                        labelStyle: const TextStyle(fontSize: 18),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none
                        ),
                        fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                        filled: true,
                        prefixIcon: const Icon(Icons.password),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword = !_obscureConfirmPassword;
                            });
                          },
                        ),
                      ),
                      validator: (value) {
                        if (password == '') {
                          return null;
                        }
                        if (value == null || value.isEmpty) {
                          return 'Por favor, ingrese una contraseña';
                        }
                        if (value != password) {
                          return 'Las contraseñas no son iguales';
                        }

                        passwordConfirm = value;
                        return null;
                      },
                    ),
                    const SizedBox(height: 40.0),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            int? usuarioId = prefs.getInt('usuarioId');
                            actualizarPassword(usuarioId, password, context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          backgroundColor: const Color.fromRGBO(17, 116, 186, 1),
                        ),
                        child: const Text(
                          "Cambiar contraseña",
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: 20,),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          String? graphCode = await getGraphCode();
                          if(graphCode != null) {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => HomePage()),);
                          } else {
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context) => StartPage()),);
                          }
                        },
                        child: const Text(
                          "Cancelar",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromRGBO(17, 116, 186, 1),
                          ),
                        ),
                      ),
                    )
                  ],
          ),),
        )
      ),),
    );
  }

  Future<void> actualizarPassword(int? idUsuario, String nuevaContrasenia, BuildContext context) async {
    print("idUsuario");
    print(idUsuario);

    var url;
    url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/users/actualizar-password');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'idUsuario': idUsuario.toString(),
          'PASSWORD': nuevaContrasenia,
        },
      );

      if (response.statusCode == 200) {
        print("Se ha actualizado la contraseña con exito");
        // Password cambiada con exito
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              content: const Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.check_circle, color: Colors.green, size: 100,),
                  SizedBox(height: 10),
                  Text(
                    '¡Tu password ha sido actualizada!',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    ' ',
                    style: TextStyle(fontSize: 15),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              actions: <Widget>[
                Center(
                  child: SizedBox(
                    width: 250,
                    height: 60,
                    child: ElevatedButton(
                      onPressed: () async {
                        String? graphCode = await getGraphCode();
                        if(graphCode != null) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => HomePage()),);
                        } else {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => LocationSelection()),);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: Color.fromRGBO(17, 116, 186, 1),
                      ),
                      child: const Text(
                        "IR AL INICIO",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),),
                  ),
                ),
              ],
            );
          },
        );
      } else {
        print("Error al actualizar contraseña");
        print('Respuesta: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}
