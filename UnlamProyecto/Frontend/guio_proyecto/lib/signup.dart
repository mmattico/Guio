import 'package:flutter/material.dart';
import 'login.dart';

/*const users =  {
  'admin@gmail.com': '12345',
  'guioapp@gmail.com': 'guioapp',
};*/

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          color: Colors.white,
          margin: const EdgeInsets.fromLTRB(24, 0, 24, 24),
          child: Column(
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _back(context),
                const SizedBox(height: 10),
                _headerSignUp(context),
                const SizedBox(height: 30),
                _inputSignUp(context),
                const SizedBox(height: 70),
                _logIn(context)
              ]
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

  _headerSignUp(context){
    return const
    Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "¡Bienvenido!",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Text("Crea tu cuenta en GUIO App"),
        ],
      ),
    );
  }

  _inputSignUp(context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          decoration: InputDecoration(
              hintText: "Nombre y Apellido",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none
              ),
              fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
              filled: true,
              prefixIcon: const Icon(Icons.person)),
        ),
        const SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
              hintText: "Email",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide: BorderSide.none
              ),
              fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
              filled: true,
              prefixIcon: const Icon(Icons.email)),
        ),
        const SizedBox(height: 20),
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
        const SizedBox(height: 20),
        TextField(
          decoration: InputDecoration(
            hintText: "Repetir Contraseña",
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
                borderSide: BorderSide.none),
            fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
            filled: true,
            prefixIcon: const Icon(Icons.password),
          ),
          obscureText: true,
        ),
        const SizedBox(height: 20),

        ElevatedButton(
          onPressed: () {
          },
          style: ElevatedButton.styleFrom(
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(vertical: 16),
            backgroundColor: const Color.fromRGBO(65, 105, 225, 1),
          ),
          child: const Text(
            "Registrate",
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        )
      ],
    );
  }

  _logIn(context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("¿Ya tienes cuenta?"),
        TextButton(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()),);
            },
            child: const Text("Iniciar Sesión", style: TextStyle(color: Color.fromRGBO(65, 105, 225, 1)),)
        )
      ],
    );
  }
}

