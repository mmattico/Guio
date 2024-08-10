import 'package:flutter/material.dart';
import '../other/user_session.dart';
import 'signup.dart';
import 'home_page.dart';
import '../other/password_recovery.dart';
//import 'home_page_accesible.dart';

/*const users =  {
  'admin@gmail.com': '12345',
  'guioapp@gmail.com': 'guioapp',
};*/

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
              //_back(context),
              const SizedBox(height: 30),
              _header(context),
              const SizedBox(height: 50),
              _inputField(context),
              const SizedBox(height: 35),
              _buttonLogin(context),
              const SizedBox(height: 20),
              _forgotPassword(context),
              const SizedBox(height: 50),
              _signup(context),
            ],
          ),
        ),
      ),),),
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
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            "¡Bienvenido Nuevamente!",
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Text("Inicia sesión en tu cuenta",
          style: TextStyle(fontSize: 18),),
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
                  hintText: "Nombre de usuario",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide: BorderSide.none
                  ),
                  fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                  filled: true,
                  prefixIcon: const Icon(Icons.person)
              ),
              /*validator: (value) {
              if (value == null || value.isEmpty) {
                return  'Por favor, ingrese su nombre de usuario';
              }
              UserSession().username = value;
              return null;
              },*/
            ),
            const SizedBox(height: 15),
            TextFormField(
              controller: _passwordController,
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
              /*validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingrese su contraseña';
                }
                return null;
              },*/
            ),
          ],
        )
        )
    );
  }

  _buttonLogin(context) {
    return SizedBox(
        width: 250,
        height: 60,
        child: ElevatedButton(
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          //despues de validar usuario y contraseña
          //con el UserSession().username vas a buscar el dato del booleano
          //y lo asignas en UserSession().userAccessibility
            Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()),);
            //Navigator.push(context, MaterialPageRoute(builder: (context) => AccesibleHome()),);
        }
      },
      style: ElevatedButton.styleFrom(
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(vertical: 16),
        backgroundColor: const Color.fromRGBO(17, 116, 186, 1),
      ),
      child: const Text(
        "Iniciar Sesión",
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),),
    );
  }

  _forgotPassword(context) {
    return TextButton(
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PasswordRecovery())
        );
      },
      child: const Text("¿Haz olvidado la contraseña?",
        style: TextStyle(color: Color.fromRGBO(17, 116, 186, 1)),
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
            child: const Text("Registrate", style: TextStyle(color: Color.fromRGBO(17, 116, 186, 1)),)
        )
      ],
    );
  }
}

