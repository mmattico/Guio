import 'package:flutter/material.dart';
import 'package:guio_web_admin/dashboard.dart';
import 'package:guio_web_admin/other/user_session.dart';
import 'package:guio_web_admin/area_management.dart';
import 'package:guio_web_admin/get_tickets.dart';
import 'package:guio_web_admin/login_admin.dart';
import 'dart:async';

class WebHomePage extends StatefulWidget {
  @override
  _WebHomePageState createState() => _WebHomePageState();
}

class _WebHomePageState extends State<WebHomePage> {
  int selectedOption = 0;
  Timer? _timer;
  Future<String?> graphCode = getGraphCode();
  late int cantidadAlertasPrev = 0;
  late int cantidadAlertasNuevas = 0;
  int qtyAlertasNuevas = 0;

  @override
  void initState() {
    super.initState();
    _fetchAlertas();
    _startFetchingAlertas();
  }

  Future<void> _fetchAlertas() async {
    // Realiza la llamada asíncrona aquí
    List<Ticket> nuevasAlertas = await fetchAlertas(graphCode);
    setState(() {
      cantidadAlertasPrev = nuevasAlertas.length;
    });
  }

  void _startFetchingAlertas() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) async {
      print("llamando");
      await _refreshAlertas(); // Llama a la función de actualización
    });
  }

  Future<void> _refreshAlertas() async {
    try {
      List<Ticket> nuevasAlertas = await fetchAlertas(graphCode);
      setState(() {
        cantidadAlertasNuevas = nuevasAlertas.length;
        setState(() {
          qtyAlertasNuevas = nuevasAlertas.length - cantidadAlertasPrev;
          if(qtyAlertasNuevas > 0) {
            _showNotification(context);
          }
          cantidadAlertasPrev = nuevasAlertas.length;
        });
      });
    } catch (e) {
      print('Error al actualizar alertas: $e');
    }
  }

  void _showNotification(BuildContext context) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        bottom: 20.0,
        right: 20.0,
        child: Material(
          color: Colors.transparent,
          child: IntrinsicWidth(
            child: SizedBox(
              width: 380,
              height: 130,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.7),  // Color de fondo blanco
                  borderRadius: BorderRadius.circular(8.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2), // Sombra más sutil
                      blurRadius: 10.0,
                      spreadRadius: 2.0,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.add_alert, size: 45, color: Color(0xFF1174ba)), // Icono de advertencia
                    SizedBox(width: 15), // Espacio entre el icono y el texto
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '¡HAY UNA ALERTA NUEVA!',
                            style: TextStyle(
                              color: Color(0xFF1174ba),
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold, // Texto en negrita
                            ),
                            textAlign: TextAlign.left,
                          ),
                          SizedBox(height: 5), // Espacio entre el título y la descripción
                          Text(
                            'Revisa la nueva alerta desde el menú "Alertas"',
                            style: TextStyle(color: Colors.grey[600], fontSize: 14.0), // Texto más pequeño
                            textAlign: TextAlign.left,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );

    // Muestra la notificación usando el overlay
    overlay.insert(overlayEntry);

    // Elimina la notificación después de 5 segundos
    Future.delayed(Duration(seconds: 7), () {
      overlayEntry.remove();
    });
  }


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
                    //Image.asset('assets/images/unlam-logo.png', height: 80, width: 200),
                    FutureBuilder<String?>(
                      future: graphCode, // Usar la variable Future aquí
                      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          // Mostrar un indicador de carga mientras se obtiene el graphCode
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          // Manejo de errores
                          return Text('Error: ${snapshot.error}');
                        } else if (!snapshot.hasData || snapshot.data == null) {
                          // Manejo del caso cuando no hay datos
                          return const Text('No se encontró el grafo.');
                        } else {
                          // Aquí ya tienes el valor de graphCode
                          String? graphCodeValue = snapshot.data;

                          // Decide qué imagen mostrar
                          if (graphCodeValue == 'UNLAM') {
                            return Image.asset('assets/images/unlam-logo.png', height: 80, width: 200);
                          } else {
                            return Image.asset('assets/images/logo_GUIO.png', height: 80, width: 200);
                          }
                        }
                      },
                    ),
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
                                selectedOption = 0;
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
                                selectedOption = 1;
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
                                selectedOption = 2;
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
                                selectedOption = 3;
                              });
                            },
                          ),
                          const SizedBox(height: 100),
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
                        'SISTEMA DE GESTIÓN DE ESTABLECIMIENTOS',
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
                      Container(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: DashboardPage(), // Mostrando la clase TicketsList aquí
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
