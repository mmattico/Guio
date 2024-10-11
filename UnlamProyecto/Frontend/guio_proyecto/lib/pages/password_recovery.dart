import 'package:flutter/material.dart';
import 'package:guio_proyecto/other/password_recovery_confirmation.dart';
import '/pages/login.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PasswordRecovery extends StatefulWidget {
  const PasswordRecovery({super.key});

  @override
  _PasswordRecoveryState createState() => _PasswordRecoveryState();
}

class _PasswordRecoveryState extends State<PasswordRecovery> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = '';
  bool _isValidatingInfo = false; // Variable para controlar el estado del botón "Recovery"
  String msgError = '';

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
                  const SizedBox(height: 50),
                  _header(context),
                  const SizedBox(height: 50),
                  _inputField(context),
                  const SizedBox(height: 50),
                  _recoveryButton(context),
                  const SizedBox(height: 10),
                  _cancelButton(context),
                ],
              ),
            ),
          ),
        ),),
    );
  }

  _header(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "Recuperá tu contraseña\n", // Primer texto con salto de línea
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.black, // Especifica el color
                ),
              ),
              TextSpan(
                text: "Te enviaremos una nueva contraseña a tu casilla de correo electrónico", // Segundo texto
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black, // Especifica el color
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10), // Mantén el espacio entre widgets si es necesario
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
                      hintText: "Correo Electrónico",
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
                      return 'Por favor, ingrese su correo electrónico';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Formato inválido de correo electrónico';
                    }

                    email = value;

                    if(msgError != '') {
                      return msgError;
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(height: 10),

              ],
            )
        )
    );
  }

  _recoveryButton(context){
    return SizedBox(
      width: double.infinity,
      height: 55,
        child: ElevatedButton(
      onPressed: _isValidatingInfo? null : () async {
        setState(() {
          _isValidatingInfo = true; // Deshabilita el botón
        });
        msgError = '';

        if(_formKey.currentState!.validate()) {
          await _validateEmail();
        }

        if (_formKey.currentState!.validate()) {
          if(msgError == '') {
            await _enviarMailRecovery();
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                PasswordRecoveryConfirmation(email: email)),);
          }
        }
        setState(() {
          _isValidatingInfo = false; // Habilita el botón
        });
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
        "Recuperar Contraseña",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),),
    );
  }

  _cancelButton(context){
    return TextButton(
        onPressed: () {
          Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
          );
        },
        child: const Text(
          'Cancelar',
          style: TextStyle(color:Color.fromRGBO(17, 116, 186, 1), fontSize: 16),
        ),
    );
  }

  Future<void> _enviarMailRecovery() async {
    var url;
    url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/users/reset-password', {'EMAIL': email});

    try {
      final response = await http.post(url);

      if (response.statusCode == 200) {
        print("Se ha reseteado la contraseña con exito");
      } else {
        print("Error al resetear contraseña");
        print('Respuesta: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _validateEmail() async{
    var url;
    url = Uri.https('guio-hgazcxb0cwgjhkev.eastus-01.azurewebsites.net', '/api/users/validar-correo',
        {'EMAIL': email});

    final response = await http.get(url);
    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print("Retorno del email $email: $responseData");
      if(!responseData) {
        msgError = "El correo ingresado no esta registrado";
      } else {
        msgError = "";
      }
    } else {
      msgError = "Error al validar correo, intente de nuevo";
    }
  }
}





