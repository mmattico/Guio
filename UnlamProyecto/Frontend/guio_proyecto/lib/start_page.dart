import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.network(
            'https://cdn.logo.com/hotlink-ok/logo-social.png', //Reemplazar con Icon de GUIO
            height: 150,
          ),
          const Text("Guío"),
          const SizedBox(height: 50),
          /*const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Bienvenido"),
                Text("Inicia sesión para disfrutar de todas \n"
                    "las opciones que ofrece Guío"),
              ]
          ),*/
          const SizedBox(height: 100),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 10),
              SizedBox(
                width: 250,
                height: 60,
                child:ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: const Color.fromRGBO(65, 105, 225, 1),
                  ),
                  child: const Text(
                    "Iniciar Sesión",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 250,
                height: 60,
                child:ElevatedButton(
                  onPressed: () {
                    Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const SignupPage()),);
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const StadiumBorder(),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: Colors.white,
                    overlayColor: Colors.blue,
                  ),
                  child: const Text(
                    "Registrate",
                    style: TextStyle(fontSize: 20, color: Color.fromRGBO(65, 105, 225, 1)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}