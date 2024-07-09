import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';
//import 'package:google_fonts/google_fonts.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        body: Center(
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
              const SizedBox(height: 50),
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
                          MaterialPageRoute(builder: (context) => LoginPage()),);
                      },
                      style: ElevatedButton.styleFrom(
                        shape: const StadiumBorder(),
                        padding: const EdgeInsets.symmetric(vertical: 16),
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
                        style: TextStyle(fontSize: 20, color: Color.fromRGBO(17, 116, 186, 1)),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
    );
  }
}