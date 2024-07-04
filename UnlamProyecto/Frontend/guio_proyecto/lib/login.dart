import 'package:flutter/material.dart';
import 'signup.dart';
import '../home_page.dart';

/*const users =  {
  'admin@gmail.com': '12345',
  'guioapp@gmail.com': 'guioapp',
};*/

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _back(context),
              const SizedBox(height: 10),
              _header(context),
              const SizedBox(height: 50),
              _inputField(context),
              const SizedBox(height: 20),
              _forgotPassword(context),
              const SizedBox(height: 50),
              _signup(context),
            ],
          ),
        ),
      ),
    );
  }

  _back (context){
    return AppBar(
      //elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  _header(context) {
    return const
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "¡Bienvenido Nuevamente!",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Text("Inicia sesión en tu cuenta"),
        ],
      ),
    );
  }

  _inputField(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: InputDecoration(
              hintText: "Correo Electrónico",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none
              ),
              fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
              filled: true,
              prefixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 10),
        TextField(
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
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()),);
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
        )
      ],
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {},
      child: const Text("¿Haz olvidado la contraseña?",
        style: TextStyle(color: Color.fromRGBO(65, 105, 225, 1)),
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
            child: const Text("Registrate", style: TextStyle(color: Color.fromRGBO(65, 105, 225, 1)),)
        )
      ],
    );
  }
}