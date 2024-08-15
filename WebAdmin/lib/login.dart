import 'package:flutter/material.dart';
import 'package:guio_web_admin/home_page_web.dart';

import 'get_tickets.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.network('https://cdn-icons-png.flaticon.com/512/5332/5332306.png', height: 400,),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        'Inicio de Sesión de Administrador',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 80),

                      // TextFormField con tamaño fijo
                      SizedBox(
                        width: 500,
                        height: 50,
                        child: TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            hintText: "Usuario Administrador",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.person),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // Otro TextFormField con tamaño fijo
                      SizedBox(
                        width: 500, // Ancho fijo
                        height: 50, // Alto fijo
                        child: TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Contraseña",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18),
                              borderSide: BorderSide.none,
                            ),
                            fillColor: const Color.fromRGBO(65, 105, 225, 0.1),
                            filled: true,
                            prefixIcon: const Icon(Icons.password),
                          ),
                          obscureText: true,
                        ),
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: 500,
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => TicketListPage()),);
                          },
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            backgroundColor: const Color.fromRGBO(17, 116, 186, 1),
                          ),
                          child: const Text(
                            "Iniciar Sesión",
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      TextButton(
                          onPressed: () {
                        // Lógica
                          },
                          child: const Text('Contactarse con soporte', style: TextStyle(color: Color.fromRGBO(17, 116, 186, 1)),))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
