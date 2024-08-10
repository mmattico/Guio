import 'package:flutter/material.dart';
import '../pages/password_recovery.dart';
import '/pages/login.dart';
import '../pages/change_password.dart';

class PasswordRecoveryConfirmation extends StatelessWidget {
  final String email;

  const PasswordRecoveryConfirmation({super.key, required this.email});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(65, 105, 225, 0.1),
                  borderRadius: BorderRadius.circular(50.0),
                ),
                child: const Icon(
                  Icons.email_outlined,
                  size: 80.0,
                  color: Color.fromRGBO(17, 116, 186, 1),
                ),
              ),
              const SizedBox(height: 30.0),
              const Text(
                "Revisá tu casilla de\ncorreo electrónico",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
              Text(
                "Si el correo $email coincide con un usuario creado recibirás la nueva contraseña para ingresar a GUIO App",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 30.0),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()),);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    backgroundColor: const Color.fromRGBO(17, 116, 186, 1),
                  ),
                  child: const Text(
                    "Iniciar Sesión",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),),
              ),
              const SizedBox(height: 40.0),
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PasswordRecovery())
                      //MaterialPageRoute(builder: (context) => const ChangePassword()) //ESTE LO USO SOLO A MODO DE PRUEBA
                  );
                },
                child: const Text(
                  "Probar con otro correo electrónico",
                  style: TextStyle(
                    fontSize: 14.0,
                    color: Color.fromRGBO(17, 116, 186, 1),
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}