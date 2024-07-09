import 'package:flutter/material.dart';
import '/pages/login.dart';

class PasswordRecovery extends StatelessWidget {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: SingleChildScrollView(
            child: Column(
              children: [
                _back(context),
                const SizedBox(height: 10),
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
        ),),
    );
  }

    _back (context){
      return AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      );
    }

    _header(context) {
      return const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "Recuperá tu contraseña",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          )
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
        width: 280,
        height: 65,
        child: ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          //Enviar mail de recovery
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
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
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        },
        child: const Text(
          'Cancelar',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
    );
  }

}





