import 'package:flutter/material.dart';
import 'package:guio_web_admin/area_management.dart';
import 'package:guio_web_admin/get_tickets.dart';
import 'package:guio_web_admin/login_admin.dart';

class WebHomePage extends StatefulWidget {
  @override
  _WebHomePageState createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  int selectedOption = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Parte del menú (lado izquierdo)
          Expanded(
            flex: 1,
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                color: const Color(0xFF1174ba),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 30),
                    Image.asset('assets/images/unlam-logo.png', height: 80, width: 200),
                    const SizedBox(height: 10),
                    const Divider(color: Colors.blueAccent),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        'Menú',
                        style: const TextStyle(fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Expanded(
                      child: ListView(
                        children: [
                          ListTile(
                            title: const Text(
                              'Inicio',
                              style: TextStyle(color: Colors.white),
                            ),
                            leading: const Icon(Icons.house, color: Colors.white, size: 30.0),
                            onTap: () {
                              setState(() {
                                selectedOption = 0; // Cambia la opción a 1
                              });
                            },
                          ),
                          ListTile(
                            title: const Text(
                              'Alertas',
                              style: TextStyle(color: Colors.white),
                            ),
                            leading: const Icon(Icons.add_alert_sharp, color: Colors.white, size: 30.0),
                            onTap: () {
                              setState(() {
                                selectedOption = 1; // Cambia la opción a 1
                              });
                            },
                          ),
                          ListTile(
                            title: const Text(
                              'Dashboard',
                              style: TextStyle(color: Colors.white),
                            ),
                            leading: const Icon(Icons.bar_chart, color: Colors.white, size: 30.0),
                            onTap: () {
                              setState(() {
                                selectedOption = 2; // Cambia la opción a 2
                              });
                            },
                          ),
                          ListTile(
                            title: const Text(
                              'Gestión de Espacios',
                              style: TextStyle(color: Colors.white),
                            ),
                            leading: const Icon(Icons.space_dashboard, color: Colors.white, size: 30.0),
                            onTap: () {
                              setState(() {
                                selectedOption = 3; // Cambia la opción a 3
                              });
                            },
                          ),
                          const SizedBox(height: 450),
                          ListTile(
                            title: const Text(
                              'Cerrar Sesion',
                              style: TextStyle(color: Colors.white),
                            ),
                            leading: const Icon(Icons.exit_to_app, color: Colors.white, size: 30.0),
                            onTap: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),

          // Parte derecha (contenido dinámico)
          Expanded(
            flex: 4,
            child: LayoutBuilder(builder: (context, constraints) {
              return Container(
                width: constraints.maxWidth,
                height: constraints.maxHeight,
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    if (selectedOption == 0) ...[
                      Image.asset('assets/images/logo_GUIO.png', height: 350, width: 800),
                      Text(
                        'SISTEMA DE GESTIÓN DE ESPACIOS',
                        style: const TextStyle(fontSize: 50),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Seleccione una opción del MENÚ para continuar',
                        style: const TextStyle(fontSize: 16),
                      ),
                    ] else if (selectedOption == 1) ...[
                      Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: TicketListPage(), // Mostrando la clase TicketsList aquí
                      ),
                    ] else if (selectedOption == 2) ...[
                      const Text(
                        'Dashboard',
                        style: TextStyle(fontSize: 50),
                      ),
                    ] else if (selectedOption == 3) ...[
                      Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: GridPage(), // Mostrando la clase TicketsList aquí
                      ),
                    ],
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );

  }

}
