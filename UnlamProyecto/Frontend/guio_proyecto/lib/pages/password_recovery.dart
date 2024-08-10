import 'package:flutter/material.dart';
import 'package:guio_proyecto/other/password_recovery_confirmation.dart';
import '/pages/login.dart';

class PasswordRecovery extends StatelessWidget {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String email = '';

  PasswordRecovery({super.key});

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
      return const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Recuperá tu contraseña",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold,),
          ),
          SizedBox(height: 10),
          Text("Te enviaremos una nueva contraseña a tu casilla de correo electrónico", style: TextStyle(fontSize: 14),)
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
                    return null;
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
        width: 250,
        height: 55,
        child: ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          //Enviar mail de recovery
          Navigator.push(context, MaterialPageRoute(builder: (context) => PasswordRecoveryConfirmation(email: email)),);
        }
      },
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        backgroundColor: const Color.fromRGBO(17, 116, 186, 1),
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

}





